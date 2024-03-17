extends Node2D

@export var next_scene_name : String
@export var scene_id : int
@export var spawn_player_at : Vector2
var is_passing_through : bool = false

signal go_to_next_scene

func _ready() -> void:
	#go_to_next_scene.emit("on_level_change", self, GetToNextScene)
	if !Manager.go_to_next_scene.is_connected(get_to_next_scene):
		Manager.go_to_next_scene.connect(get_to_next_scene)
	else:
		print_debug("signal go_to_next_scene is already connected.")
		print_stack()
	pass

func get_to_next_scene(new_scene : PackedScene) -> void:
	if is_passing_through:
		call_deferred("load_next_scene", new_scene)
	pass

func load_next_scene(new_scene : PackedScene):
	if new_scene != null:
		var world : Node = new_scene.instantiate()
		
		TransitionScene.transition()
		await TransitionScene.on_transition_finished
		
		get_tree().get_root().get_child(4).remove_child(Manager.player_character)
		world.add_child(Manager.player_character)
		get_tree().get_root().add_child(world)
		get_tree().get_root().get_child(4).free()
		
		Manager.player_character.position = Manager.spawn_player_at
	else:
		print_debug("next scene could not be loaded, check next scene name, please.")

func _on_area_2d_body_entered(body : Node2D) -> void:
	if body.name == "PlayerCharacter":
		if !is_passing_through:
			is_passing_through = true
			Manager.target_world =  next_scene_name
			Manager.target_world_door_id = scene_id
			Manager.spawn_player_at = spawn_player_at
			
			Manager.load_scene()
			print_debug("on body entered signal: " + str(Manager.spawn_player_at))
			Manager.go_to_next_scene.emit(Manager.new_scene)
	pass


func _on_area_2d_body_exited(body : Node2D) -> void:
	if body.name == "PlayerCharacter":
		is_passing_through = false
		pass
	pass
