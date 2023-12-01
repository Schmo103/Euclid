class_name FarmTower
extends Tower



#the list of commodities this farm produces
var commodities : Array[Node] = []
#the amount this farm produces per cycle
@export var production_rate := 1
#the "radius" of the square that this farm produces commodities from
#if the radius is 2, than this will result in a 5 by 5 square
@export var produce_range_radius : int = 2




func _ready() -> void:
	#calls _ready function of parent class Tower
	super()
	update_commodities()
	GameState.back_tile_map.update_map_size.connect(_on_update_map_size)
	
	
func _on_update_map_size(_r : int, _center : Vector2) -> void:
	update_commodities()


#produce resources
func _on_farm_timer_timeout() -> void:
	for c in commodities:
		c = c as CommodityObject
		for i in range(0, production_rate):
			if c.has_commodity():
				c.take_commodity()
				GameState.build_manager.add_commodities(c.commodity.name, 1)
			else:
				break
		
		
#find commodities within range and add them to commodities array
func update_commodities() -> void:
	var start_tile = tile_pos - Vector2(produce_range_radius, produce_range_radius)
	var tile = start_tile
	
	var end_tile_x = tile.x + 2 * produce_range_radius + 1
	while(tile.x < end_tile_x):
		
		var end_tile_y = tile.y + 2 * produce_range_radius + 1
		while(tile.y < end_tile_y):
			var c : Node = GameState.front_tile_map.get_tile_commodity_node(tile)
			if c != null:
				commodities.append(c)
			tile.y += 1
		tile.y = start_tile.y
		
		tile.x += 1
	
