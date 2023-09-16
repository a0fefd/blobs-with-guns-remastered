extends Area2D


@export var item: PackedScene
@export var sprite_texture: Texture
@export var is_spritesheet := true
@export var spritesheet_frames := Vector2(3, 3)
@export var sprite_index: int = 0

@onready var sprite = get_node("Sprite2D")


func _ready():
	sprite.texture = sprite_texture
	if is_spritesheet:
		sprite.hframes = spritesheet_frames.x
		sprite.vframes = spritesheet_frames.y
		sprite.frame = sprite_index


func _on_body_entered(body):
	if body.is_in_group("Players"):
		body.pickup(item)
		queue_free()
