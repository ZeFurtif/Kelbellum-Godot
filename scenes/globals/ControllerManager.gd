extends Node

const NO_DEVICE_ID : int = -1

@export var players_controller_id : Dictionary = {
	0 : NO_DEVICE_ID, 
	1 : NO_DEVICE_ID, 
	2 : NO_DEVICE_ID,
	3 : NO_DEVICE_ID,
}

var mapping_allowed : bool = true

func _ready() -> void :
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	return
	
func _on_joy_connection_changed(device : int, connected : bool) -> void :
	if connected :
		if has_controller_id(device) :
			print("WEIRD BEHAVIOR -- Gamepad already connected somehow")
		else:
			if mapping_allowed :
				for i in range(0, players_controller_id.size()) :
					if players_controller_id[i] == NO_DEVICE_ID :
						players_controller_id[i] = device
						print("NEW DEVICE -- Added new device for player ", i)
						return
				print("WEIRD BEHAVIOR -- No player ID available for this device")
			else:
				print("MAPPING NOT ALLOWED -- Controller mapping currently not allowed")
	else :
		if has_controller_id(device) :
			var player_id : int = get_player_id(device)
			players_controller_id[player_id] = -1
			print("REMOVED DEVICE -- Player ", player_id, "'s device disconnected")
		else:
			print("WEIRD BEHAVIOR -- Unknown gamepad disconnected")

func get_player_id(controller_id : int) -> int :
	var ret = players_controller_id.find_key(controller_id)
	if ret != null :
		return ret
	return -1

func has_player_id(player_id : int) -> bool :
	if player_id in players_controller_id :
		return true
	return false

func get_controller_id(player_id : int) -> int :
	if player_id in players_controller_id :
		return players_controller_id[player_id]
	return -1

func has_controller_id(controller_id : int) -> bool :
	if players_controller_id.find_key(controller_id) != null :
		return true
	return false
