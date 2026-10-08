class_name SimClock
extends RefCounted
## Converte tempo real em ticks de simulação. Não decide o que acontece em cada tick.

## O acumulador é medido em ticks (1.0 = um tick). Assim, 0,1 s × 10 tps = 1.0 é exato
## em ponto flutuante, e o número de ticks não depende da soma de frações de segundo.
const ACCUMULATOR_LIMIT := 1.0

var tick: int = 0
var speed: int = 1
var paused: bool = false
## Tempo real já convertido em ticks, ainda não consumido. Sempre em [0, ACCUMULATOR_LIMIT).
var accumulator: float = 0.0


func set_speed(value: int) -> bool:
	if not SimSettings.SPEED_OPTIONS.has(value):
		return false
	speed = value
	return true


func set_paused(value: bool) -> void:
	paused = value


func toggle_pause() -> void:
	paused = not paused


## Devolve quantos ticks devem ser executados para o tempo real informado.
## Não altera `tick`: quem executa cada tick é o mundo, que incrementa o relógio.
func advance(delta: float) -> int:
	if paused or delta <= 0.0:
		return 0
	accumulator += delta * speed * SimSettings.TICKS_PER_SECOND
	var due := 0
	while accumulator >= ACCUMULATOR_LIMIT and due < SimSettings.MAX_TICKS_PER_ADVANCE:
		accumulator -= ACCUMULATOR_LIMIT
		due += 1
	if due == SimSettings.MAX_TICKS_PER_ADVANCE:
		accumulator = 0.0
	return due
