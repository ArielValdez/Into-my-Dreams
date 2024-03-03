extends Node

signal pass_through_door

@onready var room_scene = preload("res://Scenes/Worlds/House/room.tscn")
@onready var starting_area_dream_scene = preload("res://Scenes/Worlds/nexus.tscn")

var pause_menu : Control
var effect_menu : Control

var new_scene : PackedScene

var target_world : String
var target_world_door_id : int
var send_interaction : bool

var player_character : CharacterBody2D
var spawn_player_at : Vector2


func _ready() -> void:
	pass

func load_scene() -> void:
	new_scene = load("res://Scenes/Worlds/" + target_world + ".tscn")
	#print_debug(target_world)
	#print_debug(new_scene)
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
	
	get_tree().get_root().get_child(2).remove_child(player_character)
	get_tree().get_root().add_child(world)
	
	get_tree().get_root().get_child(2).free()
		
	world.add_child(player_character)
	
	player_character.position = Vector2(350, 200)
	player_character.CanMove = true

func change_levels() -> void:
	get_child(2).queue_free()
	var nextLvl = new_scene.instance() 
	#const lvlPath = preload("res://path of your level scene")
	call_deferred("add_child", nextLvl)
	pass

func character_effect(effect: YumeEffects.Value):
	player_character.anim_name = YumeEffects.Value.keys()[effect]
	
	match effect:
		YumeEffects.Value.Tutorial:
			print_debug("Tutorial button was pressed")
			# abrir menu de tutorial
			pass
		YumeEffects.Value.Regular:
			print_debug("Regular button was pressed")
			Manager.player_character.anim_name = ""
			pass
		YumeEffects.Value.Dream:
			print_debug("Dream button was pressed")
			pass
		_: # effect does not exist
			print_debug("you should not be here...")
			player_character.sprite.texture = SpriteManager.sprite
			player_character.walk_speed = player_character.start_walk_speed
			player_character.run_speed = player_character.start_run_speed
	
	# turning everything to where it was
	pause_menu.is_paused = false
	pause_menu.visible = false
	
	effect_menu.visible = false
	effect_menu.on_effects_menu = false
	
	get_tree().paused = false
	pass
