class_name FrontTileMap
extends TileMap

var commodity_terrain : Dictionary
var tower_data : Dictionary

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
		
		
func remove_tower(t : Vector2) -> void:
	if tower_data.has(t):
		tower_data.erase(t)
	erase_cell(0, t)


func build_tower(tower : PackedScene, tower_pos : Vector2) -> void:
	var t = tower.instantiate()
	var tp = tower_pos * GameState.tile_size + GameState.tile_size / 2
	t.position = tp
	add_child(t)
	
	
func register_tower(tile_pos : Vector2, t : Tower) -> void:
	tower_data[tile_pos] = t
	
	


