class_name EnemySpawnManager
extends Node2D

@export var wave_alert : WaveAlert

var standard_enemy_scene : PackedScene = preload("res://enemies/standard/standard_enemy.tscn")

var wave_difficulty : int = 3  #one difficulty point spawns one standard enemy
var wave_difficulty_increment_rate : int = 2

enum available_enemies {STANDARD}
var available_enemy_scenes : Array[PackedScene] = [standard_enemy_scene]
var enemy_ratio : Array[int] = [1]

var wave : Dictionary = {standard_enemy_scene : 3}

var wave_nodes : Array[Enemy]
var wave_spawn_position : Vector2 = Vector2.ZERO

var spawn_points : Array[SpawnPoint] = []


func _ready() -> void:
	wave_alert.end_of_count_down_reached.connect(_on_final_count_down_ended)
	register_spawn_points()
	
	
func _on_final_count_down_ended() -> void:
	prep_next_wave()
	launch_wave()
	increment_wave_difficulty()
	
	
func prep_next_wave() -> void:
	wave_spawn_position = get_wave_spawn_point()
	generate_wave()
	
	
func launch_wave() -> void:
	#actually instances all the enemies in the wave at wave_spawn_point
	wave_nodes.clear()
	for enemy_scene in wave.keys():
		for i in range(0, wave[enemy_scene]):
			var e = enemy_scene.instantiate()
			e.position = wave_spawn_position
			wave_nodes.append(e)
	spawn_enemy_from_wave_nodes()
	#the wave is spawned one enemy at a time, with a small delay between each one
	$SpawnDelayTimer.start()
	

func generate_wave() -> void:
	#uses wave difficulty to procedurally generate wave and sets wave Dictionary
	wave.clear()
	for i in range(0, wave_difficulty):
		var e = available_enemy_scenes[available_enemies.STANDARD]
		if wave.has(e):
			wave[e] += 1
		else:
			wave[e] = 1
		
	
func spawn_enemy_from_wave_nodes() -> void:
	if wave_nodes.size() > 0:
		var e : Enemy = wave_nodes[wave_nodes.size() - 1]
		GameState.enemy_manager.add_child(e)
		wave_nodes.remove_at(wave_nodes.size() - 1)
	
	
func get_wave_spawn_point() -> Vector2:
	#choose randomly from all spawn point children
	var i = randi_range(0, spawn_points.size() - 1)
	return spawn_points[i].position
	
	
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
