class_name Tower
extends Node2D

enum tower_types {UTIL, DEFENSE}

@export_enum("UTIL", "DEFENSE") var type : int = tower_types.UTIL

@export var health := 10:
	set(h):
		if h <= 0:
			health = 0
			fall()
		else:
			health = h
			
var tile_pos : Vector2


func _ready():
	#make tile not navigatable
	tile_pos = (global_position - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size
	GameState.back_tile_map.set_tile_navigatable(tile_pos, false)
	print(str(tile_pos))
	
	
func _exit_tree():
	#make tile navigatable when leaving scene tree
	GameState.back_tile_map.set_tile_navigatable(tile_pos, true)
	

func take_damage(dmg : int) -> void:
	health -= dmg
	
	
#destroy the tower
func fall() -> void:
	print("tower is destroyed")
