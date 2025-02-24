extends Area2D

class_name Character

@export var GreetDialogue : Dialogue
@export var Travel : TravelItinerary
@export var EndDialogue : Dialogue

var bInteracted = false

signal CompleteSentence

func _ready():
	$Label.text = ""
	var characterRadar = load("res://Prefabs/Radar.tscn").instantiate() as Radar
	characterRadar.SetTarget(self)
	Finder.GetUI().add_child(characterRadar)
	await characterRadar.DoEvent
	characterRadar.queue_free()
	
	


func Interact():
	if bInteracted:
		return
	bInteracted = true
	await GreetDialogue.DoDialogue(self)
	
func Pickup(playerRef : Player):
	ShowBody(false)
	reparent(playerRef)
	var radar = null
	playerRef.AssignCustomerImage($Head.texture)
	var targetPosition = Vector2.ZERO
	for travel in Travel.Destinations:
		await travel.Dialogues.DoDialogue(self)
		Finder.GetMissionText().SetDestination(travel.Dest)
		radar = load("res://Prefabs/Radar.tscn").instantiate() as Radar
		radar.SetTarget(Finder.GetBuilding(travel.Dest.InnerName))
		Finder.GetUI().add_child(radar)
		targetPosition = Finder.GetBuilding(travel.Dest.InnerName).GetCharacterPosition()
		await get_tree().create_timer(2.0).timeout
		Say("")
		await radar.DoEvent
		Finder.GetMissionText().SetText("")
		radar.queue_free()
	
	playerRef.AssignCustomerImage(null)
	playerRef.SetCanMove(false)
	global_position = targetPosition
	reparent(playerRef.get_parent())
	ShowBody(true)
	await EndDialogue.DoDialogue(self)
	playerRef.SetCanMove(true)
	queue_free()
		
	
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
