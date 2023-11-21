class_name World
extends Node2D

@export var home_tile_pos : Vector2

func _enter_tree() -> void:
	GameState.world = self
	
func _ready() -> void:
	GameState.set_up_commodities.emit()
