class_name ShockTower
extends Tower

@export var enemy_detector : Area2D

@export var load_time : float = 4
@export var fire_time : float = 3

var loaded : bool = false
var firing : bool = false

@export var damage : int = 5

func _ready() -> void:
	super()
	$LoadTimer.wait_time = load_time
	$FireTimer.wait_time = fire_time
	$LoadTimer.start()
	
	
func _process(_delta) -> void:
	if can_fire() and has_target():
		fire()
	
	
func can_fire() -> bool:
	return loaded and not firing
	
	
func has_target() -> bool:
	for b in enemy_detector.get_overlapping_bodies():
		if b.is_in_group("enemy"):
			return true
	return false


func fire() -> void:
	loaded = false
	firing = true
	for b in enemy_detector.get_overlapping_bodies():
		if b.is_in_group("enemy"):
			b.hit_by_shock(damage, fire_time)
	$FireTimer.start()
	$AnimationPlayer.play("shock",-1,2.0)


func _on_load_timer_timeout():
	loaded = true


func _on_fire_timer_timeout():
	firing = false
	$LoadTimer.start()
