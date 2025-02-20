extends Node


func GetMissionText() -> MissionText:
	var result = get_tree().get_nodes_in_group("MissionText")
	if result:
		return result[0]
	return null
