class_name SpellHUD
extends TextureRect

@onready var progress_bar : ProgressBar = $"ProgressBar"
@onready var freeze_overlay : ColorRect = $"FreezeOverlay"

@export var cooldown : float = 2
var elapsed_time : float = 0
var _frozen : bool = false
var _lastUseTime : float = -9999

func _ready() -> void:
	return
	
func _physics_process(delta: float) -> void: # USING PHYSICS PROCESS BECAUSE IT UPDATES LESS
	if !_frozen:
		elapsed_time -= delta
		if elapsed_time < 0:
			reset_progress_bar()
		else:
			update_progress_bar(elapsed_time)

func reset_progress_bar() -> void:
	progress_bar.value = 0
	return 
	
func update_progress_bar(elapsed_time : float) -> void:
	progress_bar.value = 100 - elapsed_time * 100
	return

func start_timer() -> void:
	elapsed_time = cooldown
	return

func toggle_freeze() -> void:
	_frozen = !_frozen
	freeze_overlay.visible = _frozen
	return
