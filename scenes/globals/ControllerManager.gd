extends Node

## signal emit when a new controller is connected
signal controller_connected(controller_id : int)

## signal emit when controller is disconnected
signal controller_disconnected(controller_id : int)

## default device ID
const NO_DEVICE_ID : int = -1

var players_controller_id : Dictionary = {
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
		else :
			if mapping_allowed :
				# check for player slot
				for i in range(0, players_controller_id.size()) :
					if players_controller_id[i] == NO_DEVICE_ID :
						players_controller_id[i] = device
						print("NEW DEVICE -- Added new device for player ", i)
						controller_connected.emit(device)
						return
				print("WEIRD BEHAVIOR -- No player ID available for this device")
			else:
				print("MAPPING NOT ALLOWED -- Controller mapping currently not allowed")
	else :
		if has_controller_id(device) :
			# free player slot
			var player_id : int = get_player_id(device)
			players_controller_id[player_id] = -1
			controller_disconnected.emit(device)
			print("REMOVED DEVICE -- Player ", player_id, "'s device disconnected")
		else :
			print("WEIRD BEHAVIOR -- Unknown gamepad disconnected")
	return

## Get player_id from controller_id
func get_player_id(controller_id : int) -> int :
	var ret = players_controller_id.find_key(controller_id)
	if ret != null :
		return ret
	return -1

## Check if player_id is valid
func has_player_id(player_id : int) -> bool :
	if player_id in players_controller_id :
		return true
	return false

## Get controller_id from player_id
func get_controller_id(player_id : int) -> int :
	if player_id in players_controller_id :
		return players_controller_id[player_id]
	return -1

## Check if controller_id is valid
func has_controller_id(controller_id : int) -> bool :
	if players_controller_id.find_key(controller_id) != null :
		return true
	return false
