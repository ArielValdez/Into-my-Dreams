extends Resource
class_name SaveGame

const SAVE_PATH_FOR_GAME : String = "user://imd_"

# Limiting save files to an array of files
#var slots
var active_effects : Array[ActiveEffect]

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

func save_game(file_name : String) -> void:
	var file : FileAccess = FileAccess.open(SAVE_PATH_FOR_GAME + file_name + ".txt", FileAccess.WRITE)
	
	if file != null:
		var content : String
		var data : Dictionary 
		var inner_data : Array = []
		
		for effect in active_effects:
			inner_data.append({
					"ID": effect.ID,
					"effect": effect.effect,
					"is_active": effect.is_active,
					"has_been_activated": effect.has_been_activated,
					"can_use_outside_dream": effect.can_use_outside_dream,
					"description_of_effect": effect.description_of_effect
				})
		if inner_data != null:
			data = { "ActiveEffect": inner_data }
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

func load_game(file_name : String) -> void:
	var file : FileAccess = FileAccess.open(SAVE_PATH_FOR_GAME + file_name + ".txt", FileAccess.READ)
	
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
			var data : Array = json.data["ActiveEffect"]
			if data != null:
				for effect in active_effects:
					for d in data:
						if effect.ID == d.ID:
							effect.is_active = d.is_active
							effect.can_use_outside_dream = d.can_use_outside_dream
							effect.has_been_activated = d.has_been_activated
			else:
				printerr("Failed to load saved data.")
		json = null
	else:
		var error : Error = FileAccess.get_open_error()
		printerr("File error " + str(error))

static func exists_game_file(file_name : String) -> bool:
	var result : bool = false
	var file : FileAccess = FileAccess.open(SAVE_PATH_FOR_GAME + file_name + ".txt", FileAccess.READ)
	
	if file != null and file.to_string() != '':
		result = true
	else:
		var error : Error = FileAccess.get_open_error()
		printerr("File error " + str(error))
	return result

static func delete_game_file(file_name : String) -> void:
	pass
