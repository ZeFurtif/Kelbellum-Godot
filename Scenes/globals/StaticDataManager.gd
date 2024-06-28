extends Node

@export var characters : Array

func _ready():
	var a = DirAccess.get_files_at("res://Resources/CharacterData/")
	

func get_character_data(characterId):
	if 0 < characterId and characterId < len(characters):
		return characterId
	return
