extends BackBufferCopy

onready var color_filter := $ColorFilter
onready var tween := $Tween as Tween

func _ready():
	pass
	
var going_to_grey := false
var grey_offset: float = 0.0

func _on_player_death(_player):
	going_to_grey = true
	grey_offset = 0.0
	# var shader = color_filter.material.shader as Shader
	# tween.interpolate_property(shader, "shader_param:grey_offset", 0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)

func _physics_process(delta):
	if going_to_grey && grey_offset < 1:
		grey_offset += delta
		color_filter.material.set_shader_param("grey_offset", grey_offset)
