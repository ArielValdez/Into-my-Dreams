extends Node2D

@export var OtherSide : Node2D
var ThisSide : Node2D

func _ready() -> void:
	if !OtherSide:
		OtherSide = $"."
	pass
	
	ThisSide = get_tree().current_scene

func CrossDoorForNextWorld() -> void:
	# play animation for enter door
	
	get_tree().change_scene_to_file(OtherSide.get_path())
	pass
