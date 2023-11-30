class_name GameStateData
extends Node

signal base_fell
signal ended_game

#the commoditys in the game
@export var commoditys : Array[Commodity]
#the towers in the game
@export var towers : Array[TowerStats]

#references to important nodes
var building_gui : BuildingGui
var build_manager : BuildManager
var back_tile_map : TileMap
var front_tile_map : TileMap
var world : World
var missiles : MissileManager
var enemy_manager : EnemyManager
var player : Player

#tile size information
var tile_size : Vector2 = Vector2(32, 32)
var tile_scale : Vector2 = Vector2(2, 2)

@onready var real_tile_size = tile_size * tile_scale

var game_over : bool = false


func on_base_fell() -> void:
	base_fell.emit()
	end_game()
	
	
func end_game() -> void:
	game_over = true
	ended_game.emit()
	
	
func start_game() -> void:
	game_over = false
	

 
