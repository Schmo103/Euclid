class_name Tower
extends Node2D

signal fell

enum tower_types {UTIL, DEFENSE, TERRAIN}

@export var tower_stats : TowerStats
@export_enum("UTIL", "DEFENSE", "TERRAIN")
var type : int = tower_types.UTIL

@export var health := 10:
	set(h):
		if h <= 0:
			health = 0
			fall()
		else:
			health = h
		if health_display != null:
			health_display.value = health
			
var tile_pos : Vector2

@export var health_display : Control


func _ready():
	#make tile not navigatable
	tile_pos = (global_position - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size
	GameState.back_tile_map.set_tile_navigatable(tile_pos, false)
	@warning_ignore("narrowing_conversion")
	z_index = tile_pos.y
	add_to_group("tower")
	
	if health_display != null:
		health_display.max_value = health
	
	
func _exit_tree():
	#make tile navigatable when leaving scene tree
	#note: right now this will happen even if the tile originally wasnt navigatable
	GameState.back_tile_map.set_tile_navigatable(tile_pos, true)
	GameState.front_tile_map.erase_cell(0, tile_pos)
	

func take_damage(dmg : int) -> void:
	health -= dmg
	
	
#destroy the tower
func fall() -> void:
	fell.emit()
	queue_free()
