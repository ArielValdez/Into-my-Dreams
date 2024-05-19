extends State
class_name IdleSnowWoman

@export var enemy : Enemy
@export var move_speed : float = 250.0
@export var idle_start : float = 2
@export var idle_end : float = 7
@export var walk_start : float = 1
@export var walk_end : float = 5
@export var is_animation_stop : bool = false

var move_direction : Vector2
var wander_time : float
var idle_time : float

func randomize_values() -> void:
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(walk_start, walk_end)
	idle_time = randf_range(idle_start, idle_end)
	pass

func to_await_random(delta : float) -> void:
	move_direction = Vector2.ZERO
	idle_time -= delta
	if idle_time <= 0:
		randomize_values()

func enter() -> void:
	if enemy != null:
		move_speed = enemy.walk_speed
	
	randomize_values()

func update(delta : float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		to_await_random(delta)
	pass

func physics_update(delta : float) -> void:
	if enemy != null:
		enemy.movement(move_direction, move_speed)
		enemy.handle_animation(enemy.animation_player, "walk_", is_animation_stop)
