extends Position2D
class_name WaterDetecion

export (NodePath) var water_tiles_node := "/root/Game/TileMaps/Water"
onready var water_tiles := get_node(water_tiles_node) as TileMap

export (NodePath) var reflection_target_node := ".."
onready var reflection_target := get_node(reflection_target_node)

export (bool) var draw_reflection := false
var water_reflection_scene = preload("res://Components/water_reflection.tscn");
onready var water_reflection: WaterReflection = water_reflection_scene.instance()

export (bool) var draw_water_splash := false

func _ready():
	if draw_reflection:
		water_reflection.target = reflection_target.get_node("layer_body")
		water_tiles.add_child(water_reflection)
		
var in_water: bool = false
var cell_value: int = -1

func _physics_process(delta):
	var pos := water_tiles.world_to_map(global_position)
	cell_value = water_tiles.get_cellv(pos)
	
	if cell_value >= 0:
		in_water = true
		if draw_reflection:
			water_reflection.show()
			water_reflection.do_update()
	else:
		water_reflection.hide()
		in_water = false

func _exit_tree():
	water_tiles.remove_child(water_reflection)
