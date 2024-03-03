extends Node2D

@export var next_scene_name : String
@export var scene_id : int
@export var spawn_player_at : Vector2

signal go_to_next_scene

func _ready() -> void:
	#go_to_next_scene.emit("on_level_change", self, GetToNextScene)
	pass

func _process(delta : float) -> void:
	GetToNextScene(Manager.new_scene)
	pass

func GetToNextScene(new_scene : PackedScene) -> void:
	if Manager.player_character.IsAtDoor:
		var world : Node = new_scene.instantiate()
		
		get_tree().get_root().get_child(2).remove_child(Manager.player_character)
		
		world.add_child(Manager.player_character)
		
		get_tree().get_root().add_child(world)
		
		get_tree().get_root().get_child(2).free()
		
		Manager.player_character.position = Manager.spawn_player_at
	pass


func _on_area_2d_body_entered(body):
	if body.name == "PlayerCharacter":
		if !Manager.player_character.IsAtDoor:
			
			Manager.target_world =  next_scene_name
			Manager.target_world_door_id = scene_id
			Manager.load_scene()
			
			Manager.player_character.IsAtDoor = true
			
			Manager.spawn_player_at = spawn_player_at
			print_debug("on body entered signal: " + str(Manager.spawn_player_at))
	pass


func _on_area_2d_body_exited(body):
	if body.name == "PlayerCharacter":
		Manager.player_character.IsAtDoor = false
		pass
	pass
