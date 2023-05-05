@tool
class_name GraphEditor
extends SubViewportContainer

@onready var sub_viewport: SubViewport = get_node("%SubViewport")
@onready var graph_ui: GraphUI = get_node("%GraphUI")
@onready var editor_overlay: CanvasLayer = get_node("%EditorOverlay")
@onready var background_texture: ColorRect = get_node("%Texture")

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
	background_texture.material.set_shader_parameter("grid_offset", graph_ui.camera_2d.position)
	background_texture.material.set_shader_parameter("grid_zoom", zoom)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		handle_mouse_input(event)
		update_cursor_shape()

	if sub_viewport:
		sub_viewport.push_input(event)


func _set_zoom(value):
	zoom = clampf(value, min_zoom, max_zoom)

	graph_ui.camera_2d.zoom = Vector2(zoom, zoom)
	background_texture.material.set_shader_parameter("grid_zoom", zoom)


func handle_mouse_input(event: InputEventMouse) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
			panning_mouse_start_pos = event.position
			panning_camera_start_pos = graph_ui.camera_2d.position
			is_panning_camera = true
		else:
			is_panning_camera = false

		handle_scroll(event)

	if event is InputEventMouseMotion:
		if is_panning_camera:
			pan_camera(event.position)

		if editor_overlay:
			editor_overlay.set_mouse_pos_overlay(event.position)
			editor_overlay.set_camera_pos_overlay(graph_ui.camera_2d.position)


func handle_scroll(event: InputEventMouseButton) -> void:
	if not event.is_pressed(): return

	if event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom += zoom_delta
	if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom -= zoom_delta


func pan_camera(pan_offset: Vector2) -> void:
	if not graph_ui.camera_2d: return

	var cam_offset = (pan_offset - panning_mouse_start_pos) / zoom
	var relative_offset = panning_camera_start_pos - cam_offset

	graph_ui.camera_2d.position = relative_offset

	if background_texture:
		background_texture.material.set_shader_parameter("grid_offset", relative_offset)


func update_cursor_shape() -> void:
	if is_panning_camera:
		self.mouse_default_cursor_shape = self.CURSOR_DRAG
		return

	if graph_ui.is_dragging_node:
		self.mouse_default_cursor_shape = self.CURSOR_DRAG
		return

	self.mouse_default_cursor_shape = self.CURSOR_ARROW


func init_camera() -> void:
	if not graph_ui.camera_2d:
		push_error("Camera2D node not found")
		return

	graph_ui.camera_2d.enabled = true
	graph_ui.camera_2d.make_current()
	graph_ui.camera_2d.position = panning_camera_start_pos
	graph_ui.camera_2d.editor_draw_screen = false
	graph_ui.camera_2d.editor_draw_limits = false
	graph_ui.camera_2d.editor_draw_drag_margin = false


func center_view() -> void:
	if graph_ui and graph_ui.camera_2d:
		graph_ui.camera_2d.position = Vector2.ZERO


func zoom_less() -> void:
	zoom -= zoom_delta


func zoom_more() -> void:
	zoom += zoom_delta


func zoom_reset() -> void:
	zoom = 1
