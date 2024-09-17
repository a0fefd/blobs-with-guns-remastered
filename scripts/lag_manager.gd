extends Node2D


var max_shells: int = 100
var shells := []

func _process(_delta):
	if shells.size() > max_shells:
		shells[0].queue_free()
		shells.remove_at(0)
