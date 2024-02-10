extends Node

signal pass_through_door

var new_scene : PackedScene
var target_world : String
var target_world_door_id : int
var player_character : CharacterBody2D

var send_interaction : bool

func _ready() -> void:
	#pass_through_door.emit("on-level-change", self, change_levels)
	pass

func load_scene() -> void:
	new_scene = load("res://Scenes/Worlds/" + target_world + ".tscn")
	print_debug(new_scene)
	pass

func change_levels() -> void:
	get_child(1).queue_free()
	var nextLvl = new_scene.instance() #const lvlPath = preload("res://path of your level scene")
	call_deferred("add_child", nextLvl)
	pass
