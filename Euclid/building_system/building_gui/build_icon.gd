class_name BuildIcon
extends Sprite2D

@export var faded_modulate : Color = Color(1.0, 1.0, 1.0)
@onready var area = $Area2D

func _ready() -> void:
	$Area2D/CollisionShape2D.shape.size = GameState.real_tile_size - Vector2(1, 1)
	
	
func get_area_overlapping_bodies() -> Array[Node2D]:
	return area.get_overlapping_bodies()
	

func set_faded(b : bool) -> void:
	if b:
		modulate = faded_modulate
	else:
		modulate = Color(1.0, 1.0, 1.0)
