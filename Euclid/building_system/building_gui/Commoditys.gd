class_name CommodityDisplayManager
extends HBoxContainer

var commocity_display_scene : PackedScene = preload("res://building_system/building_gui/commodity_display.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for commodity in GameState.commoditys:
		add_commodity_display(commodity)
		
		
func add_commodity_display(c : Commodity) -> void:
	var d := commocity_display_scene.instantiate()
	d.icon = c.image
	d.commodity_name = c.name
	add_child(d)
	
	
func set_commodity_count(commodity : String, count : int) -> void:
	if has_node(commodity):
		get_node(commodity).commodity_count = count
	else:
		push_error("Commodity \"" + commodity + "\" not in menu")
	
