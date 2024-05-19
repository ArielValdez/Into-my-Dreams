extends State

class_name GriefState

@export var enemy : Movements
@export var animation_player : AnimationPlayer
@export var move_speed : float = 50.0
@export var idle_start : float = 2
@export var idle_end : float = 7
@export var walk_start : float = 1
@export var walk_end : float = 5
@export var times_move_start : int = 5
@export var times_move_end : int = 12
@export var direction_to_move : Vector2

var move_direction : Vector2
var wander_time : float
var idle_time : float
var dir_move : int

func _ready():
	dir_move = randi_range(times_move_start, times_move_end)
	
	if enemy != null:
		move_speed = enemy.walk_speed
	
	if animation_player != null:
		animation_player.play("idle")
	pass

func randomize_values():
	var x : int = randi_range(-1, 1)
	
	move_direction = direction_to_move.normalized()
	wander_time = randf_range(walk_start, walk_end)
	idle_time = randf_range(idle_start, idle_end)
	pass

func enter():
	randomize_values()

func update(delta : float):
	if dir_move > 0:
		if wander_time > 0:
			wander_time -= delta
		else:
			to_await_random(delta)
		pass

func to_await_random(delta : float):
	idle_time -= delta
	if idle_time <= 0:
		randomize_values()

func physics_update(delta : float):
	if enemy:
		enemy.movement(move_direction, move_speed)
