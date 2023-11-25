class_name TowerDisplayManager
extends GridContainer

var tower_dispay_scene = preload("res://building_system/building_gui/tower_display.tscn")


func _ready():
	build_tower_menu()
	get_child(0).grab_focus()
	(get_child(0) as Control).focus_neighbor_left = get_child(-1).get_path()
	(get_child(-1) as Control).focus_neighbor_right = get_child(0).get_path()
#	for c in get_children():
#		c.update_size_dependant_properties()
		
	
#adds a tower button for every tower in GameState.towers
func build_tower_menu():
	for tower in GameState.towers:
		var t := tower_dispay_scene.instantiate()
		t.tower_stats = tower
		add_child(t)
		
