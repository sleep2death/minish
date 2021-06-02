extends EntityStateBase

var direction = "none"

func _enter():
	direction = get_direction_name()
	
	ase_player.play("side_idle")
	ase_player.flipped = true
