class_name BuildIcon
extends Sprite2D

#color modulate for when build icon cant build at indicated position
@export var faded_modulate : Color = Color(1.0, 1.0, 1.0)
#area2d node for checking for physics bodies
@onready var area = $Area2D

#sets areas rect shape to the size of a tile
func _ready() -> void:
	$Area2D/CollisionShape2D.shape.size = GameState.real_tile_size - Vector2(1, 1)
	
	
#gets the area2ds overlapping bodies
func get_area_overlapping_bodies() -> Array[Node2D]:
	return area.get_overlapping_bodies()
	

#sets whether the modulate is applied
func set_faded(b : bool) -> void:
	if b:
		modulate = faded_modulate
	else:
		modulate = Color(1.0, 1.0, 1.0)
