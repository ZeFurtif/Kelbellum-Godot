extends CharacterBody3D

# debug
@export var debug_reach_right_click : bool = false
@export var selected : bool = false

@export var movement_speed : float = 4.0

var GRAVITY : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var GRAVITY_DIRECTION : Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector")

@onready var navigation_agent : NavigationAgent3D = $NavigationAgent3D
@onready var camera : Camera3D = get_viewport().get_camera_3d()

var target : Player = null

# TODO must be modify with architecture
@export var players : Array[Player] = []

func _ready() -> void :
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	# trick to wait navigation map synchronization
	await get_tree().process_frame
	return

func _physics_process(delta : float) -> void :
	_find_nearest_player()
	if target :
		navigation_agent.target_position = target.global_position
	
	if navigation_agent.is_navigation_finished():
		print("finish")
		return

	var next_path_position : Vector3 = navigation_agent.get_next_path_position()
	var new_velocity : Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled :
		navigation_agent.velocity = new_velocity
	else :
		_on_velocity_computed(new_velocity)
	return

func _on_velocity_computed(safe_velocity : Vector3) -> void :
	velocity = safe_velocity
	move_and_slide()
	return


func _input(event : InputEvent) -> void :
	if debug_reach_right_click and selected :
		if event is InputEventMouseButton :
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed :
				var mouse_position : Vector2 = get_viewport().get_mouse_position()
				var ray_length : float = 100
				var from : Vector3 = camera.project_ray_origin(mouse_position)
				var to : Vector3 = from + camera.project_ray_normal(mouse_position) * ray_length
				var space : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
				var ray_query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
				ray_query.from = from
				ray_query.to = to
				ray_query.collide_with_areas = true
				var result : Dictionary = space.intersect_ray(ray_query)
				
				# Teleport
				if Input.is_key_pressed(KEY_SHIFT) :
					global_position = result.position
					navigation_agent.target_position = result.position
				# Navigation
				else :
					navigation_agent.target_position = result.position
	return


func _find_nearest_player() -> void :
	target = null
	if players.size() :
		var distance : float = global_position.distance_squared_to(players[0].global_position)
		target = players[0]
		for player : Player in players :
			var new_distance : float = global_position.distance_squared_to(player.global_position)
			if new_distance < distance :
				target = player
	return
