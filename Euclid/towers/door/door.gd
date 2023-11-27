class_name Door
extends Wall



var middle_door_ids : Array = [0, 1] #horizontal, vertical

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
