extends State

@export var enemy : Movements
@export var walk_start : float = 40
@export var walk_end : float = 120
@export var walk_speed : float = 120
@export var distance_to_player : float = 100

var time_before_walking : float
var move_direction : Vector2
var camera_rect : Rect2
var player : PlayerCharacter

func _set_values():
	move_direction = Vector2(0, 0).normalized()
	player = Manager.player_character
	pass

func enter():
	time_before_walking = randf_range(walk_start, walk_end)
	print_debug(time_before_walking)
	
	if enemy != null:
		walk_speed = enemy.walk_speed
	
	_set_values()

func update(delta : float):
	if time_before_walking > 0:
		time_before_walking -= delta
	else:
		var pos_direction = player.position - enemy.position
		if pos_direction.length() >= distance_to_player:
			move_direction = Vector2(pos_direction.x, pos_direction.y).normalized()
		else:
			move_direction = Vector2.ZERO
	pass


func physics_update(delta : float):
	if enemy != null:
		if time_before_walking <= 0:
			enemy.movement(move_direction, walk_speed)
