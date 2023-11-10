class_name TowerStats
extends Resource

enum types {UTIL, DEFENSE}



@export var name : String = ""
@export var icon : Texture
@export var price : Dictionary
@export_enum("UTIL", "DEFENSE") var type : int = types.UTIL

@export_subgroup("Tile Information")
@export var source_id : int = -1
@export var alternative_tile_id : int = -1


