extends Area2D


@export var speed = 1000
@export var range = 100

@onready var origin = global_position

var shot_from


func _process(delta):
	global_position += Vector2(speed, 0).rotated(rotation) * delta
	
	if (global_position - origin).length() > range:
		queue_free()


func _on_body_entered(body):
	if body != shot_from and body.is_in_group("Blobs"):
		body.queue_free()
		queue_free()
