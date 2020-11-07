extends KinematicBody2D

var motion = Vector2.ZERO
var gravity = 20
var movement = -60

var local_poc = null

func _on_attacked(player: PlayerController):
	player.launch(0.7)
	$AnimatedSprite.play("hurt")
	yield($AnimatedSprite, "animation_finished")
	queue_free()


func _on_body_shape_entered(body_id: int, body: Node, body_shape: int, area_shape: int) -> void:
	if body is PlayerController:
		for contact in get_contact_points(body, body_shape, area_shape):
			var contact_direction = (body.position - contact).normalized()
			var dot = contact_direction.dot(Vector2.UP)
			
			if dot > 0.85:
				_on_attacked(body)
				break


func get_contact_points(body: PlayerController, body_shape: int, area_shape: int) -> Array:
	var shape_of_body = body_shape(body, body_shape)
	var shape_of_area = body_shape(self, area_shape)
	
	var body_shape_2d: Shape2D = shape_of_body[0]
	var body_global_transform: Transform = shape_of_body[1]
	var area_shape_2d: Shape2D = shape_of_area[0]
	var area_global_transform: Transform = shape_of_area[1]
	
	var collision_points = area_shape_2d.collide_and_get_contacts(area_global_transform, body_shape_2d, body_global_transform)
	return collision_points


func body_shape(this: CollisionObject2D, shape: int) -> Array:
	var shape_owner_id := this.shape_find_owner(shape)
	var shape_owner: Node2D = this.shape_owner_get_owner(shape_owner_id)
	var shape_2d := this.shape_owner_get_shape(shape_owner_id, 0)
	
	return [shape_2d, shape_owner.global_transform]


func _physics_process(delta: float) -> void:
	motion.x = movement
	motion.y += gravity
	motion = move_and_slide(motion, Vector2.UP)
