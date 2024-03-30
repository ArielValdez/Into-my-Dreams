extends State
class_name IdleSnowballLing

@export var enemy : CharacterBody2D
@export var move_speed : float = 250.0
@export var idle_start : float = 2
@export var idle_end : float = 7
@export var walk_start : float = 1
@export var walk_end : float = 5

var move_direction : Vector2
var wander_time : float
var idle_time : float

func _ready():
	if enemy != null:
		move_speed = enemy.walk_speed

func randomize_values():
	var x : int = randi_range(-1, 1)
	var y : int = 0
	if x == 0:
		y = randi_range(-1, 1)
	
	move_direction = Vector2(x, y).normalized()
	wander_time = randf_range(walk_start, walk_end)
	idle_time = randf_range(idle_start, idle_end)
	pass

func enter():
	randomize_values()

func update(delta : float):
	if wander_time > 0:
		wander_time -= delta
	else:
		to_await_random(delta)
	pass

func to_await_random(delta : float):
	move_direction = Vector2.ZERO
	idle_time -= delta
	if idle_time <= 0:
		randomize_values()

func physics_update(delta : float):
	if enemy:
		enemy.movement(move_direction, move_speed)
		enemy.handle_animation(enemy.animation_player, "move_", true)
