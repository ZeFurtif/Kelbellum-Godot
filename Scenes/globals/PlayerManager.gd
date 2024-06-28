extends Node

@export var controller_maping_allowed = true
@export var playerIds_to_controllerIds = {0: -1, 1: -1, 2: -1, 3: -1}

func _ready():
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
func _on_joy_connection_changed(device, connected):
	if connected:
		if get_playerId(device) != -1:
			print("WEIRD BEHAVIOR -- Gamepad already connected somehow")
		else:
			if controller_maping_allowed:
				for i in range(0, len(playerIds_to_controllerIds)):
					if playerIds_to_controllerIds[i] == -1:
						playerIds_to_controllerIds[i] = device
						print("NEW DEVICE -- Added new device for player ", i)
						return
				print("WEIRD BEHAVIOR -- No players available for this device")
			else:
				print("MAPPING NOT ALLOWED -- Controller mapping currently not allowed")
	else:
		if get_playerId(device) != -1:
			playerIds_to_controllerIds[get_playerId(device)] = -1
			print("REMOVED DEVICE -- Player ", get_playerId(device), "'s device disconnected")
		else:
			print("WEIRD BEHAVIOR -- Unknown gamepad disconnected")

func get_controllerId(playerId):
	if playerId in playerIds_to_controllerIds:
		return playerIds_to_controllerIds[playerId]
	return -1

func get_playerId(controllerId):
	var ret = playerIds_to_controllerIds.find_key(controllerId)
	if ret != null:
		return ret
	else:
		return -1
