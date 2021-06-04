class_name Peahat
extends Agent

onready var hit_box := $HitBox
onready var hurt_box := $HurtBox

onready var ase := $AsePlayer
onready var target_detection = $TargetDetection

onready var shadow = $layer_shadow

var velocity := Vector2.ZERO
var jump_up := true

func _ready():
	pass
