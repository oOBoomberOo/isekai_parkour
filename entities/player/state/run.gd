extends "on_ground.gd"

class_name RunState

onready var timer := $Timer

enum Side {
	LEFT,
	RIGHT
}

var side = Side.LEFT
var steps := 0

func _enter(_prev: Node) -> void:
	player().animator.play("run")
	timer.start()
	steps = 0

func _update(delta: float) -> void:
	var player := player()
	player.move(motion)
	
	if steps >= 2:
		print("slide!")
		steps = 0
		# emit_signal("switch", "slide")
	
	if should_stop():
		emit_signal("pop")
	
	._update(delta)

func _handle_input(event: InputEvent):
	if steps == 0:
		if event.is_action_pressed("move_left"):
			side = Side.LEFT
			steps += 1
		elif event.is_action_pressed("move_right"):
			side = Side.RIGHT
			steps += 1
	
	match side:
		Side.LEFT:
			if event.is_action_pressed("move_left"):
				steps += 1
			else:
				steps = 0
		Side.RIGHT:
			if event.is_action_pressed("move_right"):
				steps += 1
			else:
				steps = 0
	
	._handle_input(event)

func should_stop() -> bool:
	var is_running := player().is_running(motion)
	var timer_stopped = timer.is_stopped()
	var no_input = steps == 0
	return not is_running and (timer_stopped or no_input)
