extends Node

signal pass_through_door

@onready var room_scene = preload("res://Scenes/Worlds/House/room.tscn")
@onready var starting_area_dream_scene = preload("res://Scenes/Worlds/nexus.tscn")

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
	print_debug(target_world)
	print_debug(new_scene)
	pass

func sleep_or_wake_up_next_scene() -> void:
	var sleep_or_awake_scene : PackedScene
	if player_character.IsSleeping:
		sleep_or_awake_scene = room_scene
		pass
	else:
		sleep_or_awake_scene = starting_area_dream_scene
		pass
	pass
	
	var world : Node = sleep_or_awake_scene.instantiate()
	
	get_tree().get_root().get_child(1).remove_child(player_character)
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_child(1).free()
		
	world.add_child(player_character)
	player_character.position = Vector2(350, 200)
	player_character.CanMove = true

func change_levels() -> void:
	get_child(1).queue_free()
	var nextLvl = new_scene.instance() 
	#const lvlPath = preload("res://path of your level scene")
	call_deferred("add_child", nextLvl)
	pass
