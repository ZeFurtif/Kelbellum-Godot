extends Node3D

enum EnemyRarity {
	COMMON,
	UNCOMMON,
	RARE,
	BOSS,
}

@export var debug_enable : bool = false

@export_category("Common Enemies")
@export var common_enemies_scene : Array[PackedScene] = []
@export var common_enemies_spawn_rate : Array[float] = []

@export_category("Uncommon Enemies")
@export var uncommon_enemies_scene : Array[PackedScene] = []
@export var uncommon_enemies_spawn_rate : Array[float] = []

@export_category("Rare Enemies")
@export var rare_enemies_scene : Array[PackedScene] = []
@export var rare_enemies_spawn_rate : Array[float] = []

@export_category("Boss Enemies")
@export var boss_enemies_scene : Array[PackedScene] = []
@export var boss_enemies_spawn_rate : Array[float] = []

var enemy_count : int = 0
var random : RandomNumberGenerator = RandomNumberGenerator.new()
var available_spawns : Array[VisibleOnScreenNotifier3D] = []

func _ready() -> void :
	# Setup random for spawn
	random.randomize()
	# Setup spawner
	for spawn in get_children() :
		if spawn is VisibleOnScreenNotifier3D :
			spawn.screen_entered.connect(_on_spawn_screen_entered.bind(spawn))
			spawn.screen_exited.connect(_on_spawn_screen_exited.bind(spawn))
		
	if debug_enable :
		$DebugSpawn.autostart = true
		$DebugSpawn.start()
	return
	
func _spawn_random_enemies(rarety : EnemyRarity, quantity : int) -> void :
	for index : int in quantity :
		_spawn_random_enemy(rarety)
	return

func _spawn_enemies(enemy_scene : PackedScene, quantity : int) -> void :
	for index : int in quantity :
		_spawn_enemy(enemy_scene)
	return

func _spawn_enemy(enemy_scene : PackedScene) -> void :
	var spawner : Node3D = _get_random_available_spawn()
	if spawner :
		var enemy : Node3D = enemy_scene.instantiate()
		call_deferred("add_child", enemy)
		# position must be set when node is in tree
		await enemy.tree_entered 
		enemy.global_position = spawner.global_position
		enemy.tree_exited.connect(_on_enemy_die)
		enemy_count += 1
	else :
		push_warning("No spawn defined")
	return

func _spawn_random_enemy(rarety : EnemyRarity) -> void :
	var enemies_scene : Array[PackedScene] = []
	var enemies_spawn_rate : Array[float] = []
	var rand : float = random.randf()
	
	match rarety :
		EnemyRarity.COMMON :
			enemies_scene = common_enemies_scene
			enemies_spawn_rate = common_enemies_spawn_rate
		EnemyRarity.UNCOMMON :
			enemies_scene = uncommon_enemies_scene
			enemies_spawn_rate = uncommon_enemies_spawn_rate
		EnemyRarity.RARE :
			enemies_scene = rare_enemies_scene
			enemies_spawn_rate = rare_enemies_spawn_rate
		EnemyRarity.BOSS :
			enemies_scene = boss_enemies_scene
			enemies_spawn_rate = boss_enemies_spawn_rate

	var sum : float = 0.0
	for index : int in enemies_scene.size() :
		sum += enemies_spawn_rate[index]
		if rand <= sum :
			var spawner : Node3D = _get_random_available_spawn()
			if spawner :
				var enemy : Node3D = enemies_scene[index].instantiate()
				call_deferred("add_child", enemy)
				# position must be set when node is in tree
				await enemy.tree_entered 
				enemy.global_position = spawner.global_position
				enemy.tree_exited.connect(_on_enemy_die)
				enemy_count += 1
			else :
				push_warning("No spawn defined")
			return
	return

func _on_enemy_die() -> void :
	enemy_count -= 1
	return

func _on_spawn_screen_entered(spawn : VisibleOnScreenNotifier3D) -> void :
	available_spawns.erase(spawn)
	return
	
func _on_spawn_screen_exited(spawn : VisibleOnScreenNotifier3D) -> void :
	available_spawns.append(spawn)
	return
	
func _get_random_available_spawn() -> Node3D :
	if available_spawns.size() :
		return available_spawns.pick_random()
	else :
		return null

func _on_debug_spawn_timeout() -> void :
	_spawn_random_enemy(EnemyRarity.COMMON)
	return
