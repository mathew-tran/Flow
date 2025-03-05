extends Sprite2D

class_name Building

@export var BuildingID = Destination.PLACE.MOES_BAR
@export var bHideOnGameStart = false

func _enter_tree():
	visible = bHideOnGameStart == false

func _ready():
	add_to_group("BUILDING")
	
func GetCharacterPosition():
	return $CharacterPoint.global_position
