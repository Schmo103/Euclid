class_name GameOverDisplay
extends Control

@export var game_over_display_duration : float = 3

func _ready() -> void:
	visible = false
	$GameDisplayTimer.wait_time = game_over_display_duration
	GameState.ended_game.connect(_on_game_over)

func _on_game_over() -> void:
	visible = true
#	$GameDisplayTimer.start()


func _on_game_display_timer_timeout():
	GameState.world.exit_to_menu()


func _on_button_pressed():
	GameState.world.exit_to_menu()
