@tool
class_name GraphEditorPanel
extends VBoxContainer

@onready var graph_editor: GraphEditor = %GraphEditor
@onready var view_controls: EditorViewControls = %ViewControls

func _on_center_view_button_pressed() -> void:
	if not graph_editor: return
	graph_editor.center_view()


func _on_zoom_less_button_pressed() -> void:
	if not graph_editor: return
	graph_editor.zoom_less()


func _on_zoom_reset_button_pressed() -> void:
	if not graph_editor: return
	graph_editor.zoom_reset()


func _on_zoom_more_button_pressed() -> void:
	if not graph_editor: return
	graph_editor.zoom_more()
