extends StateMachine

onready var player := parent as PlayerController

var history := []
var lifetime := 30 # Lifetime of the history, in frame.

func _start():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("slide_left")
	add_state("slide_right")
	add_state("backflip")
	return state.idle

func _run(current: int, _delta: float):
	handle_history()
	
	match current:
		state.idle:
			return __idle()
		state.run:
			return __run()
		state.jump:
			return __jump()
		state.fall:
			return __fall()
		state.slide_left, state.slide_right:
			return __slide()
		state.backflip:
			return __backflip()


func _enter_state(new, _prev):
	log_state(new)
	match new:
		state.idle:
			player.animator.play("idle")
		state.run:
			player.animator.play("run")
		state.jump:
			player.jump(1)
			player.animator.play("jump")
		state.fall:
			player.animator.play("fall")
		state.slide_right:
			player.move(1)
			player.animator.play("slide")
		state.slide_left:
			player.move(-1)
			player.animator.play("slide")
		state.backflip:
			player.animator.play("backflip")


func _exit_state(new, prev):
	match [prev, new]:
		[state.fall, state.idle]:
			player.land()


func log_state(state):
	history.push_front({ "state": state, "life": lifetime })


func handle_history():
	var new_history = []
	for s in history:
		s.life -= 1
		if s.life > 0:
			new_history.push_back(s)
	history = new_history


func state_history() -> Array:
	var result = []
	for s in history:
		result.append(s.state)
	return result


# States
func __idle():
	match state_history():
		[state.idle, state.run, state.idle, ..]:
			if player.input == 1:
				return state.slide_right
			if player.input == -1:
				return state.slide_left
	
	player.move(player.input)
	
	if player.is_running():
		return state.run
	if player.is_jumping():
		return state.jump


func __run():
	player.move(player.input)

	if not player.is_running():
		return state.idle
	if player.is_jumping():
		return state.jump


func __jump():
	player.move(player.input)
	
	if player.is_decending():
		return state.fall
	if player.is_on_floor():
		return state.idle
	
	yield(get_tree().create_timer(0.5), "timeout")
	return state.backflip


func __fall():
	player.move(player.input)
	
	if player.is_on_floor():
		return state.idle


func __slide():
	if not player.is_moving_along_input() and player.is_running():
		return state.idle
	
	yield(player.animator, "animation_finished")
	return state.idle


func __backflip():
	player.move(player.input)
	
	if player.is_on_floor():
		return state.idle
	yield(player.animator, "animation_finished")
	return state.fall
