extends Node2D

class_name Door

@export var TargetWorld : String

func _ready() -> void:
	pass

func CrossDoorForNextWorld() -> void:
	# play animation for enter door

	get_tree().change_scene_to_file("res://Scenes/Worlds/" + TargetWorld + ".tscn")
	pass


func _on_interaction_zone_body_entered(body : Node2D):
	if body.name == "PlayerCharacter":
		# body.IsAtDoor = true
		pass
	pass


func _on_interaction_zone_body_exited(body : Node2D):
	if body.name == "PlayerCharacter":
		# body.IsAtDoor = false
		pass
	pass
