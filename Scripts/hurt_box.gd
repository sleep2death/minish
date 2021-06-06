extends Area2D
class_name HurtBox

signal hurt(stats)
func on_hit(stats):
	# print("get hit from: ", stats.owner.name)
	emit_signal("hurt", stats)
