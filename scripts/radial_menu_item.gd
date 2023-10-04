extends Control


var gun_names := ["Pistol", "SilencedPistol", "Uzi", "Shotgun", "GrenadeLauncher", "AssaultRifle", "SniperRifle"]

@onready var sprite = get_node("Sprite2D")


func _ready():
	sprite.hide()


func _process(_delta):
	sprite.global_rotation = 0


func set_icon(gun_name):
	sprite.frame = gun_names.find(gun_name)
	sprite.show()
