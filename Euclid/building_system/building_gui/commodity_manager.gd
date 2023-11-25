class_name CommodityDisplayManager
extends HBoxContainer

var commocity_display_scene : PackedScene = preload("res://building_system/building_gui/commodity_display.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	build_commodity_menu()
	
	
#adds a commodity display for every commodity in GameState
func build_commodity_menu():
	for commodity in GameState.commoditys:
		add_commodity_display(commodity)
		
		
#takes a Commodity resource and adds a commodity display
func add_commodity_display(c : Commodity) -> void:
	var d := commocity_display_scene.instantiate()
	d.commodity = c
	add_child(d)
	
	
#sets the amount on a given commodity dispay
func set_commodity_count(commodity : String, count : int) -> void:
	if has_node(commodity):
		get_node(commodity).commodity_count = count
	else:
		push_error("Commodity \"" + commodity + "\" not in menu")
		
		
func set_commodities_to_price(price : Dictionary, hide_empty_commodities : bool = true):
	for c in get_children():
		if price.has(c.name):
			set_commodity_count(c.name, price[c.name])
		else:
			set_commodity_count(c.name, 0)
			c.visible = not hide_empty_commodities
	
	
