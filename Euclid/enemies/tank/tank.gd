class_name Tank
extends StandardEnemy

var tank_scale = Vector2(0.075, 0.075)

func _ready():
	super()
	anti_jit.timeout.connect(_on_anti_jit_timeout)
	
	



func update_visuals(v : Vector2) -> void:
	var angle = v.angle()
	var direction = ""

	if -PI/4 <= angle and angle < PI/4:
		direction = "right"
	elif PI/4 <= angle and angle < 3*PI/4:
		direction = "down"
	elif -3*PI/4 <= angle and angle < -PI/4:
		direction = "up"
	else:
		direction = "left"
	
	if !attacking:
		match direction:
			"up":
				attack_dir = "up"
				left_right_v.visible = false
				up_v.visible = true
				down_v.visible = false
				anim_player.play("up_walk")
			"down":
				attack_dir = "down"
				left_right_v.visible = false
				up_v.visible = false
				down_v.visible = true
				anim_player.play("down_walk")
			"left":
				attack_dir = "left"
				left_right_v.visible = true
				up_v.visible = false
				down_v.visible = false
				left_right_v.scale.x = tank_scale.x * -1
				anim_player.play("walk_left_right")
			"right":
				attack_dir = "right"
				left_right_v.visible = true
				up_v.visible = false
				down_v.visible = false
				left_right_v.scale.x = tank_scale.x * 1
				anim_player.play("walk_left_right")
	
	
func attack_clean_up() -> void:
	anim_player.play("RESET")
	anim_player.play("UP_RESET")
	anim_player.play("DOWN_RESET")
	
	
func attack_target(target : Node) -> void:
	attacking = true
	if target != null and is_instance_valid(target):
		target.take_damage(damage_dealt)
	
		var angle = global_position.direction_to(target.global_position).angle()
		var direction = ""

		if -PI/4 <= angle and angle < PI/4:
			direction = "right"
		elif PI/4 <= angle and angle < 3*PI/4:
			direction = "down"
		elif -3*PI/4 <= angle and angle < -PI/4:
			direction = "up"
		else:
			direction = "left"
			
		attack_dir = direction
		print(str(direction))
		match attack_dir:
			"right":
				anim_player.play("slash_left_right")
			"left":
				anim_player.play("slash_left_right")
			"up":
				anim_player.play("up_slash")
			"down":
				anim_player.play("down_slash")
			
	
	
func _on_anti_jit_timeout() -> void:
	if !GameState.game_over:
		if !attacking:
			update_visuals(anim_dir)
	
	
	
func hit_by_shock(dmg : int, t : float) -> void:
	shocked.shock_time = t
	shocked.old_state = state_machine.state
	$"shock?".visible = true
	$shock_player.play("shock",-1,2.0)
	state_machine.transition_to(shocked)
	take_damage(dmg)

func shock_cleanup():
	$shock_player.play("RESET")
	$"shock?".visible = false

