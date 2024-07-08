class_name AttackAbilityData
extends AbilityData

enum AttackType {
	MELEE = 0,
	RANGE = 1,
	INVOCATION = 2,
}

@export var damage : float = 1
@export var range : float = 2
@export var attack_type : AttackType = AttackType.MELEE

func _init():
	resource_name = "AttackAbilityData"
