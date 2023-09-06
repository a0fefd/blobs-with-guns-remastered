extends Node2D


@export var recoil = 300
@export var shell = preload("res://scenes/guns/shell.tscn")

var world
var animPlayer = null

signal fired(recoil_vector)

func _ready():
	animPlayer = $AnimationPlayer

func _process(delta):
	if Input.is_action_just_pressed("fire"):
		fired.emit(-Vector2(recoil, 0).rotated(rotation))
		animPlayer.play("shoot")
		eject_shell()
	
	look_at(get_global_mouse_position())


func eject_shell():
	var shell_inst = shell.instantiate()
	world.add_child(shell_inst)
	shell_inst.global_position = $Sprite2D/ShellPos.global_position
