extends Agent
class_name Lizafos

onready var hit_box := $HitBox as HitBox
onready var hurt_box := $HurtBox as HurtBox

onready var ase := $AsePlayer as AsePlayer
onready var target_detection = $TargetDetection as TargetDetection

onready var shadow = $layer_shadow

onready var fsm = $FSM

onready var stats := $Stats as Stats

var velocity := Vector2.ZERO

export (String, "front", "back", "left", "right") var direction_name = "front"

func _on_hit(s):
	if s is Player and s.invincible_time <= 0:
		shake_camera(0.3)
		freeze_frame(0.01)
	
		fsm.on_global_event("on_hit", s)

func _on_hurt(s):
	fsm.on_global_event("on_hurt", s)
	
signal req_frame_freeze(duration)

func freeze_frame(duration: float):
	emit_signal("req_frame_freeze", duration)
	
signal req_shake_camera(trauma)

func shake_camera(trauma: float):
	emit_signal("req_shake_camera", trauma)
