class_name Checks
extends RefCounted
## Contador de verificações do runner headless.

var total := 0
var failed := 0


func check(condition: bool, description: String) -> void:
	total += 1
	if not condition:
		failed += 1
		printerr("FAIL: " + description)
