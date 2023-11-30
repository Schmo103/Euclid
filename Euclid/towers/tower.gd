class_name Tower
extends Node2D

signal fell

const TILE_SIZE = 32.0

enum tower_types {UTIL, DEFENSE, TERRAIN}

@export_enum("UTIL", "DEFENSE", "TERRAIN")
var type : int = tower_types.UTIL

@export var health := 100:
	set(h):
		if h <= 0:
			health = 0
			fall()
		else:
			health = h
		if health_display != null:
			health_display.value = health
			
var tile_pos : Vector2

@export var health_display : Control

@export var tower_menu : TowerMenu

@export var range_display : RangeDisplay



func _ready():
	#make tile not navigatable
	tile_pos = (global_position - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size
	GameState.back_tile_map.set_tile_navigatable(tile_pos, false)
	@warning_ignore("narrowing_conversion")
	z_index = tile_pos.y
	add_to_group("tower")
	
	if health_display != null:
		health_display.max_value = health
		
	GameState.front_tile_map.register_tower(tile_pos, self)
	
	if tower_menu != null:
		tower_menu.sell_clicked.connect(_on_sell_clicked)
	else:
#		push_error("Tower: " + str(self) + " at pos: " + str(tile_pos) + "has no menu assigned") 
		pass
	safe_set_range_visible(false)
	
	
func _exit_tree():
	#make tile navigatable when leaving scene tree
	#note: right now this will happen even if the tile originally wasnt navigatable
	GameState.back_tile_map.set_tile_navigatable(tile_pos, true)
	GameState.front_tile_map.remove_tower(tile_pos)

	

func take_damage(dmg : int) -> void:
	health -= dmg
	
	
#destroy the tower
func fall() -> void:
	fell.emit()
	GameState.front_tile_map.remove_tower(tile_pos)
	queue_free()
	

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var mp = get_local_mouse_position()
			if max(abs(mp.x), abs(mp.y)) < TILE_SIZE / 2.0:
#				print("tower " + str(self) + "has seriously been clicked at pos: " + str(tile_pos))
				set_tower_specific_info_visible(true)
			else:
				set_tower_specific_info_visible(false)
				
				
func sell() -> void:
	fall()
	
	
#shows and hides things when tower is clicked
func set_tower_specific_info_visible(b : bool) -> void:
	safe_set_tower_menu_visible(b)
	safe_set_range_visible(b)
	
	
func safe_set_tower_menu_visible(b : bool) -> void:
	if tower_menu != null:
		tower_menu.visible = b
		
		
func safe_set_range_visible(b : bool) -> void:
	if range_display != null:
		range_display.set_range_visible(b)
	
	
func safe_get_tower_menu_visible() -> bool:
	if tower_menu != null:
		return tower_menu.visible
	else:
		return false
		
		
func _on_sell_clicked() -> void:
	sell()
	
	
func get_price() -> void:
	pass
