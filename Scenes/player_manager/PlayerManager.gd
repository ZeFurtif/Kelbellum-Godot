extends Node3D

@export_file("*.tscn") var player_path: String = "res://scenes/player/Player.tscn"

var players : Dictionary = {
	0 : null,
	1 : null,
	2 : null,
	3 : null,
}

func _ready() -> void:
	spawn_players()
	return
	
func spawn_players() -> void:
	var player_scene : PackedScene = load(player_path)
	for player_id in range(4):
		if ControllerManager.players_controller_id[player_id] != -1:
			var player : Player = player_scene.instantiate()
			players[player_id] = player
			player._player_id = player_id
			call_deferred("add_child", player)
	return
