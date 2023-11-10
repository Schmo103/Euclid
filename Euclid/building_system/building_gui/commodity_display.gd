class_name CommodityDisplay
extends HBoxContainer

var commodity : Commodity

#when commodity_count is set, it automatically changes the labels text
var commodity_count := 0:
	set(n):
		$Number.text = str(n)
		commodity_count = int(n)
		
	
#sets the icon of the commodity
func _ready():
	$Icon.texture = commodity.icon
	if commodity.name != "":
		name = commodity.name
