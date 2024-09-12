class_name EnemyBlob
extends Blob


@export var held_weapon: PackedScene = null
@export var reaction_time: int = 200

var is_player_heard := false
var seen_tiles: Array = []
var vec_to_player: Vector2i = Vector2i(0, 0)

var timedout := false
var ready_to_fire := false

var player
var player_shoot_sound

# variables:
## world
## gun_pos
## sprite
## collider

func _ready():
	
	$ReactionTime.set_wait_time(reaction_time/1000.0)
	
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
	player = world.find_child("Player")
	player_shoot_sound = player.find_child("GunPos").get_child(player.inv_selected_gun).find_child("ShootSound")
	if is_player_heard:
		if player_shoot_sound.playing and !player_shoot_sound.get_parent().is_suppressed:
			if $ReactionTime.is_stopped() and !timedout:
				$ReactionTime.start()
		
		if timedout:
			ready_to_fire = true
	else:
		ready_to_fire = false
		
		
		


func _on_hearing_area_body_entered(body):
	if body.name == "Player":
		is_player_heard = true


func _on_hearing_area_body_exited(body):
	if body.name == "Player":
		is_player_heard = false
		timedout = false


func _on_reaction_time_timeout():
	timedout = true
	$ReactionTime.set_wait_time(reaction_time/1000)
	
