@tool
class_name EditorViewControls
extends HBoxContainer

signal center_view_button_pressed

signal zoom_less_button_pressed
signal zoom_more_button_pressed
signal zoom_reset_button_pressed

@onready var center_view: TextureButton = get_node("%CenterViewButton")
@onready var zoom_less: TextureButton = get_node("%ZoomLessButton")
@onready var zoom_reset: TextureButton = get_node("%ZoomResetButton")
@onready var zoom_more: TextureButton = get_node("%ZoomMoreButton")

func _ready() -> void:
	connect_signals()


func _exit_tree() -> void:
	disconnect_signals()


func connect_signals() -> void:
	if center_view:
		center_view.pressed.connect(_on_center_view_button_pressed)

	if zoom_less:
		zoom_less.pressed.connect(_on_zoom_less_button_pressed)

	if zoom_reset:
		zoom_reset.pressed.connect(_on_zoom_reset_button_pressed)

	if zoom_more:
		zoom_more.pressed.connect(_on_zoom_more_button_pressed)


func disconnect_signals() -> void:
	if center_view:
		center_view.pressed.disconnect(_on_center_view_button_pressed)

	if zoom_less:
		zoom_less.pressed.disconnect(_on_zoom_less_button_pressed)

	if zoom_reset:
		zoom_reset.pressed.disconnect(_on_zoom_reset_button_pressed)

	if zoom_more:
		zoom_more.pressed.disconnect(_on_zoom_more_button_pressed)


func _on_center_view_button_pressed() -> void:
	center_view_button_pressed.emit()


func _on_zoom_less_button_pressed() -> void:
	zoom_less_button_pressed.emit()


func _on_zoom_more_button_pressed() -> void:
	zoom_more_button_pressed.emit()


func _on_zoom_reset_button_pressed() -> void:
	zoom_reset_button_pressed.emit()
