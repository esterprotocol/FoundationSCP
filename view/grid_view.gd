class_name GridView
extends Node2D
## Apresentação da grade: desenha as células e recebe o clique de seleção.
## Não decide regra; lê o tipo das células de SimGrid.

signal selection_changed

var grid: SimGrid
var has_selection := false
var selected := Vector2i.ZERO


func _draw() -> void:
	if grid == null:
		return
	var px := float(SimSettings.CELL_PX)
	for y in grid.size.y:
		for x in grid.size.x:
			var cell := Vector2i(x, y)
			var rect := Rect2(SimGrid.pixel_origin(cell), Vector2(px, px))
			draw_rect(rect, _color_for(grid.get_cell(cell)))
			draw_rect(rect, Color(0.3, 0.32, 0.36), false, 1.0)
	if has_selection:
		var rect := Rect2(SimGrid.pixel_origin(selected), Vector2(px, px))
		draw_rect(rect, Color(0.95, 0.8, 0.2), false, 3.0)


func _unhandled_input(event: InputEvent) -> void:
	var button := event as InputEventMouseButton
	if button == null or not button.pressed or button.button_index != MOUSE_BUTTON_LEFT:
		return
	var cell := SimGrid.cell_at_pixel(get_local_mouse_position())
	has_selection = grid.in_bounds(cell)
	if has_selection:
		selected = cell
	queue_redraw()
	selection_changed.emit()
	get_viewport().set_input_as_handled()


func _color_for(type: int) -> Color:
	match type:
		SimGrid.CellType.WALL:
			return Color(0.45, 0.45, 0.5)
		SimGrid.CellType.DOOR:
			return Color(0.55, 0.38, 0.2)
		SimGrid.CellType.OBJECT:
			return Color(0.3, 0.5, 0.35)
	return Color(0.13, 0.14, 0.16)
