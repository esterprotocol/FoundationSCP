extends Node2D
## Apresentação mínima da F0: controla o relógio e mostra o estado. Nenhuma regra de simulação aqui.

var world := SimWorld.new(2026)
var label := Label.new()
var message := ""


func _ready() -> void:
	label.position = Vector2(16, 16)
	add_child(label)
	_refresh()


func _process(delta: float) -> void:
	world.advance(delta)
	_refresh()


func _unhandled_input(event: InputEvent) -> void:
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


func _report(error: String, ok_text: String) -> String:
	return ok_text if error.is_empty() else "Erro: " + error


func _refresh() -> void:
	label.text = "Tick %d · %dx · %s\nChecksum %d\n%s\nEspaço pausa · 1/2/4 velocidade · F5 salvar · F9 carregar" % [
		world.clock.tick,
		world.clock.speed,
		"Pausado" if world.clock.paused else "Rodando",
		world.checksum,
		message,
	]
