class_name WaveAlert
extends Control

signal end_of_count_down_reached

@export var wave_progress_bar : TextureProgressBar

@export var total_time_till_wave : float = 30:
	set(v):
		total_time_till_wave = v
		wave_progress_bar.max_value = v

var time_till_wave : float:
	set(v):
		time_till_wave = v
		if v < 0:
			time_till_wave = 0
		wave_progress_bar.value = total_time_till_wave - time_till_wave
		
		
var displaying_final_countdown : bool = false
var final_count_down_message : String = "Wave in: \n"
var start_count_down_num : int = 3
var count_down_num : int = start_count_down_num
var last_rep : bool = false
var last_rep_message : String = "Wave Began"

var wave_count_down_active : bool = false
		
		
func _ready() -> void:
	reset_counter()
	wave_progress_bar.max_value = total_time_till_wave
	$Label.visible = false
	
		
func reset_counter() -> void:
	time_till_wave = total_time_till_wave
	
	
func _process(delta) -> void:
	if wave_count_down_active:
		time_till_wave -= delta
		if time_till_wave <= 0 and not displaying_final_countdown:
			display_final_countdown()
		
		
func display_final_countdown() -> void:
	wave_progress_bar.visible = false
	displaying_final_countdown = true
	$Label.visible = true
	$Label.text = final_count_down_message + str(count_down_num)
	last_rep = false
	$FinalCountDownTimer.wait_time = 1
	$FinalCountDownTimer.start()
	wave_count_down_active = false
	
	
func clean_up_final_count_down() -> void:
	displaying_final_countdown = false
	$Label.visible = false
	count_down_num = start_count_down_num
#	start_wave_count_down()
	
func start_wave_count_down() -> void:
	reset_counter()
	wave_progress_bar.visible = true
	wave_count_down_active = true
	
	
	
func _on_final_count_down_timer_timeout():
	count_down_num -= 1
	if count_down_num <= 0:
		if not last_rep:
			$FinalCountDownTimer.wait_time = 3
			$FinalCountDownTimer.start()
			$Label.text = last_rep_message
			last_rep = true
			end_of_count_down_reached.emit()
		else:
			clean_up_final_count_down()
	else:
		$Label.text = final_count_down_message + str(count_down_num)
		$FinalCountDownTimer.start()
