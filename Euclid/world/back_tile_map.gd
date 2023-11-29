class_name BackTileMap
extends TileMap

signal update_map_size(r : int, center : Vector2)

#variables regarding which tile to set when setting navigation shape
var navigation_layer : int = 1
var navigation_tile_atlas : int = 0
var navigation_tile_coords : Vector2 = Vector2(0, 0)

@export var initial_radius : int = 5
var radius : int = initial_radius
@export var max_radius : int = 10
@export var radius_expansion_distance : int = 5
@export var waves_per_expansion : int = 5

func _enter_tree() -> void:
	GameState.back_tile_map = self


#sets whether tile has navigation shape
func set_tile_navigatable(pos: Vector2, b : bool) -> void:
	if b:
		set_cell(navigation_layer, pos, navigation_tile_atlas, navigation_tile_coords)
	else:
		set_cell(navigation_layer, pos)


func expand_map() -> void:
	if radius + radius_expansion_distance <= max_radius:
		radius += radius_expansion_distance
		update_map_size.emit(radius, GameState.world.home_tile_pos)

