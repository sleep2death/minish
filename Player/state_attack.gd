extends EntityStateBase

var direction_name = "none"

export (float, 0.1, 3.0, 0.01) var attack_animation_speed = 2.0
export (int, 100, 600, 1) var friction = 500

export (Shape2D) var shape

var velocity := Vector2.ZERO
var target_pos := Vector2.ZERO

func _enter():
	target_pos = find_target()
	if target_pos == Vector2.ZERO:
		assert(not player.anim_direction_name == "none", "animation has no direction: %s" % ase_player.current_animation)
	else:
		player.anim_direction_name = get_direction_name((target_pos - player.global_position).normalized())

	play_anim("attack_dagger", player.anim_direction_name, attack_animation_speed, false)
	assert(ase_player.connect("animation_finished", self, "on_animation_finished") == OK)

func _exit():
	ase_player.disconnect("animation_finished", self, "on_animation_finished")

func _update(_delta):
	pass

func find_target() -> Vector2:
	var res = player.get_interactives()
	var nearest = player.get_nearest_interactive_pos(res)
	return nearest

func on_animation_finished(_name: String):
	transition_to("Move")
