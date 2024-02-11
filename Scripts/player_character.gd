extends Movement

class_name PlayerCharacter

var Direction : Vector2
var PlayersCamera : Camera2D
var IsAtDoor : bool = false

signal Interact

var character_name : String = "Yume"

@onready var playerAnimations : AnimationPlayer = $AnimationPlayer
@onready var player_sprite : Sprite2D = $Sprite2D
@onready var player_hitbox : CollisionShape2D = $CollisionShape2D

func _init():
	Manager.player_character = self
	pass

func _ready() -> void:
	super.get_sprite_from_body(player_sprite)
	pass

func _physics_process(delta : float) -> void:
	handleCollission()
	character_movement()
	super.process_movement(current_speed)
	pass

func _process(delta : float) -> void:
	# character_tiled_movement()
	pass

func handleCollission() -> void:
	var collission : KinematicCollision2D
	var collider : Object
	for i in get_slide_collision_count():
		collission = get_slide_collision(i)
		collider = collission.get_collider()
	pass

func character_movement() -> void:
	current_speed = walk_speed
	if Input.is_action_pressed("run_button"):
		current_speed = run_speed
	
	Direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
		
	super.handle_animation(playerAnimations)
	super.movement(Direction, current_speed)

func character_tiled_movement() -> void:
	current_speed = tile_based_walk_speed
	if Input.is_action_pressed("run_button"):
		current_speed = tile_based_run_speed
	
	if Input.is_action_pressed("move_left"):
		Direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		Direction = Vector2.RIGHT
	elif Input.is_action_pressed("move_up"):
		Direction = Vector2.UP
	elif Input.is_action_pressed("move_down"):
		Direction = Vector2.DOWN
	else:
		Direction = Vector2.ZERO
	
	super.handle_animation(playerAnimations)
	super.tile_based_movement(Direction, current_speed)
	pass

func interact_input() -> bool:
	return Input.is_action_just_pressed("accept_button")
