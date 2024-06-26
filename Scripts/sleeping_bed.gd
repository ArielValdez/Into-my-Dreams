extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collision_bed : CollisionShape2D = $StaticBody2D/CollisionShape2D

@export var time_sleep : float = 5 # in seconds

var tween : Tween = null
var player_on_bed : bool = false
var player_can_interact : bool = false
var player_interacted : bool = false
# like yume nikki, this should be a bed to transport to another area, but radomly between beds
var is_teleport_bed : bool = false 
var player_position : Vector2

func _input(event : InputEvent) -> void:
	if player_can_interact:
		if event.is_action_pressed("accept_button"):
			player_interacted = true
			if !player_on_bed:
				player_position = Manager.player_character.position
				collision_bed.disabled = true
				
				Manager.player_character.CanMove = false
				Manager.player_character.position = self.position + Vector2(0, 24)
				Manager.player_character.playerAnimations.play("walk_left")
				Manager.player_character.playerAnimations.stop()
				
				player_on_bed = !player_on_bed
				
				Manager.player_character.timer_for_sleep.start(time_sleep)
				
				tween = get_tree().create_tween()
				tween.tween_callback(transfer).set_delay(time_sleep)
				
				#await Manager.player_character.timer_for_sleep.timeout
				#transfer()
				
				pass
			else:
				collision_bed.disabled = false
				
				Manager.player_character.CanMove = true
				Manager.player_character.position = player_position
				Manager.player_character.IsSleeping = false
				
				player_on_bed = !player_on_bed
				
				Manager.player_character.timer_for_sleep.stop()
				if tween != null:
					tween.kill()
				pass
	pass

func transfer():
	Manager.sleep_or_wake_up_next_scene()
	Manager.player_character.IsSleeping = true

func _on_interaction_zone_body_entered(body : Node2D) -> void:
	if body.name == "PlayerCharacter":
		player_can_interact = true
	pass


func _on_interaction_zone_body_exited(body : Node2D) -> void:
	if body.name == "PlayerCharacter":
		player_can_interact = false
	pass # Replace with function body.
