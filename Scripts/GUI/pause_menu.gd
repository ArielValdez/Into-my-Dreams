extends Control

var is_paused : bool = false
var on_main_menu : bool = true
@onready var button : Button = $MarginContainer/VBoxContainer/Effects

func _init() -> void:
	visible = false
	Manager.pause_menu = self
	pass

func _process(delta : float) -> void:
	if not Manager.effect_menu.on_effects_menu:
		input_pause_menu()

func pause():
	if !on_main_menu:
		visible = true
		is_paused = true
		get_tree().paused = true
		
		if button.has_method("grab_focus"):
			button.grab_focus()
		else:
			print_debug("button needs gran_focus function")
		pass

func resume():
	visible = false
	is_paused = false
	get_tree().paused = false
	pass

func input_pause_menu():
	if Input.is_action_just_pressed("pause_menu") and not is_paused:
		pause()
	elif (Input.is_action_just_pressed("pause_menu") or Input.is_action_just_pressed("run_button")) and is_paused:
		resume()
	pass

func _on_effects_pressed():
	visible = false
	Manager.effect_menu.visible = true
	Manager.effect_menu.on_effects_menu = true
	Manager.effect_menu.button.grab_focus()
	pass

func _on_resume_pressed():
	resume()
	pass


func _on_quit_pressed():
	# here, we should call another window to confirm or deny, then quit or not given de input
	get_tree().quit(0)
