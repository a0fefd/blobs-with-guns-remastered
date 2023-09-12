extends Node2D


signal fired(recoil_vector)

@export var recoil = 300
@export var eject_force = Vector2(0, -10000)
@export var shell_spin = 1
@export var inaccuracy = 5
@export var mag_size = 10
@export var shell = preload("res://scenes/guns/shell.tscn")
@export var bullet = preload("res://scenes/guns/bullet.tscn")

var world
var ammo_in_mag = mag_size

@onready var animation_player = get_node("AnimationPlayer")
@onready var shell_pos = get_node("Sprite2D/ShellPos")
@onready var barrel_end = get_node("Sprite2D/BarrelEnd")


func _process(_delta):
	if Input.is_action_just_pressed("fire") and ammo_in_mag > 0:
		fire()
	
	if Input.is_action_just_pressed("reload") and ammo_in_mag != mag_size:
		reload()
	
	look_at(get_global_mouse_position())


func eject_shell():
	var shell_inst = shell.instantiate()
	world.add_child(shell_inst)
	shell_inst.global_transform = shell_pos.global_transform
	
	if get_parent().scale.x == 1:
		shell_inst.apply_force(eject_force.rotated(global_rotation), Vector2(shell_spin, 0).rotated(global_rotation))
	else:
		shell_inst.apply_force(eject_force.rotated(-global_rotation), Vector2(shell_spin, 0).rotated(-global_rotation))


func create_bullet():
	var bullet_inst = bullet.instantiate()
	world.add_child(bullet_inst)
	bullet_inst.global_transform = barrel_end.global_transform
	bullet_inst.shot_from = owner
	bullet_inst.bullet_origin = global_position
	bullet_inst.rotation_degrees += randf_range(-inaccuracy, inaccuracy)


func fire():
	fired.emit(-Vector2(recoil, 0).rotated(rotation))
	animation_player.play("shoot")
	eject_shell()
	create_bullet()
	ammo_in_mag -= 1


func reload():
	ammo_in_mag = mag_size
