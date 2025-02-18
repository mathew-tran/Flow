extends RigidBody2D

var Speed = 10000

func _physics_process(delta):
	
	var newVelocity = Vector2.ZERO
	if Input.is_action_pressed("forward"):
		newVelocity.x = 1
	elif Input.is_action_pressed("reverse"):
		newVelocity.x = -1
		
	if $RaySteer.is_colliding() and newVelocity.x > 0:
		apply_force(Vector2.UP * 10000 * delta, $FrontWheel.position)
		print("move up")
	

	newVelocity = newVelocity.rotated(rotation)

	newVelocity = (newVelocity * Speed * delta)
	newVelocity *= .98

	
	apply_force(newVelocity, $BackWheel.position)
	apply_force(newVelocity, $FrontWheel.position)
	print(newVelocity)
	
	
	if $FrontRay.is_colliding() == false and $BackRay.is_colliding() == false:
		look_at(get_global_mouse_position())
