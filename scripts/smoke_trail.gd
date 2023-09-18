extends Line2D


@export var length: float = 50

var target = null


func _physics_process(delta):
	if is_instance_valid(target):
		add_point(target.global_position)
	else:
		if get_point_count() > 0:
			remove_point(0)
		else:
			queue_free()
