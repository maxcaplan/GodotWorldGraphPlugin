@tool
class_name GraphNodeUI
extends PanelContainer

signal graph_node_gui_input(event: InputEvent, node: GraphNodeUI)
signal name_text_submitted(new_name: String)

@onready var name_line_edit: LineEdit = %NameLineEdit

var node_name := "Node" :
	set(value):
		node_name = value
		if name_line_edit: name_line_edit.text = value


func _ready() -> void:
	name_line_edit.text = node_name

	name_line_edit.text_submitted.connect(_on_name_line_edit_submitted)


func _on_name_line_edit_submitted(new_text: String) -> void:
	print(node_name)
	name_line_edit.release_focus()
	if new_text == "":
		name_line_edit.text = node_name
		return

	node_name = new_text
	name_text_submitted.emit(new_text)


func _gui_input(event: InputEvent) -> void:
	graph_node_gui_input.emit(event, self)
	if event is InputEventMouseButton: handle_mouse_button(event)


func handle_mouse_button(event: InputEventMouseButton) -> bool:
	if event.button_index == MOUSE_BUTTON_LEFT:
		return event.is_pressed()

	return false
