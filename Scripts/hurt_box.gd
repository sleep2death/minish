extends Area2D
class_name HurtBox

signal hurt(stats)

func _ready():
	# warning-ignore: return_value_discarded
	connect("area_entered", self, "on_area_entered")

func on_area_entered(hit_box: Area2D):
	if hit_box.owner and hit_box.owner.stats:
		on_hit(hit_box.owner.stats)

func on_hit(stats):
	# print("get hit from: ", stats.owner.name)
	emit_signal("hurt", stats)
