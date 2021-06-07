extends Position2D
class_name VisualCamera

export (NodePath) var player_node = "../World/Player"
onready var player := get_node(player_node) as Player

export (NodePath) var camera_node = "./Camera"
onready var camera := $Camera

export (OpenSimplexNoise) var noise
export(float, 0, 1) var trauma = 0.0

export var max_x = 150
export var max_y = 150
export var max_r = 25

export var time_scale = 150

export(float, 0, 1) var decay = 0.6

var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	for r in get_tree().get_nodes_in_group("camera_shaker"):
		r.connect("req_shake_camera", self, "add_trauma")
	
	for r in get_tree().get_nodes_in_group("frame_freezer"):
		r.connect("req_frame_freeze", self, "freeze_frame")

var is_shaking_locked: bool = false
func add_trauma(trauma_in: float):
	if is_shaking_locked == false:
		is_shaking_locked = true
		trauma = clamp(trauma + trauma_in, 0, 1)

var is_frame_freezing: bool = false

func freeze_frame(duration: float):
	if not is_frame_freezing:
		get_tree().paused = true
		is_frame_freezing = true
		
		yield(get_tree().create_timer(duration), 'timeout')
		get_tree().paused = false
		is_frame_freezing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	# if trauma > 0: prints(trauma, rotation_degrees)
	
	var shake = pow(trauma, 2)
	global_position.x = player.global_position.x + noise.get_noise_3d(time * time_scale, 0, 0) * max_x * shake
	global_position.y = player.global_position.y + noise.get_noise_3d(0, time * time_scale, 0) * max_y * shake
	rotation_degrees = noise.get_noise_3d(0, 0, time * time_scale) * max_r * shake
		
	if trauma > 0: 
		trauma = clamp(trauma - (delta * decay), 0, 1)
	else:
		is_shaking_locked = false

