class_name BuildingGui
extends Control

signal tower_pressed(tower_stats : TowerStats)

@onready var commodity_manager : CommodityDisplayManager = $CommodityManager
@onready var tower_manager : TowerDisplayManager = $TowerManager


func _enter_tree() -> void:
	GameState.building_gui = self
	
	
#exposes control of the commodity menu
func set_commodity_count(commodity : String, count : int) -> void:
	commodity_manager.set_commodity_count(commodity, count)
	
	
#exposes the tower buttons enabled status
func set_tower_button_enabled(tower_name : String, enabled : bool) -> void:
	if tower_manager.has_node(tower_name):
		tower_manager.get_node(tower_name).set_enabled(enabled)
	else:
		push_error("Tower: " + tower_name + " not in menu")


#function called by tower buttons when they're pressed
func tower_button_pressed(tower_stats : TowerStats) -> void:
	tower_pressed.emit(tower_stats)
