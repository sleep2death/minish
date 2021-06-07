class_name HitBox
extends Area2D

signal hit(stats)

func _ready():
	# warning-ignore: return_value_discarded
	connect("area_entered", self, "on_area_entered")

func on_area_entered(hurt_box: Area2D):
	if hurt_box.owner and hurt_box.owner.stats:
		on_hit(hurt_box.owner.stats)

func on_hit(stats):
	# print("get hit from: ", stats.owner.name)
	emit_signal("hit", stats)
