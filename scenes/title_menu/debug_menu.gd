extends Control

@export_dir var debug_scenes_dir = "res://scenes/debug/"

@onready var debug_container : VBoxContainer = $DebugScenes

func _ready() -> void:
	var debug_scenes_paths : PackedStringArray = DirAccess.get_files_at(debug_scenes_dir)
	for path in debug_scenes_paths:
		var button : Button = Button.new()
		button.text = path
		debug_container.call_deferred("add_child", button)
		button.pressed.connect(self._on_debug_button_pressed.bind(debug_scenes_dir+path))
	return

func _on_debug_button_pressed(scene_path : String):
	print(scene_path)
	get_tree().change_scene_to_packed(load(scene_path))
	return
