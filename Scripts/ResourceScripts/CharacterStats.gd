extends Resource

class_name CharacterStats

@export_group("Base Stats")
@export_category("GLOBAL")
@export var health : int  = 50
@export var speed : int = 300
@export var attackSpeed : int = 1
@export_category("COMBAT")
@export var strength : float = 1
@export var dexterity : float = 1
@export var arcana : float = 1
@export var strengthResistance : float = 1
@export var dexterityResistance : float = 1
@export var arcanaResistance : float = 1
@export_category("DISCRETE")
@export var size : float = 1 
@export var critChance : float = 0
@export var lifeSteal : float = 0
@export var evasiveness : float = 0
@export var regeneration : int = 0
