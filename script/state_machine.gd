extends Node

class_name StateMachine

var parent: Node

var state: Dictionary = {}
var _current_state = null setget set_state

func _ready() -> void:
	parent = get_parent()
	var init_state = _start()
	call_deferred("set_state", init_state)

func _process(delta: float) -> void:
	if _current_state != null:
		var transition = _run(_current_state, delta)
		
		# Handle the case where the function return coroutine
		if transition is GDScriptFunctionState and transition.is_valid():
			transition = yield(transition, "completed")
		
		if transition is int and transition != null:
			set_state(transition)

func set_state(new_state: int):
	var prev_state = _current_state
	
	if prev_state != null:
		_exit_state(new_state, prev_state)
	
	_enter_state(new_state, prev_state)
	_current_state = new_state

func add_state(state_name):
	state[state_name] = state.size()

# Virtual Methods

func _start():
	pass

func _run(state: int, delta: float):
	return null

func _enter_state(new_state, previous_state):
	pass

func _exit_state(new_state, previous_state):
	pass
