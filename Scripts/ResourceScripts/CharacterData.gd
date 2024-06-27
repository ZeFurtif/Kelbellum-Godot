extends Resource

class_name CharacterData

@export_category("ID")
@export var id : int = 0
@export var color : Color
@export var name : String = "Name"
@export var description : String = "A description"
@export_category("STATS")
@export var baseStats : CharacterStats
