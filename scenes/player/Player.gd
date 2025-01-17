class_name Player extends CharacterBody3D

## if true keyboard can be use for control
@export var keyboard_control : bool = false

# CONTROLLER DEAD ZONE
const JOYSTICK_DEAD_ZONE : float = 0.5
const TRIGGER_DEAD_ZONE : float = 0.1
const SPEED : float = 5.0
const SIGHT_RANGE : float = 20.0
var GRAVITY : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var GRAVITY_DIRECTION : Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector")


var raw_move_input : Vector2 = Vector2.ZERO
var monocible_reset : bool = true
var multicible_a_reset : bool = true
var multicible_b_reset : bool = true
var mobilite_reset : bool = true
var buff_reset : bool = true
var ultimate_reset : bool = true

var player_id : int = 0
var character_id : int = -1
var controller_id : int = -1

@onready var Raycast : RayCast3D = $RayCast3D
@onready var Camera : Camera3D = get_viewport().get_camera_3d()

func _ready() -> void :
	# Debug Mode
	if keyboard_control :
		controller_id = -1
		return

func _process(delta : float) -> void :
	# waiting for controller
	if not keyboard_control:
		if controller_id == -1 :
			controller_id = ControllerManager.get_controller_id(player_id)
			if controller_id != -1 :
				set_physics_process(true)
			return
	
	# normal process
	handle_aim()
	handle_abilities()
	return

func _physics_process(delta : float) -> void :
	handle_movement(delta)
	return

func handle_movement(delta : float) -> void :
	raw_move_input = Vector2.ZERO
	velocity = Vector3.ZERO
	
	if not is_on_floor() :
		velocity += GRAVITY * GRAVITY_DIRECTION
	else :
		velocity.y = 0
	
	if keyboard_control :
		raw_move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		raw_move_input = raw_move_input.normalized()
	else :
		raw_move_input.x = Input.get_joy_axis(controller_id, JOY_AXIS_LEFT_X)
		raw_move_input.y = Input.get_joy_axis(controller_id, JOY_AXIS_LEFT_Y)
	
	if raw_move_input.length() >= JOYSTICK_DEAD_ZONE :
		velocity.x = raw_move_input.x * SPEED * raw_move_input.length()
		velocity.z = raw_move_input.y * SPEED * raw_move_input.length()
	else :
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func handle_aim() -> void :
	var raw_input : Vector2 = Vector2.ZERO # if keyboard = mouse pos, if controller = input
	var look_dir : Vector3 = Vector3.ZERO # VEC3 Translation
	if keyboard_control :
		raw_input = get_viewport().get_mouse_position()
		look_dir = Plane(Vector3(0, 0, 10), 0).intersects_ray(Camera.project_ray_origin(raw_input),Camera.project_ray_normal(raw_input))
		if look_dir :
			look_dir.z = look_dir.y * -1
			look_dir.y = global_position.y
		else :
			look_dir = Vector3.ZERO
	else :
		raw_input.x = Input.get_joy_axis(controller_id, JOY_AXIS_RIGHT_X)
		raw_input.y = Input.get_joy_axis(controller_id, JOY_AXIS_RIGHT_Y)
		if abs(raw_input.length()) < JOYSTICK_DEAD_ZONE : # IF NO AIM INPUT STICK TO VELOCITY
			if abs(velocity.x * velocity.z) >= JOYSTICK_DEAD_ZONE : # CHECK VELOCITY IF NOT FUCK YOU
				look_dir = position
				look_dir.x += velocity.x * SIGHT_RANGE
				look_dir.z += velocity.z * SIGHT_RANGE
		else :
			look_dir = position 
			look_dir.x += raw_input.x * SIGHT_RANGE
			look_dir.z += raw_input.y * SIGHT_RANGE
	if abs(look_dir.length()) > JOYSTICK_DEAD_ZONE :
		var corrected_look_dir = get_aimest_valid_target_position(look_dir, SIGHT_RANGE, false)
		if abs(raw_input.length()) >= JOYSTICK_DEAD_ZONE and not keyboard_control:
			look_at(corrected_look_dir)
		else:
			look_at(look_dir)
	return

func get_aimest_valid_target_position(lookdir : Vector3, range : float, lineOfSight : bool) -> Vector3 :
	var all_targets : Array[Node] = get_tree().get_nodes_in_group("Target")
	var score_threshold : float = 0.8
	var best_score : float = score_threshold
	var best_target : Node = null
	for target : Node in all_targets:
		if (target.position - position).length() < range :
			var target_score = (lookdir - position).normalized().dot((target.position - position).normalized())
			if best_score < target_score :
				best_score = target_score
				best_target = target
	if best_target :
		var new_lookdir = lookdir.lerp(best_target.position, (best_score - score_threshold) / (1 - score_threshold))
		new_lookdir.y = position.y
		return new_lookdir
	return lookdir

func handle_abilities() -> void :
	if is_using_monocible() :
		if monocible_reset :
			monocible_reset = false
			print("monocible")
	else:
		monocible_reset = true
	
	if is_using_muliticible_a() :
		if multicible_a_reset :
			multicible_a_reset = false
			print("multicible a")
	else:
		multicible_a_reset = true
	
	if is_using_muliticible_b() :
		if multicible_b_reset :
			multicible_b_reset = false
			print("multicible b")
	else:
		multicible_b_reset = true
	
	if is_using_mobilite() :
		if mobilite_reset :
			mobilite_reset = false
			print("mobilite")
	else:
		mobilite_reset = true
	
	if is_using_buff() :
		if buff_reset :
			buff_reset = false
			print("buff")
	else:
		buff_reset = true
	
	if is_using_ultimate() :
		if ultimate_reset :
			ultimate_reset = false
			print("ultimate")
	else:
		ultimate_reset = true

func is_using_monocible() -> bool :
	if keyboard_control :
		if Input.is_action_just_pressed("monocible"):
			return true
	else :
		if Input.get_joy_axis(controller_id, JOY_AXIS_TRIGGER_RIGHT) > TRIGGER_DEAD_ZONE :
			return true
	return false

func is_using_muliticible_a() -> bool :
	if keyboard_control :
		if Input.is_action_just_pressed("multicible a"):
			return true
	else:
		if Input.get_joy_axis(controller_id, JOY_AXIS_TRIGGER_LEFT) > TRIGGER_DEAD_ZONE:
			return true
	return false

func is_using_muliticible_b() -> bool :
	if keyboard_control :
		if Input.is_action_just_pressed("multicible b"):
			return true
	else:
		if Input.is_joy_button_pressed(controller_id, JOY_BUTTON_LEFT_SHOULDER):
			return true
	return false

func is_using_mobilite() -> bool :
	if keyboard_control :
		if Input.is_action_just_pressed("mobilite"):
			return true
	else:
		if Input.is_joy_button_pressed(controller_id, JOY_BUTTON_A):
			return true
	return false

func is_using_buff() -> bool :
	if keyboard_control :
		if Input.is_action_just_pressed("buff"):
			return true
	else:
		if Input.is_joy_button_pressed(controller_id, JOY_BUTTON_X):
			return true
	return false

func is_using_ultimate() -> bool :
	if keyboard_control :
		if Input.is_action_just_pressed("ultimate"):
			return true
	else :
		if Input.is_joy_button_pressed(controller_id, JOY_BUTTON_RIGHT_SHOULDER):
			return true
	return false
