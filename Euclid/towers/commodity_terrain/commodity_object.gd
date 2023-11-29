class_name CommodityObject
extends Node2D

@export var commodity : Commodity

@export var off_map_effects : OffMapEffects

var tile_pos : Vector2
var available : bool = false


func _ready() -> void:
	tile_pos = (global_position - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size
	add_to_group("commodity_object")
	add_to_group("void")
#	set_up_commodity()
	#check if available based on back_tile_map.initial_radius
	var a = is_in_radius(tile_pos, GameState.back_tile_map.initial_radius, GameState.world.home_tile_pos)
	safe_set_tile_available(a)
	GameState.back_tile_map.update_map_size.connect(_on_update_map_size)

	
func set_up_commodity() -> void:
	GameState.front_tile_map.set_tile_commodity_data(tile_pos, self)
	
	
func _exit_tree() -> void:
	GameState.front_tile_map.set_tile_commodity_data(tile_pos)
	
	
func safe_set_tile_available(b : bool) -> void:
	if not available and b:
		set_up_commodity()
	available = b
	if off_map_effects != null:
		off_map_effects.set_tile_available(b)
	else:
		push_warning("commodity object is missing off map effects")
		
		
func _on_update_map_size(r : int, center : Vector2) -> void:
	if not available and is_in_radius(tile_pos, r, center):
		safe_set_tile_available(true)
	
	
func is_in_radius(t : Vector2, r : int, center : Vector2i) -> bool:
	var max_x : int = center.x + r
	var min_x : int = center.x - r
	var max_y : int = center.y + r
	var min_y : int = center.y - r
	
	var in_x : bool = t.x <= max_x and t.x >= min_x
	var in_y : bool = t.y <= max_y and t.y >= min_y
	
	return in_x and in_y
	
	

