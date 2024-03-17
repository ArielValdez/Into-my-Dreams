extends GridContainer

@export var active_effects : Array[ActiveEffect]
@export var button_size : Vector2
var container : GridContainer = self

var player_character : CharacterBody2D

func _ready():
	# get the number of effects that exists then change the count of the array to it
	# all effects except tutorial should be put as inactive
	Manager.connect("effect_collected", obtain_new_effect)
	load_active_effects()
	pass

func _process(delta):
	if Input.is_action_just_pressed("effect_action"):
		var effect : ActiveEffect = ActiveEffect.new()
		effect.is_active = false
		effect.effect = YumeEffects.Value.Killer
		obtain_new_effect(effect, true)
	pass

func obtain_new_effect(effect : ActiveEffect, activate_effect : bool = true):
	load_active_effects(effect, activate_effect)
	# play animation saying "new effect gotten" from a new GUI
	
	pass

func load_active_effects(effect : ActiveEffect = null, effect_is_activated : bool = false):
	#load active effects with load in gridContainer with buttons
	if container.get_child_count() > 0:
		remove_children(container)
	
	for item in active_effects:
		if effect != null and effect_is_activated:
			if item.effect == effect.effect:
				item.is_active = effect_is_activated
		
		if item.is_active:
			var button : Button = Button.new()
			button.text = YumeEffects.Value.keys()[item.effect]
			button.set_custom_minimum_size(button_size)
			
			# connect pressed signal with the script
			if Manager.has_method("character_effect"):
				button.pressed.connect(Callable(Manager.character_effect).bind(item))
			
			container.add_child(button)
	var first_btn : Button = container.get_child(0)
	Manager.effect_menu.button = first_btn
	Manager.effect_menu.button.grab_focus()
	pass

func remove_children(container = self):
	for child in container.get_children():
		container.remove_child(child)
		pass
	pass
