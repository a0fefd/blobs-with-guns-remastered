extends RigidBody2D


@export var gun = preload("res://scenes/guns/gun.tscn")

@onready var gun_pos = get_node("GunPos")
@onready var sprite = get_node("Sprite2D")
@onready var collider = get_node("CollisionPolygon2D")

var guns = []
var equipped_gun = null


func add_gun(gun_to_add):
	var gun_inst = gun_to_add.instantiate()
	guns.append(gun_inst)
	gun_pos.add_child(gun_inst)
	gun_inst.hide()
	gun_inst.fired.connect(get_recoiled)
	gun_inst.world = get_parent()
	gun_inst.owner = self


func equip_gun(index):
	if equipped_gun:
		equipped_gun.hide()
	
	equipped_gun = guns[index]
	equipped_gun.show()


func get_recoiled(recoil_vector):
	apply_central_impulse(recoil_vector.rotated(rotation))  # check this


func flip():
	sprite.scale.x *= -1
	collider.scale.x *= -1
	gun_pos.position.x *= -1
	gun_pos.scale.x *= -1


func _ready():
	add_gun(gun)
	equip_gun(0)


func _process(_delta):
	if abs(equipped_gun.rotation_degrees) > 90:
		flip()
