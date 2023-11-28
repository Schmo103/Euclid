class_name Door
extends Wall



var middle_door_ids : Array = [3, 7] #horizontal, vertical
var solo_door_id : int = 3

func _ready() -> void:
	super()
	add_to_group("door")

func update_image() -> void:
	update_adjacent_walls()
	if adjacents[Vector2.RIGHT] or adjacents[Vector2.LEFT]:
		horizontal = true
		set_image(middle_door_ids[0])
	elif adjacents[Vector2.UP] or adjacents[Vector2.DOWN]:
		horizontal = false
		set_image(middle_door_ids[1])
	else:
		set_image(solo_door_id)
