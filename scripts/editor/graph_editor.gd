@tool
extends SubViewportContainer

@onready var sub_viewport: SubViewport = %SubViewport
@onready var editor_overlay: CanvasLayer = %EditorOverlay
@onready var camera_2d: Camera2D = %Camera2D
@onready var background_texture: ColorRect = %Texture

var is_panning_camera = false
var panning_mouse_start_pos = Vector2.ZERO
var panning_camera_start_pos = Vector2.ZERO

var zoom_delta = 0.05
var min_zoom = 0.5
var max_zoom = 2
var zoom = 1 : set = _set_zoom

func _ready() -> void:
	var is_panning_camera = false
	init_camera()
	background_texture.material.set_shader_parameter("grid_offset", camera_2d.position)
	background_texture.material.set_shader_parameter("grid_zoom", zoom)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		handle_mouse_input(event)

	if sub_viewport: sub_viewport.push_input(event)


func _set_zoom(value):
	zoom = clampf(value, min_zoom, max_zoom)

	camera_2d.zoom = Vector2(zoom, zoom)
	background_texture.material.set_shader_parameter("grid_zoom", zoom)


func handle_mouse_input(event: InputEventMouse) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
			panning_mouse_start_pos = event.position
			panning_camera_start_pos = camera_2d.position
			is_panning_camera = true
		else:
			is_panning_camera = false

		handle_scroll(event)

	if event is InputEventMouseMotion:
		if is_panning_camera:
			pan_camera(event.position)

		if editor_overlay:
			editor_overlay.set_mouse_pos_overlay(event.position)


func handle_scroll(event: InputEventMouseButton) -> void:
	if not event.is_pressed(): return

	if event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom += zoom_delta
	if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom -= zoom_delta



func pan_camera(pan_offset: Vector2) -> void:
	if not camera_2d: return
	var cam_offset = (pan_offset - panning_mouse_start_pos) / zoom
	camera_2d.position = panning_camera_start_pos - cam_offset
	background_texture.material.set_shader_parameter("grid_offset", panning_camera_start_pos - cam_offset)


func init_camera() -> void:
	if not camera_2d:
		push_error("Camera2D node not found")
		return

	camera_2d.enabled = true
	camera_2d.make_current()
	camera_2d.position = panning_camera_start_pos
	camera_2d.editor_draw_screen = false
	camera_2d.editor_draw_limits = false
	camera_2d.editor_draw_drag_margin = false


func _on_zoom_less_button_pressed() -> void:
	zoom -= zoom_delta


func _on_zoom_reset_button_pressed() -> void:
	zoom = 1


func _on_zoom_more_button_pressed() -> void:
	zoom += zoom_delta
