extends FSMState

onready var entity := get_node("../..") as Peahat

export (float, 0.1, 3.0) var jump_anim_speed = 1.0

func _enter():
	if entity.jump_up:
		entity.ase.play_anim("jump", "", jump_anim_speed, false)
	else:
		entity.ase.play_anim("jump", "", jump_anim_speed, false, true)

	if entity.ase.connect("animation_finished", self, "on_animation_finished") != 0:
		push_error("can't connected to: " + entity.ase.name)

func _exit():
	entity.ase.disconnect("animation_finished", self, "on_animation_finished")

func on_animation_finished(_anim):
	if entity.jump_up:
		transition_to("Fly")
	else:
		transition_to("Ground")

