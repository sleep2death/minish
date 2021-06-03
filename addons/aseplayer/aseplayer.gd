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
