extends FSMState

var hit_burst := preload("res://VFx/HitBurst.tscn")

onready var entity := get_node("../..") as Peahat

export (int, 0, 600) var knock_back_speed = 80
export (int, 0, 600) var friction = 40

func _enter(from):
	if entity.stats.take_damage(from) == 0:
		print(entity.name + " is dead")

	var dir: Vector2 = (entity.global_position - from.owner.global_position).normalized()
	entity.velocity = knock_back_speed * dir

	var hb := hit_burst.instance() as AnimatedSpriteAutoFree
	hb.playing = true
	hb.global_position = entity.hurt_box.global_position

	get_tree().current_scene.call_deferred("add_child", hb)

func _update(delta):
	entity.velocity = entity.velocity.move_toward(Vector2.ZERO, delta * friction)
	entity.velocity = entity.move_and_slide(entity.velocity)

	if entity.velocity.length_squared() <= 0.01:
		if entity.stats.is_dead:
			transition_to("Dying")
		else:
			transition_to("Flying")

func _exit():
	pass
