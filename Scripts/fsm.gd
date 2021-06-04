class_name FSM
extends Node

export (NodePath) var initial_state_node: NodePath

var current_state: FSMState

func _ready():
	call_deferred("on_transitioned", initial_state_node)

func on_transitioned(to):
	var next := get_node_or_null(to) as FSMState
	if not next:
		return push_error("next state not found: " + to)

	if current_state != null:
		current_state._exit()
		current_state.disconnect("transitioned", self, "on_transitioned")

	if next.connect("transitioned", self, "on_transitioned") != 0:
		return push_error("next state can't connect: " + to)

	next._enter()
	current_state = next

func on_global_event(name, args):
	if current_state:
		current_state._on_global_event(name, args)

func _physics_process(delta):
	if current_state:
		current_state._update(delta)
