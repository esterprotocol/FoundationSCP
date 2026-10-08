extends SceneTree
## Runner headless: godot --headless --script res://tests/run.gd
## Sai com código 1 se houver falha ou se nenhuma verificação rodar.

const SUITES := [
	preload("res://tests/test_clock.gd"),
	preload("res://tests/test_world.gd"),
	preload("res://tests/test_save.gd"),
]


func _initialize() -> void:
	var checks := Checks.new()
	for suite in SUITES:
		suite.new().run(checks)
	print("RESULT: %d checks, %d failures" % [checks.total, checks.failed])
	quit(1 if checks.failed > 0 or checks.total == 0 else 0)
