extends FSMState

export (float, 0.1, 3.0) var fly_anim_speed = 1.0
onready var entity := get_node("../..") as Peahat

onready var animated_top := get_node("../../animated_top") as AnimatedSprite

export (int, 0, 480, 1) var ground_count = 120
var idle_count = 0

func _enter():
	entity.ase.play_anim("fly", "", fly_anim_speed)

	entity.hit_box.position.y = -20
	entity.hurt_box.position.y = -20

	animated_top.visible = true

	if entity.target_detection.connect("targets_changed", self, "on_targets_changed") != 0:
		push_error("can't connected to: " + entity.target_detection.name)

func _exit():
	animated_top.visible = false
	idle_count = 0
	entity.target_detection.disconnect("targets_changed", self, "on_targets_changed")

func _update(_delta):
	var target := Utils.find_nearest_target(entity.global_position, entity.target_detection.targets)
	if not target:
		idle_count += 1
		if idle_count > ground_count:
			entity.jump_up = false
			transition_to("Jump")

func on_targets_changed(targets):
	if targets.size() > 0:
		pass

