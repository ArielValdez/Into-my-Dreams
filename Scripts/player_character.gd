extends Movements

class_name PlayerCharacter

var Direction : Vector2
var PlayersCamera : Camera2D
var IsAtDoor : bool = false
var IsSleeping : bool = false
var CanMove : bool = true
var character_name : String = "Yume"
var anim_name : String = ""

@export var current_effect : YumeEffects.Value = YumeEffects.Value.Regular

@onready var playerAnimations : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var player_hitbox : CollisionShape2D = $CollisionShape2D
@onready var timer_for_sleep : Timer = $TriggerTimer

var start_walk_speed : float
var start_run_speed : float

func _init():
	# should be called just once
	Manager.player_character = self
	pass

func _ready() -> void:
	start_walk_speed = walk_speed
	start_run_speed = run_speed
	super.get_sprite_from_body(sprite)
	pass

func _physics_process(delta : float) -> void:
	handleCollission()
	character_movement()
	super.process_movement(current_speed)
	pass

func _input(event : InputEvent) -> void:
	if IsSleeping:
		if event.is_action_pressed("wake_up"):
			Manager.sleep_or_wake_up_next_scene()
			IsSleeping = false
			pass
	pass

func handleCollission() -> void:
	if !CanMove:
		var collission : KinematicCollision2D
		var collider : Object
		for i in get_slide_collision_count():
			collission = get_slide_collision(i)
			collider = collission.get_collider()
	pass

func character_movement() -> void:
	if CanMove:
		var animation : String = "walk_"
		current_speed = walk_speed
		
		if Input.is_action_pressed("run_button"):
			animation = "walk_"
			current_speed = run_speed
		
		animation += anim_name
		
		Direction = Input.get_vector(
			"move_left",
			"move_right",
			"move_up",
			"move_down"
		)
			
		super.handle_animation(playerAnimations, animation)
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
	
	super.handle_animation(playerAnimations, "walk_")
	super.tile_based_movement(Direction, current_speed)
	pass

func interact_input() -> bool:
	return Input.is_action_just_pressed("accept_button")
