class_name Tutorial
extends Control
@export var p_men : Control
@onready var label : Label = $Label

var step : int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	if GameState.using_tutorial:
#		p_men.process_mode = Node.PROCESS_MODE_DISABLED
#		get_tree().set_paue(true)
		do_tutorial()
	else:
		visible = false
		
		
		
		
func do_tutorial() -> void:
	match step:
		1:
			label.text = "Use WASD to move around the map and left click to attack"
		2:
			label.text = "The big tower in the middle is your base. If it's destroyed, you lose"
		3:
			label.text = "In the top left, you can see how many resources you have."
		4:
			label.text = "In the bottom right, you can see the build menu. If you click the different icons, you can see that you can build a drill, a cannon, a laser cannon, a shock tower, a wall, and a gate"
		5:
			label.text = "Use Q, E, and Space to quickly move through the build menu and easily select towers to build. Above each icon, you can see the name of the tower and its price"
		6:
			label.text = "Build a drill and place it near some iron. You can see the range of the drill. You can also see the range of some of the other defensive towers if you select them"
		7:
			label.text = "The drill will mine resources in its range"
		8:
			label.text = "The cannon and laser cannon will both fire on enemies who come nearby, but the laser cannon is more powerful"
		9:
			label.text = "The shock tower will shock enemies that come nearby, freezing them for a moment"
		10:
			label.text = "The walls block enemies from moving (at least temporarily), and the gates are just like walls except you can move through them"
		11:
			label.text = "You can click on a tower you've already build to sell it or see its range"
		12:
			label.text = "Now build up defenses around your main tower. A red icon on one of the sides of the screen shows you which direction the enemies are coming from."
		13:
			label.text = "Right click to exit build mode"
		14:
			label.text = "Eventually the resources your drill is mining will run out. However, if you can hold out long enough the map will expand."
		15:
			label.text = "Click the the button to call the first wave, and the game will begin. If you die, you will respawn shortly, as long as you protect your tower"
		16:
			label.text = "Good luck!"
			$Button.text = "Exit tutorial"
		_:
			exit_tutorial()



func _on_button_pressed():
	step += 1
	do_tutorial()
	
	
func exit_tutorial() -> void:
	visible = false
#	get_tree().set_pause(false)
#	p_men.process_mode = Node.PROCESS_MODE_ALWAYS
	
