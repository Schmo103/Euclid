class_name WaveCallerMenu
extends Control

@export var wave_alert : WaveAlert

var wave_number_string : String = "Wave Number "


func _on_button_pressed():
	$Button.visible = false
	$Label.visible = true
	wave_alert.start_wave_count_down()
	
	
func set_wave_count(n : int) -> void:
	$Label.text = wave_number_string + str(n)

