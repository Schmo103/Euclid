class_name EnemySpawnManager
extends Node2D

@export var wave_alert : WaveAlert
@export var wave_direction_indicator : WaveDirectionIndicator
@export var wave_caller_menu : WaveCallerMenu
@export var boss_wave_alert : Label
@export var enemies : Array[EnemyStats]



var standard_enemy_scene : PackedScene = preload("res://enemies/standard/standard_enemy.tscn")
var tank_enemy_scene : PackedScene = preload("res://enemies/tank/tank.tscn")
enum available_enemies {STANDARD}
var available_enemy_scenes : Array[PackedScene] = [standard_enemy_scene]
var enemy_ratio : Array[int] = [1]


@export var wave_difficulty : int = 6  #one difficulty point spawns one standard enemy
@export var wave_difficulty_increment_rate : int = 2
var wave_difficulty_one_time_bonus : int = 0

@export var wave_boss_bonus : int = 15
@export var waves_per_boss_wave : int = 5

@export var spawn_offset : float = 32

var wave_count : int = 0
var first_wave : bool = true
var wave : Dictionary = {standard_enemy_scene : 3}

var wave_nodes : Array[Enemy]
var wave_spawn_position : Vector2 = Vector2.ZERO
var wave_spawn_point : SpawnPoint

var spawn_points : Array[SpawnPoint] = []


func _ready() -> void:
	wave_alert.end_of_count_down_reached.connect(_on_final_count_down_ended)
	register_spawn_points()
	wave_spawn_position = get_wave_spawn_point()
	wave_caller_menu.set_wave_count(wave_count + 1)
	
	
func _on_final_count_down_ended() -> void:
	if wave_count % GameState.back_tile_map.waves_per_expansion == 0 and not first_wave:
		GameState.back_tile_map.expand_map()
		
	if wave_count % waves_per_boss_wave == 0 and not first_wave:
		#boss wave stuff here
		wave_difficulty_one_time_bonus = wave_boss_bonus
		boss_wave_alert.visible = true
	else:
		boss_wave_alert.visible = false
		
	first_wave = false
	prep_next_wave()
	if not GameState.game_over:
		launch_wave()
		increment_wave_difficulty()
	wave_count += 1
	wave_caller_menu.set_wave_count(wave_count + 1)
	
	
	
func prep_next_wave() -> void:
	generate_wave()
	
	
func launch_wave() -> void:
	#actually instances all the enemies in the wave at wave_spawn_point
	wave_nodes.clear()
	var total_enemy_count : int = 1
	var left : bool = false
	for enemy_stats in enemies:
		if wave.has(enemy_stats.enemy_scene):
			for i in range(0, wave[enemy_stats.enemy_scene]):
				var e = enemy_stats.enemy_scene.instantiate()
				var offset : Vector2 = wave_spawn_point.direction_from_home.orthogonal() * total_enemy_count * spawn_offset
				if left:
					offset = offset.orthogonal().orthogonal()
				e.position = wave_spawn_position + offset
				wave_nodes.append(e)
				if left:
					total_enemy_count += 1
				left = !left
#	for enemy_scene in wave.keys():
#		for i in range(0, wave[enemy_scene]):
#			var e = enemy_scene.instantiate()
#			e.position = wave_spawn_position
#			wave_nodes.append(e)
	spawn_enemy_from_wave_nodes()
	#the wave is spawned one enemy at a time, with a small delay between each one
	$SpawnDelayTimer.start()
	

func generate_wave() -> void:
	#uses wave difficulty to procedurally generate wave and sets wave Dictionary
	wave.clear()
	var points_left : int = wave_difficulty + wave_difficulty_one_time_bonus #how many difficulty points we have to spend on enemies
	wave_difficulty_one_time_bonus = 0
	var level : int = 0 #the enemy tier we are on
	var max_level : int = enemies.size() - 1 #the number of enemy tiers
	var this_round : Dictionary = {} #the enemies we've bought this round
	while(points_left > 0):
		#check if can pay
		var e : EnemyStats = enemies[level]
		if points_left >= e.cost: #if can afford enemy, buy enemy
			add_enemy_to_wave(e.enemy_scene)
			add_enemy_stats_to_dict(e, this_round)
			points_left -= e.cost
		else: #if cant afford enemy, go down a level tier
			if level <= 0:
				break
			else:
				level -= 1
				continue
		if this_round.has(e) and this_round[e] >= e.ratio: #if bought enough enemies to advance
			if level >= max_level: #if at top enemy tier
				level = 0  #go to bottom enemy tier
				this_round.clear() #start new round
			else: #if not at top enemy tier
				level += 1 #advance to next enemy tier
	
	
	
func add_enemy_to_wave(ps : PackedScene) -> void:
	if wave.has(ps):
		wave[ps] += 1
	else:
		wave[ps] = 1
		
		
func add_enemy_stats_to_dict(e : EnemyStats, d : Dictionary) -> void:
	if d.has(e):
		d[e] += 1
	else:
		d[e] = 1

	
func spawn_enemy_from_wave_nodes() -> void:
	if wave_nodes.size() > 0:
		var e : Enemy = wave_nodes[0]
		GameState.enemy_manager.add_child(e)
		wave_nodes.remove_at(0)
	
	
func get_wave_spawn_point() -> Vector2:
	#choose randomly from all spawn point children
	var i = randi_range(0, spawn_points.size() - 1)
	wave_spawn_point = spawn_points[i]
#	wave_spawn_point = $SpawnPoint
	wave_direction_indicator.change_spawn_point(wave_spawn_point)
#	return $SpawnPoint.position
	return spawn_points[i].position

	
	
func increment_wave_difficulty() -> void:
	wave_difficulty += wave_difficulty_increment_rate
	
	
func _on_spawn_delay_timer_timeout():
	if wave_nodes.size() > 0:
		spawn_enemy_from_wave_nodes()
		$SpawnDelayTimer.start()
	else:
		wave_spawn_position = get_wave_spawn_point()
		wave_alert.start_wave_count_down()
		
		
func register_spawn_points() -> void:
	for c in get_children():
		if c.is_in_group("spawn_point"):
			spawn_points.append(c)
			
			
