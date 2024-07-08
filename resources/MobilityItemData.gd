class_name MobilityItemData
extends Resource

@export var id: int = -1
@export var name: String
@export var icon: Texture
@export var movement_ability: MovementAbilityData 

func _init():
	resource_name = "MobilityItemData"
