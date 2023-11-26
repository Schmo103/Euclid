class_name MissileTower
extends Tower

@export var missie_launch_point : Node2D
@export var enemy_detector : Area2D
var missile_scene : PackedScene = preload("res://towers/missile_tower/missile.tscn")

@export var damage : int = 10

@export var load_time : float = 1
var loaded : bool = false

@export var missile_speed : float = 300
var target : Node2D = null


func _ready() -> void:
	super()
	$LoadTimer.wait_time = load_time
	$LoadTimer.start()


func _process(_delta) -> void:
	if can_fire():
		set_target()
		if target != null:
			fire_missile(target, missile_speed, damage)
	

func fire_missile(t : Node2D, speed : float, d : int) -> void:
	var m = missile_scene.instantiate()
	m.position = missie_launch_point.global_position
	m.target = t
	m.speed = speed
	m.damage = d
	GameState.missiles.add_missile(m)
	loaded = false
	$LoadTimer.start()


func set_target() -> void:
	var bodies = enemy_detector.get_overlapping_bodies()
	if is_instance_valid(target) and bodies.has(target):
		return
	else:
		target = null
		for b in bodies:
			if b.is_in_group("enemy"):
				target = b
				return
	
	
#returns true if tower is able to fire, regardless of whether or not a target is available
func can_fire() -> bool:
	return loaded
	
	
func _on_load_timer_timeout():
	loaded = true
