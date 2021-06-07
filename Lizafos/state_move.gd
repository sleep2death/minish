extends FSMState

onready var entity := get_node("../..") as Lizafos
export (float, 0.1, 3.0) var move_anim_speed = 1.0

# Maximum possible linear velocity
export (int, 1, 15, 1) var move_speed = 4
# Maximum change in linear velocity
export (int, 1, 20, 1) var acceleration = 1

var target_dir := Vector2.ZERO

export (int, 0, 360, 1) var move_count: int = 180
var frame_count: int = 0

func _enter(_args):
	if entity.target_detection.targets.size() > 0:
		var target := Utils.find_nearest_target(entity.global_position, entity.target_detection.targets)
		target_dir = (target.global_position - entity.global_position).normalized()
		entity.direction_name = entity.ase.get_direction_name(target_dir)
		
		entity.ase.play_anim("spear_move", entity.direction_name, move_anim_speed)
	else:
		transition_to("Grab", true, false)

func _exit():
	frame_count = 0
	entity.velocity = Vector2.ZERO
		
func _update(delta):
	entity.velocity = entity.velocity.move_toward(target_dir * move_speed, delta * acceleration)
	var collision = entity.move_and_collide(entity.velocity)
	
	if collision != null:
		# prints(collision.position, collision.normal, collision.collider)
		transition_to("Hurt", collision)
		# _fsm.transition_to("hurt", null)
	else:
		frame_count += 1
		if frame_count > move_count:
			transition_to("Grab", true)

func _on_global_event(name, _args):
	if name == "on_hurt":
		transition_to("Hurt", _args)
