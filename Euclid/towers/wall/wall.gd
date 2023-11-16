class_name Wall
extends Tower

enum edges {MIDDLE, LEFT, RIGHT, SOLO}

#higher level representation of adjacent wall tiles
var horizontal : bool = true
var edge : int = edges.MIDDLE

#ids in spritesheet of correc sprites
var middle_ids := [1, 12]
var left_ids := [0, 18] #left and down
var right_ids := [2, 6] #right and up
var solo_id := [7, 7]

var top_corner_ids := [20, 21] #left and right
var bottom_corner_ids := [26, 27] #left and right

var ids : Array = [middle_ids, left_ids, right_ids, solo_id]

#dictionary representing adjacent wall towers
var adjacents : Dictionary = {Vector2.UP: false, Vector2.DOWN: false, Vector2.LEFT: false, Vector2.RIGHT: false}

func _ready() -> void:
	super()
	tower_stats.wall_destroyed.connect(_on_wall_destroyed)
	tower_stats.new_wall_built.connect(_on_new_wall_placed)
	tower_stats.new_wall_built.emit(tile_pos)
	
	
	
func update_image() -> void:
	update_adjacent_walls()
	if adjacents[Vector2.RIGHT] or adjacents[Vector2.LEFT]:
		horizontal = true
		if adjacents[Vector2.RIGHT] and adjacents[Vector2.LEFT]:
			edge = edges.MIDDLE
			set_image(middle_ids[0])
		elif adjacents[Vector2.RIGHT]:
			if adjacents[Vector2.UP]:
				set_image(bottom_corner_ids[0])
			elif adjacents[Vector2.DOWN]:
				set_image(top_corner_ids[0])
			else:
				edge = edges.LEFT
				set_image(left_ids[0])
		else: #Vector2.LEFT
			if adjacents[Vector2.UP]:
				set_image(bottom_corner_ids[1])
			elif adjacents[Vector2.DOWN]:
				set_image(top_corner_ids[1])
			else:
				edge = edges.RIGHT
				set_image(right_ids[0])
	elif adjacents[Vector2.UP] or adjacents[Vector2.DOWN]:
		horizontal = false
		if adjacents[Vector2.UP] and adjacents[Vector2.DOWN]:
			edge = edges.MIDDLE
			set_image(middle_ids[1])
		elif adjacents[Vector2.UP]:
			edge = edges.LEFT
			set_image(left_ids[1])
		else: #Vector2.LEFT
			edge = edges.RIGHT
			set_image(right_ids[1])
	else:
		edge = edges.SOLO
		set_image(solo_id[0])
		
	
func _on_new_wall_placed(wall_tile_pos : Vector2) -> void:
	if tile_pos.distance_to(wall_tile_pos) <= 1:
		update_image()
		
		
func _on_wall_destroyed(wall_tile_pos : Vector2) -> void:
	if tile_pos.distance_to(wall_tile_pos) <= 1:
		fall()
		
		
func update_adjacent_walls() -> void:
	for offset in adjacents:
		adjacents[offset] = (GameState.front_tile_map.get_cell_source_id(0, tile_pos + offset) != -1)
		
		
func set_image(id : int) -> void:
	$Sprite2D.frame = id

