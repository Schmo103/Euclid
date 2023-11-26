class_name Enemy
extends RigidBody2D

@export var health : int = 100:
	set(h):
		health = set_health(h)
		
@export var speed : int

func _ready() -> void:
	add_to_group("entity")
	add_to_group("enemy")
	

func take_damage(dmg : int) -> void:
	health -= dmg
	if health <= 0:
		die()
		
		
func die() -> void:
	print("Enemy died")
	queue_free()


func set_health(h : int) -> int:
#	health = h
	if h < 0:
		return 0
	else:
		return h
