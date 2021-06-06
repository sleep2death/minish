extends TileMap
class_name InteractiveTileMap

var bush_particles = preload("res://VFx/BushParticles.tscn")
var lostwoods_bush_particles = preload("res://VFx/LostWoodsBushParticles.tscn")

func on_hit(pos: Vector2, _stats: Stats):
	var lp = map_to_world(pos)
	var gp = to_global(lp)

	match tile_set.tile_get_name(get_cellv(pos)):
		"global_bush":
			hit_bush(pos, gp, bush_particles)
		"lostwoods_bush":
			hit_bush(pos, gp, lostwoods_bush_particles)

func hit_bush(map_pos, global_pos, par):
	var p = par.instance()
	p.position = global_pos + Vector2(16, 16)
	var world = get_tree().current_scene
	world.add_child(p)

	set_cellv(map_pos, -1)
