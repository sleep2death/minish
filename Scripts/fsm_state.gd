class_name FSMState
extends Node

signal transitioned(to)

func transition_to(name: String, args = null, immediatly: bool = true):
	if immediatly:
		emit_signal("transitioned", name, args)
	else:
		call_deferred("emit_signal", "transitioned", name, args)

func _enter(_args):
	pass

func _update(_delta):
	pass

func _exit():
	pass

func _on_global_event(_name, _args):
	pass
