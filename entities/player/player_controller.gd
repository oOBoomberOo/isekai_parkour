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

onready var animator: AnimatedSprite = $AnimatedSprite
onready var state_machine: StateMachine = $State

func _ready():
	animator.playing = true
	return $State.connect("state_changed", self, "handle_state_changed")

func _physics_process(_delta):
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)

func moving_direction(input: float):
	var dir = sign(input)
	if dir == 1:
		animator.flip_h = false
	elif dir == -1:
		animator.flip_h = true

func launch(power: float) -> void:
	state_machine.switch_state("jump")
	velocity.y = 0
	jump(power)

func jump(power: float) -> void:
	velocity.y -= power * jump_speed
	emit_signal("jumped")
	
func move(power: float) -> void:
	velocity.x = power * run_speed

func land():
	emit_signal("landed")

func handle_state_changed(_prev, _new):
	var result = "State:\n"
	var i = 0
	for state in $State.stack:
		i += 1
		result += "  %s. %s\n" % [i, state]
	$Control/Label.text = result

# Helper Methods
func is_decending() -> bool:
	return velocity.y > 0

func is_ascending() -> bool:
	return velocity.y < 0

func is_moving() -> bool:
	return sign(velocity.x) != 0

func is_moving_along_input(dir: float) -> bool:
	return sign(velocity.x) == sign(dir)

func is_running(input: float) -> bool:
	return sign(input) != 0

func is_jumping() -> bool:
	return Input.is_action_just_pressed("jump")
