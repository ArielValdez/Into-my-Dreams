extends Node

class_name SceneSignalManager

signal collected_effect_from_npc
signal effect_collected
signal resize_camera_limit
signal open_door
signal go_to_next_scene
signal got_to_jail
signal got_effect_pop_up
signal got_stabbed

@onready var room_scene = preload("res://Scenes/Worlds/House/room.tscn")
@onready var starting_area_dream_scene = preload("res://Scenes/Worlds/balcony_dream.tscn")

var pause_menu : Control
var effect_menu : Control
var effect_pop_up : Control
var save_menu : Control
var load_menu : Control

var new_scene : PackedScene

var target_world : String
var target_world_door_id : int
var send_interaction : bool
var enable_camera_on_scene : bool = true

var player_character : PlayerCharacter
var spawn_player_at : Vector2
var world_size : Vector2

func get_world_size(current_world : TileMap) -> Vector2:
	var world_size : Vector2 = Vector2.ZERO
	if current_world != null:
		var tilemap_rect = current_world.get_used_rect()
		var tilemap_size = current_world.cell_quadrant_size
		world_size = tilemap_rect.size * tilemap_size
	
	return world_size

func load_scene() -> void:
	if target_world != null or target_world != "":
		new_scene = load("res://Scenes/Worlds/" + target_world + ".tscn")
	else:
		print_debug("Add a world, please")
	pass

func change_to_next_scene(this_new_scene : PackedScene, transfer_position : Vector2, waking_up : bool = false) -> void:
	var world : Node = this_new_scene.instantiate()
	
	TransitionScene.transition()
	await TransitionScene.on_transition_finished
	player_character.position = transfer_position
	
	if waking_up:
		transform_player(YumeEffects.Value.Base, SpriteManager.default_player_sprite, "", player_character.start_walk_speed, player_character.start_run_speed)
	
	get_tree().get_root().get_child(4).remove_child(player_character)
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_child(4).free()
	world.add_child(player_character)
	pass

func sleep_or_wake_up_next_scene() -> void:
	var sleep_or_awake_scene : PackedScene
	var transfer_position : Vector2
	
	if player_character.IsSleeping:
		sleep_or_awake_scene = room_scene
		transfer_position = Vector2(350, 200)
		pass
	else:
		sleep_or_awake_scene = starting_area_dream_scene
		transfer_position = Vector2(416, 384)
		pass
	pass
	
	change_to_next_scene(sleep_or_awake_scene, transfer_position, true)
	
	player_character.CanMove = true

func character_effect(effect: ActiveEffect):
	if player_character.IsSleeping:
		player_character.remove_child(player_character.light_source)
		player_character.has_light = false
		
		match effect.effect:
			YumeEffects.Value.Tutorial:
				print_debug("Tutorial button was pressed")
				# abrir menu de tutorial
				pass
			YumeEffects.Value.SnowWoman:
				transform_player(effect.effect, SpriteManager.snow_woman_sprite, "", player_character.start_walk_speed, player_character.start_run_speed)
				print_debug("Snowwoman transoformation")
				pass
			YumeEffects.Value.Killer:
				print_debug("Killer button was pressed")
				transform_player(effect.effect, SpriteManager.killer_sprite, "", player_character.start_walk_speed, player_character.start_run_speed)
				pass
			YumeEffects.Value.Demon:
				transform_player(effect.effect, SpriteManager.demon_sprite, "", player_character.start_walk_speed, player_character.start_run_speed)
				pass
			YumeEffects.Value.Mini:
				transform_player(effect.effect, SpriteManager.mini_sprite, "", player_character.start_walk_speed, player_character.start_run_speed)
				pass
			_: # effect does not exist
				print_debug("returning to default.")
				transform_player(effect.effect, SpriteManager.default_player_sprite, "", player_character.start_walk_speed, player_character.start_run_speed)
				pass
		
		# turning everything to where it was
		pause_menu.is_paused = false
		pause_menu.visible = false
		
		effect_menu.visible = false
		effect_menu.on_effects_menu = false
		
		get_tree().paused = false
	else:
		print_debug("Muri")
		pass
	pass

func transform_player(effect : YumeEffects.Value, sprite_transformation : Texture2D, anim_name : String, walk_speed_change : float, run_speed_change : float):
	if player_character.current_effect == effect:
		player_character.anim_name = ""
		player_character.current_effect = YumeEffects.Value.Base
		if player_character.sprite != null:
			player_character.sprite.texture = SpriteManager.default_player_sprite
		player_character.walk_speed = player_character.start_walk_speed
		player_character.run_speed = player_character.start_run_speed
	else:
		player_character.current_effect = effect
		player_character.anim_name = anim_name
		if player_character.sprite != null:
			player_character.sprite.texture = sprite_transformation
		player_character.walk_speed = walk_speed_change
		player_character.run_speed = run_speed_change
		pass
