extends AnimatedSprite
class_name AnimatedSpriteAutoFree

var rewind := false

func _ready():
	if rewind:
		play("default", true)
	else:
		self.frame = 0
		play("default", false)

	#warning-ignore: return_value_discarded
	connect("animation_finished", self, "on_animation_finished")

func on_animation_finished():
	disconnect("animation_finished", self, "on_animation_finished")
	queue_free()
