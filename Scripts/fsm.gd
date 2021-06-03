class_name FSM
extends Node

export (NodePath) var initial_state_node: NodePath

var current_state: FSMState
var previous_state: FSMState

func _ready():
	call_deferred("on_transitioned", initial_state_node)

func on_transitioned(to):
	var next := get_node_or_null(to) as FSMState
	assert(next != null, "next state not found: " + to)

	if current_state != null:
		current_state._exit()
		previous_state = current_state

	current_state = next
	assert(current_state.connect("transitioned", self, "on_transitioned", [], CONNECT_ONESHOT) == OK)

	current_state._enter()

func on_global_event(name, args):
	if current_state:
		current_state._on_global_event(name, args)

func _physics_process(delta):
	if current_state:
		current_state._update(delta)
