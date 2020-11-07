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
		var transition = _auto_run(_current_state, delta)
		
		# Handle the case where the function return coroutine
		if transition is GDScriptFunctionState and transition.is_valid():
			transition = yield(transition, "completed")
		
		if transition is int and transition != null:
			set_state(transition)

func set_state(new_state: int):
	var prev_state = _current_state
	
	if prev_state != null:
		_auto_exit_state(new_state, prev_state)
	
	_auto_enter_state(new_state, prev_state)
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

# Auto-implement methods

# Automatically call function with signature: __state_name(delta)
func _auto_run(current: int, delta: float):
	var transition = _auto_call(current, "__", delta)
	if transition != null:
		return transition
	
	return _run(current, delta)

# Automatically call function with signature: __enter_state_name(previous_state)
func _auto_enter_state(new_state, previous_state):
	_auto_call(new_state, "__enter_", previous_state)
	_enter_state(new_state, previous_state)

# Automatically call function with signature: __exit_state_name(new_state)
func _auto_exit_state(new_state, previous_state):
	_auto_call(previous_state, "__exit_", new_state)
	_exit_state(new_state, previous_state)

func _auto_call(target_state, prefix: String, parameter):
	for s in state:
		if state[s] != target_state:
			continue
		var method_name := prefix + str(s)
		if self.has_method(method_name):
			return self.call(method_name, parameter)
