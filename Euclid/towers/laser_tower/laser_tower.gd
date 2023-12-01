class_name LaserTower
extends Tower

@export var enemy_detector : Area2D
@export var laser_fire_postion : Node2D
@export var laser_line : Line2D
@export var laser_ray_cast : RayCast2D

@export var damage : int = 45

@export var load_duration : float = 2
var loaded : bool = false

@export var fire_duration : float = 0.5
var firing : bool = false



var target : Node2D = null

func _ready() -> void:
	super()
	$LoadTimer.wait_time = load_duration
	$LoadTimer.start()
	$FireTimer.wait_time = fire_duration
	laser_line.visible = false
	
	
func _process(_delta) -> void:
	if can_fire():
		set_target()
		if target != null:
			fire_laser()
	if firing:
		if is_instance_valid(target):
			update_laser_ray_cast()
			draw_laser()
		else:
			quit_firing()
		

#activates laser and related stuff
func fire_laser() -> void:
	loaded = false
	firing = true
	target.hit_by_laser(damage)
	$FireTimer.start()
	update_laser_ray_cast()
	laser_ray_cast.force_raycast_update()
	
	
#draws the laser
func draw_laser() -> void:
	laser_line.visible = true
	laser_line.clear_points()
	laser_line.add_point(laser_fire_postion.position)
#	laser_line.add_point(to_local(target.global_position))
	laser_line.add_point(to_local(laser_ray_cast.get_collision_point()))


#sets the target of the tower as the closeset enemy in range
func set_target() -> void:
	var bodies = enemy_detector.get_overlapping_bodies()
	if is_instance_valid(target) and bodies.has(target):
		return
	else:
		target = null
		var d : float = -1
		for b in bodies:
			if b.is_in_group("enemy"):
				var new_d : float
				new_d = to_global(position).distance_to(b.global_position)
				if d == -1 or new_d < d:
					target = b
					d = new_d
		return
		
		
func update_laser_ray_cast() -> void:
	laser_ray_cast.target_position = to_local(target.global_position)
	
	
func quit_firing() -> void:
	firing = false
	laser_line.visible = false


func can_fire() -> bool:
	return loaded and not firing
	

func _on_load_timer_timeout():
	loaded = true


func _on_fire_timer_timeout():
	quit_firing()
	$LoadTimer.start()
