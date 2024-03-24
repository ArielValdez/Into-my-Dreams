extends Movements

@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var held_effect : ActiveEffect
var in_range : bool = false

func _ready() -> void:
	Manager.connect("collected_effect_from_npc", send_effect)
	print_debug("")
	print_debug(YumeEffects.Value.keys()[held_effect.effect])
	print_debug("")
	pass

func _input(event):
	if event.is_action_pressed("accept_button"):
		Manager.collected_effect_from_npc.emit(in_range, held_effect)

# connected signals
func _on_area_2d_body_entered(body : Node2D) -> void:
	if body.name == "PlayerCharacter":
		in_range = true
	pass

func _on_area_2d_body_exited(body : Node2D) -> void:
	if body.name == "PlayerCharacter":
		in_range = false
	pass

func send_effect(in_range : bool, effect : ActiveEffect):
	Manager.player_character.collect_effect(in_range, effect, self)
	pass
