class_name OffMapEffects
extends Node2D

@export var off_map_image : Sprite2D
@export var off_map_body : StaticBody2D


func set_tile_available(b : bool) -> void:
	if off_map_image != null and off_map_body != null:
		off_map_image.visible = not b
		#set collision shape to enabled or disabled
		if b:
			off_map_body.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			off_map_body.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		push_warning("off map effects is missing either an off map image or an off map body")
