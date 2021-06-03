extends Camera2D

export (NodePath) var player_node = "../Player"
onready var player := get_node(player_node) as Player

onready var tween := $ShiftTween as Tween

export (float, -2, 2, 0.01) var offset_scale = 0

onready var sz = OS.get_real_window_size().normalized()

func _physics_process(_delta):
	pass
	# var target_position = player.global_position + player.look_ahead * offset_scale * sz
	# global_position = target_position
