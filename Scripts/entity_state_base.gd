class_name EntityStateBase
extends FSMState

onready var joystick := get_node("/root/Game/CanvasLayer/UI/Joystick") as Joystick

export (NodePath) var body_node = "../.."
onready var player := get_node(body_node) as Player

export (NodePath) var foot_collision_node = "../../FootCollision"
onready var foot_collision := get_node(foot_collision_node) as CollisionShape2D

export (NodePath) var hurt_box_node = "../../HurtBox"
onready var hurt_box := get_node(hurt_box_node) as Area2D

export (NodePath) var hit_box_node = "../../HitBox"
onready var hit_box := get_node(hit_box_node) as Area2D

export (NodePath) var ase_player_node = "../../AsePlayer"
onready var ase_player := get_node(ase_player_node) as AsePlayer

func play_anim(name: String, direction: String = "", speed: float = 1.0, looped: bool = true, backwards: bool = false):
	if not direction.empty():
		if direction == "left":
			ase_player.flipped = true
		else:
			ase_player.flipped = false

		direction = get_side_direction(direction)
		name = direction + "_" + name

	var anim := ase_player.get_animation(name)
	anim.loop = looped

	if backwards:
		speed = speed * -1
		ase_player.play(name, -1, speed, true)
	else:
		ase_player.play(name, -1, speed)
func get_direction_vector() -> Vector2:
	return joystick.output.normalized()

# direction names
const DIRECTIONS = ["back", "right", "front", "left"]

# smooth 8-axis snapping
# SEE: https://forum.unity.com/threads/8-way-direction-joystick-only.438758/
func get_direction_name(input: Vector2) -> String:
	var rad = input.angle()
	var deg = -7.5 * sin(rad * 4) + rad2deg(rad)
	return DIRECTIONS[int(round(deg / 90)) + 1]

func get_direction_name_from_player() -> String:
	var anim = ase_player.current_animation.split("_")[0]
	if anim == "side":
		anim = "left" if ase_player.flipped else "right"
	if DIRECTIONS.find(anim) > -1:
		return anim
	return "none"

func get_side_direction(name: String) -> String:
	if name == "left" or name == "right":
		return "side"
	return name
