extends TileMap

var commodity_terrain : Dictionary

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	GameState.front_tile_map = self
	
	
#sets whether a tile position has a given commodity
func set_tile_commodity_data(tile_pos : Vector2, commodity_object : Node = null) -> void:
	if commodity_object == null:
		if commodity_terrain.has(tile_pos):
			commodity_terrain.erase(tile_pos)
	else:
		commodity_terrain[tile_pos] = commodity_object


#returns a commodity type if tile_pos has a commodity
func get_tile_commodity_type(tile_pos : Vector2) -> String:
	if commodity_terrain.has(tile_pos):
		return commodity_terrain[tile_pos].commodity.name
	else:
		return ""
