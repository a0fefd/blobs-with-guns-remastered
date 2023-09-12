extends Node2D


signal fired(recoil_vector)

@export var recoil: int = 300
@export var shell_spin: float = 1
@export var inaccuracy: int = 5
@export var mag_size: int = 10
@export var eject_force := Vector2(0, -10000)
@export var rounds_per_second: float = 10
@export var shell: PackedScene = preload("res://scenes/guns/shell.tscn")
@export var bullet: PackedScene = preload("res://scenes/guns/bullet.tscn")

var world
var can_shoot := true
var reloading := false
var ammo_in_mag: int = mag_size
var facing: Vector2

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var shell_pos: Node2D = get_node("Sprite2D/ShellPos")
@onready var barrel_end: Node2D = get_node("Sprite2D/BarrelEnd")
@onready var shoot_timer: Timer = get_node("ShootTimer")
@onready var parent: Node2D = get_parent()


func _ready():
	shoot_timer.wait_time = 1 / rounds_per_second


func _process(_delta):
	if Input.is_action_just_pressed("fire") and ammo_in_mag > 0 and can_shoot and not reloading:
		fire()
	
	if Input.is_action_just_pressed("reload") and ammo_in_mag != mag_size and not reloading:
		reload()
	
	look_at(get_global_mouse_position())


func eject_shell():
	var shell_inst = shell.instantiate()
	world.add_child(shell_inst)
	shell_inst.global_transform = shell_pos.global_transform
	
	facing = parent.scale
	
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
	can_shoot = false
	shoot_timer.start()


func reload():
	animation_player.play("reload")
	reloading = true


func _on_shoot_timer_timeout():
	can_shoot = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "reload":
		reloading = false
		ammo_in_mag = mag_size
