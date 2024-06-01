extends Node2D

class_name WorldScene

@onready var tilemap : TileMap = get_node("TileMap")
@onready var EventTimer : Timer = $WorldEventTimer

@export var frame_limit : int = 30
@export var WorldEvents : Array[WorldEvent]
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
var has_rain : bool = false
var is_event_spawning : bool = false
var event_fail_timer : float = 60

func _init() -> void:
	Engine.max_fps = frame_limit

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	
	if jails != null:
		jails.jails = _get_jail_children()
	
	if Manager.player_character != null:
		for item in Manager.player_character.get_children():
			if item is RainParticles:
				has_rain = true
				if get_rid_rain_effect:
					Manager.player_character.remove_child(item)
		
		if rain_effect != null && !has_rain:
			Manager.player_character.add_child(rain_effect.instantiate())
	
	# send level music
	
	Manager.resize_camera_limit.emit(self)
	Manager.pause_menu.on_main_menu = false

func _process(delta : float) -> void:
	await get_tree().process_frame
	spawn_world_events_by_timer()

func _exit_tree():
	pass

func spawn_world_events_by_timer():
	if !is_event_spawning and WorldEvents != null:
		for event in WorldEvents:
			if (rng.randf() <= event.Chance):
				WorldEvents.erase(event)
				EventTimer.start(event.ThisEventTick)
				
				is_event_spawning = true
				await EventTimer.timeout
				is_event_spawning = false
				
				# spawn event into scene
				var event_spawned : Node2D = event.spawned_event.instantiate()
				event_spawned.position = event.Coordinates
				add_child(event_spawned)
			else:
				EventTimer.start(event_fail_timer)
				
				is_event_spawning = true
				await EventTimer.timeout
				is_event_spawning = false

func _get_jail_children() -> Array[Jail]:
	var jail_children : Array[Jail]
	for item in jails.get_children():
		if item is Jail:
			print_debug(item.name)
			jail_children.append(item)
	
	print_debug(jail_children.size())
	
	return jail_children
