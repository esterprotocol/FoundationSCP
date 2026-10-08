class_name SimWorld
extends RefCounted
## Estado mínimo da simulação. Sem gameplay ainda: serve para provar relógio, RNG e save.
## Cada tick consome um valor do RNG e atualiza um checksum; dois mundos com a mesma seed
## e o mesmo número de ticks precisam terminar com o mesmo checksum.

const CHECKSUM_MOD := 1000000007

var seed_value: int
var rng: SimRng
var clock := SimClock.new()
var checksum: int = 0


func _init(p_seed: int = 1) -> void:
	seed_value = p_seed
	rng = SimRng.new(p_seed)


## Executa exatamente um tick, independente de tempo real.
func step() -> void:
	_run_tick()


## Avança pelo tempo real e executa todos os ticks devidos. Devolve quantos rodaram.
func advance(delta: float) -> int:
	var due := clock.advance(delta)
	for _i in due:
		_run_tick()
	return due


func _run_tick() -> void:
	checksum = (checksum * 31 + rng.next_u32() % 1000) % CHECKSUM_MOD
	clock.tick += 1
