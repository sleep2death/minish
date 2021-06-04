extends Node2D
class_name DropShadow

export (NodePath) var target_node = "../layer_body"
onready var target = get_node(target_node)

export (Vector2) var offset = Vector2(-3, 1.0)

export (float, 0.0, 1.0, 0.1) var scale_y = 0.60
export (float, -1.0, 1.0, 0.1) var skew_x = 0.75
export (float, 0.0, 1.0, 0.1) var alpha = 0.3

func _draw():
	var tr = Transform2D(Vector2(target.scale.x, 0), Vector2(skew_x, scale_y), offset)
	self.transform = tr
	draw_texture(target.texture, target.offset, Color(0, 0, 0, alpha))

func _physics_process(_delta):
	update()
