class_name WaveDirectionIndicator
extends Sprite2D

var spawn_point : SpawnPoint

@export var left_pos : Vector2
@export var right_pos : Vector2
@export var up_pos : Vector2
@export var down_pos : Vector2

@onready var positions : Dictionary = {Vector2.UP : up_pos,
							Vector2.DOWN : down_pos,
							Vector2.LEFT : left_pos,
							Vector2.RIGHT : right_pos}


func change_spawn_point(s : SpawnPoint) -> void:
	spawn_point = s
	position = positions[spawn_point.direction_from_home]
	rotation = spawn_point.direction_from_home.angle()
	rotation_degrees += 90
	
