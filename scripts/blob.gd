extends RigidBody2D
class_name Blob


@onready var gun_pos = get_node("GunPos")
@onready var sprite = get_node("Sprite2D")
@onready var collider = get_node("CollisionPolygon2D")


func flip():
	sprite.scale.x *= -1
	collider.scale.x *= -1
	gun_pos.position.x *= -1
	gun_pos.scale.x *= -1
