extends Node

func _load_JSON(path : String) -> Variant :
	if path.ends_with(".json") :
		if FileAccess.file_exists(path):
			var file : FileAccess = FileAccess.open(path, FileAccess.READ)
			var data_str : String = file.get_as_text()
			var data : Variant = JSON.parse_string(data_str)
			return data
		else:
			push_error("File not found")
	else :
		push_error("File is not in .json format")
	return null
