class_name SaveCodec
extends RefCounted
## Save JSON versionado, um slot. Valida o arquivo inteiro antes de tocar no estado.

const DEFAULT_PATH := "user://site_director.json"
const KIND := "site_director_save"
const MAX_CHARS := 1048576
const INT_MAX := 2147483647


static func encode(world: SimWorld) -> String:
	var data := {
		"kind": KIND,
		"schema_version": SimSettings.SAVE_SCHEMA_VERSION,
		"seed": world.seed_value,
		"rng_state": world.rng.state,
		"tick": world.clock.tick,
		"speed": world.clock.speed,
		"paused": world.clock.paused,
		"accumulator": world.clock.accumulator,
		"checksum": world.checksum,
	}
	return JSON.stringify(data, "  ", true, true)


## Devolve {"ok": bool, "error": String, "state": Dictionary}. Não toca em nenhum mundo.
static func decode(text: String) -> Dictionary:
	if text.length() > MAX_CHARS:
		return _fail("arquivo grande demais")
	# JSON.new() devolve o erro sem registrar no log, diferente de parse_string().
	var json := JSON.new()
	if json.parse(text) != OK or typeof(json.data) != TYPE_DICTIONARY:
		return _fail("conteúdo não é um save válido")
	var data: Dictionary = json.data
	if data.get("kind") != KIND:
		return _fail("arquivo não pertence ao Site Director")
	if not _is_integer(data.get("schema_version")) or int(data["schema_version"]) != SimSettings.SAVE_SCHEMA_VERSION:
		return _fail("versão de save não suportada")

	var seed_value = data.get("seed")
	if not _in_int_range(seed_value, 0, SimRng.MASK):
		return _fail("seed inválida")
	var rng_state = data.get("rng_state")
	if not _in_int_range(rng_state, 1, SimRng.MASK):
		return _fail("estado do RNG inválido")
	var tick = data.get("tick")
	if not _in_int_range(tick, 0, INT_MAX):
		return _fail("tick inválido")
	var speed = data.get("speed")
	if not _is_integer(speed) or not SimSettings.SPEED_OPTIONS.has(int(speed)):
		return _fail("velocidade inválida")
	if typeof(data.get("paused")) != TYPE_BOOL:
		return _fail("estado de pausa inválido")
	var accumulator = data.get("accumulator")
	if not _is_number(accumulator) or accumulator < 0.0 or accumulator >= SimClock.ACCUMULATOR_LIMIT:
		return _fail("acumulador de tempo inválido")
	var checksum = data.get("checksum")
	if not _in_int_range(checksum, 0, SimWorld.CHECKSUM_MOD - 1):
		return _fail("checksum inválido")

	return {
		"ok": true,
		"error": "",
		"state": {
			"seed": int(seed_value),
			"rng_state": int(rng_state),
			"tick": int(tick),
			"speed": int(speed),
			"paused": data["paused"],
			"accumulator": float(accumulator),
			"checksum": int(checksum),
		},
	}


## Aplica um estado já validado por decode(). Não valida de novo.
static func apply(world: SimWorld, state: Dictionary) -> void:
	world.seed_value = state["seed"]
	world.rng.state = state["rng_state"]
	world.clock.tick = state["tick"]
	world.clock.speed = state["speed"]
	world.clock.paused = state["paused"]
	world.clock.accumulator = state["accumulator"]
	world.checksum = state["checksum"]


## Grava em arquivo temporário e troca pelo definitivo. Devolve "" em caso de sucesso.
static func save_file(world: SimWorld, path: String = DEFAULT_PATH) -> String:
	var temp_path := path + ".tmp"
	var file := FileAccess.open(temp_path, FileAccess.WRITE)
	if file == null:
		return "não foi possível abrir o arquivo de save"
	file.store_string(encode(world))
	file.close()
	var dir := DirAccess.open(path.get_base_dir())
	if dir == null or dir.rename(temp_path.get_file(), path.get_file()) != OK:
		return "não foi possível substituir o save anterior"
	return ""


## Lê, valida e só então aplica. Em caso de erro, o mundo fica intacto.
static func load_file(world: SimWorld, path: String = DEFAULT_PATH) -> String:
	if not FileAccess.file_exists(path):
		return "nenhum save encontrado"
	var result := decode(FileAccess.get_file_as_string(path))
	if not result["ok"]:
		return result["error"]
	apply(world, result["state"])
	return ""


static func _fail(message: String) -> Dictionary:
	return {"ok": false, "error": message, "state": {}}


static func _is_integer(value: Variant) -> bool:
	if typeof(value) == TYPE_INT:
		return true
	return typeof(value) == TYPE_FLOAT and value == floorf(value)


static func _is_number(value: Variant) -> bool:
	return typeof(value) == TYPE_INT or typeof(value) == TYPE_FLOAT


static func _in_int_range(value: Variant, low: int, high: int) -> bool:
	return _is_integer(value) and int(value) >= low and int(value) <= high
