class_name Tank
extends StandardEnemy



func update_visuals(_v : Vector2) -> void:
	pass
	
	
func attack_clean_up() -> void:
	pass
	
	
func attack_target(target : Node) -> void:
	attacking = true
	target.take_damage(damage_dealt)
	
	
	


