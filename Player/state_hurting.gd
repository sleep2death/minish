extends EntityStateBase

export (float, 0.1, 3.0, 0.01) var hurt_animation_speed = 1.0

export (int, 10, 600, 1) var knock_back_speed = 280
export (int, 100, 600, 1) var friction = 560

export (float, 0.0, 5.0) var hurt_invincible_duration = 0.75

export (float, 0.0, 5.0) var cancel_point = 0.35
var time_count = cancel_point

func _enter(from: Stats):
	if player.stats.take_damage(from) == 0:
		print(player.name + " is dead")
	player.invincilbe_time += hurt_invincible_duration
	
	var dir: Vector2 = (player.global_position - from.owner.global_position).normalized()
	player.velocity = knock_back_speed * dir
	
	player.anim_direction_name = player.ase.get_direction_name(dir * -1)
	player.ase.play_anim("hurt", player.anim_direction_name, hurt_animation_speed, false)

	if not player.ase.connect("animation_finished", self, "on_animation_finished") == OK:
		push_error("can not connected to player's ase")

func _update(delta):
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * friction)
	player.velocity = player.move_and_slide(player.velocity)
	
	if player.joystick.output.length_squared() > 0 and time_count < 0 and player.stats.hp > 0:
		return transition_to("Moving")
	
	if player.velocity == Vector2.ZERO:
		if player.stats.hp > 0:
			transition_to("Moving")
		else:
			transition_to("Dying")
				
	if time_count > 0: time_count -= delta

func on_animation_finished(_anim):
	if time_count < 0:
		pass
		# transition_to("Moving", null, false)
	
func _exit():
	player.ase.disconnect("animation_finished", self, "on_animation_finished")
	time_count = cancel_point
