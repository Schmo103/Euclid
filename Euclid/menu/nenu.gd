extends Control

@export
var world : PackedScene = preload("res://world/world.tscn")

func _on_start_pressed():
	get_tree().change_scene_to_packed(world)
