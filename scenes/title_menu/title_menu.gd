extends CanvasLayer

enum MenuState {
	TITLE = 0,
	SETTINGS = 1,
	CREDITS = 2,
}

var current_state = MenuState.TITLE

@onready var title_screen = $TitleScreen

func _ready() -> void:
	return

func update_menu() -> void:
	return

func _on_play_button_pressed() -> void:
	return

func _on_quit_button_pressed() -> void:
	get_tree().quit()
