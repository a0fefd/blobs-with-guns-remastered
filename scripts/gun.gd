extends Node2D


@export var recoil = 300
@export var shell = preload("res://scenes/guns/shell.tscn")

var world

@onready var animation_player = get_node("AnimationPlayer")
@onready var shell_pos = get_node("Sprite2D/ShellPos")

signal fired(recoil_vector)


func _process(delta):
	if Input.is_action_just_pressed("fire"):
		fired.emit(-Vector2(recoil, 0).rotated(rotation))
		animation_player.play("shoot")
		eject_shell()
	
	look_at(get_global_mouse_position())


func eject_shell():
	var shell_inst = shell.instantiate()
	world.add_child(shell_inst)
	shell_inst.global_position = shell_pos.global_position
