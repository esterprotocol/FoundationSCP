extends Node2D
## Apresentação: relógio (F0), grade e câmera (F1-01). Nenhuma regra de simulação aqui.

const PAN_SPEED := 600.0
const ZOOM_MIN := 0.5
const ZOOM_MAX := 3.0
const ZOOM_STEP := 1.1

var world := SimWorld.new(2026)
var grid_view := GridView.new()
var camera := Camera2D.new()
var hud := Label.new()
var message := ""


func _ready() -> void:
	grid_view.grid = world.grid
	grid_view.selection_changed.connect(_refresh)
	add_child(grid_view)

	camera.position = Vector2(SimSettings.GRID_SIZE * SimSettings.CELL_PX) / 2.0
	add_child(camera)
	camera.make_current()

	var layer := CanvasLayer.new()
	add_child(layer)
	hud.position = Vector2(16, 16)
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(hud)
	_refresh()


func _process(delta: float) -> void:
	world.advance(delta)
	camera.position += _pan_direction() * PAN_SPEED * delta / camera.zoom.x
	_refresh()


func _unhandled_input(event: InputEvent) -> void:
	var button := event as InputEventMouseButton
	if button != null:
		if button.pressed and button.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom(ZOOM_STEP)
		elif button.pressed and button.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom(1.0 / ZOOM_STEP)
		return

	var key := event as InputEventKey
	if key == null or not key.pressed or key.echo:
		return
	match key.keycode:
		KEY_SPACE:
			world.clock.toggle_pause()
		KEY_1:
			world.clock.set_speed(1)
		KEY_2:
			world.clock.set_speed(2)
		KEY_4:
			world.clock.set_speed(4)
		KEY_F5:
			message = _report(SaveCodec.save_file(world), "Save gravado.")
		KEY_F9:
			message = _report(SaveCodec.load_file(world), "Save carregado.")
	_refresh()


func _pan_direction() -> Vector2:
	var dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		dir.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		dir.x += 1.0
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		dir.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		dir.y += 1.0
	return dir.normalized()


func _zoom(factor: float) -> void:
	var z := clampf(camera.zoom.x * factor, ZOOM_MIN, ZOOM_MAX)
	camera.zoom = Vector2(z, z)


func _report(error: String, ok_text: String) -> String:
	return ok_text if error.is_empty() else "Erro: " + error


func _refresh() -> void:
	var selection := "Nenhuma célula selecionada."
	if grid_view.has_selection:
		var cell := grid_view.selected
		selection = "Célula %d,%d · %s" % [
			cell.x,
			cell.y,
			SimGrid.type_name(world.grid.get_cell(cell)),
		]
	hud.text = "Tick %d · %dx · %s\nChecksum %d\n%s\n%s\nEspaço pausa · 1/2/4 velocidade · F5 salvar · F9 carregar · setas/WASD mover · roda zoom" % [
		world.clock.tick,
		world.clock.speed,
		"Pausado" if world.clock.paused else "Rodando",
		world.checksum,
		selection,
		message,
	]
