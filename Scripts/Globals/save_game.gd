extends Node
class_name SaveGame

const SAVE_PATH_FOR_GAME : String = "user://save"

# Limiting save files to an array of files
#var slots
@export var active_effects : Array[ActiveEffect]

func save_game() -> void:
	var file : FileAccess = FileAccess.open(SAVE_PATH_FOR_GAME, FileAccess.WRITE)
	
	if file != null:
		var content : String
		var data : Dictionary 
		var inner_data : Array = []
		
		for effect in active_effects:
			inner_data.append({
					"ID": effect.ID,
					"effect": effect.YumeEffects.Value,
					"is_active": effect.is_active,
					"has_been_activated": effect.has_been_activated,
					"can_use_outside_dream": effect.can_use_outside_dream,
					"description_of_effect": effect.description_of_effect
				})
		if inner_data != null:
			data = { "ActiveEffects": inner_data }
			content = JSON.stringify(data)
			
			file.store_string(content)
			
			file.flush()
			file.close()
			file = null
			
			data.clear()
			inner_data.clear()
	else:
		var error : Error = FileAccess.get_open_error()
		printerr("File error " + str(error))

func load_game() -> void:
	var file : FileAccess = FileAccess.open(SAVE_PATH_FOR_GAME, FileAccess.READ)
	
	if file != null:
		var content : String = file.get_as_text()
		file.close()
		file = null
		
		var json : JSON = JSON.new()
		var error : Error = json.parse(content)
		
		if error != OK:
			printerr("Parsing json error " + str(error))
			printerr(json.get_error_message())
			printerr(json.get_error_line())
		else:
			# func(items: ActiveEffect): items.effect == effect.effect and effect.is_active
			var data : Array[ActiveEffect] = JSON.parse_string(json.get_parsed_text())
			if data != null:
				for effect in active_effects:
					for d in data:
						if effect.ID == d.ID:
							effect.can_use_outside_dream = d.can_use_outside_dream
							effect.has_been_activated = d.has_been_activated
							effect.is_active = d.is_active
			else:
				printerr("Failed to load saved data.")
		json = null
	else:
		var error : Error = FileAccess.get_open_error()
		printerr("File error " + str(error))
