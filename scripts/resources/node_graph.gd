@icon("res://addons/worldgraph/assets/plugin_icon.svg")
class_name NodeGraph
extends Resource

@export var nodes : Array[RoomNode] = [] : set = _set_nodes
@export var edges : Array[NodeGraphEdge] = [] : set = _set_edges

func _init(p_nodes = []) -> void:
	nodes.append_array(p_nodes)


func _set_nodes(value: Array[RoomNode]) -> void:
	nodes = value
	emit_changed()


func _set_edges(value: Array[NodeGraphEdge]) -> void:
	edges = value
	emit_changed()
