class_name Tank
extends StandardEnemy



func update_visuals(_v : Vector2) -> void:
	pass
	
	
func attack_clean_up() -> void:
	pass
	
	
func attack_target(target : Node) -> void:
	if is_instance_valid(target):
		attacking = true
		target.take_damage(damage_dealt)
<<<<<<< HEAD
=======
	
	
func _on_anti_jit_timeout() -> void:
	if !GameState.game_over:
		if !attacking:
			update_visuals(anim_dir)
>>>>>>> parent of 1438c12 (Merge branch 'main' into owens)
	
	
	


