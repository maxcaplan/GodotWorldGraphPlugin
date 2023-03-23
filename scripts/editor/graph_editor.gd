@tool
extends SubViewportContainer

@onready var sub_viewport: SubViewport = %SubViewport
@onready var editor_overlay: CanvasLayer = %EditorOverlay

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if editor_overlay:
			editor_overlay.set_mouse_pos_overlay(event.position)

	if sub_viewport: sub_viewport.push_input(event)
