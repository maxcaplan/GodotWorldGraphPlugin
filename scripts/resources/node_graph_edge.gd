extends Resource
class_name NodeGraphEdge

var vertex_a : RoomNodeVertex : set = _set_vertex_a
var vertex_b : RoomNodeVertex : set = _set_vertex_b

func _set_vertex_a(value: RoomNodeVertex) -> void:
	vertex_a = value
	emit_changed()


func _set_vertex_b(value: RoomNodeVertex) -> void:
	vertex_b = value
	emit_changed()
