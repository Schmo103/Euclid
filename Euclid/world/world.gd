class_name World
extends Node2D

signal player_spawned
signal player_died

@export var home_tile_pos : Vector2
@export var player_respawn_delay : int = 3
@export var player_scene : PackedScene
@export var player_spawn_timer : Timer

func _enter_tree() -> void:
	GameState.world = self
	player_spawn_timer.wait_time = player_respawn_delay
	
	
func _ready() -> void:
	GameState.start_game()


func on_player_died() -> void:
	player_died.emit()
	player_spawn_timer.start()
	
	
func _on_player_spawn_timer_timeout() -> void:
	var p = player_scene.instantiate()
	p.position = home_tile_pos * GameState.real_tile_size + GameState.real_tile_size * 1.5
	$Mobs.add_child(p)
	player_spawned.emit()
