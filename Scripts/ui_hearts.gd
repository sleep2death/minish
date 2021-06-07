extends HBoxContainer

export (NodePath) var player_node
onready var player := get_node(player_node) as Player
onready var stats := player.stats

var hud_hearts := preload("res://UI/Heart.tscn")

func _ready():
	if not stats.connect("health_changed", self, "on_health_changed") == OK:
		return push_error("can not connected to player")
	update_hearts(stats.max_hp)
	
func on_health_changed(hp):
	update_hearts(hp)
	# label.text = "HP: " + String(hp)

func update_hearts(hp: int):
	for c in get_children():
		c.queue_free()
	
	for _i in range(0, hp * 0.25):
		var hh := hud_hearts.instance() as HudHearts
		call_deferred("add_child", hh)
	
	var m = hp % 4
	if m > 0:
		var h := hud_hearts.instance() as HudHearts
		h.set_heart(m)
		call_deferred("add_child", h)
