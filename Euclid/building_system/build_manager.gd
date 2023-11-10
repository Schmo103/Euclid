class_name BuildManager
extends Node

@onready var building_gui : BuildingGui = GameState.building_gui

var commodity_counts : Dictionary

var building : bool = false
var tower_to_be_built : TowerStats


@export var build_icon : BuildIcon

func _ready() -> void:
	GameState.build_manager = self
	
	for c in GameState.commoditys:
		commodity_counts[c.name] = c.starting_amount
	update_all_commodity_counts()
	update_all_tower_buttons()
	
	building_gui.tower_pressed.connect(_on_tower_pressed)
	
	
func _process(_delta) -> void:
	if building:
		var mouse_pos = get_mouse_position()
		build_icon.position = (mouse_pos - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) + GameState.real_tile_size / 2
		if can_build():
			build_icon.set_faded(false)
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				build_tower(tower_to_be_built, mouse_pos)
				pay_price(tower_to_be_built.price)
				set_build_mode(false)
		else:
			build_icon.set_faded(true)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			set_build_mode(false)
	
	
func _on_tower_pressed(tower : TowerStats):
	tower_to_be_built = tower
	if can_pay(tower_to_be_built.price):
		set_build_mode(true)
		build_icon.texture = tower_to_be_built.icon
		
		
func set_build_mode(b : bool) -> void:
		building = b
		build_icon.visible = b
		

func build_tower(tower : TowerStats, cell_pos : Vector2) -> void:
	var cp : Vector2i = Vector2i(pos_to_tile(cell_pos))
	GameState.solid_tile_map.set_cell(0, cp, tower.source_id, Vector2i.ZERO, tower.alternative_tile_id)
	
	
func pay_price(price : Dictionary) -> void:
	for commodity in price:
		add_commodities(commodity, price[commodity] * -1)
	
	

#function to add or subtract commodity amount from commodity count (count can be a negative int)
func add_commodities(commodity : String, count : int) -> void: 
	if commodity_counts.has(commodity):
		commodity_counts[commodity] += count
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
	
	
func can_build() -> bool:
	return build_icon.get_area_overlapping_bodies().size() == 0
	

func update_all_commodity_counts() -> void:
	for commodity in commodity_counts:
		building_gui.set_commodity_count(commodity, commodity_counts[commodity])
		
		
func pos_to_tile(p : Vector2) -> Vector2:
	return (p - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size
	
	
func get_mouse_position() -> Vector2:
	var cam = get_viewport().get_camera_2d()
	return get_viewport().get_mouse_position() + cam.get_screen_center_position() - Vector2(DisplayServer.window_get_size() / 2)
		
		
		
