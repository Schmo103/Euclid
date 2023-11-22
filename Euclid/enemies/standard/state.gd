class_name State
extends Node

@export var enemy : StandardEnemy

var active : bool = false

func initiate_state() -> void:
	active = true
	
	
func execute_state() -> void:
	pass
	
	
func clean_up() -> void:
	active = false

