class_name SpawnPoint
extends Marker2D

@export var direction_from_home : Vector2

var offset_tile_count : int = 10

func _ready() -> void:
	add_to_group("spawn_point")
	GameState.back_tile_map.update_map_size.connect(_on_update_map_size)
	set_position_by_tile_map_radius(GameState.back_tile_map.initial_radius)
	
	
func set_position_by_tile_map_radius(map_radius : float) -> void:
	var home_pos : Vector2 = GameState.world.home_tile_pos * GameState.real_tile_size
	position = direction_from_home * GameState.real_tile_size * (map_radius + offset_tile_count) + home_pos
	print(str(self) + " position is " + str(position))
	
	
func _on_update_map_size(r : int, _home_pos : Vector2) -> void:
	set_position_by_tile_map_radius(r)

