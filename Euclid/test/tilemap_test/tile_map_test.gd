extends TileMap

#WHEN DONE::
#UNCOMMENT TOWER.GD LINE 30
#base_tower.gd lines 6 and 7
#tower.gd line 42 46


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.front_tile_map = self
	GameState.back_tile_map = self
	set_cell(0, Vector2(0, 0), 0, Vector2.ZERO, 1)
#	get_node("Wall").queue_free()
	set_cell(0, Vector2(0, 0))
#	set_cell(0, Vector2(0, 0), 0, Vector2.ZERO, 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func set_tile_navigatable(p : Vector2, b : bool) -> void:
	pass
