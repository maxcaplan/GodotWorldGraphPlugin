@tool
extends VBoxContainer

@onready var world_graph_singleton = get_tree().root.find_child("WorldGraphGlobal", true, false)

@onready var file_dialogs: Control = get_node("%FileDialogs")
@onready var file_button: MenuButton = get_node("%FileButton")
@onready var file_badge: FileBadge = get_node("%FileBadge")

var current_file_path: String:
	set(value):
		current_file_path = value
		file_badge.file_name = value.split("/")[-1]
		# Not a fan of this one...
		file_badge.visible = true if current_file_path else false

var is_saved := true:
	set(value):
		is_saved = value
		file_badge.is_saved = value

signal file_saved

enum MenuButtonItems {
	NEW_WORLD_GRAPH,
	LOAD_WORLD_GRAPH,
	SAVE_FILE,
	SAVE_FILE_AS,
	CLOSE_FILE
}

func _ready() -> void:
	if not world_graph_singleton:
		push_error("Failed to find WorldGraphGlobal autoload (graph_editor_side_bar.gd)")
		return

	remove_file_button_items()
	add_file_button_items()

	var connected = connect_signals()

	if not connected:
		push_error("Failed to connect file menu signals")


func _exit_tree() -> void:
	remove_file_button_items()
	disconnect_signals()


func connect_signals() -> bool:
	if not file_button: return false
	if not world_graph_singleton: return false
	if not file_dialogs: return false

	file_button.pressed.connect(_on_file_button_pressed)

	var file_popup_menu := file_button.get_popup()
	file_popup_menu.id_pressed.connect(_on_popup_id_pressed)

	world_graph_singleton.node_graph_resource_refrence_changed.connect(update_file_button_item_states)

	file_dialogs.load_file_selected.connect(_on_load_file_selected)
	file_dialogs.save_file_selected.connect(_on_save_file_selected)
	file_dialogs.new_confirmation_answered.connect(_on_new_confirmation_answered)
	file_dialogs.load_confirmation_answered.connect(_on_load_confirmation_answered)
	file_dialogs.close_confirmation_answered.connect(_on_close_confirmation_answered)

	return true


func disconnect_signals() -> void:
	if file_button:
		file_button.pressed.disconnect(_on_file_button_pressed)
		var file_popup_menu := file_button.get_popup()

		if file_popup_menu:
			file_popup_menu.id_pressed.disconnect(_on_popup_id_pressed)

	if world_graph_singleton:
		world_graph_singleton.node_graph_resource_refrence_changed.disconnect(update_file_button_item_states)

	if file_dialogs:
		file_dialogs.load_file_selected.disconnect(_on_load_file_selected)
		file_dialogs.save_file_selected.disconnect(_on_save_file_selected)
		file_dialogs.new_confirmation_answered.disconnect(_on_new_confirmation_answered)
		file_dialogs.load_confirmation_answered.disconnect(_on_load_confirmation_answered)
		file_dialogs.close_confirmation_answered.disconnect(_on_close_confirmation_answered)


func create_new_node_graph_resource(save_current = false) -> void:
	if not world_graph_singleton: return

	if save_current:
		save_file(current_file_path)
		await file_saved

	world_graph_singleton.node_graph_resource = NodeGraph.new()
	current_file_path = ""
	is_saved = false
	file_badge.file_name = "unsaved graph"
	file_badge.visible = true


func close_current_file(save_current = false) -> void:
	if not world_graph_singleton: return

	if save_current:
		save_file(current_file_path)
		await file_saved

	current_file_path = ""
	is_saved = true
	world_graph_singleton.node_graph_resource = null


func save_file(path: String) -> void:
	if not world_graph_singleton: return

	if not world_graph_singleton.node_graph_resource:
		file_dialogs.error_popup("There is no loaded NodeGraph to save", "File Saving Error")
		is_saved = false
		return

	#If there is no path for current file, open save as dialog
	if path == "" or path == null:
		file_dialogs.save_file_as_dialog.popup()
		return

	var file_ext = path.split(".")[-1]

	if file_ext != "tres" and file_ext != "res":
		file_dialogs.error_popup("Selected file is not a resource (*.tres or *.res)", "File Saving Error")
		is_saved = false
		return

	var save_err = ResourceSaver.save(world_graph_singleton.node_graph_resource, path)

	if save_err:
		file_dialogs.error_popup("There was an error saving %s" % path, "File Saving Error")
		is_saved = false
		return

	is_saved = true
	current_file_path = path

	file_saved.emit()


func load_file(path: String, save_current = false) -> void:
	if save_current:
		save_file(current_file_path)
		await file_saved

	if not world_graph_singleton: return

	var file_ext = path.split(".")[-1]

	if file_ext != "tres" and file_ext != "res":
		file_dialogs.error_popup("Selected file is not a resource (*.tres or *.res)", "File Loading Error")
		return

	var file = load(path)

	if not(file is NodeGraph):
		file_dialogs.error_popup("Selected file is not a NodeGraph resource", "File Loading Error")
		return

	world_graph_singleton.node_graph_resource = file
	current_file_path = path
	is_saved = true


func is_unsaved() -> bool:
	if not world_graph_singleton: return false
	return world_graph_singleton.node_graph_resource and not is_saved


func add_file_button_items() -> void:
	var file_popup_menu := file_button.get_popup()

	file_popup_menu.add_item("New WorldGraph", MenuButtonItems.NEW_WORLD_GRAPH)

	file_popup_menu.add_separator()

	file_popup_menu.add_item("Load WorldGraph", MenuButtonItems.LOAD_WORLD_GRAPH)

	file_popup_menu.add_item("Save File", MenuButtonItems.SAVE_FILE)
	file_popup_menu.add_item("Save File As", MenuButtonItems.SAVE_FILE_AS)

	file_popup_menu.add_separator()

	file_popup_menu.add_item("Close File", MenuButtonItems.CLOSE_FILE)

	update_file_button_item_states()


func update_file_button_item_states() -> void:
	if not world_graph_singleton: return

	var file_popup_menu := file_button.get_popup()
	for i in file_popup_menu.item_count:
		var item_id = file_popup_menu.get_item_id(i)
		var disable_item := false

		match item_id:
			MenuButtonItems.SAVE_FILE:
				disable_item = world_graph_singleton.node_graph_resource == null

			MenuButtonItems.SAVE_FILE_AS:
				disable_item = world_graph_singleton.node_graph_resource == null

			MenuButtonItems.CLOSE_FILE:
				disable_item = world_graph_singleton.node_graph_resource == null

		file_popup_menu.set_item_disabled(i, disable_item)


func remove_file_button_items():
	var file_popup_menu := file_button.get_popup()
	file_popup_menu.clear()


func _on_file_button_pressed() -> void:
	file_button.show_popup()


func _on_popup_id_pressed(id: int) -> void:
	match id:
		MenuButtonItems.NEW_WORLD_GRAPH:
			if is_unsaved():
				file_dialogs.new_confirmation.popup()
			else:
				create_new_node_graph_resource()

		MenuButtonItems.LOAD_WORLD_GRAPH:
			if is_unsaved():
				file_dialogs.load_confirmation.popup()
			else:
				file_dialogs.load_file_dialog.popup_centered()

		MenuButtonItems.SAVE_FILE:
			save_file(current_file_path)

		MenuButtonItems.SAVE_FILE_AS:
			file_dialogs.save_file_as_dialog.popup_centered()

		MenuButtonItems.CLOSE_FILE:
			if is_unsaved():
				file_dialogs.close_confirmation.popup()
			else:
				close_current_file()


func _on_load_file_selected(path: String) -> void:
	load_file(path)


func _on_save_file_selected(path: String) -> void:
	save_file(path)


func _on_new_confirmation_answered(confirmed: bool) -> void:
	create_new_node_graph_resource(confirmed)


func _on_load_confirmation_answered(confirmed: bool) -> void:
	if confirmed:
		save_file(current_file_path)
		await file_saved

	file_dialogs.load_file_dialog.popup_centered()


func _on_close_confirmation_answered(confirmed: bool) -> void:
	close_current_file(confirmed)
