class_name TowerDisplay
extends Button

@export var commodity_display_manager : CommodityDisplayManager 
@onready var building_gui : BuildingGui = GameState.building_gui

var commodity_display_manager_scene : PackedScene = preload("res://building_system/building_gui/commodity_manager.tscn")

var tower_stats : TowerStats 

#sets up icon and name
func _ready() -> void:
	if tower_stats != null:
		icon = tower_stats.menu_icon
		name = tower_stats.name
		$NameLabel.text = tower_stats.name
	set_up_price_display()
	commodity_display_manager.visible = false
	get_parent().ready.connect(_on_parent_ready)
	$NameLabel.visible = false
	

#tells building_gui that it was pressed
func _on_pressed() -> void:
	building_gui.tower_button_pressed(tower_stats)
	
	
#sets whether button is enabled
func set_enabled(enabled : bool) -> void:
	disabled = !enabled
	
	
func set_price_visible(b : bool) -> void:
	commodity_display_manager.visible = b
	
	
func set_name_visible(b : bool) -> void:
	$NameLabel.visible = b
	
	
func set_up_price_display() -> void:
	commodity_display_manager.set_commodities_to_price(tower_stats.price)
			
			
func update_size_dependant_properties() -> void:
	commodity_display_manager.position.x = -commodity_display_manager.size.x / 2
	$NameLabel.position.x = -1 * $NameLabel.size.x / 2
	
	
func _on_parent_ready() -> void:
	update_size_dependant_properties()
		
	
func _on_focus_entered():
	set_price_visible(true)
	set_name_visible(true)


func _on_focus_exited():
	set_price_visible(false)
	set_name_visible(false)
