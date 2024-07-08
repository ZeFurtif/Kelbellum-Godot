class_name MovementAbilityData
extends AbilityData

@export var movement_type: String  # e.g., "Dash", "Teleport", "Jump"  -> A REMPLACER PAR ENUM
@export var distance: float
@export var speed: float

func _init():
	resource_name = "MovementAbilityData"
