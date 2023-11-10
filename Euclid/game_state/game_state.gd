class_name GameStateData
extends Node

@export var commoditys : Array[Commodity]
@export var towers : Array[TowerStats]

var building_gui : BuildingGui
var build_manager : BuildManager
var flat_tile_map : TileMap
var solid_tile_map : TileMap

var tile_size : Vector2 = Vector2(32, 32)
var tile_scale : Vector2 = Vector2(2, 2)

@onready var real_tile_size = tile_size * tile_scale
