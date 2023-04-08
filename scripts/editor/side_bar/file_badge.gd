@tool
class_name FileBadge
extends HBoxContainer

const DEFAULT_ICON_PATH := "res://addons/worldgraph/assets/plugin_icon.svg"

@onready var unsaved_ui: Label = %Unsaved
@onready var icon_ui: TextureRect = %Icon
@onready var file_name_ui: Label = %FileName

@export var icon: Texture2D = preload(DEFAULT_ICON_PATH) : set = _set_icon
@export var is_saved: bool = true : set = _set_is_saved
@export var file_name: String : set = _set_file_name


func _set_icon(value: Texture2D) -> void:
	icon = value
	icon_ui.texture = value


func _set_is_saved(value: bool) -> void:
	is_saved = value
	unsaved_ui.visible = !is_saved


func _set_file_name(value: String) -> void:
	file_name = value
	file_name_ui.text = value

	if file_name:
		icon_ui.modulate = Color(1, 1, 1, 1)
	else:
		icon_ui.modulate = Color(0.5, 0.5, 0.5, 1)

