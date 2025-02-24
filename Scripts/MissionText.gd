extends Label

class_name MissionText

func _enter_tree():
	text = ""
	
func SetDestination(destRef : Destination):
	text = "Go to " + destRef.Name
	
func SetText(newText):
	text = newText
	
