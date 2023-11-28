class_name Shocked
extends State

@export var shock_timer : Timer

var shock_time : float
var old_state : State

func _ready() -> void:
	shock_timer.timeout.connect(_on_shock_timer_timeout)
	
	
func initiate_state() -> void:
	super()
	shock_timer.wait_time = shock_time
	shock_timer.start()
	print("enemy shocked")
	
	
func _on_shock_timer_timeout() -> void:
	print("exiting shock")
	print("entering state: " + str(old_state))
	enemy.state_machine.transition_to(old_state)


