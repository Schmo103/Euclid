class_name GameStateData
extends Node

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

#tile size information
var tile_size : Vector2 = Vector2(32, 32)
var tile_scale : Vector2 = Vector2(2, 2)

@onready var real_tile_size = tile_size * tile_scale
