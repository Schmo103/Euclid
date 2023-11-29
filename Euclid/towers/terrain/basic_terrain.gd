extends Sprite2D

@export var off_map_effects : OffMapEffects
var available : bool = false

var tile_pos : Vector2


var frames : Array[int] = [0, 4, 5]

func _enter_tree() -> void:
	GameState.back_tile_map.update_map_size.connect(_on_update_map_size)


func _ready() -> void:
	add_to_group("void")
	tile_pos = (global_position - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size
	var a = is_in_radius(tile_pos, GameState.back_tile_map.initial_radius, GameState.world.home_tile_pos)
	safe_set_tile_available(a)
	#choose random terrain option
	randomize()
	var r : int = randi()
	frame = frames[r % frames.size()]
	
	
	
func _on_update_map_size(r : int, center : Vector2) -> void:
	if not available and is_in_radius(tile_pos, r, center):
		safe_set_tile_available(true)
	
	
func safe_set_tile_available(b : bool) -> void:
	available = b
	if off_map_effects != null:
		off_map_effects.set_tile_available(b)
	else:
		push_warning("basic terrain is missing off map effects")
	
	
func is_in_radius(t : Vector2, r : int, center : Vector2i) -> bool:
	var max_x : int = center.x + r
	var min_x : int = center.x - r
	var max_y : int = center.y + r
	var min_y : int = center.y - r
	
	var in_x : bool = t.x <= max_x and t.x >= min_x
	var in_y : bool = t.y <= max_y and t.y >= min_y
	
	return in_x and in_y
