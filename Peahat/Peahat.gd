class_name Peahat
extends KinematicBody2D

onready var hit_box := $HitBox
onready var hurt_box := $HurtBox

onready var ase := $AsePlayer
onready var target_detection = $TargetDetection

onready var shadow = $layer_shadow

var jump_up := true

func _ready():
	pass
