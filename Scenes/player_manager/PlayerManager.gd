extends Node3D

@export_file("*.tscn") var player_scene: String = "res://scenes/player/Player.tscn"

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
	var player = load(player_scene)
	for player_id in range(0, 4):
		if ControllerManager.players_controller_id[player_id] != 0:
			var player_copy = player.instantiate()
			players[player_id] = player_copy
			player_copy.PLAYER_ID = player_id
			call_deferred("add_child", player_copy)
	return
