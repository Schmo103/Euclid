class_name CommodityObject
extends Node2D

@export var commodity : Commodity

var tile_pos : Vector2


func _ready() -> void:
	tile_pos = (global_position - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size
	add_to_group("commodity_object")
	set_up_commodity()

	
func set_up_commodity() -> void:
	GameState.front_tile_map.set_tile_commodity_data(tile_pos, self)
	
	
func _exit_tree() -> void:
	GameState.front_tile_map.set_tile_commodity_data(tile_pos)
