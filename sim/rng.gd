class_name SimRng
extends RefCounted
## xorshift32 próprio. A sequência é a mesma em qualquer plataforma e versão do Godot,
## diferente do RandomNumberGenerator embutido, que pode mudar entre versões.

const MASK := 0xFFFFFFFF

var state: int = 1


func _init(seed_value: int = 1) -> void:
	state = seed_value & MASK
	if state == 0:
		state = 1


func next_u32() -> int:
	var x := state
	x ^= (x << 13) & MASK
	x ^= x >> 17
	x ^= (x << 5) & MASK
	state = x
	return x
