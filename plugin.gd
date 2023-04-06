@tool
extends EditorPlugin

var bottom_panel_scene := preload("res://addons/worldgraph/scenes/editor/graph_editor_panel.tscn")

var bottom_panel_instance: Control
var bottom_panel_button: Button

var editor_interface := get_editor_interface()
var editor_selection := editor_interface.get_selection()
var inspector := editor_interface.get_inspector()

var bottom_panel_button_visible := false

var world_graph_singleton : WorldGraphSingleton
var node_graph_resource : NodeGraph

func _enter_tree() -> void:
	add_autoload_singleton('WorldGraphGlobal', "res://addons/worldgraph/scripts/world_graph_global.gd")

	world_graph_singleton = get_tree().root.find_child("WorldGraphGlobal", true, false)

	if not world_graph_singleton:
		push_error("World Graph Plugin init failed - Unable to find WorldGraphGlobal auto load")
		return


	_make_visible(false)
	_connect_signals()

	world_graph_singleton.node_graph_resource = get_selected_node_node_graph()
	update_bottom_panel_control(world_graph_singleton.node_graph_resource)


func _exit_tree() -> void:
	remove_autoload_singleton('WorldGraphGlobal')

	clean_up_bottom_panel()

	_disconnect_signals()


func _make_visible(visible):
	if bottom_panel_instance:
		bottom_panel_instance.visible = visible


func _get_plugin_name() -> String:
	return "World Graph Editor"


func _get_plugin_icon() -> Texture2D:
	return load("res://addons/worldgraph/assets/plugin_icon.svg")


func _on_editor_selection_changed():
	world_graph_singleton.node_graph_resource = get_selected_node_node_graph()
	update_bottom_panel_control(world_graph_singleton.node_graph_resource)


func _on_inspector_property_edited(property: String):
	world_graph_singleton.node_graph_resource = get_selected_node_node_graph()
	update_bottom_panel_control(world_graph_singleton.node_graph_resource)


func _on_inspector_resource_selected(resource: Resource, path: String):
	world_graph_singleton.node_graph_resource = get_selected_node_node_graph()
	update_bottom_panel_control(world_graph_singleton.node_graph_resource)

func _on_inspector_object_changed():
	var file_system_current_path = editor_interface.get_current_path()

	# Check that selected file is a resource
	if file_system_current_path.get_extension() != "tres": return

	var resource : = load(file_system_current_path)

	world_graph_singleton.node_graph_resource = resource if resource is NodeGraph else null
	update_bottom_panel_control(world_graph_singleton.node_graph_resource)


func _connect_signals() -> void:
	editor_selection.connect("selection_changed", _on_editor_selection_changed)
	inspector.connect("property_edited", _on_inspector_property_edited)
	#inspector.connect("resource_selected", _on_inspector_resource_selected)
	#inspector.connect("edited_object_changed", _on_inspector_object_changed)


func _disconnect_signals() -> void:
	if editor_selection.is_connected("selection_changed", _on_editor_selection_changed):
		editor_selection.disconnect("selection_changed", _on_editor_selection_changed)

	if inspector.is_connected("property_edited", _on_inspector_property_edited):
		inspector.disconnect("property_edited", _on_inspector_property_edited)

	if inspector.is_connected("resource_selected", _on_inspector_resource_selected):
		inspector.disconnect("resource_selected", _on_inspector_resource_selected)


	if inspector.is_connected("edited_object_changed", _on_inspector_object_changed):
		inspector.disconnect("edited_object_changed", _on_inspector_object_changed)


func get_selected_node_node_graph() -> NodeGraph:
	var selection = editor_selection.get_selected_nodes()
	var node = null if selection.is_empty() else selection[0]

	if not node: return

	for prop in node.get_property_list():
		var prop_value = node.get(prop["name"])
		if prop_value is NodeGraph:
			return prop_value

	return


func update_bottom_panel_control(resource: NodeGraph):
	if not resource:
		remove_control_from_bottom_panel(bottom_panel_instance)
		clean_up_bottom_panel()
		bottom_panel_button_visible = false
		return

	if bottom_panel_button_visible: return

	bottom_panel_instance = bottom_panel_scene.instantiate()
	bottom_panel_button = add_control_to_bottom_panel(bottom_panel_instance, "World Graph Editor")
	bottom_panel_button_visible = true


func clean_up_bottom_panel():
	if bottom_panel_instance:
		remove_control_from_bottom_panel(bottom_panel_instance)
		bottom_panel_instance.queue_free()

	if bottom_panel_button:
		bottom_panel_button.queue_free()
