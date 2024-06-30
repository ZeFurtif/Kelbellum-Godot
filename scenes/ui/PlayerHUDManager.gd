class_name PlayerHUDManager
extends HBoxContainer

@export_file("*.tscn") var player_hud_path : String = "res://scenes/player/player_hud/player_hud.tscn"

var player_huds : Dictionary = {}

func _ready() -> void:
	spawn_players_hud()
	return

func spawn_players_hud() -> void:
	var player_hud_scene : PackedScene = load(player_hud_path)
	for player_id in range(4):
		var player_hud : PlayerHUD = player_hud_scene.instantiate()
		player_huds[player_id] = player_hud
		call_deferred("add_child", player_hud)
	return
