extends Node2D

@onready var hitbox : Area2D = $Area2D

var go_to_save : bool = false

func _ready():
	Manager.got_to_saving.connect(_go_to_save)

func _go_to_save(action_pressed : bool):
	if go_to_save and action_pressed:
		Manager.pause_menu.can_pause = false
		
		TransitionScene.transition()
		await TransitionScene.on_transition_finished
		
		Manager.save_menu.on_save_menu = true
		Manager.save_menu.visible = true
		Manager.save_menu.button.grab_focus()

func _on_area_2d_body_entered(body):
	if body.has_method("get_collision_layer_value"):
		if body.get_collision_layer_value(hitbox.collision_mask):
			go_to_save = true
		else:
			print_debug("body name: " + body.name)


func _on_area_2d_body_exited(body):
	if body.has_method("get_collision_layer_value"):
		if body.get_collision_layer_value(hitbox.collision_mask):
			go_to_save = false
		else:
			print_debug("body name: " + body.name)
