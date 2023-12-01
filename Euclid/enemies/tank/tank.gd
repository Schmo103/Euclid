class_name Tank
extends StandardEnemy

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
			left_right_v.scale.x = normal_scale.x * -1
			anim_player.play("walk_left_right")
		"right":
			attack_dir = "right"
			left_right_v.visible = true
			up_v.visible = false
			down_v.visible = false
			left_right_v.scale.x = normal_scale.x * 1
			anim_player.play("walk_left_right")
	
	
func attack_clean_up() -> void:
	pass
	
	
func attack_target(target : Node) -> void:
	if is_instance_valid(target):
		attacking = true
		target.take_damage(damage_dealt)

	
	
func _on_anti_jit_timeout() -> void:
	if !GameState.game_over:
		if !attacking:
			update_visuals(anim_dir)
	
	
	


