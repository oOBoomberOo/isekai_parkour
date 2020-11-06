extends KinematicBody2D

class_name PlayerController

signal jumped
signal landed

var run_speed = 300
var jump_speed = 800

var backflip_threshold = jump_speed / 1.5
var running_threshold = 0.1

var bounce = false
var gravity = 20
var motion = Vector2()

onready var animator: AnimatedSprite = $AnimatedSprite

func _ready() -> void:
	animator.playing = true

func _physics_process(_delta):
	gather_input()
	gather_environment()
	motion = move_and_slide(motion, Vector2.UP)
	
	moving_direction()

func gather_input():
	motion.x = 0
	
	if Input.is_action_pressed("move_left"):
		move(-1)
	if Input.is_action_pressed("move_right"):
		move(1)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump(1)

func gather_environment():
	motion.y += gravity

func moving_direction(epoch := 0.1):
	if motion.x < -epoch:
		animator.flip_h = true
	elif motion.x > epoch:
		animator.flip_h = false

func launch(power: float) -> void:
	motion.y = 0
	bounce = true
	jump(power)

func jump(power: float) -> void:
	motion.y -= power * jump_speed
	emit_signal("jumped")
	
func move(dx: float) -> void:
	motion.x += dx * run_speed

func land():
	bounce = false
	emit_signal("landed")
