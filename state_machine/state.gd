extends Node

class_name State

# warning-ignore:unused_signal
signal switch(new)
# warning-ignore:unused_signal
signal push(new)
# warning-ignore:unused_signal
signal pop

# warning-ignore:unused_argument
func _enter(prev: Node) -> void:
	pass

# warning-ignore:unused_argument
func _exit(new: Node) -> void:
	pass

# warning-ignore:unused_argument
func _update(delta: float) -> void:
	pass

# warning-ignore:unused_argument
func _handle_input(input: InputEvent) -> void:
	pass
