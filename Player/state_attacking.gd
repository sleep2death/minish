extends EntityStateBase

var direction_name = "none"

export (float, 0.1, 3.0, 0.01) var attack_animation_speed = 2.0
export (int, 100, 600, 1) var friction = 500

# actually frame, not animation frame
export (int, 0, 10) var hit_start_frame = 4
export (int, 0, 10) var hit_end_frame = 8
var frame_count = 0

func _enter(_args):
	var target_pos := find_target()
	if target_pos == Vector2.ZERO and player.anim_direction_name == "none":
		return push_error("animation has no direction: %s" % player.ase.current_animation)
	elif target_pos != Vector2.ZERO:
		# prints(target_pos, player.global_position)
		# prints(rad2deg((target_pos - player.global_position).normalized().angle()))
		player.anim_direction_name = player.ase.get_direction_name((target_pos - player.hit_box.global_position).normalized())

	if player.ase.connect("animation_finished", self, "on_animation_finished") != 0:
		return push_error("can't connect to ase_player")

	player.ase.play_anim("attack_dagger", player.anim_direction_name, attack_animation_speed, false)
	player.hit_box.rotation = player.ase.get_direction_from_name(player.anim_direction_name).angle() - HALF_PI

func _exit():
	frame_count = 0
	player.ase.disconnect("animation_finished", self, "on_animation_finished")

func _update(delta):
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * friction)
	player.velocity = player.move_and_slide(player.velocity)

	# hit duration
	if frame_count >= hit_start_frame && frame_count < hit_end_frame:
		if player.hit_interactives():
			player.freeze_frame(30)
			player.shake_camera(0.1)
			
	frame_count += 1

func find_target() -> Vector2:
	var res = player.get_interactives()
	return player.get_nearest_interactive_pos(res)

func on_animation_finished(_name: String):
	transition_to("Moving", null, false)
