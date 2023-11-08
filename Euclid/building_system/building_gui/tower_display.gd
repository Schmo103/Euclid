extends Button


@onready var building_gui : BuildingGui = GameState.building_gui

var tower_stats : TowerStats 


func _ready():
	if tower_stats != null:
		icon = tower_stats.icon
		name = tower_stats.name


func _on_pressed():
	building_gui.tower_button_pressed(tower_stats)
	
	
func set_enabled(enabled : bool):
	disabled = !enabled
	
