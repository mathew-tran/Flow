extends Label

class_name MissionText

func _enter_tree():
	SetText("")
	
func SetDestination(destRef : Destination):
	text = "Go to " + destRef.Name
	text = "[" + text + "]"
	visible = true
	
func SetText(newText):
	text = newText
	if text.length() > 0:
		text = "[" + text + "]"
		visible = true
	else:
		visible = false
	
