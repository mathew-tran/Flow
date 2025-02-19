extends Node

class_name CarEngine

var Fuel = 0
var MaxFuel = 100
var RechargeRate = 10

enum USAGE_TYPE {
	GROUND,
	AIR,
	JUMP
}

func _ready():
	Fuel = MaxFuel

func CanUse(usageType = USAGE_TYPE.GROUND):
	return Fuel >= GetCost()

func ToString():
	return "FUEL: " + str(Fuel)	 + "/" + str(MaxFuel)
	
func GetCost(usageType = USAGE_TYPE.GROUND):
		match usageType:
			USAGE_TYPE.GROUND:
				return .05
			USAGE_TYPE.AIR:
				return .8
			USAGE_TYPE.JUMP:
				return 10
				
func Use(usageType = USAGE_TYPE.GROUND):
	Fuel -= GetCost(usageType)	
	if Fuel <= 0 :
		Fuel = 0
		
func Recharge(delta):
	Fuel += delta * RechargeRate
	if Fuel >= MaxFuel:
		Fuel = MaxFuel

func GetPercent():
	return float(Fuel) / float(MaxFuel)
