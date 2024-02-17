extends Node2D

@export var next_scene_name : String
@export var scene_id : int
@export var spawn_player_at : Vector2

func _process(delta : float) -> void:
	GetToNextScene(Manager.new_scene)
	pass

func GetToNextScene(new_scene : PackedScene) -> void:
	if Manager.player_character.IsAtDoor:
		var world : Node = new_scene.instantiate()
		
		get_tree().get_root().get_child(1).remove_child(Manager.player_character)
		
		get_tree().get_root().add_child(world)
		
		get_tree().get_root().get_child(1).free()
		
		world.add_child(Manager.player_character)
		Manager.player_character.position = spawn_player_at
		
		Manager.player_character.IsAtDoor = false
	pass


func _on_area_2d_body_entered(body):
	if body.name == "PlayerCharacter":
		if !Manager.player_character.IsAtDoor:
			
			Manager.target_world =  next_scene_name
			Manager.target_world_door_id = scene_id
			Manager.load_scene()
			
			Manager.player_character.IsAtDoor = true
	pass


func _on_area_2d_body_exited(body):
	if body.name == "PlayerCharacter":
		Manager.player_character.IsAtDoor = false
		pass
	pass
