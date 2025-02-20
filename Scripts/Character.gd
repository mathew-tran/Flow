extends Area2D

class_name Character

@export var GreetDialogue : Dialogue
@export var Travel : TravelItinerary

var bInteracted = false

signal CompleteSentence

func _ready():
	$Label.text = ""


func Interact():
	if bInteracted:
		return
	bInteracted = true
	await GreetDialogue.DoDialogue(self)
	
func Pickup(playerRef : Player):
	ShowBody(false)
	reparent(playerRef)
	playerRef.AssignCustomerImage($Head.texture)
	for travel in Travel.Destinations:
		await travel.Dialogues.DoDialogue(self)
		Finder.GetMissionText().SetDestination(travel.Dest)
		await get_tree().create_timer(2.0).timeout
		Say("")
		
	
func ShowBody(bShow):
	$Head.visible = bShow
	$Body.visible = bShow
	

func HasInteracted():
	return bInteracted

func Say(words):
	$Label.visible = false
	$Label.visible_characters = 0
	$Label.text = words
	$Label.visible = true
	for word in words:
		$Label.visible_characters += 1
		await get_tree().create_timer(.05).timeout
	CompleteSentence.emit()
