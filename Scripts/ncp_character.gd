extends Movements

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var held_effect : ActiveEffect
var in_range : bool = false

func _ready() -> void:
	Manager.connect("collected_effect_from_npc", send_effect)
	pass

func _input(event):
	if Input.is_action_just_pressed("accept_button"):
		Manager.collected_effect_from_npc.emit(in_range)

# connected signals
func _on_area_2d_body_entered(body : Node2D) -> void:
	if body.name == "PlayerCharacter":
		in_range = true
	pass

func _on_area_2d_body_exited(body : Node2D) -> void:
	if body.name == "PlayerCharacter":
		in_range = false
	pass

func send_effect(in_range : bool):
	Manager.player_character.collect_effect(in_range, self)
	pass
