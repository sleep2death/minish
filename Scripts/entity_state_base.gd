class_name EntityStateBase
extends FSMState

const HALF_PI = PI * 0.5

export (NodePath) var player_node = "../.."
onready var player := get_node(player_node) as Player
