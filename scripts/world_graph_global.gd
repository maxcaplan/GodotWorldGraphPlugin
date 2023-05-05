@tool
extends Node
class_name WorldGraphSingleton

signal node_graph_resource_changed
signal node_graph_resource_refrence_changed

var node_graph_resource : NodeGraph: set = _set_node_graph_resource

func _ready() -> void:
	if node_graph_resource:
		node_graph_resource.changed.connect(_on_node_graph_resource_changed)


func _set_node_graph_resource(value: NodeGraph):
	update_node_graph_resource_signals(node_graph_resource, value)
	node_graph_resource = value
	node_graph_resource_refrence_changed.emit()


func _on_node_graph_resource_changed():
	print("resource changed")
	node_graph_resource_changed.emit()


func update_node_graph_resource_signals(old_resource: NodeGraph, new_resource: NodeGraph):
	if old_resource:
		old_resource.changed.disconnect(_on_node_graph_resource_changed)

	if new_resource:
		new_resource.changed.connect(_on_node_graph_resource_changed)
