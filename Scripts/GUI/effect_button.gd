extends Button

var this_button_effect : YumeEffects.Value

# should create a signal per button, so to change the appearence of the character
func character_effect(effect: YumeEffects.Value):
	match effect:
		YumeEffects.Value.Tutorial:
			print_debug("Tutorial button was pressed")
			pass
		YumeEffects.Value.Regular:
			print_debug("Regular button was pressed")
			pass
		YumeEffects.Value.Dream:
			print_debug("Dream button was pressed")
			pass
		_: # effect does not exist
			print_debug("you should not be here...")
			Manager.player_character.walk_speed = Manager.player_character.start_walk_speed
			Manager.player_character.run_speed = Manager.player_character.start_run_speed
	pass
