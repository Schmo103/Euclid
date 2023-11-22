class_name Attacking
extends State

var target : Node #either player or tower

@export var fighting : State

@export var attacking_timer : Timer
@export var attack_duration : float = 1.0


#sets up attack timer
func _ready() -> void:
	assert(attacking_timer != null, "attack state does not have timer")
	attacking_timer.timeout.connect(_on_attacking_timer_timed_out)
	attacking_timer.wait_time = attack_duration
	

#begins attack and starts countdown to end attack
func initiate_state() -> void:
	super()
	attacking_timer.start()
	enemy.attack_target(target)
	
	
#when attack has been carried out, returns to fighting state to plan next attack
func _on_attacking_timer_timed_out() -> void:
	enemy.state_machine.transition_to(fighting)
	
	
	