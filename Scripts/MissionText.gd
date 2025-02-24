extends Label

class_name MissionText

func _enter_tree():
	text = ""
	
func SetDestination(destRef : Destination):
	text = "Go to " + destRef.Name
	text = "[" + text + "]"
	
func SetText(newText):
	text = newText
	if text.length() > 0:
		text = "[" + text + "]"
	
