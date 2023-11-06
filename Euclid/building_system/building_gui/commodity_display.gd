class_name CommodityDisplay
extends HBoxContainer

var icon : Texture
var commodity_name : String

var commodity_count := 0:
	set(n):
		$Number.text = str(n)
		commodity_count = int(n)
		

func _init(t : Texture = null, s : String = ""):
	icon = t
	commodity_name = s
	
	
func _ready():
	$Icon.texture = icon
	if commodity_name != "":
		name = commodity_name
