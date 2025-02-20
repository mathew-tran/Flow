extends Resource

class_name Dialogue

@export var Text : Array[String]

signal DialogueCompleted

func DoDialogue(charRef : Character):
	for line in Text:
		await charRef.Say(line)
		await charRef.get_tree().create_timer(1).timeout
