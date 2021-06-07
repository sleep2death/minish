extends FSMState

var enemy_death := preload("res://VFx/GlobalEnemyDeath.tscn")

onready var entity := get_node("../..") as Lizafos

export (int, 0, 600) var knock_back_speed = 80
export (int, 0, 600) var friction = 40

func _enter(_from):
	var anim := enemy_death.instance() as AnimatedSpriteAutoFree
	anim.playing = true
	anim.global_position = entity.hurt_box.global_position

	get_tree().current_scene.call_deferred("add_child", anim)
	entity.call_deferred("queue_free")

func _update(_delta):
	pass

func _exit():
	pass
