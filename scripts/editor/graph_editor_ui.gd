@tool
class_name GraphUI
extends Node2D

signal camera_initialized

@onready var world_graph_singleton = get_tree().root.find_child("WorldGraphGlobal", true, false)

#@onready var graph_node_ui_scene = load("res://addons/worldgraph/scenes/editor/graph_node_ui.tscn")

@onready var graph_nodes_ui: Node2D = get_node("%GraphNodesUI")

var camera_2d: Camera2D

var focused_control : Control

var is_dragging_node := false
var dragging_node : GraphNodeUI
var drag_offset := Vector2.ZERO

var graph_nodes: Array[GraphNodeUI] = []

func _ready() -> void:
	call_deferred("init_camera")

	get_viewport().gui_focus_changed.connect(_on_control_focus_changed)

	if not world_graph_singleton:
		push_error("Failed to find WorldGraphGlobal autoload (graph_editor_ui.gd)")
		return


func _exit_tree() -> void:
	get_viewport().gui_focus_changed.disconnect(_on_control_focus_changed)


func _input(event: InputEvent) -> void:
	if not camera_2d: return

	if event is InputEventMouseMotion:
		if is_dragging_node and dragging_node:
			var node_pos = (event.position / camera_2d.zoom) - drag_offset + camera_2d.position
			dragging_node.position = node_pos


func _on_control_focus_changed(node: Control):
	focused_control = node


func _on_node_input(event: InputEvent, node: GraphNodeUI):
	if event is InputEventMouseButton:
		if not is_dragging_node and node.handle_mouse_button(event):
			drag_offset = event.position

		is_dragging_node = node.handle_mouse_button(event)

		if is_dragging_node:
			dragging_node = node


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		update_control_focus(event)


func init_camera() -> void:
	camera_2d = Camera2D.new()

	camera_2d.position = Vector2.ZERO
	camera_2d.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	camera_2d.editor_draw_screen = false
	camera_2d.editor_draw_limits = false
	camera_2d.editor_draw_drag_margin = false

	add_child(camera_2d)

	camera_2d.enabled = true
	#camera_2d.make_current()

	camera_initialized.emit()


# Releases focus if click outside of a control node
func update_control_focus(event: InputEventMouseButton):
	if not focused_control: return
	if not event.is_pressed(): return

	if event.button_index == MOUSE_BUTTON_LEFT:
		focused_control.release_focus()
