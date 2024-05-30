extends GridContainer

@export var button_size : Vector2

var active_effects : Array[ActiveEffect]
var container : GridContainer = self
var player_character : CharacterBody2D
var path_of_effects : String = "res://Resources/Effects"

func _init():
	var dir = DirAccess.open(path_of_effects)
	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name.contains(".tres"):
			var resource : ActiveEffect = load(path_of_effects + "/" + file_name)
			if resource.effect == YumeEffects.Value.Tutorial:
				resource.is_active = true
			
			active_effects.append(resource)
			file_name = dir.get_next()
			pass
		pass
	pass

func _ready():
	# get the number of effects that exists then change the count of the array to it
	# all effects except tutorial should be put as inactive
	Manager.connect("effect_collected", obtain_new_effect)
	_load_effects()
	pass

func obtain_new_effect(effect : ActiveEffect, activate_effect : bool = true):
	_load_active_effects(effect, activate_effect)
	# play animation saying "new effect gotten" from a new GUI
	
	pass

func _load_active_effects(effect : ActiveEffect, effect_is_activated : bool = false):
	#load active effects with load in gridContainer with buttons
	if Manager.player_character.player_collected_effects.any(func(items: ActiveEffect): items.effect == effect.effect and effect.is_active):
		Manager.player_character.player_collected_effects.append(effect)
	if !active_effects.any(func(items: ActiveEffect): items.effect == effect.effect):
		remove_children()
		
		for item in active_effects:
			if item.effect == effect.effect:
				item.is_active = effect_is_activated
			
			if item.is_active:
				item.has_been_activated = effect_is_activated
				
				var button : Button = Button.new()
				button.text = YumeEffects.Value.keys()[item.effect]
				button.set_custom_minimum_size(button_size)
				# connect pressed signal with the script
				button.pressed.connect(Callable(Manager.character_effect).bind(item))
				container.add_child(button)
				
				Manager.effect_menu.button = container.get_child(0)
				Manager.effect_menu.button.grab_focus()
	pass

func _load_effects():
	for item in active_effects:
		if item.is_active and item.has_been_activated:
			var button : Button = Button.new()
			button.text = YumeEffects.Value.keys()[item.effect]
			button.set_custom_minimum_size(button_size)
			# connect pressed signal with the script
			button.pressed.connect(Callable(Manager.character_effect).bind(item))
			container.add_child(button)
			
			Manager.effect_menu.button = container.get_child(0)
			Manager.effect_menu.button.grab_focus()

func remove_children():
	for item in container.get_children():
		container.remove_child(item)
