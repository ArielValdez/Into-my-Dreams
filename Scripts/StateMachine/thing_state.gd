extends State

class_name ThingState

@export var enemy : Enemy
@export var animation_player : AnimationPlayer

func enter() -> void:
	if enemy != null:
		enemy.die_on_stab = false
	
	Manager.got_stabbed.connect(_get_stabbed_change_animation)
	pass

func exit() -> void:
	if Manager.got_stabbed.is_connected(_get_stabbed_change_animation):
		Manager.got_stabbed.disconnect(_get_stabbed_change_animation)
	pass

func update(delta : float) -> void:
	pass

func physics_update(delta : float) -> void:
	pass

func _get_stabbed_change_animation():
	if animation_player != null:
		animation_player.play("stabbed")
	
	if Manager.got_stabbed.is_connected(_get_stabbed_change_animation):
		Manager.got_stabbed.disconnect(_get_stabbed_change_animation)
