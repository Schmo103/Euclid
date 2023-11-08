class_name TowerDisplayManager
extends GridContainer

var tower_dispay_scene = preload("res://building_system/building_gui/tower_display.tscn")


func _ready():
	build_tower_menu()
	
	
func build_tower_menu():
	for tower in GameState.towers:
		var t := tower_dispay_scene.instantiate()
		t.tower_stats = tower
		add_child(t)
		
