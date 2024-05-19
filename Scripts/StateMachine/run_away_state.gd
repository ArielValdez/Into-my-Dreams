extends State

@export var enemy : Movements
@export var walk_start : float = 40
@export var walk_end : float = 120
@export var walk_speed : float = 120

var move_direction : Vector2
var player : PlayerCharacter

func _set_values():
	move_direction = Vector2(0, 0).normalized()
	player = Manager.player_character
	pass

func enter():
	if enemy != null:
		walk_speed = enemy.walk_speed
	
	_set_values()

func update(delta : float):
	var pos_direction = enemy.position - player.position
	move_direction = Vector2(pos_direction.x, pos_direction.y).normalized()
	pass


func physics_update(delta : float):
	if enemy != null:
		enemy.movement(move_direction, walk_speed)
