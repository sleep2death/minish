class_name Utils
extends Object

const half_pi = PI * 0.5

static func find_nearest_target(global_pos: Vector2, targets: Array) -> KinematicBody2D:
	if targets.size() == 0:
		return null
	elif targets.size() == 1:
		return targets[0]

	var nearest_dist = INF
	var nearest: KinematicBody2D = null
	for p in targets:
		var dist = global_pos.distance_squared_to(p.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = p
		else:
			continue

	return nearest
