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

@export var damage_dealt : int = 10


func _ready() -> void:
	super()
	health_display.max_value = health
	health_display.value = health
	
	
#the enemies standard attack function
func attack_target(target : Node) -> void:
	target.take_damage(damage_dealt)
	
	
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
		
#	var anim_dir : Vector2 = lv.normalized()
	
	
func set_health(h : int) -> int:
	if health_display != null:
		health_display.value = super(h)
	return super(h)
	

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	lv = safe_velocity
	
