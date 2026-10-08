extends RefCounted
## F0-04: save versionado, round-trip idêntico, validação antes de aplicar.

const DIR := "user://tests"
const PATH := "user://tests/slot.json"


func run(c: Checks) -> void:
	DirAccess.open("user://").make_dir_recursive("tests")

	var original := SimWorld.new(42)
	for _i in 500:
		original.step()
	original.clock.set_speed(2)
	original.clock.advance(0.02)  # 0,02 s a 2× = 0,4 tick fica no acumulador
	var text := SaveCodec.encode(original)

	var restored := SimWorld.new(1)
	var result := SaveCodec.decode(text)
	c.check(result["ok"], "save válido é aceito")
	SaveCodec.apply(restored, result["state"])
	c.check(SaveCodec.encode(restored) == text, "salvar→carregar→salvar gera JSON idêntico")
	for _i in 200:
		original.step()
		restored.step()
	c.check(restored.checksum == original.checksum, "após carregar, a simulação continua igual")

	c.check(SaveCodec.save_file(original, PATH) == "", "grava o slot em disco")
	var from_disk := SimWorld.new(7)
	c.check(SaveCodec.load_file(from_disk, PATH) == "", "carrega o slot do disco")
	c.check(SaveCodec.encode(from_disk) == SaveCodec.encode(original), "estado vindo do disco é idêntico")

	var before := SaveCodec.encode(from_disk)
	var data: Dictionary = JSON.parse_string(text)
	data["tick"] = "x"
	c.check(not SaveCodec.decode(JSON.stringify(data))["ok"], "tipo inválido em tick é rejeitado")
	data["tick"] = 500
	data["speed"] = 3
	c.check(not SaveCodec.decode(JSON.stringify(data))["ok"], "velocidade fora de 1/2/4 é rejeitada")
	data["speed"] = 2
	data["accumulator"] = 1.5
	c.check(not SaveCodec.decode(JSON.stringify(data))["ok"], "acumulador acima de um tick é rejeitado")
	data["accumulator"] = 0.4
	data["schema_version"] = 99
	c.check(not SaveCodec.decode(JSON.stringify(data))["ok"], "versão desconhecida é rejeitada")

	var file := FileAccess.open(PATH, FileAccess.WRITE)
	file.store_string("{ truncado")
	file.close()
	c.check(SaveCodec.load_file(from_disk, PATH) != "", "arquivo corrompido gera erro")
	c.check(SaveCodec.encode(from_disk) == before, "arquivo corrompido não altera o estado")

	DirAccess.open(DIR).remove("slot.json")
