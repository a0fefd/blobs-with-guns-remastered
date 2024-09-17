extends RigidBody2D


@onready var lag_handler: Node2D = get_parent().get_node("Player/LagHandler")


func _ready():
	lag_handler.shells.append(self)


func _on_timer_timeout():
	lag_handler.shells.erase(self)
	queue_free()
