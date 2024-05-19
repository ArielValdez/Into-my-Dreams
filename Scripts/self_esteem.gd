extends Enemy
class_name SelfEsteem

func _init() -> void:
	sprite = $Sprite2D

func _on_area_2d_collider_body_entered(body : Node2D):
	if body is PlayerCharacter:
		Manager.got_to_jail.emit(body)



func _on_area_2d_collider_body_exited(body : Node2D):
	pass # Replace with function body.
