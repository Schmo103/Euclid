class_name WallStats
extends TowerStats

signal new_wall_built(tile_pos : Vector2)
signal wall_destroyed(tile_pos : Vector2)

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
				return false
			elif possible_corners.has(v):
				corners.append(v)
			elif possible_adjacent_positions.has(v):
				adjacent_positions.append(v)
		else:
			return false
	if adjacent_positions.size() > 2:
		return false
	for ad in adjacent_positions:
		if !check_pos_has_only_one_adjacent(tile_pos + ad):
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
		if GameState.front_tile_map.get_cell_source_id(0, a + pos) != -1:
			if one:
				return false
			else:
				one = true
	return true
		