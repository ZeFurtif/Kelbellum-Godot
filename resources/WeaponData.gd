class_name WeaponData
extends Resource

@export var id: int = -1
@export var name: String
@export var icon: Texture
@export var ability1: AttackAbilityData
@export var ability2: AttackAbilityData
@export var ability3: AttackAbilityData

func _init():
	resource_name = "WeaponData"
