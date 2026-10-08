# STATUS (única fonte de estado real)

Atualizar a cada commit relevante. Só registrar o que foi executado.

**Reset:** 2026-10-07. Projeto recomeçado do zero. Código anterior arquivado em `esterprotocol/scp`, branch `feat/classd-basic-needs`, como referência.

**Ambiente de verificação:** Godot `4.6.3.stable.official.7d41c59c4` (binário oficial, Linux x86_64), executado via `tools/godot.sh`.

**Branches:**
- `feat/f0-core` — F0 (commit `57a95de`). Aceitação manual **pendente**; o usuário decidiu seguir para F1 antes dela.
- `feat/f1-grid` — F1-01 (a partir de `feat/f0-core`). Alterações **não commitadas**.

| Item | Estado | Evidência |
|---|---|---|
| F0-01 | verificado | `godot --headless --import` e `--quit-after 120` da cena `view/main.tscn` sem erro (exit 0). Visual com janela ainda não executado. |
| F0-02 | verificado (headless) | `tests/test_clock.gd` e `tests/test_world.gd`: 1000 passos explícitos e 1000 chamadas de `advance(0.1)` produzem o mesmo checksum; velocidades 1/2/4; pausa; limite de salto. |
| F0-03 | verificado | `tests/run.gd` imprime `RESULT: 26 checks, 0 failures` e sai com 0. Com uma falha deliberada numa cópia descartável: `FAIL:` impresso, `RESULT: 27 checks, 1 failures`, exit 1. |
| F0-04 | verificado (headless) | `tests/test_save.gd`: salvar→carregar→salvar gera JSON idêntico; gravação em disco e leitura; tipo, velocidade, acumulador e versão inválidos rejeitados; arquivo corrompido não altera o estado. |
| F1-01 | verificado (headless); clique e câmera pendentes de teste visual | `tests/test_grid.gd`: grade 24×24, limites, tipos válidos, sentinela fora da grade, conversão pixel→célula. `tools/validate.sh` → `RESULT: 44 checks, 0 failures`, exit 0. Seleção por clique, zoom e pan só foram verificados por código, não na janela. |

Validação completa: `GODOT_BIN=/caminho/godot bash tools/validate.sh` → exit 0.

## Aceitações manuais
- F0: pendente. Não executada; o usuário pediu para seguir para F1 mesmo assim.
- F1: pendente (fatia só fecha com a aceitação de 10–15 min do `BACKLOG.md`).

## Limitações conhecidas
- F0-02 pede "duas execuções" idênticas. Os testes comparam dois mundos no mesmo processo, não dois processos separados.
- Tempo real é convertido em ticks por soma de ponto flutuante em unidades de tick. Com a mesma sequência de deltas, o resultado é idêntico; a simulação em si depende só do número de ticks, não da cadência de frames.
- Save: um slot, sem migração (fora de escopo de F0-04). A troca do arquivo usa `rename` do Godot; o comportamento de substituição no Windows não foi verificado aqui.
- A cena não tem gameplay além da grade e da seleção. Controles: Espaço pausa; 1/2/4 velocidade; F5 salva; F9 carrega; setas/WASD movem a câmera; roda do mouse dá zoom; clique esquerdo seleciona célula.
- **F1-01:** a grade (`SimWorld.grid`) ainda **não entra no save**. Salvar e carregar não preserva o mapa. Isso é escopo de F1-07; até lá, não usar o save como prova de nada envolvendo células.
- Binário do Godot foi obtido pelo download oficial e fica em `~/.local/bin/godot` nesta sessão, fora do repo.
- `docs/archive/GDD_v1.1.html` ainda não foi adicionado ao repo.
- Código de navegação do repo antigo (`esterprotocol/scp`) ainda não foi portado (F1-02).
