extends Resource

class_name Dialogue

@export var Text : Array[String]
@export var VisiblityType = Character.VISIBILITY_TYPE.IN_CAR

signal DialogueCompleted

func DoDialogue(charRef : Character):
	for line in Text:
		charRef.SetVisibility(VisiblityType)
		await charRef.Say(line)
		await charRef.get_tree().create_timer(1).timeout
