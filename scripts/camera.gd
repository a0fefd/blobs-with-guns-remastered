extends Camera2D


@export var shake_intensity: float = 3
@export var shake_lerp: float = 0.2

var shake_amount


func _physics_process(_delta):
	if shake_amount:
		offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		shake_amount = lerp(shake_amount, 0.0, shake_lerp)


func shake(intensity=shake_intensity):
	shake_amount = intensity
