class_name CharacterData
extends Resource

@export var id: int = -1
@export var name: String = ""
@export var icon: Texture = Texture.new()
@export var base_health: float = 0.0
@export var base_speed: float = 0.0
@export var ultimate_ability: AbilityData = AbilityData.new()

func _init():
	resource_name = "CharacterData"
