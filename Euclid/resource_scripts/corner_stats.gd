class_name CornerStats
extends TowerStats

func can_build(objects : Array, tile_pos : Vector2) -> bool:
	for ob in objects:
		if !ob.is_in_group("wall"):
			return false
	return true
	
	
func build(tile_pos : Vector2) -> void:
	pass
