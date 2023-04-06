@tool
class_name EditorViewControls
extends HBoxContainer

signal center_view_button_pressed

signal zoom_less_button_pressed
signal zoom_more_button_pressed
signal zoom_reset_button_pressed

func _on_center_view_button_pressed() -> void:
	center_view_button_pressed.emit()


func _on_zoom_less_button_pressed() -> void:
	zoom_less_button_pressed.emit()


func _on_zoom_more_button_pressed() -> void:
	zoom_more_button_pressed.emit()


func _on_zoom_reset_button_pressed() -> void:
	zoom_reset_button_pressed.emit()
