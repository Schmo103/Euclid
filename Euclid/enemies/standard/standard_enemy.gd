class_name StandardEnemy
extends Enemy

@export var health_display : Control
@export var nav_agent : NavigationAgent2D

var on_route : bool

var lv : Vector2


func _ready() -> void:
	health_display.max_value = health
	set_destination()
	

func _process(_delta):
	z_index = ((position - GameState.real_tile_size / 2).snapped(GameState.real_tile_size) / GameState.real_tile_size).y


func _integrate_forces(s : PhysicsDirectBodyState2D) -> void:
	var next_path_pos : Vector2
	var dir : Vector2
	if on_route:
		next_path_pos = nav_agent.get_next_path_position()
		dir = position.direction_to(next_path_pos)
		if nav_agent.is_navigation_finished():
			on_route = false
	
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
	
	s.set_linear_velocity(lv)
	
	
func set_destination() -> void:
	nav_agent.target_position = GameState.world.home_tile_pos * GameState.real_tile_size + GameState.real_tile_size / 2
	on_route = true
	
	
func set_health(h : int) -> void:
	super(h)
	health_display.value = h


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	lv = safe_velocity
