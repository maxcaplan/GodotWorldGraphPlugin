@tool
extends VBoxContainer

@onready var file_button: MenuButton = %FileButton

@onready var load_file_dialog: FileDialog = %LoadFileDialog
@onready var save_file_as_dialog: FileDialog = %SaveFileAsDialog
@onready var error_dialog: AcceptDialog = %ErrorDialog
@onready var new_confirmation_dialog: ConfirmationDialog = %NewConfirmationDialog
@onready var load_confirmation_dialog: ConfirmationDialog = $%LoadConfirmationDialog
@onready var close_confirmation_dialog: ConfirmationDialog = %CloseConfirmationDialog
@onready var file_badge: FileBadge = %FileBadge

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
	remove_file_button_items()
	add_file_button_items()

	var connected = connect_signals()

	if not connected:
		push_error("Failed to connect file menu signals")


func _exit_tree() -> void:
	remove_file_button_items()
	disconnect_signals()


func _on_file_button_pressed() -> void:
	file_button.show_popup()


func _on_popup_id_pressed(id: int) -> void:
	match id:
		MenuButtonItems.NEW_WORLD_GRAPH:
			if is_unsaved():
				new_confirmation_dialog.popup()
			else:
				create_new_node_graph_resource()

		MenuButtonItems.LOAD_WORLD_GRAPH:
			if is_unsaved():
				load_confirmation_dialog.popup()
			else:
				load_file_dialog.popup_centered()

		MenuButtonItems.SAVE_FILE:
			save_file(current_file_path)

		MenuButtonItems.SAVE_FILE_AS:
			save_file_as_dialog.popup_centered()

		MenuButtonItems.CLOSE_FILE:
			if is_unsaved():
				close_confirmation_dialog.popup()
			else:
				close_current_file()


func _on_load_file_selected(path: String) -> void:
	var file_ext = path.split(".")[-1]

	if file_ext != "tres" and file_ext != "res":
		error_dialog.title = "File Loading Error"
		error_dialog.dialog_text = "Selected file is not a resource (*.tres or *.res)"
		error_dialog.popup()
		return

	var file = load(path)

	if not(file is NodeGraph):
		error_dialog.title = "File Loading Error"
		error_dialog.dialog_text = "Selected file is not a NodeGraph resource"
		error_dialog.popup()
		return

	WorldGraphGlobal.node_graph_resource = file
	current_file_path = path
	is_saved = true


func _on_save_file_selected(path: String) -> void:
	save_file(path)


func open_load_dialog(save_current = false) -> void:
	if save_current:
		save_file(current_file_path)
		await file_saved

	load_file_dialog.popup()


func create_new_node_graph_resource(save_current = false) -> void:
	if save_current:
		save_file(current_file_path)
		await file_saved

	WorldGraphGlobal.node_graph_resource = NodeGraph.new()
	current_file_path = ""
	is_saved = false
	file_badge.file_name = "unsaved graph"
	file_badge.visible = true


func close_current_file(save_current = false) -> void:
	if save_current:
		save_file(current_file_path)
		await file_saved

	current_file_path = ""
	is_saved = true
	WorldGraphGlobal.node_graph_resource = null


func save_file(path: String) -> void:
	if not WorldGraphGlobal.node_graph_resource:
		error_dialog.title = "File Saving Error"
		error_dialog.dialog_text = "There is no loaded NodeGraph to save"
		error_dialog.popup()
		is_saved = false
		return

	#If there is no path for current file, open save as dialog
	if path == "" or path == null:
		save_file_as_dialog.popup()
		return

	var file_ext = path.split(".")[-1]

	if file_ext != "tres" and file_ext != "res":
		error_dialog.title = "File Saving Error"
		error_dialog.dialog_text = "Selected file is not a resource (*.tres or *.res)"
		error_dialog.popup()
		is_saved = false
		return

	var save_err = ResourceSaver.save(WorldGraphGlobal.node_graph_resource, path)

	if save_err:
		error_dialog.title = "File Saving Error"
		error_dialog.dialog_text = "There was an error saving %s" % path
		error_dialog.popup()
		is_saved = false
		return

	is_saved = true
	current_file_path = path

	file_saved.emit()


func is_unsaved() -> bool:
	return WorldGraphGlobal.node_graph_resource and not is_saved


func connect_signals() -> bool:
	if not file_button: return false
	if not WorldGraphGlobal: return false

	var file_popup_menu := file_button.get_popup()
	file_popup_menu.id_pressed.connect(_on_popup_id_pressed)

	WorldGraphGlobal.node_graph_resource_refrence_changed.connect(update_file_button_item_states)

	return true


func disconnect_signals() -> void:
	if file_button:
		var file_popup_menu := file_button.get_popup()

		if file_popup_menu.id_pressed.is_connected(_on_popup_id_pressed):
			file_popup_menu.id_pressed.disconnect(_on_popup_id_pressed)

	if WorldGraphGlobal:
		if WorldGraphGlobal.node_graph_resource_refrence_changed.is_connected(update_file_button_item_states):
			WorldGraphGlobal.node_graph_resource_refrence_changed.disconnect(update_file_button_item_states)


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
	var file_popup_menu := file_button.get_popup()
	for i in file_popup_menu.item_count:
		var item_id = file_popup_menu.get_item_id(i)
		var disable_item := false

		match item_id:
			MenuButtonItems.SAVE_FILE:
				disable_item = WorldGraphGlobal.node_graph_resource == null

			MenuButtonItems.SAVE_FILE_AS:
				disable_item = WorldGraphGlobal.node_graph_resource == null

			MenuButtonItems.CLOSE_FILE:
				disable_item = WorldGraphGlobal.node_graph_resource == null

		file_popup_menu.set_item_disabled(i, disable_item)


func remove_file_button_items():
	var file_popup_menu := file_button.get_popup()
	file_popup_menu.clear()
