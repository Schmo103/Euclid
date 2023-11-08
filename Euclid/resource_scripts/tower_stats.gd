class_name TowerStats
extends Resource

enum types {UTIL, DEFENSE}



@export var name : String = ""
@export var icon : Texture

@export var scene : PackedScene

@export var price : Dictionary
@export var size : Vector2 = Vector2(32, 32)
@export_enum("UTIL", "DEFENSE") var type : int = types.UTIL


