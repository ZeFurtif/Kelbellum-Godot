extends Camera3D

@export var follow_players : bool = true
@export var offset : Vector3 = Vector3(0, 20, 20)
@export var min_size : float = 5
@export var max_size : float = 20
@onready var screen_ratio : float = get_viewport().size.x / get_viewport().size.y 

@onready var player_manager : Node3D = $"../PlayerManager"

func _physics_process(delta: float) -> void:
	if follow_players:
		move_camera()
	return
	
func move_camera() -> void:
	var sigma_position : Vector3 = Vector3.ZERO # Sum of all player positions
	var all_pos_x : Array[float] = [] # Get all x coords of positions
	var all_pos_z : Array[float] = [] # Get all z coords of positions
	var player_count : int = 0 # Count players
	for player_id in player_manager.players:
		if player_manager.players[player_id]: # Add everything
			sigma_position += player_manager.players[player_id].global_position
			all_pos_x.append(player_manager.players[player_id].global_position.x)
			all_pos_z.append(player_manager.players[player_id].global_position.z)
			player_count += 1 
	sigma_position = sigma_position / player_count # Average player position
	var distance_left_right : float = all_pos_x.max() - all_pos_x.min() # Max distance between players on x axis
	var distance_up_down : float = ((all_pos_z.max() - all_pos_z.min()) * screen_ratio) # Max distance between players on z axis 
	size = clamp(max(distance_left_right, distance_up_down) + 5, min_size, max_size)  # Have the max distance set the size of the camera view
	position = sigma_position + offset # Update the camera position
	return 
