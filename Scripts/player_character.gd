extends Movement

class_name PlayerCharacter

var Direction : Vector2
var PlayersCamera : Camera2D

var IsAtDoor : bool = false

@onready var playerAnimations : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	handleCollission()
	character_movement()
	pass

func handleCollission() -> void:
	var collission : KinematicCollision2D
	var collider : Object
	for i in get_slide_collision_count():
		collission = get_slide_collision(i)
		collider = collission.get_collider()
	pass

func character_movement() -> void:
	var current_speed : float = walk_speed
	if Input.is_action_pressed("run_button"):
		current_speed = run_speed
	
	Direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	
	velocity = current_speed * Direction
	
	super.handle_animation(playerAnimations)
	super.movement()

func interact_input() -> void:
	if Input.is_action_just_pressed("accept_button"):
		
		pass
