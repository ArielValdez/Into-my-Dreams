extends Node2D

class_name Door
var generic_name : String = "Doorway"

@onready var sprite : Sprite2D = $Sprite2D
@onready var player_character : CharacterBody2D = $"../PlayerCharacter"

@export var texture : Texture2D
@export var TargetWorld : String

#private
var spawn_player_at : Vector2
var manager : SceneManager

func _ready() -> void:
	sprite.texture = texture
	player_character.Interact.connect(CrossDoorForNextWorld)
	manager = get_tree().get_root().get_child(0)
	manager.new_scene = load("res://Scenes/Worlds/" + TargetWorld + ".tscn")
	
	pass

func CrossDoorForNextWorld(pressedInteract : bool) -> void:
	# play animation for enter door
	
	if pressedInteract and player_character.IsAtDoor:
		var world = manager.new_scene.instantiate()
		var next_door : Door
		for item in world.get_children():
			if item.name.contains("WorldDoorway"):
				next_door = item
		
		get_tree().get_root().get_child(1).queue_free()
		get_tree().get_root().add_child(world)
		
		spawn_player_at = next_door.position + Vector2(0, 32)
		world.get_node("PlayerCharacter").position = spawn_player_at
		#get_tree().change_scene_to_file("res://Scenes/Worlds/" + TargetWorld + ".tscn")
	pass


func _on_interaction_zone_body_entered(body : Node2D):
	if body.name == "PlayerCharacter":
		player_character.IsAtDoor = true
		pass
	pass


func _on_interaction_zone_body_exited(body : Node2D):
	if body.name == "PlayerCharacter":
		player_character.IsAtDoor = false
		pass
	pass
