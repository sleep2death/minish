extends Node

export (NodePath) var output_label_node = "./UI/Output"
onready var output_label = get_node(output_label_node)

export (NodePath) var joystick_node = "./UI/Joystick"
onready var joystick := get_node(joystick_node) as Joystick

func _process(_delta: float):
	output_label.text = var2str(joystick.output)
