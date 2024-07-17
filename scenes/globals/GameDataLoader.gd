extends Node

var characters : Dictionary = {}
var weapons : Dictionary = {}
var mobility_items : Dictionary = {}
var buff_items : Dictionary = {}

func _ready() -> void:
	load_tres("res://datas/characters/", characters)
	load_tres("res://datas/weapons/", weapons)
	load_tres("res://datas/mobility_items/", mobility_items)
	load_tres("res://datas/buff_items/", buff_items)
	return
	
func load_tres(dir_path : String, dest : Dictionary) -> void: # POPULATE DICTIONARIES WITH EQUIPED STUFF
	if !DirAccess.dir_exists_absolute(dir_path):
		#print("GameDataLoader : PATH NOT FOUND")
		return
	var paths = DirAccess.get_files_at(dir_path)
	for path in paths:
		if ".tres" in path:
			var res = load(dir_path + path)
			if "id" in res:
				dest[res.id] = res
	return
