class_name BaseTower
extends Tower

func _ready() -> void:
	super()
	GameState.world.player_died.connect(_on_player_died)
	GameState.world.player_spawned.connect(_on_player_spawned)
	
	
func fall() -> void:
	super()
	GameState.on_base_fell()
	
	
func _on_player_died() -> void:
	$Camera2D.enabled = true
	
	
func _on_player_spawned() -> void:
	$Camera2D.enabled = false
	
	



