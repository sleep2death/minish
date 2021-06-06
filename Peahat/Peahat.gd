class_name Peahat
extends Agent

onready var hit_box := $HitBox
onready var hurt_box := $HurtBox

onready var ase := $AsePlayer
onready var target_detection = $TargetDetection

onready var shadow = $layer_shadow

onready var fsm = $FSM

onready var stats = $Stats

var velocity := Vector2.ZERO

func _ready():
	if  hurt_box.connect("hurt", self, "on_hurt") != 0:
		push_error("can not connected to hurtbox")

func on_hurt(from: Stats):
	fsm.on_global_event("on_hurt", from)
