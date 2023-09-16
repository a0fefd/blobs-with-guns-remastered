extends Area2D


@export var speed: int = 1000
@export var bullet_range: int = 300
@export var damage: float = 1

var shot_from
var bullet_origin: Vector2


func _process(delta):
	global_position += Vector2(speed, 0).rotated(rotation) * delta
	
	if (global_position - bullet_origin).length() > bullet_range:
		queue_free()


func _on_body_entered(body):
	if body != shot_from:
		if body.is_in_group("Hittable"):
			body.get_hit(damage)
	
		queue_free()
