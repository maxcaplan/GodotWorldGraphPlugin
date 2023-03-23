@tool
extends Node2D

var node_graph_resource : NodeGraph

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)

		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			print("Right button was clicked at ", event.position)

		if event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
			print("Middle button was clicked at ", event.position)



