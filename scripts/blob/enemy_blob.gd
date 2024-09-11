class_name EnemyBlob
extends Blob


@export var held_weapon: PackedScene = null

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
