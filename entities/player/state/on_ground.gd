extends "on_motion.gd"

func _update(delta: float) -> void:
	var player := player()
	player.moving_direction(motion)
	if not player.is_on_floor():
		emit_signal("push", "fall")
	._update(delta)

func _handle_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		emit_signal("push", "jump")
	return ._handle_input(event)
