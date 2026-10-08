class_name SimGrid
extends RefCounted
## Grade de células da simulação. Sem nós de cena; não importa nada de view/.
## Guarda só o tipo de cada célula. Interpretação (acesso, capacidade, rota) vem em itens posteriores.

enum CellType { EMPTY = 0, WALL = 1, DOOR = 2, OBJECT = 3 }

## Sentinela devolvida por get_cell() fora da grade. Não é um tipo válido.
const OUT_OF_BOUNDS := -1

var size: Vector2i
var _cells := PackedInt32Array()


func _init(p_size: Vector2i = SimSettings.GRID_SIZE) -> void:
	size = p_size
	_cells.resize(size.x * size.y)
	_cells.fill(CellType.EMPTY)


func in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < size.x and cell.y < size.y


func get_cell(cell: Vector2i) -> int:
	if not in_bounds(cell):
		return OUT_OF_BOUNDS
	return _cells[cell.y * size.x + cell.x]


## Devolve false e não altera nada se a célula estiver fora da grade ou o tipo for inválido.
func set_cell(cell: Vector2i, type: int) -> bool:
	if not in_bounds(cell) or not is_valid_type(type):
		return false
	_cells[cell.y * size.x + cell.x] = type
	return true


static func is_valid_type(type: int) -> bool:
	return type >= CellType.EMPTY and type <= CellType.OBJECT


## Nome exibível do tipo, para a UI. Não é usado como identificador de save.
static func type_name(type: int) -> String:
	match type:
		CellType.EMPTY:
			return "vazia"
		CellType.WALL:
			return "parede"
		CellType.DOOR:
			return "porta"
		CellType.OBJECT:
			return "objeto"
	return "desconhecida"


## Célula que contém o ponto (em pixels lógicos da grade). Pode cair fora da grade.
static func cell_at_pixel(point: Vector2) -> Vector2i:
	return Vector2i(floori(point.x / SimSettings.CELL_PX), floori(point.y / SimSettings.CELL_PX))


## Canto superior esquerdo da célula, em pixels lógicos.
static func pixel_origin(cell: Vector2i) -> Vector2:
	return Vector2(cell) * SimSettings.CELL_PX
