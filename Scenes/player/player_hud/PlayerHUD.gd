class_name PlayerHUD
extends Control

@export_file("*.tscn") var spell_hud_path : String = "res://scenes/player/player_hud/spell_hud.tscn"
@export_file("*.tscn") var upgrade_hud_path : String = "res://scenes/player/player_hud/upgrades_hud.tscn"

@onready var spells_container : HBoxContainer = $PlayerCard/SpellsContainer
@onready var upgrades_container : HBoxContainer = $UpgradesContainer

var spells : Dictionary = {}
var upgrades : Dictionary = {}

func _ready() -> void:
	spawn_spells()
	spawn_upgrades()
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
