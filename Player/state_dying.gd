extends EntityStateBase

export (float, 0.1, 3.0, 0.01) var death_animation_speed = 1.0

func _enter(_args):
	player.ase.play_anim("death", "", death_animation_speed, false)

	if not player.ase.connect("animation_finished", self, "on_animation_finished") == OK:
		push_error("can not connected to player's ase")

func on_animation_finished(_anim):
	player.is_dead = true
	
func _exit():
	player.ase.disconnect("animation_finished", self, "on_animation_finished")
