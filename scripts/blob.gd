class_name Blob
extends RigidBody2D


@export var max_velocity: int = 500
@export var hp: float = 1
@export var gore_particles: PackedScene = preload("res://scenes/blobs/blob_gore.tscn")

@onready var world: Node2D = get_parent()
@onready var gun_pos: Node2D = get_node("GunPos")
@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var collider: CollisionPolygon2D = get_node("CollisionPolygon2D")

func _integrate_forces(_state):
	if get_linear_velocity().length() > max_velocity:
		set_linear_velocity(get_linear_velocity().normalized() * max_velocity)


func flip():
	sprite.scale.x *= -1
	collider.scale.x *= -1
	gun_pos.position.x *= -1
	gun_pos.scale.x *= -1


func get_hit(damage, direction):
	hp -= damage
	
	var gore_inst = gore_particles.instantiate()
	world.add_child(gore_inst)
	gore_inst.global_transform = global_transform
	gore_inst.rotation = direction
	
	if hp < 0:
		queue_free()
