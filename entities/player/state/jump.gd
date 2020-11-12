extends "on_motion.gd"

func _enter(prev: Node) -> void:
	var player := player()
	if prev is IdleState or prev is RunState:
		player.jump(1)
	player.animator.play("jump")

func _update(delta: float) -> void:
	var player := player()
	player.move(motion)
	
	if player.is_decending():
		emit_signal("switch", "fall")
	
	if player.is_on_floor():
		emit_signal("pop")
	
	._update(delta)
