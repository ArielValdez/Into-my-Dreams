extends State
class_name RunningState

@export var enemy : CharacterBody2D
@export var move_speed : float = 250.0

var move_direction : Vector2
var wander_time : float
var move_down_time : float
var move_downwards : bool = true

func _ready():
	if enemy != null:
		move_speed = enemy.walk_speed

func reset_values():
	move_direction = Vector2.RIGHT
	wander_time = 2.5
	move_down_time = 1.5
	move_downwards = !move_downwards
	pass

func enter():
	reset_values()

func update(delta : float):
	if wander_time > 0:
		wander_time -= delta
	else:
		move_down(delta)
	pass

func move_down(delta : float):
	if move_downwards:
		move_direction = Vector2.DOWN
	else:
		move_direction = Vector2.UP
	move_down_time -= delta
	if move_down_time <= 0:
		reset_values()

func physics_update(delta : float):
	if enemy:
		enemy.movement(move_direction, move_speed)
		enemy.handle_animation(enemy.animation_player, "move_", true)
