extends Node

class_name SceneManager

var new_scene : PackedScene

func get_this_tree_child(child : String) -> Node:
	var current_scene = new_scene.instantiate()
	var children : Array[Node] = current_scene.get_children()
	var node : Node
	for foundChild in children:
		if foundChild.name == child:
			node = foundChild
	return node
