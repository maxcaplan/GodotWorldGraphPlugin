@tool
class_name GraphEditorPanel
extends HBoxContainer

@onready var graph_editor: GraphEditor = get_node("%GraphEditor")
@onready var view_controls: EditorViewControls = get_node("%ViewControls")
@onready var side_bar: VBoxContainer = get_node("%SideBar")
@onready var side_bar_toggle: TextureButton = get_node("%SideBarToggleButton")

const BACK_TEXTURE = preload("res://addons/worldgraph/assets/Back.svg")
const FORWARD_TEXTURE = preload("res://addons/worldgraph/assets/Forward.svg")

func _ready() -> void:
	connect_signals()


func _exit_tree() -> void:
	disconnect_signals()


func connect_signals() -> void:
	if view_controls:
		view_controls.center_view_button_pressed.connect(_on_center_view_button_pressed)
		view_controls.zoom_less_button_pressed.connect(_on_zoom_less_button_pressed)
		view_controls.zoom_more_button_pressed.connect(_on_zoom_more_button_pressed)
		view_controls.zoom_reset_button_pressed.connect(_on_zoom_reset_button_pressed)

	if side_bar_toggle:
		side_bar_toggle.pressed.connect(_on_side_bar_toggle_pressed)


func disconnect_signals() -> void:
	if view_controls:
		view_controls.center_view_button_pressed.disconnect(_on_center_view_button_pressed)
		view_controls.zoom_less_button_pressed.disconnect(_on_zoom_less_button_pressed)
		view_controls.zoom_more_button_pressed.disconnect(_on_zoom_more_button_pressed)
		view_controls.zoom_reset_button_pressed.disconnect(_on_zoom_reset_button_pressed)

	if side_bar_toggle:
		side_bar_toggle.pressed.disconnect(_on_side_bar_toggle_pressed)

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
