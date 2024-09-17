class_name EnemyBlob
extends Blob


@export var held_weapon: PackedScene = null
@export var reaction_time: int = 200
@export var attention_time: int = 10000

#var vec_to_player: Vector2i = Vector2i(0, 0)
var raycast: RayCast2D

var is_player_heard := false
var is_player_spotted := false
var timedout := false
var has_line_of_sight := false
var ready_to_fire := false
var distracted := true
var had_attention := false

var player: Player
var player_shoot_sound

var weapon: Gun

# variables:
## world
## gun_pos
## sprite
## collider

func _ready():
	raycast = $RayCast2D
	#raycast.add_exception(world.get_node("TileMap"))
	
	$ReactionTime.set_wait_time(reaction_time/1000.0)
	$ReactionTime.stop()
	$AttentionTime.set_wait_time(attention_time/1000.0)
	$AttentionTime.stop()
	
	if (held_weapon != null):
		# setting up the held weapon
		weapon = held_weapon.instantiate()
		gun_pos.add_child(weapon) # put the weapon into the "hand" of the blob
		weapon.hide()
		weapon.world = world # make the instance actually exist in the world
		weapon.owner = self # this guy is the owner of his gun
		weapon.dequip()
		weapon.equip()
	

func _process(_delta):
	$AttentionTimeLabel.visible_characters = 0 if distracted else 1
	
	$GunTarget.set_global_position(raycast.get_target_position())
	$Collider.set_global_position(raycast.get_collision_point())
	weapon = $GunPos.get_child(0) if $GunPos.get_child_count() > 0 else null
	player = world.find_child("Player")
	if !player.radial_inventory.visible:
		player_shoot_sound = player.find_child("GunPos").get_child(player.inv_selected_gun).find_child("ShootSound")
	if is_player_heard:
		if player_shoot_sound.playing and !player_shoot_sound.get_parent().is_suppressed:
			distracted = false
			$AttentionTime.stop()
			had_attention = true
			if $ReactionTime.is_stopped() and !timedout:
				$ReactionTime.start()
		elif !player_shoot_sound.playing and !player_shoot_sound.get_parent().is_suppressed:
			if has_line_of_sight: timedout = false
		
	if is_player_spotted:
		if $ReactionTime.is_stopped() and !timedout:
				$ReactionTime.start()
		raycast.set_target_position(player.global_position - self.global_position)
		raycast.force_raycast_update()
		if raycast.is_colliding() and raycast.get_collider().name == "Player":
			has_line_of_sight = true
			print("player")
		else:
			has_line_of_sight = false
		
		if has_line_of_sight:
			distracted = false
			had_attention = true
			$AttentionTime.stop()
			self.weapon.look_at(player.position) if weapon != null else null
	else:
		has_line_of_sight = false

	if timedout and !distracted:
		self.sprite_facing_logic(player.position) 
		timedout = false if !has_line_of_sight else timedout
	if timedout and has_line_of_sight and !distracted:
		had_attention = true
		ready_to_fire = true
	
	if !has_line_of_sight:
		ready_to_fire = false
		timedout = false
		if $AttentionTime.is_stopped() and !distracted and had_attention:
			$AttentionTime.start()
		if !$AttentionTime.is_stopped():
			print("Time Until Distracted: ", round($AttentionTime.time_left))
		if had_attention: had_attention = false
	
	if ready_to_fire and weapon != null and self.weapon.can_shoot:
		self.weapon.fire(self.weapon.shotgun_check)


func _on_hearing_area_body_entered(body):
	if body.name == "Player":
		is_player_heard = true


func _on_hearing_area_body_exited(body):
	if body.name == "Player":
		is_player_heard = false
		timedout = false


func _on_reaction_time_timeout():
	timedout = true
	had_attention = true


func _on_seeing_area_body_entered(body):
	if body.name == "Player":
		is_player_spotted = true


func _on_seeing_area_body_exited(body):
	if body.name == "Player":
		raycast.set_target_position(Vector2.ZERO)
		is_player_spotted = false


func _on_attention_time_timeout():
	distracted = true
	self.flip()
