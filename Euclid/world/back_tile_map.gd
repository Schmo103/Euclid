class_name BackTileMap
extends TileMap

#variables regarding which tile to set when setting navigation shape
var navigation_layer : int = 1
var navigation_tile_atlas : int = 2
var navigation_tile_coords : Vector2 = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.back_tile_map = self


#sets whether tile has navigation shape
func set_tile_navigatable(pos: Vector2, b : bool) -> void:
	if b:
		set_cell(navigation_layer, pos, navigation_tile_atlas, navigation_tile_coords)
	else:
		set_cell(navigation_layer, pos)


