class_name Player
extends RigidBody2D

signal fell

@onready var visuals = $left_right_visuals
@onready var norm_scale = $left_right_visuals.scale
@onready var a_player = $left_right_visuals/AnimationPlayer

var walk_accel := 10000
var friction := 7000
var max_speed := 16000
var walking = false
var attacking : bool = false

@export var damage : int = 40
@export var attack_duration : float = 0.5
@onready var attack_timer : Timer = $AttackTimer
@onready var enemy_detector : Area2D = $EnemyDetector

var enemy_detector_positions : Dictionary = {Vector2.UP : Vector2(0, -45), 
											Vector2.DOWN : Vector2(0, 45), 
											Vector2.LEFT : Vector2(-45, 0), 
											Vector2.RIGHT : Vector2(45, 0)}

var player_direction : Vector2 = Vector2.RIGHT
var already_hit_bodies : Array[Node2D] = []

@export var health_display : Control

@export var health := 100:
	set(h):
		if h <= 0:
			health = 0
			die()
		else:
			health = h
		health_display.value = health
		

var lv : Vector2 = Vector2.ZERO

func _ready() -> void:
	GameState.player_dead = false
	health_display.max_value = health
	attack_timer.wait_time = attack_duration
	

func _process(_delta):
	z_index = ((position - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size).y
	if attacking:
		for body in enemy_detector.get_overlapping_bodies():
			if body.is_in_group("enemy") and not already_hit_bodies.has(body):
				body = body as Enemy
				body.hit_by_player(damage)
				already_hit_bodies.append(body)


func take_damage(dmg : int) -> void:
	health -= dmg
	
	
func die() -> void:
	fell.emit()
	GameState.player_dead = true
	GameState.world.on_player_died()
	queue_free()
	
	
func attack() -> void:
	attacking = true
	attack_timer.start()
	set_enemy_detector_position(player_direction)
	print("attacking")
	attack_anim(player_direction)
	
	
func clean_up_attack() -> void:
	attacking = false
	already_hit_bodies.clear()
	print("ended attack")
	$up_visuals/arm_left_top/sword.visible = true
	$up_visuals/arm_left_top/sword_hand.visible = false
	$down_visuals/arm_right_top/sword.visible = true
	$down_visuals/arm_right_top/sword_hand.visible = false
	
	
func set_enemy_detector_position(dir : Vector2) -> void:
	if enemy_detector_positions.has(dir):
		enemy_detector.position = enemy_detector_positions[dir]
	else:
		enemy_detector.position = enemy_detector_positions[Vector2.RIGHT]
	
	
func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if not attacking and not GameState.build_manager.building:
				attack()
	
	
func _integrate_forces(s : PhysicsDirectBodyState2D):
	var step = s.get_step()
	
	#apply movement
	if Input.is_action_pressed("player_up") and not attacking:
		player_direction = Vector2.UP
		lv.y -= walk_accel
		$up_visuals.visible = true
		$down_visuals. visible = false
		$left_right_visuals.visible = false
	if Input.is_action_pressed("player_down") and not attacking:
		player_direction = Vector2.DOWN
		lv.y += walk_accel 
		$down_visuals. visible = true
		$up_visuals. visible = false
		$left_right_visuals.visible = false
	if Input.is_action_pressed("player_right") and not attacking:
		player_direction = Vector2.RIGHT
		lv.x += walk_accel
		visuals.scale.x = norm_scale.x
		$down_visuals. visible = false
		$up_visuals. visible = false
		$left_right_visuals.visible = true
	if Input.is_action_pressed("player_left") and not attacking:
		player_direction = Vector2.LEFT
		lv.x -= walk_accel
		visuals.scale.x = norm_scale.x * -1
		$down_visuals. visible = false
		$up_visuals. visible = false
		$left_right_visuals.visible = true
		
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
	
	if lv * step != Vector2.ZERO:
		walking = true
	else:
		walking = false
	
	if walking == true and !attacking:
			if Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right"):
				a_player.play("run_left_right")
			else:
				if Input.is_action_pressed("player_up"):
					a_player.play("run_up",-1,1.2)
				if Input.is_action_pressed("player_down"):
					a_player.play("run_down",-1,1.2)
	elif !walking and !attacking:
		if player_direction == Vector2.LEFT or player_direction == Vector2.RIGHT:
			a_player.play("RESET")
		if player_direction == Vector2.UP:
			a_player.play("UP_RESET")
		if player_direction == Vector2.DOWN:
			a_player.play("DOWN_RESET")
			
	
func attack_anim(dir):
	print(str(dir))
	randomize()
	if dir == Vector2.LEFT or dir == Vector2.RIGHT:
		var rand = randi_range(1,2)
		if rand == 1:
			a_player.play("slash_left_right")
		if rand == 2:
			a_player.play("stab_left_right")
	if dir == Vector2.UP:
		$up_visuals/arm_left_top/sword.visible = false
		$up_visuals/arm_left_top/sword_hand.visible = true
		a_player.play("stab_up")
	if dir == Vector2.DOWN:
		$down_visuals/arm_right_top/sword.visible = false
		$down_visuals/arm_right_top/sword_hand.visible = true
		a_player.play("stab_down")

func _on_attack_timer_timeout():
	clean_up_attack()
