extends RigidBody2D


@export var gun = preload("res://scenes/guns/gun.tscn")

@onready var gun_pos = get_node("GunPos")

var guns = []


func add_gun(gun_to_add):
	var gun_inst = gun_to_add.instantiate()
	guns.append(gun_inst)
	gun_pos.add_child(gun_inst)
	gun_inst.hide()
	gun_inst.fired.connect(get_recoiled)
	gun_inst.world = get_parent()
	gun_inst.owner = self


func get_recoiled(recoil_vector):
	apply_central_impulse(recoil_vector.rotated(rotation))


func _ready():
	add_gun(gun)
	guns[0].show()
