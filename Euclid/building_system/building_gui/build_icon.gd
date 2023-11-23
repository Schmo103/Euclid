class_name BuildIcon
extends Sprite2D

#color modulate for when build icon cant build at indicated position
@export var faded_modulate : Color = Color(1.0, 1.0, 1.0)
#area2d node for checking for physics bodies
@onready var tower_detector : Area2D = $TowerDetector
@onready var mob_detector : Area2D = $MobDetector
@onready var message : Label = $Message

#sets areas rect shape to the size of a tile
func _ready() -> void:
	$TowerDetector/CollisionShape2D.shape.size = GameState.real_tile_size * 3 - Vector2(1, 1)
	$MobDetector/CollisionShape2D.shape.size = GameState.real_tile_size - Vector2(1, 1)
	
	
#gets the area2ds overlapping bodies
func get_area_overlapping_bodies() -> Array[Node2D]:
	var bodies : Array = tower_detector.get_overlapping_bodies()
	bodies.append_array(mob_detector.get_overlapping_bodies())
	return bodies
	
	
func get_area_overlapping_entitys() -> Array[Node2D]:
	return mob_detector.get_overlapping_bodies()
	
	
func get_are_overlapping_towers() -> Array[Node2D]:
	return tower_detector.get_overlapping_bodies()
	
	
func set_message(m : String) -> void:
	message.text = m
	

#sets whether the modulate is applied
func set_faded(b : bool) -> void:
	if b:
		self_modulate = faded_modulate
	else:
		self_modulate = Color(1.0, 1.0, 1.0)


