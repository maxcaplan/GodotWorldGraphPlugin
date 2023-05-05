@tool
extends EditorPlugin

const PLUGIN_NAME = "World Graph Editor"

const PLUGIN_ICON_PATH = "res://addons/worldgraph/assets/plugin_icon.svg"
const AUTO_LOAD_PATH = "res://addons/worldgraph/scripts/world_graph_global.gd"
const BOTTOM_PANEL_PATH = "res://addons/worldgraph/scenes/editor/graph_editor_bottom_panel.tscn"

var bottom_panel_scene = preload(BOTTOM_PANEL_PATH)
var bottom_panel_instance: Control
var bottom_panel_button: Button

var editor_interface := get_editor_interface()
var editor_selection := editor_interface.get_selection()
var inspector := editor_interface.get_inspector()

var world_graph_singleton : WorldGraphSingleton

func _enter_tree() -> void:
	call_deferred("init_plugin")


func _exit_tree() -> void:
	clean_up_bottom_panel()

	disconnect_signals()

	remove_autoload_singleton('WorldGraphGlobal')


func _make_visible(visible):
	if bottom_panel_instance:
		bottom_panel_instance.visible = visible


func _get_plugin_name() -> String:
	return PLUGIN_NAME


func _get_plugin_icon() -> Texture2D:
	return load(PLUGIN_ICON_PATH)


func connect_signals() -> void:
	pass


func disconnect_signals() -> void:
	pass


func init_plugin() -> void:
	if not init_autoload_singleton(): return

	bottom_panel_instance = bottom_panel_scene.instantiate()
	bottom_panel_button = add_control_to_bottom_panel(bottom_panel_instance, "World Graph Editor")

	_make_visible(false)
	connect_signals()


func init_autoload_singleton() -> bool:
	var find_autoload = func() -> Node:
		return get_tree().root.find_child("WorldGraphGlobal", true, false)
	#var find_autoload = func() -> Node: return get_node("/root/WorldGraphGlobal")

	world_graph_singleton = find_autoload.call()

	if not world_graph_singleton:
		add_autoload_singleton('WorldGraphGlobal', AUTO_LOAD_PATH)
		world_graph_singleton = find_autoload.call()

	if not world_graph_singleton:
		push_error("World Graph Plugin init failed - Unable to find WorldGraphGlobal auto load")
		return false

	return true


func clean_up_bottom_panel():
	if bottom_panel_instance:
		remove_control_from_bottom_panel(bottom_panel_instance)
		bottom_panel_instance.queue_free()
