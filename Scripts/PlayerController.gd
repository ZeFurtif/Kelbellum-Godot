extends Node3D

#NODES
@onready var Body = $PlayerBody
@onready var Raycast = $PlayerBody/RayCast3D
@onready var Camera = get_viewport().get_camera_3d()
@onready var MyAnimationTree = $PlayerBody/Visuals/PlayerModel/AnimationTree

#PUBLIC
@export var PLAYER_ID = -1
@export var CHARACTER_ID = 0
@export var SPEED = 300
@export var SIGHT_RANGE = 5

#PRIVATE
var raw_move_input = Vector2.ZERO
var primary_reset = true
var secondary_reset = true
var ultimate_reset = true

func _ready():
	pass

func _physics_process(delta):
	# MOVEMENT
	handle_movement(delta)
	handle_aim()
	#handle_move_animation()
	# ABILITIES
	handle_abilities()

# BASE EVENTS
func handle_movement(delta):
	raw_move_input = Vector2.ZERO
	if PLAYER_ID == -1:
		raw_move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		raw_move_input = raw_move_input.normalized()
	else:
		var controllerId = PlayerManager.get_controllerId(PLAYER_ID)
		if controllerId != -1:
			raw_move_input.x = Input.get_joy_axis(controllerId,JOY_AXIS_LEFT_X)
			raw_move_input.y = Input.get_joy_axis(controllerId,JOY_AXIS_LEFT_Y)
	if raw_move_input.length() >= 0.5:
		Body.velocity.x = raw_move_input.x * SPEED * delta * raw_move_input.length()
		Body.velocity.z = raw_move_input.y * SPEED * delta * raw_move_input.length()
		Body.move_and_slide()

func handle_aim():
	var raw_input = Vector2.ZERO # VEC2, if keyboard = mouse pos, if controller = input
	var look_dir = Vector3.ZERO # VEC3 Translation
	if PLAYER_ID == -1: # KEYBOARD
		raw_input = get_viewport().get_mouse_position()
		look_dir = Plane(Vector3(0, 0, 10), 0).intersects_ray(Camera.project_ray_origin(raw_input),Camera.project_ray_normal(raw_input))
		if look_dir:
			look_dir.z = look_dir.y * -1
			look_dir.y = Body.global_position.y
		else:
			look_dir = Vector3.ZERO
	else: # CONTROLLER
		var controllerId = PlayerManager.get_controllerId(PLAYER_ID)
		if controllerId != -1: # CHECK IF CONTROLLER CONNECTED
			raw_input.x = Input.get_joy_axis(controllerId, JOY_AXIS_RIGHT_X)
			raw_input.y = Input.get_joy_axis(controllerId, JOY_AXIS_RIGHT_Y)
			if abs(raw_input.length()) < 0.5: # IF NO AIM INPUT STICK TO VELOCITY
				if abs(Body.velocity.x * Body.velocity.z) >= 0.5: # CHECK VELOCITY IF NOT FUCK YOU
					look_dir = Body.position
					look_dir.x += Body.velocity.x * 5
					look_dir.z += Body.velocity.z * 5
			else: # IF AIM 
				look_dir = Body.position 
				look_dir.x += raw_input.x * 5
				look_dir.z += raw_input.y * 5
	if abs(look_dir.length()) > 0.5:
		var corrected_look_dir = get_aimest_valid_target_position(look_dir, SIGHT_RANGE, false)
		#print(abs(raw_input.length()))
		if abs(raw_input.length()) >= 0.5:
			Body.look_at(corrected_look_dir)
		else:
			Body.look_at(look_dir)

#func handle_move_animation():
#	var move_length = raw_move_input.length()
#	if move_length >= 0.5:
#		var flat_aim = Vector2(Body.global_transform.basis.z.x, Body.global_transform.basis.z.z)
#		var angle_to_aim = raw_move_input.angle_to(flat_aim*-1)/ PI
#		var left = -1
#		if angle_to_aim < 0:
#			left = 1
#		var blend_x = (abs(abs(angle_to_aim) - 0.5) - 0.5) * -2 * left
#		var blend_y = ((abs(angle_to_aim) * 2) - 1) * -1
#		MyAnimationTree["parameters/IsRunning/blend_amount"] = true
#		MyAnimationTree["parameters/WalkRunBlend/blend_amount"] = parametric_blend(remap(move_length, 0.5, 1, 0, 1))
#		MyAnimationTree["parameters/WalkBlend/blend_position"].x = blend_x
#		MyAnimationTree["parameters/WalkBlend/blend_position"].y = blend_y
#		MyAnimationTree["parameters/RunBlend/blend_position"].x = blend_x
#		MyAnimationTree["parameters/RunBlend/blend_position"].y = blend_y
#	else:
#		MyAnimationTree["parameters/IsRunning/blend_amount"] = false

func handle_abilities():
	if is_using_primary():
		if primary_reset:
			primary_reset = false
			print("primary")
	else:
		primary_reset = true
	if is_using_secondary():
		if secondary_reset:
			secondary_reset = false
			print("secondary")
	else:
		secondary_reset = true
	if is_using_ultimate():
		if ultimate_reset:
			ultimate_reset = false
			print("ultimate")
	else:
		ultimate_reset = true

func use_primary():
	pass

# HELPERS
func get_aimest_valid_target_position(lookdir, range, lineOfSight):
	var all_targets = get_tree().get_nodes_in_group("Target")
	var score_threshold = 0.8
	var best_score = score_threshold
	var best_target
	for target in all_targets:
		if (target.position - Body.position).length() < range:
			var target_score = (lookdir - Body.position).normalized().dot((target.position - Body.position).normalized())
			if best_score < target_score:
				best_score = target_score
				best_target = target
	if best_target:
		var new_lookdir = lookdir.lerp(best_target.position, (best_score-score_threshold)/(1-score_threshold))
		new_lookdir.y = Body.position.y
		return new_lookdir
	return lookdir

func is_using_primary():
	if PLAYER_ID == -1:
		if Input.is_action_just_pressed("primary"):
			return true
	else:
		var controllerId = PlayerManager.get_controllerId(PLAYER_ID)
		if controllerId != -1:
			if Input.get_joy_axis(controllerId,JOY_AXIS_TRIGGER_RIGHT) > 0.5:
				return true
	return false

func is_using_secondary():
	if PLAYER_ID == -1:
		if Input.is_action_just_pressed("secondary"):
			return true
	else:
		var controllerId = PlayerManager.get_controllerId(PLAYER_ID)
		if controllerId != -1:
			if Input.get_joy_axis(controllerId,JOY_AXIS_TRIGGER_LEFT) > 0.5:
				return true
	return false

func is_using_ultimate():
	if PLAYER_ID == -1:
		if Input.is_action_just_pressed("ultimate"):
			return true
	else:
		var controllerId = PlayerManager.get_controllerId(PLAYER_ID)
		if controllerId != -1:
			if Input.is_joy_button_pressed(controllerId, JOY_BUTTON_LEFT_SHOULDER) and Input.is_joy_button_pressed(controllerId, JOY_BUTTON_RIGHT_SHOULDER):
				return true
	return false

# UTILITY / MATH
func parametric_blend(t):
	var sqr = t * t;
	return sqr / (2 * (sqr - t) + 1);
