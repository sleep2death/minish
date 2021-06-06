class_name Stats
extends Node

export (int, 1, 100, 1) var damage = 1

export (int, 1, 20, 1) var max_hp = 12
onready var hp: int = max_hp setget set_hp

signal dying()
signal health_changed(hp)

var is_dead: bool = false setget _block_set, _is_dead

func _ready():
	emit_signal("health_changed", hp)

func set_hp(value):
	value = clamp(value, 0, max_hp)
	if value != hp:
		hp = value
		emit_signal("health_changed", hp)

	if hp == 0:
		emit_signal("dying")
func _is_dead() -> bool:
	return hp <= 0

func take_damage(from: Stats) -> int:
	self.hp -= from.damage
	return hp

func _block_set(_value):
	push_error('can not set is_dead, read ONLY')
