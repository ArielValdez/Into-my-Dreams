extends Movements

class_name PlayerCharacter

var Direction : Vector2

var IsAtDoor : bool = false
var IsSleeping : bool = false
var CanMove : bool = true
var has_light : bool = false

var character_name : String = "Yume"
var anim_name : String = ""

@export var current_effect : YumeEffects.Value = YumeEffects.Value.Base

@onready var player_camera : Camera2D = $Camera2D
@onready var playerAnimations : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var player_hitbox : CollisionShape2D = $CollisionBox
@onready var timer_for_sleep : Timer = $TriggerTimer

var light_source : Node2D

@export var start_walk_speed : float
@export var start_run_speed : float

var player_collected_effects : Array[ActiveEffect]

signal interaction_signal

func _init():
	Manager.player_character = self

func _ready() -> void:
	Manager.player_character = self
	
	if start_walk_speed <= 0:
		start_walk_speed = walk_speed
	
	if start_run_speed <= 0:
		start_run_speed = run_speed
	
	super.get_sprite_from_body(sprite)
	pass

func _physics_process(delta : float) -> void:
	handleCollission()
	character_movement()
	pass

func _input(event : InputEvent) -> void:
	if IsSleeping:
		if event.is_action_pressed("wake_up"):
			Manager.sleep_or_wake_up_next_scene()
			IsSleeping = false
			pass
	
	if not IsSleeping:
		if Input.is_action_just_pressed("accept_button"):
			pass
	
	if Input.is_action_just_pressed("effect_action"):
		effect_powers()
	
	if not Manager.effect_pop_up.on_pop_up:
		Manager.open_door.emit(Input.is_action_just_pressed("accept_button"))
	pass

func collect_effect(in_range : bool, ncp : Enemy) -> void:
	if Input.is_action_just_pressed("accept_button"):
		if in_range and ncp.held_effect and !ncp.held_effect.is_active:
			if !player_collected_effects.any(func(items: ActiveEffect): items.effect == ncp.held_effect.effect):
				print_debug("emition")
				print_debug(ncp.name)
				Manager.effect_collected.emit(ncp.held_effect, true)
				
				Manager.effect_pop_up.visible = true
				get_tree().paused = true
				
				Manager.effect_pop_up.on_pop_up = true
			pass
	pass

func handleCollission() -> void:
	if !CanMove:
		#var collission : KinematicCollision2D
		#var collider : Object
		#for i in get_slide_collision_count():
			#collission = get_slide_collision(i)
			#collider = collission.get_collider()
			pass
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

func effect_powers():
	match current_effect:
		YumeEffects.Value.SnowWoman:
			print_debug("Snowwoman transformation")
			pass
		YumeEffects.Value.Killer:
			print_debug("Killer button was pressed")
			pass
		YumeEffects.Value.Demon:
			if light_source != null:
				remove_child(light_source)
				has_light = false
				light_source = null
			else:
				light_source = load("res://Scenes/Effects/demon_fire_ball.tscn").instantiate()
				add_child(light_source)
				has_light = true
			pass
		YumeEffects.Value.Mini:
			print_debug("Mini button was pressed")
			pass
		_: # effect does not exist
			print_debug("No effect for this. Put some sound effect for impossible")
			pass
	pass
