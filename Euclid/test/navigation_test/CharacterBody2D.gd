extends CharacterBody2D

var target : Vector2

var speed := 7000

var en_route := false

var i := 0

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			target = get_viewport().get_mouse_position()
			en_route = true
			$NavigationAgent2D.target_position = target
#			if !$NavigationAgent2D.is_target_reachable():
#				$NavigationAgent2D.target_position = position
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var p = (get_viewport().get_mouse_position() - Vector2(32, 32)).snapped(Vector2(64, 64)) / Vector2(64, 64)
			print(str(p))
#			print(str($"../TileMap".get_cell_atlas_coords(0, p)))
			if $"../TileMap".get_cell_atlas_coords(0, p) == Vector2i(0, 0):
				$"../TileMap".set_cell(0, p, 0, Vector2i(1, 0))
			else:
				$"../TileMap".set_cell(0, p, 0, Vector2i(0, 0))
				


func _physics_process(delta):
	var p
	var dir : Vector2
	if en_route:
		p = $NavigationAgent2D.get_next_path_position()
		dir = position.direction_to(p)
		if $NavigationAgent2D.is_navigation_finished():
			print("finished " + str(i))
			i += 1
			en_route = false
		
	
	velocity = dir * speed * delta
	move_and_slide()
