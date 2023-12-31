class_name Traveling #to home base
extends State

var on_route : bool = false

@export var fighting : State

func initiate_state() -> void:
	super()
	on_route = false
	
	
func clean_up() -> void:
	super()
	if is_instance_valid(enemy):
		enemy.moving = false
	

#enemy heads toward base
func execute_state() -> void:
	if is_instance_valid(enemy):
		if not on_route:
			enemy.nav_agent.target_position = global_from_tile_pos(GameState.world.home_tile_pos)
			on_route = true
		enemy.moving = true
		var next_path_pos : Vector2
		next_path_pos = enemy.nav_agent.get_next_path_position()
		enemy.dir = enemy.position.direction_to(next_path_pos)
		if enemy.nav_agent.is_navigation_finished():
			on_route = false
			enemy.state_machine.transition_to(fighting)
		
		
func global_from_tile_pos(tile_pos : Vector2) -> Vector2:
	return tile_pos * GameState.real_tile_size + GameState.real_tile_size / 2
