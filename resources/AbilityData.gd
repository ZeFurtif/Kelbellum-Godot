class_name AbilityData
extends Resource

@export var id: int = -1
@export var name: String
@export var icon: Texture
@export var cooldown: float

func _init():
	resource_name = "AbilityData"
