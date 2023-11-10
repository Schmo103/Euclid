extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.solid_tile_map = self
