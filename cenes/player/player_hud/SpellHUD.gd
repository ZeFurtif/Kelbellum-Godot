class_name SpellHUD
extends TextureRect

@onready var progress_bar : ProgressBar = $"ProgressBar"
@onready var freeze_overlay : ColorRect = $"FreezeOverlay"

@export var cooldown_ms : float = 2000
var _frozen : bool = false
var _lastUseTime : float = -9999

func _ready() -> void:
	return
	
func _physics_process(delta: float) -> void: # USING PHYSICS PROCESS BECAUSE IT UPDATES LESS
	if !_frozen:
		var elapsed_time : float = Time.get_ticks_msec() - _lastUseTime
		if elapsed_time >= cooldown_ms:
			reset_progress_bar()
		else:
			update_progress_bar(elapsed_time)

func reset_progress_bar() -> void:
	progress_bar.value = 0
	return 
	
func update_progress_bar(elapsed_time : float) -> void:
	progress_bar.value = 100 - (elapsed_time/cooldown_ms) * 100
	return

func start_timer() -> void:
	_lastUseTime = Time.get_ticks_msec()
	return

func toggle_freeze() -> void:
	_frozen = !_frozen
	freeze_overlay.visible = _frozen
	return
