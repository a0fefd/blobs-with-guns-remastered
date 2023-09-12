extends Node2D


signal fired(recoil_vector)

@export var recoil: int = 300
@export var shell_spin: int = 1
@export var inaccuracy: int = 5
@export var mag_size: int = 10
@export var eject_force: Vector2 = Vector2(0, -10000)
@export var facing: Vector2 = Vector2.RIGHT # Set to Vector2.DIR
@export var shell: PackedScene = preload("res://scenes/guns/shell.tscn")
@export var bullet: PackedScene = preload("res://scenes/guns/bullet.tscn")

var world
var ammo_in_mag = mag_size

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var shell_pos: Node2D = get_node("Sprite2D/ShellPos")
@onready var barrel_end: Node2D = get_node("Sprite2D/BarrelEnd")


func _process(_delta):
	if Input.is_action_just_pressed("fire") and ammo_in_mag > 0:
		fire()
	
	if Input.is_action_just_pressed("reload") and ammo_in_mag != mag_size:
		reload()
	
	look_at(get_global_mouse_position())
	
	facing = get_parent().scale


func eject_shell():
	var shell_inst = shell.instantiate()
	world.add_child(shell_inst)
	shell_inst.global_transform = shell_pos.global_transform
	
	if facing.x == Vector2.RIGHT.x:
		shell_inst.apply_force(eject_force.rotated(global_rotation), Vector2(shell_spin, 0).rotated(global_rotation))
	elif facing.x == Vector2.LEFT.x:
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
	animation_player.play("reload")
	ammo_in_mag = mag_size
