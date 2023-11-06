class_name Commodity
extends Resource

@export var image : Texture
@export var name : String = ""

func _init(i : Texture = null, n : String = ""):
	image = i
	name = n
