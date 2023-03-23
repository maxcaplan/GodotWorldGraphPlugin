extends Resource
class_name NodeGraph

@export var nodes : Array[RoomNode]

func _init(p_nodes = []) -> void:
	nodes = p_nodes
