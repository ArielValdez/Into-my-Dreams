extends State

@export var enemy : Enemy
@export var hitbox : Area2D

@export var run_speed : float = 200
@export var walk_speed : float = 200
@export var distance_detection_player : float = 500
@export var idle_start : float = 2
@export var idle_end : float = 7
@export var walk_start : float = 1
@export var walk_end : float = 5

@export var sprite_texture : Texture2D

var move_direction : Vector2
var player : PlayerCharacter

var wander_time : float
var idle_time : float
var speed : float = walk_speed

var state_on : bool = false

func _set_values() -> void:
	move_direction = Vector2(0, 0).normalized()
	
	player = Manager.player_character
	pass

func _set_random_values() -> void:
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(walk_start, walk_end)
	idle_time = randf_range(idle_start, idle_end)
	pass

func _to_await_random(delta : float) -> void:
	move_direction = Vector2.ZERO
	idle_time -= delta
	if idle_time <= 0:
		_set_random_values()

func exit()  -> void:
	var default_sprite : Texture2D = load("res://Sprites/Characters/NCP/self_depreciation.png")
	enemy.sprite.texture = default_sprite
	state_on = false

func enter() -> void:
	if sprite_texture != null and enemy != null:
		enemy.sprite.texture = sprite_texture
	
	_set_values()
	
	state_on = true

func update(delta : float) -> void:
	if player != null:
		var pos_direction = player.position - enemy.position
		if pos_direction.length() <= distance_detection_player:
			move_direction = Vector2(pos_direction.x, pos_direction.y).normalized()
			speed = run_speed
		else:
			speed = walk_speed
			if wander_time > 0:
				wander_time -= delta
			else:
				_to_await_random(delta)
	else:
		speed = walk_speed
		if wander_time > 0:
			wander_time -= delta
		else:
			_to_await_random(delta)

func physics_update(delta : float) -> void:
	enemy.movement(move_direction, speed)
	enemy.handle_animation(enemy.animation_player, "walk_", true)
	
	_send_to_hell()

func _send_to_hell() -> void:
	if state_on and hitbox != null:
		for body in hitbox.get_overlapping_bodies():
			if body.has_method("get_collision_layer_value"):
				if body.get_collision_layer_value(hitbox.collision_mask):
					Manager.change_to_next_scene(load("res://Scenes/Worlds/sorrow_maze_world.tscn"), Vector2(1650, 1430))
				else:
					print_debug("body name: " + body.name)
	pass
