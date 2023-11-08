class_name Commodity
extends Resource

@export var name : String = ""
@export var icon : Texture
@export var starting_amount := 0


func _init(i : Texture = null, n : String = "", s_a : int = 0):
	icon = i
	name = n
	starting_amount = s_a
