@tool
extends CanvasLayer
class_name GraphEditorOverlay

@onready var mouse_pos: Label = %MousePos

func set_mouse_pos_overlay(pos: Vector2) -> void:
	mouse_pos.text = "X:%s Y:%s" % [pos.x, pos.y]
