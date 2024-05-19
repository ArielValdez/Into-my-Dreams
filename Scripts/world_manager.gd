extends Node2D

class_name WorldScene

@onready var tilemap : TileMap = get_node("TileMap")
@onready var EventTimer : Timer = $WorldEventTimer

@export var WorldEvents : Array[WorldEvent]
@export var Panoram : Image
@export var EventsAreByTimer : bool
@export var is_looping_world : bool = false
@export var get_rid_rain_effect : bool = true
@export var enabled_camera_for_scene : bool = false
@export var camera_limit_off_set : Vector2
@export var camera_zero_off_set_limit : Vector2
@export var world_music : AudioStream
@export var rain_effect : PackedScene
@export var jails : JailManager

var rng : RandomNumberGenerator

func _ready() -> void:
	if jails != null:
		jails.jails = _get_jail_children()
	
	# send level music
	
	Manager.resize_camera_limit.emit(self)
	Manager.pause_menu.on_main_menu = false

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

func _get_jail_children() -> Array[Jail]:
	var jail_children : Array[Jail]
	for item in jails.get_children():
		if item is Jail:
			print_debug(item.name)
			jail_children.append(item)
	
	print_debug(jail_children.size())
	
	return jail_children
