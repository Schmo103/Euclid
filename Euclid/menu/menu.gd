extends Control

@export
var world : PackedScene = preload("res://world/world.tscn")

func _ready() -> void:
	get_tree().set_pause(false)
	

func _on_start_pressed():
	get_tree().change_scene_to_packed(world)
