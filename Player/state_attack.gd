extends EntityStateBase

var direction_name = "none"

export (float, 0.1, 3.0, 0.01) var attack_animation_speed = 2.0
export (int, 100, 600, 1) var friction = 500

# actually frame, not animation frame
export (int, 0, 10) var hit_start_frame = 4
export (int, 0, 10) var hit_end_frame = 8
var frame_count = 0

func _enter():
	var target_pos := find_target()
	if target_pos == Vector2.ZERO and player.anim_direction_name == "none":
		return push_error("animation has no direction: %s" % ase_player.current_animation)
	else:
		player.anim_direction_name = get_direction_name((target_pos - player.global_position).normalized())

	prints("attack", player.anim_direction_name)
	if ase_player.connect("animation_finished", self, "on_animation_finished") != 0:
		return push_error("can't connect to ase_player")

	play_anim("attack_dagger", player.anim_direction_name, attack_animation_speed, false)
	hit_box.rotation = get_direction_from_name(player.anim_direction_name).angle() - HALF_PI

func _exit():
	frame_count = 0
	ase_player.disconnect("animation_finished", self, "on_animation_finished")

func _update(delta):
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * friction)
	player.velocity = player.move_and_slide(player.velocity)

	# hit duration
	if frame_count >= hit_start_frame && frame_count < hit_end_frame:
		player.hit_interactives()
	frame_count += 1

func find_target() -> Vector2:
	var res = player.get_interactives()
	var nearest = player.get_nearest_interactive_pos(res)
	return nearest

func on_animation_finished(_name: String):
	transition_to("Move", false)
