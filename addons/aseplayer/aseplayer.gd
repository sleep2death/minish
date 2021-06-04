class_name AsePlayer
extends AnimationPlayer

export(String, FILE, "*.json") var config

export(Vector2) var offset = Vector2(-64, -64)

export (Array, NodePath) var layers
var layer_nodes : Array = []

var flipped: bool = false setget set_flipped

func _ready():
	for p in layers:
		var node := get_node(p) as Sprite
		layer_nodes.append(node)

func on_frame_changed(_idx):
	pass

func get_current_direction() -> String:
	var anim := current_animation
	if anim.empty():
		return "none"

	var res = anim.split("_")[0]
	if res == "side":
		res = "left" if flipped == true else "right"
	return res

func set_flipped(value):
	flipped = value
	for node in layer_nodes:
		node.scale.x = -1 if flipped else 1


func play_anim(name: String, direction: String = "", speed: float = 1.0, looped: bool = true, backwards: bool = false):
	if not direction.empty():
		if direction == "left":
			self.flipped = true
		else:
			self.flipped = false

		direction = get_side_direction(direction)
		name = direction + "_" + name

	var anim := get_animation(name)
	anim.loop = looped

	if backwards:
		speed = speed * -1
		play(name, -1, speed, true)
	else:
		play(name, -1, speed)

# direction names
const DIRECTIONS = ["back", "right", "front", "left"]

# smooth 8-axis snapping
# SEE: https://forum.unity.com/threads/8-way-direction-joystick-only.438758/
func get_direction_name(input: Vector2) -> String:
	var rad = input.angle()
	var deg = -7.5 * sin(rad * 4) + rad2deg(rad)
	return DIRECTIONS[int(round(deg / 90)) + 1]

func get_direction_name_from_player() -> String:
	var anim = current_animation.split("_")[0]
	if anim == "side":
		anim = "left" if flipped else "right"
	if DIRECTIONS.find(anim) > -1:
		return anim
	return "none"

func get_direction_from_name(name: String) -> Vector2:
	match name:
		"left":
			return Vector2.LEFT
		"right":
			return Vector2.RIGHT
		"back":
			return Vector2.UP
		"front":
			return Vector2.DOWN
	return Vector2.ZERO

func get_side_direction(name: String) -> String:
	if name == "left" or name == "right":
		return "side"
	return name
