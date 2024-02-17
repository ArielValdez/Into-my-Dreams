extends Node2D

signal invoke_event

@export var EventTimer : Timer
@export var WorldEvents : Array[WorldEvent]
@export var Panoram : Image
@export var EventsAreByTimer : bool

var rng : RandomNumberGenerator

func _ready() -> void:
	pass

func _process(delta : float) -> void:
	await get_tree().process_frame
	SpawnWorldEventsByTimer()
	pass

func SpawnWorldEventsByTimer():
	if WorldEvents:
		for event in WorldEvents:
			EventTimer.start(event.ThisEventTick)
			
			await EventTimer.timeout
			if (rng.Randf() < event.Chance):
				# spawn event into scene
				
				
				WorldEvents.erase(event)
				pass
	pass

