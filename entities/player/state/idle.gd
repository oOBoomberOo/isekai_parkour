extends "on_ground.gd"

class_name IdleState

func _enter(_prev: Node):
	player().animator.play("idle")

func _update(delta: float) -> void:
	if motion != 0.0:
		emit_signal("push", "run")
	
	._update(delta)
