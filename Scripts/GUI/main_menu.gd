extends Control

@onready var startin_area = preload("res://Scenes/Worlds/House/room.tscn")

func _ready() -> void:
	Manager.pause_menu.on_main_menu = true

func _on_quit_pressed():
	get_tree().quit(0)


func _on_load_pressed():
	Manager.pause_menu.on_main_menu = false
	pass # Replace with function body.


func _on_new_game_pressed():
	Manager.pause_menu.on_main_menu = false
	
	var world : Node = startin_area.instantiate()
	get_tree().get_root().add_child(world)
	queue_free()
	pass # Replace with function body.