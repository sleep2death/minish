extends Node2D
class_name WaterReflection

var target: Sprite
var offset: Vector2 = Vector2(0, 10)

var water_splash_scene = preload("res://VFx/WaterSplash.tscn")
onready var water_splash: AnimatedSprite = water_splash_scene.instance()

var water_circle_scene = preload("res://VFx/WaterCircle.tscn");
onready var water_circle: AnimatedSprite = water_circle_scene.instance()

func _ready():
	add_child(water_splash)
	add_child(water_circle)
	
	water_splash.scale.y = -1
	water_circle.scale.y = -1
	
	water_splash.position += offset * 0.5
	water_circle.position += offset * 0.5
	
	water_splash.z_index = 1
	
	water_splash.hide()
	water_circle.hide()
	
	do_update()

func _draw():
	var tr = Transform2D(Vector2(target.global_transform.x.x, 0), Vector2(0, -1), target.global_position + offset)
	self.transform = tr
	draw_texture(target.texture, target.offset)

func do_update():
	var t = target.texture as AtlasTexture
	material.set_shader_param("os", t.region.position.y)
	material.set_shader_param("oe", t.region.position.y + t.region.size.y)
	
	if "velocity" in target.get_parent():
		if target.get_parent().velocity != Vector2.ZERO:
			water_splash.show()
			water_circle.hide()
		else:
			water_circle.show()
			water_splash.hide()
	update()
