extends Node

@export var parent : Node2D 
@export var object : Node2D
@export var world_boundaries : TileMap

func _ready() -> void:
	octicate()

# Coding Kook's logic
func octicate() -> void:
	if object != null:
		if world_boundaries != null:
			var size_of_world : Vector2 = Manager.get_world_size(world_boundaries)
			
			var dup_platform_positions = [
				object.position + Vector2(size_of_world.x, size_of_world.y),
				object.position + Vector2(size_of_world.x, 0),
				object.position + Vector2(0, size_of_world.y),
				object.position + Vector2(-size_of_world.x, size_of_world.y),
				object.position + Vector2(-size_of_world.x, 0),
				object.position + Vector2(-size_of_world.x, -size_of_world.y),
				object.position + Vector2(0, -size_of_world.y),
				object.position + Vector2(size_of_world.x, -size_of_world.y),
			]
			
			for platform_pos in dup_platform_positions:
				_dup_object(platform_pos)
		else:
			print_debug("a tile map is needed for this operation.")
	pass

func octitate_tile_map() -> void:
	if object is TileMap:
		pass
	pass

func _dup_object(pos : Vector2):
	var new_object : Node2D = object.duplicate()
	new_object.position = pos
	
	call_deferred("_add_child_to_parent", new_object)
	pass

func _add_child_to_parent(obj : Node2D):
	parent.add_child(obj)
