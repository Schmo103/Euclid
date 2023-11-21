class_name CommodityObject
extends Tower

@export var commodity : Commodity

#var first_frame := true

func _ready() -> void:
	super()
#	GameState.set_up_commodities.connect(_on_world_ready)
	add_to_group("commodity_object")
	set_up_commodity()
	
	
#func _process(delta):
#	if first_frame:
#		first_frame = false
#		set_up_commodity()
	
	
	
func _on_world_ready() -> void:
	print("setting up commodity")
#	set_up_commodity()

	
func set_up_commodity() -> void:
	GameState.front_tile_map.set_tile_commodity_data(tile_pos, self)
#	print(str(GameState.front_tile_map))
	
	
func _exit_tree() -> void:
	super()
	GameState.front_tile_map.set_tile_commodity_data(tile_pos)
