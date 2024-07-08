class_name BuffItemData
extends Resource

@export var id: int = -1
@export var name: String
@export var icon: Texture
@export var buff_ability: BuffAbilityData

func _init():
	resource_name = "BuffItemData"
