@tool
extends Control

@onready var load_file_dialog: FileDialog = get_node("%LoadFileDialog")
@onready var save_file_as_dialog: FileDialog = get_node("%SaveFileAsDialog")
@onready var error_accept: AcceptDialog = get_node("%ErrorAcceptDialog")
@onready var new_confirmation: ConfirmationDialog = get_node("%NewConfirmationDialog")
@onready var load_confirmation: ConfirmationDialog = get_node("%LoadConfirmationDialog")
@onready var close_confirmation: ConfirmationDialog = get_node("%CloseConfirmationDialog")

signal load_file_selected(path: String)
signal save_file_selected(path: String)
signal new_confirmation_answered(confirmed: bool)
signal load_confirmation_answered(confirmed: bool)
signal close_confirmation_answered(confirmed: bool)


func _ready() -> void:
	connect_signals()


func connect_signals() -> void:
	if load_file_dialog:
		load_file_dialog.file_selected.connect(_on_load_file_selected)

	if save_file_as_dialog:
		save_file_as_dialog.file_selected.connect(_on_save_file_selected)

	if new_confirmation:
		new_confirmation.canceled.connect(_on_new_confirmation_canceled)
		new_confirmation.confirmed.connect(_on_new_confirmation_confirmed)

	if load_confirmation:
		load_confirmation.canceled.connect(_on_load_confirmation_canceled)
		load_confirmation.confirmed.connect(_on_load_confirmation_confirmed)

	if close_confirmation:
		close_confirmation.canceled.connect(_on_close_confirmation_canceled)
		close_confirmation.confirmed.connect(_on_close_confirmation_confirmed)


func disconnect_signals() -> void:
	if load_file_dialog:
		load_file_dialog.file_selected.disconnect(_on_load_file_selected)

	if save_file_as_dialog:
		save_file_as_dialog.file_selected.disconnect(_on_save_file_selected)

	if new_confirmation:
		new_confirmation.canceled.disconnect(_on_new_confirmation_canceled)
		new_confirmation.confirmed.disconnect(_on_new_confirmation_confirmed)

	if load_confirmation:
		load_confirmation.canceled.disconnect(_on_load_confirmation_canceled)
		load_confirmation.confirmed.disconnect(_on_load_confirmation_confirmed)

	if close_confirmation:
		close_confirmation.canceled.disconnect(_on_close_confirmation_canceled)
		close_confirmation.confirmed.disconnect(_on_close_confirmation_confirmed)


func _on_load_file_selected(path: String) -> void:
	load_file_selected.emit(path)


func _on_save_file_selected(path: String) -> void:
	save_file_selected.emit(path)


func _on_new_confirmation_canceled() -> void:
	new_confirmation_answered.emit(false)


func _on_new_confirmation_confirmed() -> void:
	new_confirmation_answered.emit(true)


func _on_load_confirmation_canceled() -> void:
	load_confirmation_answered.emit(false)


func _on_load_confirmation_confirmed() -> void:
	load_confirmation_answered.emit(true)


func _on_close_confirmation_canceled() -> void:
	close_confirmation_answered.emit(false)


func _on_close_confirmation_confirmed() -> void:
	close_confirmation_answered.emit(true)


func error_popup(error: String, title = "Error") -> void:
	error_accept.title = title
	error_accept.dialog_text = error
	error_accept.popup()
