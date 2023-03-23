extends Resource
class_name RoomNode

@export var room_name : String
@export var connections : Array[RoomNode]

func _init(p_name = "", p_connections = []) -> void:
	room_name = p_name
	connections = p_connections
