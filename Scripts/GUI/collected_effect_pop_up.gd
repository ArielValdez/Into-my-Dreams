extends Control

var on_pop_up : bool = false
@onready var timer : Timer = $Timer

func _init() -> void:
	visible = false
	pass

func _ready():
	Manager.got_effect_pop_up.connect(input_for_menu)
	Manager.effect_pop_up = self
	pass

func _input(event):
	if Input.is_action_just_pressed("accept_button"):
		Manager.got_effect_pop_up.emit()

func input_for_menu():
	if on_pop_up:
		timer.start(1.5)
		await timer.timeout
		
		visible = false
		get_tree().paused = false
		on_pop_up = false
	pass
