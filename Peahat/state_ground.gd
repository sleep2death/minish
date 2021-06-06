extends FSMState

export (float, 0.1, 3.0) var ground_anim_speed = 1.0
onready var entity := get_node("../..") as Peahat

func _enter(_args):
	entity.ase.play_anim("ground", "", ground_anim_speed)

	entity.hit_box.position.y = 0
	entity.hurt_box.position.y = 0

	if entity.target_detection.connect("targets_changed", self, "on_targets_changed") != 0:
		push_error("can't connected to: " + entity.target_detection.name)

func _exit():
	entity.target_detection.disconnect("targets_changed", self, "on_targets_changed")

func on_targets_changed(targets):
	if targets.size() > 0:
		transition_to("Jumping", false)

