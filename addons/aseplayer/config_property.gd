tool
extends EditorProperty

onready var btn: Button = Button.new()
var select_file_dialog: EditorFileDialog

var root: Node2D
var player: AsePlayer

var base_dir: String
var updating: bool = false

func _ready():
	btn.text = "SELECT ASE JSON"
	btn.connect("pressed", self, "on_pressed")

	add_child(btn)

func _exiting_tree():
	btn.disconnect("pressed", self, "on_pressed")

func on_pressed():
	select_file_dialog.connect("file_selected", self, "on_file_selected")

	if not base_dir.empty():
		select_file_dialog.current_path = base_dir

	select_file_dialog.popup_centered_ratio()

func update_property():
	var new_value = get_edited_object()[get_edited_property()]
	updating = true
	if not new_value.empty():
		btn.text = new_value.get_file()
		base_dir = new_value.get_base_dir()
	else:
		btn.text = "SELECT ASE JSON"

	updating = false

func on_file_selected(file_path: String):
	var file := File.new()
	var file_open_err := file.open(file_path, File.READ)

	if file_open_err != OK:
		push_error("Error while trying to open JSON file %s. Error code: %d" % [file_path, file_open_err])
		return

	var s := file.get_as_text()
	file.close()

	base_dir = file_path.get_base_dir()

	if s.length() > 0:
		var res = JSON.parse(s)
		if res.error == OK:
			parse_animation(res.result)
		else:
			push_error("can\'t read json file: %s" % res.error)

	emit_changed(get_edited_property(), file_path)


func parse_animation(config):
	var tags = config.meta.frameTags
	var layers = config.meta.layers
	var image_path = base_dir + "/" + config.meta.image

	var arr = []
	for layer in layers:
		var l_name = "layer_" + layer.name
		if root.get_node_or_null(l_name):
			push_warning("layer: [%s] already exist, delete it first" % layer.name)
			continue

		var sprite := Sprite.new()
		sprite.name = l_name

		var texture := load(image_path)

		sprite.texture = AtlasTexture.new()
		sprite.texture.atlas = texture
		sprite.centered = false
		sprite.offset = player.offset

		root.add_child(sprite)
		sprite.owner = root

		arr.append(NodePath("../"+l_name))

	emit_changed("layers", arr)

	for tag in tags:
		# create animation
		var anim = Animation.new()

		var l_idx = 0
		for layer in layers:
			var l_name = "layer_" + layer.name
			# create region track
			anim.add_track(Animation.TYPE_VALUE, l_idx)
			anim.track_set_path(l_idx, l_name + ":texture:region")
			anim.value_track_set_update_mode(l_idx, Animation.UPDATE_DISCRETE)

			# create margin track
			anim.add_track(Animation.TYPE_VALUE, l_idx + 1)
			anim.track_set_path(l_idx + 1, l_name + ":texture:margin")
			anim.value_track_set_update_mode(l_idx + 1, Animation.UPDATE_DISCRETE)

			# create callback track
			anim.add_track(Animation.TYPE_METHOD, l_idx + 2)
			anim.track_set_path(l_idx + 2, NodePath(player.name))			# anim.value_track_set_update_mode(l + 2, Animation.UPDATE_TRIGGER)

			var duration = 0
			for i in range(tag.from, tag.to + 1):
				var f = config.frames[layer.name + "_" + String(i)]

				anim.track_insert_key(l_idx, duration, Rect2(f.frame.x, f.frame.y, f.frame.w, f.frame.h))
				anim.track_insert_key(l_idx + 1, duration, Rect2(f.spriteSourceSize.x, f.spriteSourceSize.y, f.sourceSize.w, f.sourceSize.h))
				anim.track_insert_key(l_idx + 2, duration, {"method": "on_frame_changed", "args": [i]})
				duration += f.duration / 1000

			l_idx += 3
			anim.length = duration

		# add animation to the player
		anim.loop = true
		if player.add_animation(tag.name, anim) != 0:
			push_error("add animation FAILED: " + tag.name)
