extends Node


func change_splash_size(small_splash):
	if small_splash:
		ProjectSettings.set_setting("application/boot_splash/image", "res://sprites/logos/gutter_cat_splash_small.png")
	else:
		ProjectSettings.set_setting("application/boot_splash/image", "res://sprites/logos/gutter_cat_splash.png")
	
	ProjectSettings.save()
