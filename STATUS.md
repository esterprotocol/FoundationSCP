# STATUS (única fonte de estado real)

Atualizar a cada commit relevante. Só registrar o que foi executado.

**Reset:** 2026-10-07. Projeto recomeçado do zero. Código anterior arquivado em `esterprotocol/scp`, branch `feat/classd-basic-needs`, como referência.

**Ambiente de verificação:** Godot `4.6.3.stable.official.7d41c59c4` (binário oficial, Linux x86_64), executado via `tools/godot.sh`.

| Item | Estado | Evidência |
|---|---|---|
| F0-01 | verificado | `godot --headless --import` e `--quit-after 120` da cena `view/main.tscn` sem erro (exit 0). Visual com janela ainda não executado. |
| F0-02 | verificado (headless) | `tests/test_clock.gd` e `tests/test_world.gd`: 1000 passos explícitos e 1000 chamadas de `advance(0.1)` produzem o mesmo checksum; velocidades 1/2/4; pausa; limite de salto. |
| F0-03 | verificado | `tests/run.gd` imprime `RESULT: 26 checks, 0 failures` e sai com 0. Com uma falha deliberada numa cópia descartável: `FAIL:` impresso, `RESULT: 27 checks, 1 failures`, exit 1. |
| F0-04 | verificado (headless) | `tests/test_save.gd`: salvar→carregar→salvar gera JSON idêntico; gravação em disco e leitura; tipo, velocidade, acumulador e versão inválidos rejeitados; arquivo corrompido não altera o estado. |

Validação completa: `GODOT_BIN=/caminho/godot bash tools/validate.sh` → exit 0.

## Aceitações manuais
(nenhuma ainda — a aceitação de fatia só fecha com teste humano no Godot, conforme `GDD.md`)

## Limitações conhecidas
- F0-02 pede "duas execuções" idênticas. Os testes comparam dois mundos no mesmo processo, não dois processos separados.
- Tempo real é convertido em ticks por soma de ponto flutuante em unidades de tick. Com a mesma sequência de deltas, o resultado é idêntico; a simulação em si depende só do número de ticks, não da cadência de frames.
- Save: um slot, sem migração (fora de escopo de F0-04). A troca do arquivo usa `rename` do Godot; o comportamento de substituição no Windows não foi verificado aqui.
- A cena da F0 não tem gameplay. Controles: Espaço pausa; 1/2/4 velocidade; F5 salva; F9 carrega.
- `docs/archive/GDD_v1.1.html` ainda não foi adicionado ao repo.
- Código de grade e navegação do repo antigo (`esterprotocol/scp`) ainda não foi portado: pertence à F1 e só entra depois de F0 ser aceita.
