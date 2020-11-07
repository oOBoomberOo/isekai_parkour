extends KinematicBody2D

class_name PlayerController

signal jumped
signal landed

var run_speed := 300
var jump_speed := 800

var backflip_threshold := jump_speed / 1.5
var running_threshold := 0.1

var gravity := 20
var velocity := Vector2()

var input := 0

onready var animator: AnimatedSprite = $AnimatedSprite
onready var state_machine: StateMachine = $PlayerState

func _ready() -> void:
	animator.playing = true

func _process(_delta: float) -> void:
	gather_input()
	moving_direction()

func _physics_process(_delta):
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func gather_input():
	input = 0
	
	if Input.is_action_pressed("move_left"):
		input -= 1
	if Input.is_action_pressed("move_right"):
		input += 1

func moving_direction():
	var dir = sign(input)
	if dir == 1:
		animator.flip_h = false
	elif dir == -1:
		animator.flip_h = true

func launch(power: float) -> void:
	state_machine._current_state = state_machine.state.jump
	velocity.y = 0
	jump(power)

func jump(power: float) -> void:
	velocity.y -= power * jump_speed
	emit_signal("jumped")
	
func move(power: float) -> void:
	velocity.x = power * run_speed

func land():
	emit_signal("landed")

# Helper Methods
func is_decending() -> bool:
	return velocity.y > 0

func is_ascending() -> bool:
	return velocity.y < 0

func is_moving() -> bool:
	return sign(velocity.x) != 0

func is_moving_along_input() -> bool:
	return sign(velocity.x) == input

func is_running() -> bool:
	return input != 0

func is_jumping() -> bool:
	return Input.is_action_just_pressed("jump")
