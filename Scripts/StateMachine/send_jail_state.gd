extends State

@export var world : WorldScene
@export var enemy : Enemy
@export var hitbox : Area2D
@export var sprite_texture : Texture2D
@export var run_speed : float = 150
@export var distance_detection_player : float = 300
@export var idle_start : float = 1
@export var idle_end : float = 2
@export var walk_start : float = 1
@export var walk_end : float = 3

var move_direction : Vector2 = Vector2(0, 0).normalized()
var player : PlayerCharacter

var wander_time : float
var idle_time : float

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

func enter() -> void:
	if world == null:
		world = get_parent().get_parent().get_parent()
	
	if sprite_texture != null and enemy != null:
		enemy.sprite.texture = sprite_texture
	
	move_direction = Vector2(0, 0).normalized()
	player = Manager.player_character
	
	if Manager.got_to_jail.is_connected(_send_to_jail):
		Manager.got_to_jail.disconnect(_send_to_jail)
	
	Manager.got_to_jail.connect(_send_to_jail)
	pass

func exit() -> void:
	var default_sprite : Texture2D = load("res://Sprites/Characters/NCP/self_depreciation.png")
	enemy.sprite.texture = default_sprite

func update(delta : float) -> void:
	if player != null:
		var pos_direction = player.position - enemy.position
		if pos_direction.length() <= distance_detection_player:
			move_direction = Vector2(pos_direction.x, pos_direction.y).normalized()
		else:
			if wander_time > 0:
				wander_time -= delta
			else:
				_to_await_random(delta)
	else:
		if wander_time > 0:
			wander_time -= delta
		else:
			_to_await_random(delta)

func physics_update(delta : float) -> void:
	enemy.movement(move_direction, run_speed)
	enemy.handle_animation(enemy.animation_player, "walk_", true)
	pass

func _send_to_jail(body : PlayerCharacter) -> void:
	if hitbox != null:
		if body.get_collision_layer_value(hitbox.collision_mask):
			var rng : RandomNumberGenerator = RandomNumberGenerator.new()
			
			var jails : Array[Jail]
			
			if world != null and world.jails != null:
				jails = world.jails.jails
				
				var num : int = rng.randi_range(0, jails.size() - 1)
				var jail_position : Vector2 = jails[num].position
				# teleport player
				
				TransitionScene.transition()
				await TransitionScene.on_transition_finished
				
				body.position = jail_position
			else:
				print_debug('no world to send jail')
	pass
