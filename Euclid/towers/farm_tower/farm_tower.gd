extends Tower

#the commodity type this farm produces
var commodity_type : String = ""
#the amount this farm produces per cycle
var production_rate := 1

var cell_pos : Vector2i


func _ready() -> void:
	#check back_tile_map for commodity type to produce
	var cell_size = get_parent().tile_set.tile_size
	cell_pos = Vector2i(position.x - (cell_size.x / 2), position.y - (cell_size.y / 2)) / cell_size
	var c = GameState.back_tile_map.get_cell_tile_data(0, cell_pos)
	if c != null:
		var c_type = c.get_custom_data("commodity")
		if c_type != null and c_type != "":
			commodity_type = c_type


#produce resources
func _on_farm_timer_timeout() -> void:
	if commodity_type != null and commodity_type != "":
		GameState.build_manager.add_commodities(commodity_type, production_rate)
