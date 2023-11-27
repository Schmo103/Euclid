class_name Missile
extends Area2D

var target : Node2D
var direction : Vector2 = Vector2.UP
var speed : float

var damage : int = 10

var duration : float = 5

func _ready() -> void:
	$DurationTimer.wait_time = duration
	
	
func _process(delta):
	move_missile(delta)


func move_missile(delta : float) -> void:
	if is_instance_valid(target):
		direction = position.direction_to(target.position)
	position += direction * speed * delta
	
	
func free_missile() -> void:
	queue_free()
	
	
func can_hit(body : Node2D) -> bool:
	return body.is_in_group("enemy")
	
	
func hit(body : Node2D) -> void:
	body.hit_by_missile(damage)
	free_missile()
	
	
func _on_duration_timer_timeout() -> void:
	free_missile()


func _on_body_entered(body : Node2D) -> void:
	if can_hit(body):
		hit(body)
