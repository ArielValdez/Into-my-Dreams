extends Control

@onready var button : Button = $NinePatchRect/CenterContainer/GridContainer/File1
@onready var button2 : Button = $NinePatchRect/CenterContainer/GridContainer/File2
@onready var button3 : Button = $NinePatchRect/CenterContainer/GridContainer/File3

@export var save_game_resource : SaveGame

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

func _on_file_1_pressed():
	save_game_resource.save_game(name_file1)

func _on_file_2_pressed():
	save_game_resource.save_game(name_file2)

func _on_file_3_pressed():
	save_game_resource.save_game(name_file3)