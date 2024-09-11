class_name EnemyBlob
extends Blob


@export var held_weapon: PackedScene = null

var is_player_seen := false

# variables:
## world
## gun_pos
## sprite
## collider

func _ready():
	if (held_weapon != null):
		# setting up the held weapon
		var weapon_instance = held_weapon.instantiate()
		gun_pos.add_child(weapon_instance) # put the weapon into the "hand" of the blob
		weapon_instance.hide()
		weapon_instance.world = world # make the instance actually exist in the world
		weapon_instance.owner = self # this guy is the owner of his gun
		weapon_instance.dequip()
		weapon_instance.equip()
	
	pass

func _process(delta):
	pass


func _on_eyesight_body_entered(body):
	if body.name == "Player":
		is_player_seen = true


func _on_eyesight_body_exited(body):
	if body.name == "Player":
		is_player_seen = false
