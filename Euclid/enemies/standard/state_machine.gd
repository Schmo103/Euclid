class_name StateMachine
extends Node

@export var initial_state : State
var state : State

func _ready() -> void:
	state = initial_state
	if get_child_count() == 0:
		push_error("state machine has no states")
	
	
func execute_state() -> void:
	state.execute_state()
	
	
func transition_to(s : State) -> void:
	state.clean_up()
	state = s
	state.initiate_state()
		
