extends Button

func _ready() -> void:
	call_deferred("grab_focus")
	grab_focus()
	pass
