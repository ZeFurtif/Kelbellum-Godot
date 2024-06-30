class_name PlayerHUD
extends Control

@export_file("*.tscn") var spell_hud_path : String = "res://scenes/player/player_hud/spell_hud.tscn"
@export_file("*.tscn") var upgrade_hud_path : String = "res://scenes/player/player_hud/upgrades_hud.tscn"

@onready var spells_container : HBoxContainer = $SpellsContainer
@onready var upgrades_container : HBoxContainer = $UpgradesContainer
@onready var health_bar : ProgressBar = $"HealthBar"
@onready var character_label : Label = $"Name"
@onready var character_icon : TextureRect = $"Icon"

var spells : Dictionary = {}
var upgrades : Dictionary = {}

func _ready() -> void:
	spawn_spells()
	spawn_upgrades()
	hide_upgrades() 
	return

func spawn_spells() -> void:
	var spell_hud_scene : PackedScene = load(spell_hud_path)
	for spell_hud_id in range(5):
		var spell_hud : Node = spell_hud_scene.instantiate()
		spells[spell_hud_id] = spell_hud
		spells_container.call_deferred("add_child", spell_hud)
	return

func spawn_upgrades() -> void:
	var upgrade_hud_scene : PackedScene = load(upgrade_hud_path)
	for upgrade_hud_id in range(3):
		var upgrade_hud : Node = upgrade_hud_scene.instantiate()
		upgrades[upgrade_hud_id] = upgrade_hud
		upgrades_container.call_deferred("add_child", upgrade_hud)
	return

func hide_upgrades(id : int = -1) -> void:
	if id == -1:
		for upgrade in upgrades:
			upgrades[upgrade].visible = !upgrades[upgrade].visible
		return
	else:
		if id in upgrades:
			upgrades[id].visible = !upgrades[id].visible
			return
		else:
			print("ERROR - id not in dictionnary")

func update_health_bar(value : float) -> void:
	health_bar.value = value
	return

func set_health_bar_max_value(value : float) -> void:
	health_bar.max_value = value
	return

func set_health_bar_color(color : Color) -> void:
	health_bar["theme_override_styles/fill"].set("bg_color", color)
	return

func set_character_name(string : String) -> void:
	character_label.text = string
	return

func set_character_icon(texture : Texture) -> void:
	character_icon.texture = texture
	return
