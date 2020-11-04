extends KinematicBody2D

class_name PlayerController

signal jumped
signal landed

var run_speed = 300
var jump_speed = 800

var backflip_threshold = jump_speed / 2
var running_threshold = run_speed / 2

var gravity = 20
var motion = Vector2()

onready var animator: AnimatedSprite = $AnimatedSprite

func _physics_process(delta):
	gather_input()
	gather_environment()
	motion = move_and_slide(motion, Vector2.UP)
	
	moving_direction()

func gather_input():
	motion.x = 0
	
	if Input.is_action_pressed("move_left"):
		motion.x -= 1
	if Input.is_action_pressed("move_right"):
		motion.x += 1
	
	motion.x *= run_speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

func gather_environment():
	motion.y += gravity

func moving_direction(epoch = 0.1):
	if motion.x < -epoch:
		animator.flip_h = true
	elif motion.x > epoch:
		animator.flip_h = false

func jump():
	motion.y -= jump_speed
	emit_signal("jumped")

func land():
	emit_signal("landed")
