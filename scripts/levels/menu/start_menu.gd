extends Node2D

func _ready():
	pass


func _process(delta):
	pass


func _on_start_button_pressed():
	# this is sketchy
	var path: String = "res://scenes/levels/"+($"Control/Level Select/Level Name".text).to_lower()+".tscn"
	get_tree().change_scene_to_packed(
		load(path)
	)
