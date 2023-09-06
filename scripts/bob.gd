extends RigidBody2D


@export var gun = preload("res://scenes/guns/gun.tscn")

var guns = []


func add_gun(gun_to_add):
	var gun_inst = gun_to_add.instantiate()
	guns.append(gun_inst)
	$GunPos.add_child(gun_inst)
	gun_inst.hide()
	gun_inst.fired.connect(get_recoiled)


func get_recoiled(recoil_vector):
	#apply_impulse(recoil_vector, $GunPos.position)
	apply_central_impulse(recoil_vector.rotated(rotation))


func _ready():
	add_gun(gun)
	guns[0].show()
