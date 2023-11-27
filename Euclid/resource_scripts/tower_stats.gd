class_name TowerStats
extends Resource

#different tower type options
enum types {UTIL, DEFENSE}

@export var name : String = ""

#icon displayed in tower menu
@export var menu_icon : Texture
#icon displayed on map when trying to build
@export var build_icon : Texture

#price should be in price format (see doc/toweres.txt)
@export var price : Dictionary = {"iron": 1}

@export_enum("UTIL", "DEFENSE") var type : int = types.UTIL

#information corresponding to the tile that should be placed when this tower is built
@export_subgroup("Tile Information")
@export var scene : PackedScene
@export var source_id : int = -1
@export var alternative_tile_id : int = -1

@export_subgroup("Custom Building")
@export var auto_exit_build_mode : bool = true
@export var can_replace_walls : bool = false
#@export var drag_building_enabled : bool = false
@export var use_custom_can_build: bool = false
@export var use_custom_build : bool = false

var custom_can_build_message : String = ""

func can_build(_objects : Array, _tile_pos : Vector2) -> bool:
	return true
	
	
func build(_tile_pos : Vector2) -> void:
	pass


