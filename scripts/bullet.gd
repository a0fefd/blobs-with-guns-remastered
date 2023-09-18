extends Area2D


@export var speed: int = 1000
@export var bullet_range: int = 300
@export var damage: float = 1
@export var smoke_trail: PackedScene = preload("res://scenes/guns/smoke_trail.tscn")

var shot_from
var bullet_origin: Vector2


func _ready():
	var smoke_trail_inst = smoke_trail.instantiate()
	get_parent().add_child(smoke_trail_inst)
	smoke_trail_inst.target = self


func _process(delta):
	global_position += Vector2(speed, 0).rotated(rotation) * delta
	
	if (global_position - bullet_origin).length() > bullet_range:
		queue_free()


func _on_body_entered(body):
	if body != shot_from:
		if body.is_in_group("Hittable"):
			body.get_hit(damage)
	
		queue_free()
