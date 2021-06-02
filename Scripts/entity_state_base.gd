class_name EntityStateBase
extends FSMState

onready var joystick := get_node("/root/Game/UI/Joystick") as Joystick

export (NodePath) var foot_collision_node = "../../FootCollision"
onready var foot_collision := get_node(foot_collision_node) as CollisionShape2D

export (NodePath) var hurt_box_node = "../../HurtBox"
onready var hurt_box := get_node(hurt_box_node) as Area2D

export (NodePath) var hit_box_node = "../../HitBox"
onready var hit_box := get_node(hit_box_node) as Area2D

export (NodePath) var ase_player_node = "../../AsePlayer"
onready var ase_player := get_node(ase_player_node) as AsePlayer

func get_direction_vector() -> Vector2:
	return joystick.output.normalized()

# direction names
const DIRECTIONS = ["back", "right", "front", "left"]

# smooth 8-axis snapping
# SEE: https://forum.unity.com/threads/8-way-direction-joystick-only.438758/
func get_direction_name() -> String:
	if joystick.output.length_squared() > 0:
		var rad = joystick.output.normalized().angle()
		var deg = -7.5 * sin(rad * 4) + rad2deg(rad)
		return DIRECTIONS[int(round(deg / 90)) + 1]
	else:
		return "none"

func get_side_direction(name: String) -> String:
	if name == "left" or name == "right":
		return "side"
	return name
