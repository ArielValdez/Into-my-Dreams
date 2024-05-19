extends Movements
class_name Enemy

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

@export var held_effect : ActiveEffect

var in_range : bool = false
var die_on_stab : bool = true

func _ready() -> void:
	Manager.connect("collected_effect_from_npc", send_effect)
	pass

func _input(event):
	if Input.is_action_just_pressed("accept_button"):
		if held_effect != null:
			Manager.collected_effect_from_npc.emit(in_range)

# connected signals
func _on_area_2d_body_entered(body : Node2D) -> void:
	if body.name == "PlayerCharacter":
		in_range = true
		print_debug(in_range)
	pass

func _on_area_2d_body_exited(body : Node2D) -> void:
	if body.name == "PlayerCharacter":
		in_range = false
		print_debug(in_range)
	pass

func send_effect(in_range : bool):
	Manager.player_character.collect_effect(in_range, self)
	pass
