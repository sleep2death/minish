class_name FSMState
extends Node

signal transitioned(to)

func transition_to(name: String):
	call_deferred("emit_signal", "transitioned", name)

func _enter():
	pass

func _update(_delta):
	pass

func _exit():
	pass

func _on_global_event(_name, _args):
	pass
