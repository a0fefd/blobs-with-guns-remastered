class_name Player
extends Blob


@export var gun: PackedScene = preload("res://scenes/guns/pistol.tscn")
@export var focus_time_scale: float = 0.2
@export var screen_shake_ratio: float = 0.02

var guns := []
var equipped_gun = null

@onready var ammo_label: Label = get_node("HUD/AmmoLabel")
@onready var camera: Camera2D = get_node("Camera2D")


func _ready():
	add_gun(gun)
	equip_gun(0)


func _process(_delta):
	if sprite.scale.x == 1 and abs(rad_to_deg(get_angle_to(get_global_mouse_position()))) > 90:
		flip()
	elif sprite.scale.x != 1 and abs(rad_to_deg(get_angle_to(get_global_mouse_position()))) < 90:
		flip()
	
	if Input.is_action_pressed("focus"):
		Engine.time_scale = focus_time_scale
		AudioServer.playback_speed_scale = focus_time_scale
	else:
		Engine.time_scale = 1
		AudioServer.playback_speed_scale = 1
	
	if Input.is_action_just_pressed("next_gun"):
		if equipped_gun == guns[-1]:
			equip_gun(0)
		else:
			equip_gun(guns.find(equipped_gun) + 1)
	if Input.is_action_just_pressed("prev_gun"):
		if equipped_gun == guns[0]:
			equip_gun(-1)
		else:
			equip_gun(guns.find(equipped_gun) - 1)


func add_gun(gun_to_add):
	var gun_inst = gun_to_add.instantiate()
	guns.append(gun_inst)
	gun_pos.add_child(gun_inst)
	gun_inst.hide()
	gun_inst.world = world
	gun_inst.owner = self
	gun_inst.fired.connect(get_recoiled)
	gun_inst.ammo_changed.connect(update_ammo_display)
	gun_inst.unequip()


func equip_gun(index):
	if equipped_gun:
		equipped_gun.unequip()
	
	equipped_gun = guns[index]
	equipped_gun.equip()


func get_recoiled(recoil_vector):
	apply_central_impulse(Vector2(recoil_vector.x * sprite.scale.x, recoil_vector.y).rotated(rotation))
	camera.shake(recoil_vector.length() * screen_shake_ratio)


func update_ammo_display(ammo_in_mag, ammo):
	ammo_label.text = str(ammo_in_mag) + " | " + str(ammo)


func pickup(item):
	add_gun(item)
