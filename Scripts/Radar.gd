extends Control

class_name Radar

signal DoEvent
var Target = null
var MinDistance = 100

var bCloseToPosition = false

func SetTarget(target):
	Target = target
	
func _process(delta):
	if is_instance_valid(Target):
		bCloseToPosition = Target.global_position.distance_to(Finder.GetPlayer().global_position) < MinDistance
		var direction = (Target.global_position - Finder.GetPlayer().global_position).normalized()
		rotation = direction.angle()
	
	$Sprite.visible = bCloseToPosition == false
	
	Finder.GetInteractText().visible = bCloseToPosition
		

func _input(event):
	if bCloseToPosition:
		if event.is_action_pressed("interact"):
			DoEvent.emit()
	
