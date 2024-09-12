extends Control

# wierd asf code idk what I'm on

@export var level_list: Dictionary = {
	"test1": preload("res://scenes/levels/test1.tscn")
}

@export var selected_level: Dictionary = {
	"index": 0,
	"name": "test1"
}

@onready var level_instances: Dictionary = {}

func _ready():
	for key in level_list.keys():
		level_instances[key] = level_list[key].instantiate()
	$"Level Name".text = level_instances[ selected_level["name"] ].name


func _process(delta):
	selected_level["name"] = level_list.keys()[ selected_level["index"] ]


func _on_prev_pressed():
	selected_level["index"] = 0 if selected_level["index"] <= len(level_list)-1 else selected_level["index"] - 1
	$"Level Name".text = level_instances[ selected_level["name"] ].name


func _on_next_pressed():
	selected_level["index"] = 0 if selected_level["index"] >= len(level_list)-1 else selected_level["index"] + 1
	$"Level Name".text = level_instances[ selected_level["name"] ].name
