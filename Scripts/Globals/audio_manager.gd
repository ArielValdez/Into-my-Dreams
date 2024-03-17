extends AudioStreamPlayer

signal change_level_music
signal played_sound_effect

@onready var default_level_music : AudioStream
@onready var default_sfx : AudioStream

var currently_played_music : AudioStream

func _ready():
	change_level_music.connect(_on_change_level_music)
	played_sound_effect.connect(_play_sound_effect)
	pass

func _on_change_level_music(level_music : AudioStream):
	currently_played_music = level_music
	pass

func _play_music(music : AudioStream, volume : float = 0.0) -> void:
	if music != null and stream != music:
		stream = music
		volume_db = volume
		play()
	pass

func _play_sound_effect(sfx : AudioStream, volume : float = 0.0):
	var fx_player = AudioStreamPlayer.new()
	
	fx_player.name = "FX_PLAYER"
	fx_player.stream = sfx
	fx_player.volume_db = volume
	add_child(fx_player)
	
	await fx_player.finished
	
	fx_player.queue_free()

func play_level_music():
	_play_music(currently_played_music)
