extends Control

@onready var startin_area = preload("res://Scenes/Worlds/House/room.tscn")

@onready var button : Button = $"MarginContainer/VBoxContainer/New Game"
@onready var button2 : Button = $"MarginContainer/VBoxContainer/Load"

func _ready() -> void:
	Manager.pause_menu.on_main_menu = true

func _input(event):
	if Manager.save_menu.on_save_menu and event.is_action_pressed("run_button"):
		get_tree().paused = false
		
		Manager.pause_menu.can_pause = true
		
		Manager.save_menu.on_save_menu = false
		Manager.save_menu.visible = false

func _on_quit_pressed():
	get_tree().quit(0)

func _on_load_pressed():
	visible = false
	Manager.load_menu._on_load_game = true
	Manager.load_menu.visible = Manager.load_menu._on_load_game
	Manager.load_menu.button.grab_focus()
	pass

func _on_new_game_pressed():
	Manager.pause_menu.on_main_menu = false
	
	var world : Node = startin_area.instantiate()
	get_tree().get_root().add_child(world)
	queue_free()
