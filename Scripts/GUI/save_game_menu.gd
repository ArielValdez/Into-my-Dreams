extends Control

@onready var button : Button = $NinePatchRect/CenterContainer/GridContainer/File1
@onready var button2 : Button = $NinePatchRect/CenterContainer/GridContainer/File2
@onready var button3 : Button = $NinePatchRect/CenterContainer/GridContainer/File3

@export var save_game_resource : SaveGame

var on_save_menu : bool = false

var name_file3 : String = "file3"
var name_file2 : String = "file2"
var name_file1 : String = "file1"

func _ready():
	visible = false
	Manager.save_menu = self
	button.grab_focus()
	
	if SaveGame.exists_game_file(name_file1):
		button.text = name_file1
		button.icon = SpriteManager.front_view_sprite
	if SaveGame.exists_game_file(name_file2):
		button2.text = name_file2
		button.icon = SpriteManager.front_view_sprite
	if SaveGame.exists_game_file(name_file3):
		button3.text = name_file3
		button.icon = SpriteManager.front_view_sprite

func _process(delta):
	if Manager.save_menu.on_save_menu:
		get_tree().paused = true
	else:
		get_tree().paused = false

func _input(event):
	if Manager.save_menu.on_save_menu and event.is_action_pressed("run_button"):
		Manager.pause_menu.can_pause = true
		Manager.save_menu.on_save_menu = false
		Manager.save_menu.visible = false

func _on_file_1_pressed():
	file_saver_manager(name_file1)
	

func _on_file_2_pressed():
	file_saver_manager(name_file2)

func _on_file_3_pressed():
	file_saver_manager(name_file3)

func file_saver_manager(name_of_file : String):
	save_game_resource.save_game(name_of_file)
	visible = false
	on_save_menu = false
	Manager.pause_menu.can_pause = true
