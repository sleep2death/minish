extends Position2D

export (NodePath) var player_node = "../World/Player"
onready var player := get_node(player_node) as Player

export (NodePath) var camera_node = "./Camera"
onready var camera := get_node(camera_node) as Camera2D

export (float, -1.0, 1.0, 0.001) var offset_scale = 0.5

func _physics_process(_delta):
	global_position = player.global_position + player.velocity * offset_scale
