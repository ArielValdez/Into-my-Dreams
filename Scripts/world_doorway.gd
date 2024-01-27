extends Node2D

class_name Door

@export var OtherSide : PackedScene

signal DoorEntered

func _ready() -> void:
	if OtherSide == null:
		var scene = load("res://Scenes/Worlds/world_1.tscn")
		if scene is PackedScene:
			OtherSide = scene
		pass

func CrossDoorForNextWorld() -> void:
	# play animation for enter door

	get_tree().change_scene_to_packed(OtherSide)
	pass


func _on_interaction_zone_body_entered(body : Node2D):
	if body.name == "PlayerCharacter":
		if body.has_method("interact_input"):
			DoorEntered.emit(true)
			CrossDoorForNextWorld()
		pass
	pass


func _on_interaction_zone_body_exited(body : Node2D):
	DoorEntered.emit(false)
	pass
