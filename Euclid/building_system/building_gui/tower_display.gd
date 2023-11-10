extends Button


@onready var building_gui : BuildingGui = GameState.building_gui

var tower_stats : TowerStats 

#sets up icon and name
func _ready():
	if tower_stats != null:
		icon = tower_stats.menu_icon
		name = tower_stats.name


#tells building_gui that it was pressed
func _on_pressed():
	building_gui.tower_button_pressed(tower_stats)
	
	
#sets whether button is enabled
func set_enabled(enabled : bool):
	disabled = !enabled
	
