@tool
class_name GraphEditorPanel
extends HBoxContainer

@onready var graph_editor: GraphEditor = %GraphEditor
@onready var view_controls: EditorViewControls = %ViewControls

@onready var side_bar: VBoxContainer = %SideBar
@onready var side_bar_toggle: TextureButton = %SideBarToggleButton

const BACK_TEXTURE = preload("res://addons/worldgraph/assets/Back.svg")
const FORWARD_TEXTURE = preload("res://addons/worldgraph/assets/Forward.svg")

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


func _on_side_bar_toggle_pressed() -> void:
	side_bar.visible = !side_bar.visible

	var toggle_texture = BACK_TEXTURE if side_bar.visible else FORWARD_TEXTURE
	side_bar_toggle.texture_normal = toggle_texture
