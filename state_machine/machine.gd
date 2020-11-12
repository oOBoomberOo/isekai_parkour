extends Node

class_name StateMachine

signal state_changed(prev, new)
signal quit

export(String) var init_state

var stack := []
var _state := {}
var active := false setget set_active

func pop_state():
	var prev_name := stack.pop_back() as String
	var new_name = stack.back()
		
	var prev := state(prev_name)
	var new := state(new_name)
	
	prev._exit(new)
	if new != null:
		new._enter(prev)

	emit_signal("state_changed", prev, new)

func push_state(new_name: String):
	var prev_name := stack.back() as String
	stack.push_back(new_name)
	
	var prev := state(prev_name)
	var new := state(new_name)
	
	prev._exit(new)
	new._enter(prev)
	
	emit_signal("state_changed", prev, new)

func switch_state(new_name: String):
	var prev_name := stack.pop_back() as String
	stack.push_back(new_name)
	
	var prev := state(prev_name)
	var new := state(new_name)
	
	prev._exit(new)
	new._enter(prev)
	
	emit_signal("state_changed", prev, new)

func set_active(value: bool):
	active = value
	set_process(value)
	set_physics_process(value)

func current():
	if stack.empty():
		return null
	return stack.back()

func state(name) -> State:
	return _state.get(name)


func initiate():
	if not init_state:
		init_state = _state.keys().front()
	
	for child in get_children():
		if child is State:
			child.connect("switch", self, "switch_state")
			child.connect("push", self, "push_state")
			child.connect("pop", self, "pop_state")
	
	set_active(true)
	stack.push_front(init_state)
	var state := state(init_state)
	state._enter(null)

func _ready():
	call_deferred("initiate")

func _process(delta: float) -> void:
	if stack.empty():
		emit_signal("quit")
		return
	
	var current_state := state(current())
	if current_state != null:
		current_state._update(delta)

func _unhandled_input(event):
	var current_state := state(current())
	if current_state != null:
		current_state._handle_input(event)
