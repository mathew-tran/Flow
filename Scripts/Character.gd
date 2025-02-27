extends Area2D

class_name Character

@export var GreetDialogue : Dialogue
@export var Travel : TravelItinerary
@export var EndDialogue : Dialogue
@export var StartLocation : Destination
var TargetPosition = Vector2.ZERO

enum VISIBILITY_TYPE {
	IN_CAR,
	OUTSIDE,
	HIDDEN
}

signal CompleteSentence
signal JobFinished

func SetVisibility(visType = VISIBILITY_TYPE.IN_CAR):
	match visType:
		VISIBILITY_TYPE.IN_CAR:
			GetInCar(Finder.GetPlayer())
		VISIBILITY_TYPE.OUTSIDE:
			GetOutOfCar(Finder.GetPlayer(), TargetPosition)
		VISIBILITY_TYPE.HIDDEN:
			GetOutOfCar(Finder.GetPlayer(), TargetPosition)
			ShowBody(false)

	
func _ready():
	global_position = Finder.GetBuilding(StartLocation.InnerName).GetCharacterPosition()
	$Label.text = ""
	var characterRadar = load("res://Prefabs/Radar.tscn").instantiate() as Radar
	Finder.GetUI().add_child(characterRadar)
	characterRadar.SetTarget(self)
	
	TargetPosition = global_position
	await characterRadar.DoEvent
	characterRadar.queue_free()	
	var player = Finder.GetPlayer()
	player.SetCanMove(false)
	await Interact()
	Pickup(player)
	player.SetCanMove(true)

func Interact():
	await GreetDialogue.DoDialogue(self)
	
func Pickup(playerRef : Player):
	var radar = null
	SetVisibility(VISIBILITY_TYPE.IN_CAR)	
	
	for travel in Travel.Destinations:
		await travel.Dialogues.DoDialogue(self)
		Finder.GetMissionText().SetDestination(travel.Dest)
		radar = load("res://Prefabs/Radar.tscn").instantiate() as Radar
		radar.SetTarget(Finder.GetBuilding(travel.Dest.InnerName))
		Finder.GetUI().add_child(radar)
		TargetPosition = Finder.GetBuilding(travel.Dest.InnerName).GetCharacterPosition()
		Say("")
		await radar.DoEvent
		Finder.GetMissionText().SetText("Wait for Customer")
		radar.queue_free()
		playerRef.SetCanMove(false)
		
		if is_instance_valid(travel.PrewaitDialogue):			
			await travel.PrewaitDialogue.DoDialogue(self)		
			Say("")
			
		await get_tree().create_timer(1.0).timeout
		if is_instance_valid(travel.WaitDialogue):
			await travel.WaitDialogue.DoDialogue(self)
			Say("")

		await get_tree().create_timer(travel.WaitTime).timeout
		
		
		if is_instance_valid(travel.PostWaitDialogue):
			await travel.PostWaitDialogue.DoDialogue(self)
			Say("")
			
			
		Finder.GetMissionText().SetText("")
		

		await get_tree().create_timer(1.0).timeout
		playerRef.SetCanMove(true)
		SetVisibility(VISIBILITY_TYPE.IN_CAR)
		
		
	Finder.GetMissionText().SetText("")
	
	playerRef.SetCanMove(false)
	await EndDialogue.DoDialogue(self)
	SetVisibility(VISIBILITY_TYPE.HIDDEN)
	playerRef.SetCanMove(true)
	JobFinished.emit()
	queue_free()
		
func GetInCar(playerRef):
	ShowBody(false)
	reparent(playerRef)
	playerRef.AssignCustomerImage($Head.texture)
	position = Vector2.ZERO
	rotation = 0
	
func GetOutOfCar(playerRef, targetPosition):
	ShowBody(true)
	reparent(playerRef.get_parent())
	playerRef.AssignCustomerImage(null)
	global_position = targetPosition
	rotation = 0
	
	
func ShowBody(bShow):
	$Head.visible = bShow
	$Body.visible = bShow
	
func Say(words):
	$Label.visible = false
	$Label.visible_characters = 0
	$Label.text = words
	$Label.visible = true
	for word in words:
		$Label.visible_characters += 1
		await get_tree().create_timer(.05).timeout
	CompleteSentence.emit()
