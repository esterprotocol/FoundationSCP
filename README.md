# FoundationSCP

**SCP: Site Director** — jogo solo de construção e gestão de um Site da Fundação SCP, em visão 2D de cima.

Godot 4.6.3 · GDScript · renderer Compatibility.

## Documentos
- [`GDD.md`](GDD.md) — design (fonte única, enxuto).
- [`BACKLOG.md`](BACKLOG.md) — o que fazer.
- [`STATUS.md`](STATUS.md) — estado real, só o que foi executado.

## Estrutura
- `sim/` — simulação (não importa nada de `view/`).
- `view/` — cenas e apresentação.
- `tests/` — testes headless.
- `data/` — conteúdo configurável.
- `docs/` — documentação auxiliar.

## Rodar
Abrir a pasta no Godot 4.6.3 e executar a cena principal (`view/main.tscn`).
