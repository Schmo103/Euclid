class_name Fighting
extends State

var target : Node2D #either player or tower

@export var attacking : Attacking
@export var traveling : State

var target_fell : bool = false


func initiate_state() -> void:
	super()
	choose_target()
	if target != null and is_instance_valid(target) and target.has_signal("fell"):
		if not target.fell.is_connected(_on_target_fell):
			target.fell.connect(_on_target_fell)
		attacking.target = target
	if target_fell:
		target_fell = false
		enemy.state_machine.transition_to(traveling)


#if target is reachable, attack it
func execute_state() -> void:
	if validate_target():
		enemy.state_machine.transition_to(attacking)
	else:
		target_fell = false
		enemy.state_machine.transition_to(traveling)
	
	
#function to select target from bodies in target detector
func choose_target() -> void:
	if target != null and is_instance_valid(target) and target.has_signal("fell"):
		if target.fell.is_connected(_on_target_fell):
			target.disconnect(target.fell.get_name(), _on_target_fell)
	target = null
	var bodies : Array = enemy.target_detector.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("base"):
			target = b
			return
		elif b.is_in_group("player"):
			target = b
		elif b.is_in_group("wall"):
			if target == null:
				target = b
			elif not target.is_in_group("player"):
				target = b
		else:
			if target == null:
				target = b
			elif not target.is_in_group("wall") and not target.is_in_group("player"):
				target = b
	if target == null or not is_instance_valid(target):
		enemy.state_machine.transition_to(traveling)
#		print("traveling due to lack of targets")
		
		
#checks if target is reachable
func validate_target() -> bool:
	return enemy.target_detector.get_overlapping_bodies().has(target)
				
				
#recieves signal if target falls
func _on_target_fell() -> void:
	target_fell = true
				
