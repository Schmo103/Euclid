class_name BuildManager
extends Node2D

@onready var building_gui : BuildingGui = GameState.building_gui

#the amount of commoditys owned by the player
var commodity_counts : Dictionary

#building mode information
var building : bool = false
var tower_to_be_built : TowerStats

#node that displays build location and tests for physics bodys in build area
@export var build_icon : BuildIcon

func _ready() -> void:
	GameState.build_manager = self
	
	#set commodity amounts to each commoditys startiing amount
	for c in GameState.commoditys:
		commodity_counts[c.name] = c.starting_amount
	#updates building_gui
	update_all_commodity_counts()
	update_all_tower_buttons()
	
	building_gui.tower_pressed.connect(_on_tower_pressed)
	
	
#if building, positions the build_icon
func _process(_delta) -> void:
	if building:
		var mouse_pos = get_mouse_position()
		build_icon.position = (mouse_pos - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) + GameState.real_tile_size / 2
		build_icon.set_faded(!can_build())
			
			
#handles input
func _unhandled_input(event):
	if event is InputEventMouseButton and building:
		#builds tower on left click
		if event.button_index == MOUSE_BUTTON_LEFT:
			if can_build():
				build_tower(tower_to_be_built, get_local_mouse_position())
				pay_price(tower_to_be_built.price)
				if tower_to_be_built.auto_exit_build_mode or !can_pay(tower_to_be_built.price):
					set_build_mode(false)
		#exits build mode on right click
		elif event.button_index == MOUSE_BUTTON_RIGHT:
				set_build_mode(false)
	#code that doesnt work but I might fix up if we have time for drag building
#	if event is InputEventMouseMotion and building and tower_to_be_built.drag_building_enabled:
#		if Input.is_action_pressed("left_click"):
#			if can_build():
#				build_tower(tower_to_be_built, get_mouse_position())
#				pay_price(tower_to_be_built.price)
#				if tower_to_be_built.auto_exit_build_mode or !can_pay(tower_to_be_built.price):
#					set_build_mode(false)
	
	
#function called when a tower button is pressed
func _on_tower_pressed(tower : TowerStats) -> void:
	tower_to_be_built = tower
	if can_pay(tower_to_be_built.price):
		build_icon.texture = tower_to_be_built.build_icon
		if tower_to_be_built.range_stats == null:
			build_icon.range_display.set_range_visible(false)
		else:
			build_icon.range_display.set_range_visible(true)
			build_icon.set_range_stats(tower_to_be_built.range_stats)
		set_build_mode(true)
		
		
#sets build mode
func set_build_mode(b : bool) -> void:
		building = b
		build_icon.visible = b
		

#builds tower at position
func build_tower(tower : TowerStats, tower_pos : Vector2) -> void:
	var cp : Vector2 = Vector2(pos_to_tile(tower_pos))
	GameState.front_tile_map.build_tower(tower.scene, cp)
	
	
#pays price
#price should be in price format (see doc/towers.txt)
func pay_price(price : Dictionary) -> void:
	for commodity in price:
		add_commodities(commodity, price[commodity] * -1)
	
	

#function to add or subtract commodity amount from commodity count (count can be a negative int)
func add_commodities(commodity : String, count : int) -> void: 
	if commodity_counts.has(commodity):
		commodity_counts[commodity] += count
		if commodity_counts[commodity] < 0:
			commodity_counts[commodity] = 0
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
		

#updates the enabled status of the tower buttons
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
	
	
#checks if we can build at build_icons current location
func can_build() -> bool:
	var bodies : Array = build_icon.get_area_overlapping_bodies()
	if tower_to_be_built.use_custom_can_build:
		build_icon.set_message(tower_to_be_built.custom_can_build_message)
		return tower_to_be_built.can_build(bodies, pos_to_tile(build_icon.position))
#		return tower_to_be_built.can_build(bodies, pos_to_tile(get_mouse_position())
	else:
		if build_icon.get_area_overlapping_entitys().size() > 0:
			build_icon.set_message("Towers can't be built on top of entities")
			for e in build_icon.get_area_overlapping_entitys():
				if e.is_in_group("void"):
					build_icon.set_message("Towers can't be built off of the map")
		elif build_icon.get_are_overlapping_towers().size() > 0:
			build_icon.set_message("Towers can't be built adjacent to each other")
			for t in build_icon.get_are_overlapping_towers():
				if t.is_in_group("tower") and t.tile_pos == pos_to_tile(build_icon.position):
					build_icon.set_message("Towers can't be built on top of each other")
		else:
			build_icon.set_message("")
		return bodies.size() == 0
	

#updates the amounts in the commodity display menu
func update_all_commodity_counts() -> void:
	for commodity in commodity_counts:
		building_gui.set_commodity_count(commodity, commodity_counts[commodity])
		
		
#utility funtion that returns the tile position of a global position
func pos_to_tile(p : Vector2) -> Vector2:
	return (p - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size
	
	
#gets real in world mouse position
func get_mouse_position() -> Vector2:
	var cam = get_viewport().get_camera_2d()
	return get_viewport().get_mouse_position() + cam.get_screen_center_position() - Vector2(DisplayServer.window_get_size() / 2)
		
		
		
