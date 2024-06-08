extends Node2D

@onready var hitbox : Area2D = $Area2D
@onready var end_screen_screen : Resource = preload("res://Scenes/GUI/end_screen.tscn")
@onready var main_menu : Resource = preload("res://Scenes/GUI/main_menu.tscn")

var go_to_end_credits : bool = false

func _ready():
	Manager.got_end_credits.connect(go_to_end_credit)

func go_to_end_credit(action_pressed : bool):
	if go_to_end_credits and action_pressed:
		TransitionScene.transition()
		await TransitionScene.on_transition_finished
		
		get_tree().get_root().get_child(4).remove_child(Manager.player_character)
		get_tree().get_root().add_child(end_screen_screen.instantiate())
		get_tree().get_root().get_child(4).free()
		
		Manager._transfer()

func _on_area_2d_body_entered(body) -> void:
	if body.has_method("get_collision_layer_value"):
		if body.get_collision_layer_value(hitbox.collision_mask):
			go_to_end_credits = true
		else:
			print_debug("body name: " + body.name)

func _on_area_2d_body_exited(body) -> void:
	if body.has_method("get_collision_layer_value"):
		if body.get_collision_layer_value(hitbox.collision_mask):
			go_to_end_credits = false
		else:
			print_debug("body name: " + body.name)
