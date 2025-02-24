extends Node


func GetMissionText() -> MissionText:
	var result = get_tree().get_nodes_in_group("MissionText")
	if result:
		return result[0]
	return null

func GetBuilding(buildingType : Destination.PLACE) -> Building:
	var results = get_tree().get_nodes_in_group("BUILDING") as Array[Building]
	if results:
		for result in results:
			if result.BuildingID == buildingType:
				return result
	return null

func GetPlayer() -> Player:
	var result = get_tree().get_nodes_in_group("Player")
	if result:
		return result[0]
	return null

func GetUI() -> CanvasLayer:
	var result = get_tree().get_nodes_in_group("UI")
	if result:
		return result[0]
	return null

func GetInteractText() -> Label:
	var result = get_tree().get_nodes_in_group("InteractText")
	if result:
		return result[0]
	return null
