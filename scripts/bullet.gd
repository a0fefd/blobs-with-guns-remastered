extends Area2D


@export var speed: int = 1000
@export var bullet_range: int = 300
@export var damage: float = 1
@export var smoke_trail: PackedScene = preload("res://scenes/guns/smoke_trail.tscn")
@export var debris_particles: PackedScene = preload("res://scenes/guns/debris_particles.tscn")

var shot_from
var bullet_origin: Vector2

@onready var world = get_parent()
@onready var raycast = get_node("RayCast2D")


func _ready():
	var smoke_trail_inst = smoke_trail.instantiate()
	world.add_child(smoke_trail_inst)
	smoke_trail_inst.target = self


func _process(delta):
	global_position += Vector2(speed, 0).rotated(rotation) * delta
	
	if (global_position - bullet_origin).length() > bullet_range:
		queue_free()
	
	raycast.target_position = Vector2(speed * delta, 0)
	if raycast.is_colliding():
		global_position = raycast.get_collision_point()
		_on_body_entered(raycast.get_collider())


func _on_body_entered(body):
	if body != shot_from:
		if body.is_in_group("Hittable"):
			body.get_hit(damage)
		
		var debris_inst = debris_particles.instantiate()
		world.add_child(debris_inst)
		debris_inst.global_transform = global_transform
		
		queue_free()
