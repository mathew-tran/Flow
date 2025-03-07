extends RigidBody2D

class_name Player
var Speed = 10000

var CharacterReference : Character

var bCanMove = true
var LastCachedPosition = Vector2.ZERO

func _process(delta):
	if linear_velocity.length() <= 3 and IsGrounded() == false and $Engine.IsEmpty():
		global_position = LastCachedPosition
		rotation = 0
		
	$ProgressBar.value = $Engine.GetPercent()
	Finder.GetInteractText().visible = false
	
func SetCanMove(bMove):
	bCanMove = bMove
	
func AssignCustomerImage(charRefImage):
	$Customer.texture = charRefImage
	$Customer.visible = true
	
func HideCustomer():
	$Customer.visible = false

	
		
func _physics_process(delta):
	if bCanMove == false:
		return
	
	var newVelocity = Vector2.ZERO
	if Input.is_action_pressed("forward"):
		newVelocity.x = 1
	elif Input.is_action_pressed("reverse"):
		newVelocity.x = -1
			
	if newVelocity.x == 0 and IsGrounded():
		$Engine.Recharge(delta)
				
	if Input.is_action_just_pressed("jump") and IsGrounded() and $Engine.CanUse(CarEngine.USAGE_TYPE.JUMP):
		apply_impulse(Vector2.UP * 100, Vector2.ZERO)
		$Engine.Use(CarEngine.USAGE_TYPE.JUMP)
		
	$CarLight.modulate = Color.BLACK
	$CPUParticles2D.emitting = false
		
	if newVelocity.x != 0:
		if IsGrounded():
			if $Engine.CanUse(CarEngine.USAGE_TYPE.GROUND) == false:
				return
			$Engine.Use(CarEngine.USAGE_TYPE.GROUND)
		else:
			if $Engine.CanUse(CarEngine.USAGE_TYPE.AIR) == false:
				return
			$Engine.Use(CarEngine.USAGE_TYPE.AIR)
				
	if $RaySteer.is_colliding() and newVelocity.x > 0:
		apply_force(Vector2.UP * 10000 * delta, $FrontWheel.position)
	

	$CPUParticles2D.emitting = newVelocity.x != 0
	
	if newVelocity.x == -1:
		$CarLight.modulate = Color.RED
	elif newVelocity.x != 0:
		$CarLight.modulate = Color.WHITE
		
	newVelocity = newVelocity.rotated(rotation)

	newVelocity = (newVelocity * Speed * delta)
	newVelocity *= .98

	
	apply_force(newVelocity, $BackWheel.position)
	apply_force(newVelocity, $FrontWheel.position)
	
		
	
	if $FrontRay.is_colliding() == false and $BackRay.is_colliding() == false and $Engine.CanUse(CarEngine.USAGE_TYPE.AIR):		
		look_at(get_global_mouse_position())

func IsGrounded():
	return $FrontRay.is_colliding() or $BackRay.is_colliding()


func _on_character_finder_area_entered(area):
	if area is Character:
		print(area)
		CharacterReference = area


func _on_character_finder_area_exited(area):
	CharacterReference = null


func _on_position_checker_timeout():
	if IsGrounded():
		LastCachedPosition = global_position
	pass # Replace with function body.

func Stop():
	linear_velocity = Vector2.ZERO

func SetSong(song):
	$AudioStreamPlayer2D.stream = song
	$AudioStreamPlayer2D.play()

func StopSong():
	$AudioStreamPlayer2D.stop()

func SetVolume(amount):
	$AudioStreamPlayer2D.volume_db = amount
