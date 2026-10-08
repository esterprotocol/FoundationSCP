# FoundationSCP

**SCP: Site Director** — jogo solo de construção e gestão de um Site da Fundação SCP, em visão 2D de cima.

Godot 4.6.3 · GDScript · renderer Compatibility.

## Documentos
- [`GDD.md`](GDD.md) — design (fonte única, enxuto).
- [`BACKLOG.md`](BACKLOG.md) — o que fazer.
- [`STATUS.md`](STATUS.md) — estado real, só o que foi executado.

## Estrutura
- `sim/` — simulação pura, sem nós de cena. Não importa nada de `view/`.
- `view/` — cena principal e apresentação. Não contém regra de simulação.
- `tests/` — runner headless e suítes por comportamento.
- `tools/` — `godot.sh` (fixa a versão do Godot) e `validate.sh` (validação completa).
- `data/` — conteúdo configurável (vazio por enquanto).
- `docs/` — documentação auxiliar.

## Rodar
Abrir a pasta no Godot 4.6.3 e executar a cena principal (`view/main.tscn`).

## Validar
```bash
GODOT_BIN=/caminho/para/godot bash tools/validate.sh
```
Importa o projeto, roda o runner de testes e executa a cena principal por 120 frames. Falha se houver `ERROR:` no log, se o runner reportar qualquer falha ou se nenhuma verificação rodar.
