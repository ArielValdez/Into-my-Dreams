extends CharacterBody2D

class_name Movement

@export var walk_speed : float = 500
@export var run_speed : float = 750

func movement() -> void:
	move_and_slide()
	pass

func handle_animation(animationPlayer : AnimationPlayer) -> void:
	if animationPlayer:
		if velocity.length() == 0:
			if animationPlayer.is_playing():
				animationPlayer.stop()
		else:
			var direction = "down"
			if velocity.x < 0:
				direction = "left"
			elif velocity.x > 0:
				direction = "right"
			elif velocity.y < 0:
				direction = "up"
			
			if animationPlayer.has_animation("walk_" + direction):
				animationPlayer.play("walk_" + direction)
	pass
