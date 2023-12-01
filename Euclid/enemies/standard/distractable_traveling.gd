class_name DistractableTraveling
extends Traveling

var homeward_bound : bool = false

var target : Node2D

func execute_state() -> void:
#	if not on_route:
#		enemy.nav_agent.target_position = global_from_tile_pos(GameState.world.home_tile_pos)
#		on_route = true
	select_target()
	if target != null and target.is_in_group("player") and target.position != enemy.nav_agent.target_position:
		enemy.nav_agent.target_position = target.global_position
	enemy.moving = true
	var next_path_pos : Vector2
	next_path_pos = enemy.nav_agent.get_next_path_position()
	enemy.dir = enemy.position.direction_to(next_path_pos)
	if enemy.nav_agent.is_navigation_finished() or enemy.target_detector.get_overlapping_bodies().has(target):
		if target != null:
			fighting.target = target
		enemy.state_machine.transition_to(fighting)
		
		
func select_target() -> void:
	#if target no longer exists, target is null
	if not is_instance_valid(target):
		target = null
	if homeward_bound:
		#if we're heading to home base right now, check for an alternative target
		check_for_non_base_target()
	else:
		#if we're heading to an alternative target, make sure it still exists and is still in range
		if not target_is_available():
			#if alternative target is no longer available, check for a different alt target
			target = null
			check_for_non_base_target()
			#if check for alt target yielded no results, head towards home
			if target == null:
				enemy.nav_agent.target_position = global_from_tile_pos(GameState.world.home_tile_pos)
				homeward_bound = true
			
			
func check_for_non_base_target() -> void:
	if enemy.potential_target_detector.get_overlapping_bodies().size() > 0:
			var body = get_closest_body(enemy.potential_target_detector.get_overlapping_bodies())
			if body != target:
				target = body
				enemy.nav_agent.target_position = body.global_position
			homeward_bound = false
			

func target_is_available() -> bool:
	return enemy.potential_target_detector.get_overlapping_bodies().has(target) and target != null
	
	
func get_closest_body(bodies : Array[Node2D]) -> Node2D:
	var closest_body : Node2D = null
	for b in bodies:
		if closest_body == null:
			closest_body = b
		else:
			if enemy.global_position.distance_to(b.global_position) < enemy.global_position.distance_to(closest_body.global_position):
				closest_body = b
	return closest_body
