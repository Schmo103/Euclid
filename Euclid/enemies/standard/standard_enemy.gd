class_name StandardEnemy
extends Enemy

@export var health_display : Control
@export var nav_agent : NavigationAgent2D
@export var state_machine : StateMachine
@export var target_detector : Area2D

@export var shocked : Shocked

var on_route : bool

var lv : Vector2
var dir : Vector2
var moving : bool = false
var anim_dir : Vector2

var attack_dir = "right"
var normal_scale = Vector2(0.03, 0.03)
var attacking = false

@export var damage_dealt : int = 20

@onready var left_right_v = $left_right_visuals
@onready var up_v = $up_visuals
@onready var down_v = $down_visuals
@onready var anim_player = $AnimationPlayer
@onready var anti_jit = $anti_jitter


func _ready() -> void:
	super()
	health_display.max_value = health
	health_display.value = health
	
	
#the enemies standard attack function
func attack_target(target : Node) -> void:
	attacking = true
	target.take_damage(damage_dealt)
	
	
	match attack_dir:
		"right":
			anim_player.play("bite")
		"left":
			anim_player.play("bite")
		"up":
			anim_player.play("up_bite")
		"down":
			anim_player.play("down_bite")
	
	
func hit_by_shock(dmg : int, t : float) -> void:
	super(dmg, t)
	shocked.shock_time = t
	shocked.old_state = state_machine.state
	state_machine.transition_to(shocked)
	

#adjusts z_index so for semi isometric view
func _process(_delta):
	z_index = ((position - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size).y


func _integrate_forces(s : PhysicsDirectBodyState2D) -> void:
	#executes state
	if not GameState.game_over:
		state_machine.execute_state()
	else:
		moving = false
	
	#moving and dir are variables set by states to control enemy movement
	if moving:
		var step = s.get_step()
		var vel : Vector2 = dir * speed * step

		for idx in s.get_contact_count():
			var n = s.get_contact_local_normal(idx)
			if vel.normalized().dot(n) <= 0.4:
				vel = vel.slide(n)
			
		if nav_agent.avoidance_enabled:
			nav_agent.set_velocity(vel)
		else:
			lv = vel
		
		#moving lv
		s.set_linear_velocity(lv)
	else:
		#stopping
		s.set_linear_velocity(Vector2.ZERO)
		
	anim_dir = lv.normalized()
#	update_visuals(anim_dir)
	
	
func set_health(h : int) -> int:
	if health_display != null:
		health_display.value = super(h)
	return super(h)
	

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	lv = safe_velocity
	
	
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
			anim_player.play("walk")
		"right":
			attack_dir = "right"
			left_right_v.visible = true
			up_v.visible = false
			down_v.visible = false
			left_right_v.scale.x = normal_scale.x * 1
			anim_player.play("walk")


func _on_anti_jitter_timeout():
	if !GameState.game_over:
		if !attacking:
			update_visuals(anim_dir)

