extends CanvasLayer

signal on_transition_finished

@onready var color_rect : ColorRect = $ColorRect
@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _ready():
	#color_rect.visible = false
	anim_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name : String) -> void:
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		anim_player.play("fade_out")
		get_tree().paused = false
		pass
	elif anim_name == "fade_out":
		#color_rect.visible = false
		pass
	else:
		#color_rect.visible = false
		get_tree().paused = false
		pass
	pass

func transition(anim : String = "fade_to_black") -> void:
	#color_rect.visible = true
	get_tree().paused = true
	anim_player.play(anim)
	pass
