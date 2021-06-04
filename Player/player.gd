class_name Player
extends KinematicBody2D

var velocity := Vector2.ZERO
var anim_direction_name = "none"

export (int, 0, 300) var detection_range = 64
onready var detection_range_squared = detection_range * detection_range
onready var detection_shape := CircleShape2D.new()

onready var	physics: Physics2DDirectSpaceState = get_parent().get_world_2d().direct_space_state
var query := Physics2DShapeQueryParameters.new()

export (NodePath) var interactives_map = "../Interactives"
onready var interactives := get_node(interactives_map) as TileMap

onready var hurt_box := $HurtBox as Area2D

onready var hit_box := $HitBox as Area2D
onready var hit_shape := hit_box.get_node("CollisionShape2D") as CollisionShape2D

onready var stats := $Stats as Stats
onready var fsm := $FSM as FSM

func _ready():
	detection_shape.radius = detection_range
	query.collide_with_areas = true

func hit_interactives():
	query.set_shape(hit_shape.shape)
	query.transform = hit_shape.global_transform
	query.collision_layer = hit_box.collision_mask

	var res = physics.intersect_shape(query)
	for col in res:
		if col.collider is InteractiveTileMap:
			col.collider.on_hit(col.metadata, stats)
		elif col.collider is HurtBox:
			col.collider.on_hit(stats)
			pass

func get_interactives() -> Array:
	query.set_shape(detection_shape)
	query.transform = global_transform
	query.collision_layer = interactives.collision_layer

	return physics.intersect_shape(query)

func get_nearest_interactive_pos(targets: Array) -> Vector2:
	var nearest = detection_range_squared
	var nearest_pos = Vector2.ZERO
	for t in targets:
		var tm := t.collider as TileMap
		var lp = tm.map_to_world(t.metadata)
		var gp = tm.to_global(lp)
		var dist := global_position.distance_squared_to(gp)

		if dist < nearest:
			nearest = dist
			nearest_pos = gp
	return nearest_pos

func on_joystick_clicked(position):
	print("clicked 0")
	fsm.on_global_event("joystick_clicked", position)
