extends Label

class_name MissionText

func _enter_tree():
	SetText("")
	
func SetDestination(destRef : Destination):
	text = "Go to " + destRef.Name
	text = "[" + text + "]"
	scale = Vector2.ZERO
	visible = true
	$AudioStreamPlayer2D.play()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, .2)
	await tween.finished
	
	
func SetText(newText):
	text = newText
	if text.length() > 0:
		text = "[" + text + "]"
		scale = Vector2(2,1)
		visible = true
		$AudioStreamPlayer2D.play()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2.ONE, .2)
		await tween.finished
	else:
		visible = false
	
