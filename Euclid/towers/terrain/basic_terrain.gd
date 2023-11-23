extends Sprite2D


var frames : Array[int] = [0, 4, 5]

func _ready() -> void:
	#choose random terrain option
	randomize()
	var r : int = randi()
	frame = frames[r % frames.size()]
