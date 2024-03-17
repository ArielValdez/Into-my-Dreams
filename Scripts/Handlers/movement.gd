extends CharacterBody2D

class_name Movements

@export var walk_speed : float = 250
@export var run_speed : float = 350
@export var tile_based_walk_speed : float = 3
@export var tile_based_run_speed : float = 3.5

# @onready var tile_map : TileMap = get_this_tree_child("TileMap") as TileMap

var is_moving : bool = false
var this_body_sprite : Sprite2D
var current_speed : float

func _ready():
	pass

func process_movement(this_body_speed : float) -> void:
	if !is_moving:
		return
	
	if global_position == this_body_sprite.global_position:
		is_moving = false
		return
	
	this_body_sprite.global_position = this_body_sprite.global_position.move_toward(global_position, this_body_speed)

func get_sprite_from_body(body_sprite : Sprite2D) -> void:
	this_body_sprite = body_sprite

func get_this_tree_child(child : String) -> Node:
	var children : Array[Node] = get_tree().current_scene.get_children()
	var node : Node
	for foundChild in children:
		if foundChild.name == child:
			node = foundChild
	return node

# For action based movement
func movement(char_direction : Vector2, speed : float) -> void:
	velocity = speed * char_direction
	move_and_slide()
	pass

# For tile based movement : Currently unused
func tile_based_movement(direction : Vector2i, delta_speed : float) -> void:
	#if !is_moving:
		## Get current tile vector2i
		#var current_tile : Vector2i = tile_map.local_to_map(global_position)
		#
		## Get target tile
		#var target_tile : Vector2i = Vector2i(
			#current_tile.x + direction.x,
			#current_tile.y + direction.y
		#)
		#
		## Get custom data layer from tile
		#var tile_data : TileData = tile_map.get_cell_tile_data(0, target_tile)
		#var tile_data2 : TileData = tile_map.get_cell_tile_data(1, target_tile)
		#
		#if tile_data.get_custom_data("walkable"):
			#if tile_data2 == null:
				## Move player
				#is_moving = true
				#global_position = tile_map.map_to_local(target_tile)
				#this_body_sprite.global_position = tile_map.map_to_local(current_tile)
			#pass
	pass

func handle_animation(animationPlayer : AnimationPlayer, animation : String, should_stop : bool = true) -> void:
	if animationPlayer:
		if velocity.length() == 0:
			if animationPlayer.is_playing() and should_stop:
				animationPlayer.stop()
		else:
			var direction = "down"
			if velocity.x < 0:
				direction = "left"
			elif velocity.x > 0:
				direction = "right"
			elif velocity.y < 0:
				direction = "up"
			
			if animationPlayer.has_animation(animation + direction):
				animationPlayer.play(animation + direction)
	pass
