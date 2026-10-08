extends RefCounted
## F1-01: grade 24×24, limites, tipos válidos e conversão de pixel em célula.


func run(c: Checks) -> void:
	var grid := SimGrid.new()
	c.check(grid.size == Vector2i(24, 24), "grade tem 24×24 células")
	c.check(grid.in_bounds(Vector2i(0, 0)) and grid.in_bounds(Vector2i(23, 23)), "cantos válidos estão dentro da grade")
	c.check(not grid.in_bounds(Vector2i(24, 0)) and not grid.in_bounds(Vector2i(0, -1)), "fora da grade é rejeitado")
	c.check(grid.get_cell(Vector2i(0, 0)) == SimGrid.CellType.EMPTY, "célula nova começa vazia")
	c.check(grid.get_cell(Vector2i(-1, 0)) == SimGrid.OUT_OF_BOUNDS, "leitura fora da grade devolve sentinela")
	c.check(grid.set_cell(Vector2i(5, 7), SimGrid.CellType.WALL), "define parede dentro da grade")
	c.check(grid.get_cell(Vector2i(5, 7)) == SimGrid.CellType.WALL, "parede é lida de volta")
	c.check(grid.get_cell(Vector2i(7, 5)) == SimGrid.CellType.EMPTY, "escrita não vaza para outra célula")
	c.check(not grid.set_cell(Vector2i(24, 24), SimGrid.CellType.WALL), "escrita fora da grade é rejeitada")
	c.check(not grid.set_cell(Vector2i(0, 0), 99), "tipo inválido é rejeitado")
	c.check(grid.get_cell(Vector2i(0, 0)) == SimGrid.CellType.EMPTY, "tipo inválido não altera a célula")

	c.check(SimGrid.cell_at_pixel(Vector2(0, 0)) == Vector2i(0, 0), "pixel 0,0 é a célula 0,0")
	c.check(SimGrid.cell_at_pixel(Vector2(31.9, 31.9)) == Vector2i(0, 0), "fim da célula 0 ainda é a célula 0")
	c.check(SimGrid.cell_at_pixel(Vector2(32, 0)) == Vector2i(1, 0), "início da célula 1")
	c.check(SimGrid.cell_at_pixel(Vector2(-0.5, 0)) == Vector2i(-1, 0), "pixel negativo cai fora da grade")
	c.check(SimGrid.pixel_origin(Vector2i(2, 3)) == Vector2(64, 96), "origem em pixels da célula 2,3")
	c.check(SimGrid.type_name(SimGrid.CellType.DOOR) == "porta", "nome exibível do tipo porta")

	var world := SimWorld.new(5)
	c.check(world.grid.size == Vector2i(24, 24), "mundo possui grade 24×24")
