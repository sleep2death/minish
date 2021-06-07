extends FSMState

onready var entity := get_node("../..") as Lizafos

export (float, 0.1, 3.0) var grab_anim_speed = 1.0

var backwards: bool = false

func _enter(_args):
	backwards = _args
	if not backwards:
		entity.ase.play_anim("spear_grab", entity.direction_name, grab_anim_speed, false)
	else:
		entity.ase.play_anim("spear_grab", entity.direction_name, grab_anim_speed, false, true)

	if entity.ase.connect("animation_finished", self, "on_animation_finished") != 0:
		push_error("can't connected to: " + entity.ase.name)

func _exit():
	entity.ase.disconnect("animation_finished", self, "on_animation_finished")

func on_animation_finished(_anim):
	if not backwards:
		transition_to("Move")
	else:
		transition_to("Idle")

func _on_global_event(name, _args):
	if name == "on_hurt":
		transition_to("Hurt", _args)
