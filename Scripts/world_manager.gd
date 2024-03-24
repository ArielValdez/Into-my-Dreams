extends Node2D

class_name WorldScene

signal invoke_event

@onready var tilemap : TileMap = get_node("TileMap")
@onready var EventTimer : Timer = $WorldEventTimer

@export var WorldEvents : Array[WorldEvent]
@export var Panoram : Image
@export var EventsAreByTimer : bool
@export var rid_rain_effect : bool = true
@export var enabled_camera_for_scene : bool = false
@export var camera_limit_off_set : Vector2
@export var camera_zero_off_set_limit : Vector2
@export var world_music : AudioStream
@export var rain_effect : PackedScene

var rng : RandomNumberGenerator

func _ready() -> void:
	Manager.resize_camera_limit.emit(self)
	Manager.pause_menu.on_main_menu = false

	
	# send level music
	pass

func _process(delta : float) -> void:
	await get_tree().process_frame
	spawn_world_events_by_timer()
	pass

func spawn_world_events_by_timer():
	if WorldEvents:
		for event in WorldEvents:
			EventTimer.start(event.ThisEventTick)
			
			await EventTimer.timeout
			if (rng.Randf() < event.Chance):
				# spawn event into scene
				add_child(event)
				
				WorldEvents.erase(event)
				pass
	pass

