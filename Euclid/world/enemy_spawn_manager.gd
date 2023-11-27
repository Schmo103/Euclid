class_name EnemySpawnManager
extends Node2D

@export var wave_alert : WaveAlert

var standard_enemy_scene : PackedScene = preload("res://enemies/standard/standard_enemy.tscn")

var wave_difficulty : int = 1
var wave : Dictionary = {standard_enemy_scene : 1}
var wave_nodes : Array[Enemy]
var wave_spwan_position : Vector2 = Vector2.ZERO

func _ready() -> void:
	wave_alert.end_of_count_down_reached.connect(_on_final_count_down_ended)
	

func _on_final_count_down_ended() -> void:
	prep_next_wave()
	launch_wave()
	
	
func prep_next_wave() -> void:
	wave_spwan_position = get_wave_spawn_point()
	generate_wave()
	
	
func launch_wave() -> void:
	#actually instances all the enemies in the wave at wave_spawn_point
	wave_nodes.clear()
	for enemy_scene in wave.keys():
		for i in range(0, wave[enemy_scene]):
			print("adding node to wave_nodes")
			var e = enemy_scene.instansiate()
			e.position = wave_spwan_position
			wave_nodes.append(e)
	#spawn first enemy
	#start spawn delay timer
	#and make so it goes throught the array, spawning an enemy and removing it from the array on each timeout

	
	
func generate_wave() -> void:
	#uses wave difficulty to procedurally generate wave adn sets wave Dictionary
	pass
	
	
func get_wave_spawn_point() -> Vector2:
	#if time choose randomly from all spawn point children
	return $SpawnPoint.position
	
	
