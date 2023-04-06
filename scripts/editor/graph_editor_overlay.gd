@tool
extends CanvasLayer
class_name GraphEditorOverlay

@onready var mouse_pos: Label = %MousePos
@onready var camera_pos: Label = %CameraPos

func set_mouse_pos_overlay(pos: Vector2) -> void:
	mouse_pos.text = "Mouse: (%s, %s)" % [pos.x, pos.y]

func set_camera_pos_overlay(pos: Vector2) -> void:
	camera_pos.text = "Camera: (%s, %s)" % [pos.x, pos.y]
