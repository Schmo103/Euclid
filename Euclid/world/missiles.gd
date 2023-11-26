class_name MissileManager
extends Node2D

func _enter_tree() -> void:
	GameState.missiles = self
	
	
func add_missile(m : Node) -> void:
	add_child(m)
