extends FSMState

export (float, 0.1, 3.0) var idle_anim_speed = 1.0
onready var entity := get_node("../..") as Lizafos

# Maximum change in linear velocity
export (int, 100, 500, 1) var deceleration = 300

func _enter(_args):
	entity.ase.play_anim("idle", entity.direction_name, idle_anim_speed)

	if entity.target_detection.connect("targets_changed", self, "on_targets_changed") != 0:
		push_error("can't connected to: " + entity.target_detection.name)

func _exit():
	entity.target_detection.disconnect("targets_changed", self, "on_targets_changed")

func on_targets_changed(targets):
	if targets.size() > 0:
		transition_to("Grab", false)

func _on_global_event(name, _args):
	if name == "on_hurt":
		transition_to("Hurt", _args)

