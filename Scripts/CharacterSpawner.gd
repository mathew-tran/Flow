extends Node

@export var Chapters : Array[CharacterList]

func _ready():
	
	for chapter in Chapters:
		for character in chapter.Characters:
			await get_tree().create_timer(randf_range(2,5)).timeout
			var instance = character.instantiate()
			add_child(instance)
			await instance.JobFinished
