extends Node2D

@onready var starting_weapon_drop = $"Starting Weapon Drop"

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_weapon_drop.set_global_position(
		Vector2(0, $"Player".global_position.y - 200)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if starting_weapon_drop != null:
		starting_weapon_drop.set_global_position(
			Vector2(starting_weapon_drop.position.x, starting_weapon_drop.position.y + 40 * delta)
		)
