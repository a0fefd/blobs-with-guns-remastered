class_name Gun
extends Node2D


signal fired(recoil_vector)
signal ammo_changed(ammo_in_mag, ammo)

@export var recoil: int = 300
@export var shell_spin: float = 1
@export var inaccuracy: int = 5
@export var mag_size: int = 10
@export var ammo: int = 30
@export var eject_force := Vector2(0, -10000)
#@export var rounds_per_second: float = 10
@export var rpm: float = 600
@export var full_auto := false
@export var num_bullets: int = 9  # best if this is odd so that there is a center bullet
@export var spread: float = 40
@export var shell: PackedScene = preload("res://scenes/guns/bullets-shells/shell.tscn")
@export var bullet: PackedScene = preload("res://scenes/guns/bullets-shells/bullet.tscn")

var world
var can_shoot := true
var reloading := false
var ammo_in_mag: int
var facing: Vector2
var equipped := false

var is_player_weapon := false 
var shotgun_check := false

var player_pos

@onready var is_suppressed = true if name == "SilencedPistol" else false

@onready var enemy_list = get_tree().get_nodes_in_group("EnemyBlobs")

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var shell_pos: Node2D = get_node("Sprite2D/ShellPos")
@onready var barrel_end: Node2D = get_node("Sprite2D/BarrelEnd")
@onready var shoot_timer: Timer = get_node("ShootTimer")
@onready var parent: Node2D = get_parent()

func _ready():
	shoot_timer.wait_time = 60 / rpm
	ammo_in_mag = mag_size


func _process(_delta):
	shotgun_check = true if name == "Shotgun" else false
	
	player_pos = world.find_child("Player").global_position
	
	if equipped:
		if is_player_weapon:
			look_at(get_global_mouse_position())
			
			var input_safety_check = Input.is_action_pressed("fire") if full_auto else Input.is_action_just_pressed("fire")
			if input_safety_check and can_shoot and !reloading:
				if ammo_in_mag > 0:
					fire(shotgun_check)
				else:
					reload()
			
			if Input.is_action_just_pressed("reload") and ammo_in_mag != mag_size and !reloading:
				reload()



func eject_shell():   
	var shell_inst = shell.instantiate()
	world.add_child(shell_inst)
	shell_inst.global_transform = shell_pos.global_transform
	
	facing = parent.scale
	
	if facing.x == Vector2.RIGHT.x:
		shell_inst.apply_force(eject_force.rotated(global_rotation), Vector2(shell_spin, 0).rotated(global_rotation))
	elif facing.x == Vector2.LEFT.x:
		shell_inst.apply_force(eject_force.rotated(-global_rotation), Vector2(shell_spin, 0).rotated(-global_rotation))


func create_bullet(angle: float = 0):
	var bullet_inst = bullet.instantiate()
	world.add_child(bullet_inst)
	bullet_inst.shot_from = owner
	bullet_inst.bullet_origin = global_position
	bullet_inst.global_transform = barrel_end.global_transform
	bullet_inst.rotation_degrees += angle + randf_range(-inaccuracy, inaccuracy)


func fire(is_shotgun: bool):
	animation_player.stop()
	animation_player.play("shoot")
	
	fired.emit(-Vector2(recoil, 0).rotated(rotation))
	ammo_changed.emit(ammo_in_mag, ammo)
	
	if is_shotgun:
		for i in range(num_bullets):
			create_bullet((spread / (num_bullets - 1)) * i - spread / 2)
	else:
		create_bullet()
	
	eject_shell()
	ammo_in_mag -= 1
	can_shoot = false
	shoot_timer.start()


func reload():
	animation_player.play("reload")
	reloading = true


func equip():
	show()
	animation_player.play("equip")
	ammo_changed.emit(ammo_in_mag, ammo)


func dequip():
	hide()
	equipped = false


func _on_shoot_timer_timeout():
	can_shoot = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "reload":
		reloading = false
		
		ammo += ammo_in_mag
		ammo_in_mag = 0
		
		if ammo - mag_size >= 0:
			ammo_in_mag = mag_size
			ammo -= mag_size
		else:
			ammo_in_mag = ammo
			ammo = 0
	
	elif anim_name == "equip":
		animation_player.play("RESET")
		equipped = true
	
	ammo_changed.emit(ammo_in_mag, ammo)
