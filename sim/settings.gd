class_name SimSettings
extends RefCounted
## Parâmetros da simulação. Não contém nada de apresentação.

const TICKS_PER_SECOND := 10
const SPEED_OPTIONS := [1, 2, 4]
## Limite por chamada de advance(): evita rajada de ticks após travamento.
const MAX_TICKS_PER_ADVANCE := 100
const SAVE_SCHEMA_VERSION := 1
## F1-01: grade 24×24 de células de 32 px (medida lógica, usada também para converter cliques).
const GRID_SIZE := Vector2i(24, 24)
const CELL_PX := 32
