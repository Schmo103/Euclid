class_name WallStats
extends TowerStats

signal new_wall_built(tile_pos : Vector2)
signal wall_destroyed(tile_pos : Vector2)
signal update_image(tile_pos : Vector2, r : int)

var possible_corners : Array = [Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)]
var possible_adjacent_positions : Array = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var adjacent_positions : Array = []
var corners : Array = []

#checks if can build wall
func can_build(objects : Array, tile_pos : Vector2) -> bool:
	custom_can_build_message = ""
	adjacent_positions = []
	corners = []
	for ob in objects:
		if ob.is_in_group("wall"):
			var v : Vector2 = ob.tile_pos - tile_pos
			if v == Vector2.ZERO:
				custom_can_build_message = "Towers can't be built on top of each other"
				return false
			elif possible_corners.has(v):
				corners.append(v)
			elif possible_adjacent_positions.has(v):
				adjacent_positions.append(v)
		else:
			if ob.is_in_group("entity"):
				custom_can_build_message = "Towers can't be built on top of entities"
			else:
				if ob.is_in_group("tower") and ob.tile_pos == tile_pos:
					custom_can_build_message = "Towers can't be built on top of each other"
				else:
					custom_can_build_message = "Towers can't be built adjacent to each other"
			if ob.is_in_group("void"):
				custom_can_build_message = "Towers can't be built off of the map"
			return false
	if adjacent_positions.size() > 2:
		custom_can_build_message = "Walls can't be layered"
		return false
	for ad in adjacent_positions:
		if !check_pos_has_only_one_adjacent(tile_pos + ad):
			custom_can_build_message = "Walls can't be layered"
			return false
		#make sure if ad is door, ad does not become corner on this build
		if check_creates_door_corner(tile_pos, ad):
			custom_can_build_message = "Doors can't be wall corners"
			return false
	for c in corners:
		if !validate_diagonal(c):
			custom_can_build_message = "To build walls diagonally you must connect them with a corner"
			return false
	return true
	
	
func validate_diagonal(diag : Vector2) -> bool:
	return adjacent_positions.has(Vector2(diag.x, 0)) or adjacent_positions.has(Vector2(0, diag.y))
	
	
func check_pos_has_only_one_adjacent(pos : Vector2) -> bool:
	var one : bool = false
	for a in possible_adjacent_positions:
		if GameState.front_tile_map.tower_data.has(a + pos):
			if one:
				return false
			else:
				one = true
	return true
	
	
func check_creates_door_corner(tile_pos : Vector2, ad : Vector2) -> bool:
	var door_pos : Vector2 = tile_pos + ad
	if GameState.front_tile_map.tower_data[door_pos].is_in_group("door"):
		var this_pos_as_ad : Vector2 = tile_pos - door_pos
		if this_pos_as_ad == Vector2.UP or this_pos_as_ad == Vector2.DOWN:
			if GameState.front_tile_map.tower_data.has(door_pos + Vector2.LEFT) or GameState.front_tile_map.tower_data.has(door_pos + Vector2.RIGHT):
				return true
		else: #this_pos_as_ad is either Vector2.LEFT or Vector2.RIGHT
			if GameState.front_tile_map.tower_data.has(door_pos + Vector2.UP) or GameState.front_tile_map.tower_data.has(door_pos + Vector2.DOWN):
				return true
		return false
	else:
		return false
		
