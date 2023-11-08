class_name BuildManager
extends Node

@onready var building_gui : BuildingGui = GameState.building_gui

var commodity_counts : Dictionary

func _ready() -> void:
	for c in GameState.commoditys:
		commodity_counts[c.name] = c.starting_amount
	update_all_commodity_counts()
	update_all_tower_buttons()
	
	building_gui.tower_pressed.connect(_on_tower_pressed)
	
	
func _on_tower_pressed(tower : TowerStats):
	if can_pay(tower.price):
		print("Can pay for " + tower.name)
		

func build_tower(tower : TowerStats) -> void:
	pass
	

#function to add or subtract commodity amount from commodity count (count can be a negative int)
func add_commodities(commodity : String, count : int) -> void: 
	if commodity_counts.has(commodity):
		commodity_counts[commodity] = count
		update_all_commodity_counts()
		update_all_tower_buttons()
	else:
		push_error("Commodity: " + commodity + " not accounted for in build manager")
		
		
#a safe way to check commodity count
func get_commodity_count(commodity : String) -> int: 
	if commodity_counts.has(commodity):
		return commodity_counts[commodity]
	else:
		return 0
		

func update_all_tower_buttons() -> void:
	for tower in GameState.towers:
		building_gui.set_tower_button_enabled(tower.name, can_pay(tower.price))
		
		
#checks if we have commoditys to pay price
#price should be in tower price format (see doc/towers.txt)
func can_pay(price : Dictionary) -> bool: 
	for commodity in price:
		if price[commodity] > get_commodity_count(commodity):
			return false
	return true
	

func update_all_commodity_counts() -> void:
	for commodity in commodity_counts:
		building_gui.set_commodity_count(commodity, commodity_counts[commodity])
		
		
		
