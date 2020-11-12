extends State

var motion := 0.0

func gather_input_direction():
	motion = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func player() -> PlayerController:
	return owner as PlayerController

func _update(_delta: float) -> void:
	gather_input_direction()
	player().moving_direction(motion)
