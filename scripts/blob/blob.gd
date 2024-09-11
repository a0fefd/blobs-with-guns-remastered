class_name Blob
extends RigidBody2D


@export var max_velocity: int = 500
@export var hp_max: float = 1
@export var gore_particles: PackedScene = preload("res://scenes/blobs/blob_gore.tscn")

@onready var world: Node2D = get_parent()
@onready var gun_pos: Node2D = get_node("GunPos")
@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var collider: CollisionPolygon2D = get_node("CollisionPolygon2D")
@onready var hp := hp_max

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
	gore_inst.modulate = sprite.modulate
	
	if hp < 0:
		if name == "Player": 
			fake_die()
			set_global_position(self.spawn_position)
			self.linear_velocity = Vector2(0, 0)
			self.angular_velocity = 0
			self.rotation = 0
		else: 
			die()
		#die()

func sprite_facing_logic(target: Vector2):
	var angle_to_target: float = abs(get_angle_to(target))
	
	# angle is in quadrant 2
	if sprite.scale.x == 1 and angle_to_target > PI / 2:
		flip()
	# angle is in quadrant 1
	elif sprite.scale.x == -1 and angle_to_target < PI / 2:
		flip()

func fake_die():
	print("died")
	hp = hp_max

func die():
	queue_free() # change to normal death later
