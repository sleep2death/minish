extends FSMState

var hit_burst := preload("res://VFx/HitBurst.tscn")

onready var entity := get_node("../..") as Lizafos
export (float, 0.1, 3.0) var hurt_anim_speed = 1.5

export (int, 0, 600) var knock_back_speed = 150
export (int, 0, 600) var friction = 300

export (int, 0, 360, 1) var move_count: int = 180
var frame_count: int = 0

export (int, 0, 100, 1) var freeze_count = 30

var is_dizzle: bool = false

func _enter(_args):
	var dir := Vector2.ZERO
	if _args is KinematicCollision2D:
		is_dizzle = true
		dir = _args.normal
		entity.velocity = dir * knock_back_speed
		entity.direction_name = entity.ase.get_direction_name(dir * -1.0)
	elif _args is Stats:
		entity.stats.take_damage(_args)
		is_dizzle = false
		dir = (entity.global_position - _args.owner.global_position).normalized()
		
		entity.velocity = dir * knock_back_speed
		entity.direction_name = entity.ase.get_direction_name(dir * -1.0)
		
		var hb := hit_burst.instance() as AnimatedSpriteAutoFree
		hb.playing = true
		hb.global_position = entity.hurt_box.global_position

		get_tree().current_scene.call_deferred("add_child", hb)
			
	entity.ase.play_anim("hurt", entity.direction_name, hurt_anim_speed, false)

func _exit():
	is_dizzle = false
	frame_count = 0

func _update(delta):
	entity.velocity = entity.velocity.move_toward(Vector2.ZERO, delta * friction)
	entity.velocity = entity.move_and_slide(entity.velocity)
	
	if entity.velocity == Vector2.ZERO:
		if entity.stats.hp > 0:
			if is_dizzle:
				frame_count += 1
				if frame_count > freeze_count:
					transition_to("Idle")
			else:
				transition_to("Idle")
		else:
			transition_to("Death")


		

		
