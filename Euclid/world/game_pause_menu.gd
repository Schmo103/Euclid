class_name GamePauseMenu
extends Control

@export var play_texture : Texture
@export var pause_texture : Texture
@export var icon_modulate : Color = Color("white", 1.0)


var paused : bool = false

func _ready() -> void:
	$Button.icon = pause_texture
	$Button.modulate = icon_modulate
	$GamePausedDisplay.visible = false
	GameState.ended_game.connect(_on_game_over)


func set_paused(b) -> void:
	paused = b
	get_tree().set_pause(paused)
	if paused:
		$Button.icon = play_texture
	else:
		$Button.icon = pause_texture
	$GamePausedDisplay.visible = paused


func _on_button_pressed():
	set_paused(not paused)
	
	
func _on_game_over() -> void:
	set_paused(true)
	$GamePausedDisplay.visible = false
	process_mode = Node.PROCESS_MODE_DISABLED


