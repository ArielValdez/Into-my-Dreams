extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = { }


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state != null:
		initial_state.enter()
		current_state = initial_state
	pass

func _process(delta : float) -> void:
	if current_state:
		current_state.update(delta)
		pass
	pass

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
		pass
	pass

func on_child_transition(state : State, new_state_name : String):
	if state == current_state:
		var new_state = states.get(new_state_name.to_lower())
		
		if new_state != null:
			if current_state != null:
				current_state.exit()
			
			new_state.enter()
			current_state = new_state
		pass
	pass
