class_name Enemy
extends RigidBody2D

@export var health : int = 10:
	set(h):
		set_health(h)
		
@export var speed : int


func take_damage(dmg : int) -> void:
	health -= dmg
	if health <= 0:
		die()
		
		
func die() -> void:
	print("Enemy died")
	queue_free()


func set_health(h : int) -> void:
	health = h
	if health < 0:
		health = 0
