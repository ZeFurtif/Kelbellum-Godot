class_name BuffAbilityData
extends AbilityData

@export var buff_type: String  # e.g., "Heal", "Speed Boost", "Damage Boost" -> A REMPLACER PAR ENUM
@export var buff_amount: float
@export var duration: float

func _init():
	resource_name = "BuffAbilityData"
