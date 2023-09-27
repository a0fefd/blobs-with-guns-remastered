extends Control


var guns := ["Pistol", "SilencedPistol", "Uzi", "Shotgun", "GrenadeLauncher", "AssaultRifle", "SniperRifle"]

@onready var sprite = get_node("Sprite2D")


func _ready():
	sprite.hide()


func set_icon(gun_name):
	sprite.frame = guns.find(gun_name)
	sprite.show()


func _process(delta):
	sprite.global_rotation = 0
