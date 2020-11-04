extends KinematicBody2D

var run_speed = 300
var jump_speed = 800
var backflip_threshold = jump_speed / 2
var gravity = 20
var motion = Vector2()

onready var animator: AnimatedSprite = $AnimatedSprite

func _physics_process(delta):
	gather_input()
	gather_environment()
	motion = move_and_slide(motion, Vector2.UP)
	
	handle_animation()

func jump():
	animator.play("jump_up")

func gather_input():
	motion.x = 0
	
	if Input.is_action_pressed("move_left"):
		motion.x -= 1
	if Input.is_action_pressed("move_right"):
		motion.x += 1
	
	motion.x *= run_speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		motion.y -= jump_speed
		jump()

func gather_environment():
	motion.y += gravity

func moving_direction(epoch = 0.01):
	if motion.x < -epoch:
		animator.flip_h = true
	elif motion.x > epoch:
		animator.flip_h = false

func handle_animation():
	if animator.animation == "jump_up" and motion.y > -backflip_threshold:
		animator.play("backflip")
	elif motion.x != 0 and is_on_floor():
		animator.play("running")
	elif motion.length() == 0 and is_on_floor():
		animator.play("idle")
	
	moving_direction()

func _on_animation_finished():
	if animator.animation == "backflip":
		animator.play("jump_down")
