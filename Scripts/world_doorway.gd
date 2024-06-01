extends Node2D

class_name Door

@onready var sprite : Sprite2D = $Sprite2D

@export var texture : Texture2D
@export var TargetWorld : String
@export var ID : int

#private
var spawn_player_at : Vector2

func _ready() -> void:
	sprite.texture = texture
	Manager.open_door.connect(_cross_door)
	pass

func _cross_door(pressed_interact : bool) -> void:
	#call_deferred("cross_door_for_next_world", pressed_interact)
	cross_door_for_next_world(pressed_interact)
	pass

func cross_door_for_next_world(pressedInteract : bool) -> void:
	if pressedInteract and Manager.player_character.IsAtDoor:
		Manager.load_scene()
		var world : Node2D = Manager.new_scene.instantiate()
		
		var next_door : Door
		for item in world.get_children():
			if item.name.contains("WorldDoorway"):
				if item.ID == Manager.target_world_door_id:
					next_door = item
					break
		
		TransitionScene.transition()
		await TransitionScene.on_transition_finished
		
		get_tree().get_root().get_child(4).remove_child(Manager.player_character)
		world.add_child(Manager.player_character)
		get_tree().get_root().add_child(world)
		get_tree().get_root().get_child(4).free()
		
		spawn_player_at = next_door.position + Vector2(0, 32)
		Manager.player_character.position = spawn_player_at
		
	pass


func _on_interaction_zone_body_entered(body : Node2D):
	if body is PlayerCharacter:
		Manager.target_world = TargetWorld
		Manager.target_world_door_id = ID
		Manager.player_character.IsAtDoor = true
		
		print_debug(Manager.target_world)
	pass


func _on_interaction_zone_body_exited(body : Node2D):
	if body is PlayerCharacter:
		Manager.player_character.IsAtDoor = false
		Manager.new_scene = null
		pass
	pass
