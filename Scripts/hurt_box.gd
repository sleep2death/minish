extends Area2D
class_name HurtBox

func on_hurt(stats):
	print("get hit from: ", stats.owner)
