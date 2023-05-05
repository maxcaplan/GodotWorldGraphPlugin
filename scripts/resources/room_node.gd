extends Resource
class_name RoomNode

var room_name : String : set = _set_room_name

var vertices : Array[RoomNodeVertex] = [] : set = _set_vertices
var position := Vector2.ZERO : set = _set_position

func _init(p_name = "", p_vertices = [], p_position = Vector2.ZERO) -> void:
	room_name = p_name
	vertices.append_array(p_vertices)
	position = p_position


func _set_room_name(value: String) -> void:
	room_name = value
	emit_changed()


func _set_vertices(value: Array[RoomNodeVertex]) -> void:
	vertices = value
	emit_changed()


func _set_position(value: Vector2) -> void:
	position = value
