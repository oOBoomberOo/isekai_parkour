extends "on_motion.gd"

func _enter(_prev: Node) -> void:
	player().animator.play("fall")

func _update(delta: float) -> void:
	var player := player()
	player.move(motion)
	
	if player.is_on_floor():
		emit_signal("pop")
	
	._update(delta)
