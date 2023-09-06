extends Node2D


@export var recoil = 400

signal fired(recoil_vector)


func _process(delta):
	if Input.is_action_just_pressed("fire"):
		fired.emit(-Vector2(recoil, 0).rotated(rotation))
		$ShootSound.play()
	
	look_at(get_global_mouse_position())
