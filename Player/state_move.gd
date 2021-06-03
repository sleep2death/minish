extends EntityStateBase

export (float, 0.1, 3.0, 0.01) var idle_animation_speed = 1.0
export (float, 0.1, 3.0, 0.01) var move_animation_speed = 1.0

export (int, 10, 600, 1) var max_speed = 120
export (int, 100, 600, 1) var acceleration = 500
export (int, 100, 600, 1) var friction = 500

func _enter():
	assert(joystick.connect("clicked", self, "on_clicked") == OK)

func _exit():
	joystick.disconnect("clicked", self, "on_clicked")
func _update(delta):
	var input := joystick.output.normalized()
	var vel = input * max_speed

	if input.length_squared() > 0:
		player.anim_direction_name = get_direction_name(input)
		play_anim("move", player.anim_direction_name, move_animation_speed)

		player.velocity = player.velocity.move_toward(vel, acceleration * delta)
	else:
		if not player.anim_direction_name == "none":
			play_anim("idle", player.anim_direction_name, idle_animation_speed)
		else:
			play_anim("idle", "front", idle_animation_speed)
			player.anim_direction_name = "front"

		player.velocity = player.velocity.move_toward(vel, friction * delta)

	player.velocity = player.move_and_slide(player.velocity)

func on_clicked(_pos: Vector2):
	transition_to("Attack", true)
