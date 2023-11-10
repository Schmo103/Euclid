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
@export var price : Dictionary

@export_enum("UTIL", "DEFENSE") var type : int = types.UTIL

#information corresponding to the tile that should be placed when this tower is built
@export_subgroup("Tile Information")
@export var source_id : int = -1
@export var alternative_tile_id : int = -1


