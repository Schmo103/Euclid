class_name CommodityDisplay
extends HBoxContainer

var commodity : Commodity

var commodity_count := 0:
	set(n):
		$Number.text = str(n)
		commodity_count = int(n)
		
	
	
func _ready():
	$Icon.texture = commodity.icon
	if commodity.name != "":
		name = commodity.name
