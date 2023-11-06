class_name BuildingGui
extends Control

@onready var commodity_manager : CommodityDisplayManager = $CommodityManager


func _ready():
	GameState.building_gui = self
	pass

	
func set_commodity_count(commodity : String, count : int) -> void:
	commodity_manager.set_commodity_count(commodity, count)
