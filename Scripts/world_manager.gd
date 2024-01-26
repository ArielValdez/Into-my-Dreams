extends Node2D

@export var EventTimer : Timer
@export var WorldEvents : Array[WorldEvent]

var rng : RandomNumberGenerator

func _ready() -> void:
	pass

func _process(delta : float) -> void:
	SpawnWorldEvents()
	pass

func SpawnWorldEvents():
	if WorldEvents:
		for event in WorldEvents:
			EventTimer.start(event.ThisEventTick)
			
			await EventTimer.timeout
			if (rng.Randf() < event.Chance):
				# spawn event into scene
				
				
				WorldEvents.erase(event)
				pass
	pass
