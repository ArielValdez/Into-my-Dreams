extends Node2D

class_name Door

@onready var sprite : Sprite2D = $Sprite2D
#@onready var player_character : CharacterBody2D = $"../PlayerCharacter"

@export var texture : Texture2D
@export var TargetWorld : String
@export var ID : int

#private
var spawn_player_at : Vector2

func _ready() -> void:
	sprite.texture = texture
	pass

func _process(delta):
	CrossDoorForNextWorld(Manager.player_character.interact_input())
	pass

func CrossDoorForNextWorld(pressedInteract : bool) -> void:
	# play animation for enter door
	
	if pressedInteract and Manager.player_character.IsAtDoor:
		var world : Node = Manager.new_scene.instantiate()
		
		var next_door : Door
		for item in world.get_children():
			if item.name.contains("WorldDoorway"):
				if item.ID == Manager.target_world_door_id:
					next_door = item
					break
		
		get_tree().get_root().get_child(1).queue_free()
		get_tree().get_root().add_child(world)
		#call_deferred("add_child", world)

		spawn_player_at = next_door.position + Vector2(0, 32)
		world.get_node("PlayerCharacter").position = spawn_player_at
		#get_tree().change_scene_to_file("res://Scenes/Worlds/" + TargetWorld + ".tscn")
	pass


func _on_interaction_zone_body_entered(body : Node2D):
	if body.name == "PlayerCharacter":
		Manager.target_world = TargetWorld
		Manager.target_world_door_id = ID
		Manager.load_scene()
		Manager.player_character.IsAtDoor = true
		pass
	pass


func _on_interaction_zone_body_exited(body : Node2D):
	if body.name == "PlayerCharacter":
		Manager.player_character.IsAtDoor = false
		pass
	pass
