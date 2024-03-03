extends GridContainer

@export var active_effects : Array[ActiveEffect]
@export var button_size : Vector2
var container : GridContainer = self

func _ready():
	# get the number of effects that exists then change the count of the array to it
	# all effects except tutorial should be put as inactive
	load_active_effects()
	pass

func load_active_effects():
	#load active effects with load in gridContainer with buttons
	for item in active_effects:
		if item.is_active:
			var button : Button = Button.new()
			button.text = YumeEffects.Value.keys()[item.effect]
			button.set_custom_minimum_size(button_size)
			
			# should add a script for each button function per button
			# check for performances issues
			# button.set_script("res://Scripts/GUI/effect_button.gd")
			
			# connect pressed signal with the script
			if Manager.has_method("character_effect"):
				button.pressed.connect(Callable(Manager.character_effect).bind(item.effect))
			
			container.add_child(button)
			
			# sort children in the order of enum YumeEffects.Value
	pass
