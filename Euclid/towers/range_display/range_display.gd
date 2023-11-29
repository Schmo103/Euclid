class_name RangeDisplay
extends Node2D

enum range_modes {CIRCLE, SQUARE}

@export var display_range : float = 130
@export var range_mode : range_modes
@export var range_modulate : Color = Color(0, 0.36, 0.98, 0.21)

@export var range_stats : RangeStats

var range_z_index : int = 4090

var height : int = 32
var circle_radius : float = 265

@export var scale_multiplier : float = 1

func _ready() -> void:
	z_index = 4090
	z_as_relative = false
	update_range_properties()
		
		
func update_range_properties() -> void:
	if range_stats != null:
		display_range = range_stats.display_range
		range_mode = range_stats.range_mode
		range_modulate = range_stats.range_modulate
	$Square.modulate = range_modulate
	$Circle.modulate = range_modulate
	if range_mode == range_modes.SQUARE:
		$Circle.visible = false
		$Square.visible = true
		$Square.scale = Vector2(display_range / height, display_range / height) * scale_multiplier
	else:
		$Circle.visible = true
		$Square.visible = false
		$Circle.scale = Vector2(display_range / circle_radius, display_range / circle_radius) * scale_multiplier



func set_range_visible(b : bool) -> void:
	visible = b
	
	
	


