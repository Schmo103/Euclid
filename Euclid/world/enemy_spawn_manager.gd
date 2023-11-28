class_name EnemySpawnManager
extends Node2D

@export var wave_alert : WaveAlert
@export var enemies : Array[EnemyStats]


var standard_enemy_scene : PackedScene = preload("res://enemies/standard/standard_enemy.tscn")
enum available_enemies {STANDARD}
var available_enemy_scenes : Array[PackedScene] = [standard_enemy_scene]
var enemy_ratio : Array[int] = [1]


var wave_difficulty : int = 3  #one difficulty point spawns one standard enemy
var wave_difficulty_increment_rate : int = 2

var wave : Dictionary = {standard_enemy_scene : 3}

var wave_nodes : Array[Enemy]
var wave_spawn_position : Vector2 = Vector2.ZERO

var spawn_points : Array[SpawnPoint] = []


func _ready() -> void:
	wave_alert.end_of_count_down_reached.connect(_on_final_count_down_ended)
	register_spawn_points()
	
	
func _on_final_count_down_ended() -> void:
	prep_next_wave()
	if not GameState.game_over:
		launch_wave()
		increment_wave_difficulty()
	
	
func prep_next_wave() -> void:
	wave_spawn_position = get_wave_spawn_point()
	generate_wave()
	
	
func launch_wave() -> void:
	#actually instances all the enemies in the wave at wave_spawn_point
	wave_nodes.clear()
	for enemy_stats in enemies:
		if wave.has(enemy_stats.enemy_scene):
			for i in range(0, wave[enemy_stats.enemy_scene]):
				var e = enemy_stats.enemy_scene.instantiate()
				e.position = wave_spawn_position
				wave_nodes.append(e)
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
	var points_left : int = wave_difficulty #how many difficulty points we have to spend on enemies
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
	return spawn_points[i].position
#	return $SpawnPoint.position
	
	
func increment_wave_difficulty() -> void:
	wave_difficulty += wave_difficulty_increment_rate
	
	
func _on_spawn_delay_timer_timeout():
	if wave_nodes.size() > 0:
		spawn_enemy_from_wave_nodes()
		$SpawnDelayTimer.start()
	else:
		wave_alert.start_wave_count_down()
		
		
func register_spawn_points() -> void:
	for c in get_children():
		if c.is_in_group("spawn_point"):
			spawn_points.append(c)
