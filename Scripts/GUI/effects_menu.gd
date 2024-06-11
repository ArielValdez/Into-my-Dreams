class_name EffectsMenu
extends Control

var button : Button
var on_effects_menu : bool = false

func _init() -> void:
	visible = false
	Manager.effect_menu = self
	pass

func _process(delta : float) -> void:
	if on_effects_menu:
		return_to_pause_menu()
	pass

func return_to_pause_menu():
	if Input.is_action_just_pressed("run_button"):
		visible = false
		get_tree().paused = true
		Manager.effect_menu.on_effects_menu = false
		Manager.pause_menu.visible = true
		Manager.pause_menu.button.grab_focus()
	elif Input.is_action_just_pressed("pause_menu"):
		visible = false
		Manager.effect_menu.on_effects_menu = false
		get_tree().paused = false

