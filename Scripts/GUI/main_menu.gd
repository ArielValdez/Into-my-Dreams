extends Control

@onready var startin_area = preload("res://Scenes/Worlds/House/room.tscn")

func _on_quit_pressed():
	get_tree().quit(0)


func _on_load_pressed():
	pass # Replace with function body.


func _on_new_game_pressed():
	var world : Node = startin_area.instantiate()
	call_deferred("add_child", world)
	get_tree().get_root().add_child(world)
	pass # Replace with function body.
