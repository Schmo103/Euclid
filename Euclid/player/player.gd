extends RigidBody2D

signal fell

var walk_accel := 1000
var friction := 500
var max_speed := 13000

@export var health_display : Control

@export var health := 10:
	set(h):
		if h <= 0:
			health = 0
			die()
		else:
			health = h
		health_display.value = health
		

var lv : Vector2 = Vector2.ZERO

func _ready() -> void:
	health_display.max_value = health
	

func _process(_delta):
	z_index = ((position - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size).y


func take_damage(dmg : int) -> void:
	health -= dmg
	
	
func die() -> void:
	fell.emit()
	GameState.world.on_player_died()
	queue_free()
	
	
func _integrate_forces(s : PhysicsDirectBodyState2D):
	var step = s.get_step()
	
	#apply movement
	if Input.is_action_pressed("player_right"):
		lv.x += walk_accel
	if Input.is_action_pressed("player_left"):
		lv.x -= walk_accel
	if Input.is_action_pressed("player_up"):
		lv.y -= walk_accel
	if Input.is_action_pressed("player_down"):
		lv.y += walk_accel 
		
	#apply friction to x axis
	var x_sign : int = sign(lv.x)
	var pos_x : float = abs(lv.x)
	pos_x -= friction
	if pos_x < 0:
		pos_x = 0
	lv.x = pos_x * x_sign
	
	#apply friction to y axis
	var y_sign : int = sign(lv.y)
	var pos_y : float = abs(lv.y)
	pos_y -= friction
	if pos_y < 0:
		pos_y = 0
	lv.y = pos_y * y_sign
	
	#apply max_speed
	var dir := lv.normalized()
	var l = lv.length()
	l = clamp(l, -max_speed, max_speed)
	lv = dir * l
	
	#apply slide
	for idx in s.get_contact_count():
		var n = s.get_contact_local_normal(idx)
		if lv.normalized().dot(n) <= 0.4:
			lv = lv.slide(n)


	#set linear velocity
	s.set_linear_velocity(lv * step)
	
	
