class_name SimSettings
extends RefCounted
## Parâmetros da simulação. Não contém nada de apresentação.

const TICKS_PER_SECOND := 10
const SPEED_OPTIONS := [1, 2, 4]
## Limite por chamada de advance(): evita rajada de ticks após travamento.
const MAX_TICKS_PER_ADVANCE := 100
const SAVE_SCHEMA_VERSION := 1
