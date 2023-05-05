@tool
extends Resource
class_name RoomNodeVertex

enum NodeSides {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM
}

var name: String = "Vertex" : set = _set_name
var side: NodeSides : set = _set_side

func _set_name(value: String) -> void:
	if value == "":
		push_error("Tried to set name to empty string")
		return

	name = value
	emit_changed()


func _set_side(value: NodeSides) -> void:
	side = value
	emit_changed()
