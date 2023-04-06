@tool
class_name GraphUI
extends Node2D

@onready var graph_node_ui_scene = load("res://addons/worldgraph/scenes/editor/graph_node_ui.tscn")

@onready var camera_2d: Camera2D = %Camera2D
@onready var graph_nodes_ui: Node2D = %GraphNodesUI

var focused_control : Control

var is_dragging_node := false
var dragging_node : GraphNodeUI
var drag_offset := Vector2.ZERO

var graph_nodes: Array[GraphNodeUI] = []

func _ready() -> void:
	get_viewport().gui_focus_changed.connect(_on_control_focus_changed)

	WorldGraphGlobal.node_graph_resource_refrence_changed.connect(_on_node_graph_resource_refrence_changed)
	WorldGraphGlobal.node_graph_resource_changed.connect(_on_node_graph_resource_changed)

func _exit_tree() -> void:
	get_viewport().gui_focus_changed.disconnect(_on_control_focus_changed)

	WorldGraphGlobal.node_graph_resource_refrence_changed.disconnect(_on_node_graph_resource_refrence_changed)
	WorldGraphGlobal.node_graph_resource_changed.disconnect(_on_node_graph_resource_changed)

func _on_node_graph_resource_refrence_changed():
	printt("Resource Refrence changed to", WorldGraphGlobal.node_graph_resource)

func _on_node_graph_resource_changed():
	printt("Resource Change")

func _set_node_graph_resource(resource: NodeGraph):
	for node in graph_nodes:
		node.graph_node_gui_input.disconnect(_on_node_input)

	for node in resource.nodes:
		var node_ui : GraphNodeUI = graph_node_ui_scene.instantiate()

		node_ui.node_name = node.room_name
		node_ui.graph_node_gui_input.connect(_on_node_input)

		graph_nodes_ui.add_child(node_ui)
		graph_nodes.append(node_ui)


func _input(event: InputEvent) -> void:
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



# Releases focus if click outside of a control node
func update_control_focus(event: InputEventMouseButton):
	if not focused_control: return
	if not event.is_pressed(): return

	if event.button_index == MOUSE_BUTTON_LEFT:
		focused_control.release_focus()
