class_name Tower
extends Node2D

enum tower_types {UTIL, DEFENSE}

@export_enum("UTIL", "DEFENSE") var type : int = tower_types.UTIL

@export var health := 10:
	set(h):
		if h <= 0:
			health = 0
			fall()
		else:
			health = h


func take_damage(dmg : int) -> void:
	health -= dmg
	
	
#destroy the tower
func fall() -> void:
	print("tower is destroyed")
