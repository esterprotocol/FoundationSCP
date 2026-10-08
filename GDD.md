# SCP: Site Director — GDD v2 (enxuto)

Fonte única de verdade. O GDD v1.1 vira `docs/archive/GDD_v1.1.html`: banco de ideias, não de requisitos. Nada do v1.1 entra no jogo sem passar por uma entrada em `BACKLOG.md`.

## Pitch
Construa e administre um Site da Fundação SCP em visão 2D de cima. Pessoas reais da simulação executam o que você planeja; falhas têm causa visível.

## Pilares
1. **Pessoas visíveis:** toda ordem vira trabalho físico de alguém no mapa.
2. **Causa visível:** todo bloqueio ou falha mostra o motivo exato na UI.
3. **Liberdade de construção:** salas são definidas por objetos e acesso, não por formato.

## Loop central
Planejar → construir → pessoas executam → observar gargalo → corrigir.

## Escopo (3 fatias verticais)
- **F1 — Um Classe-D sobrevive:** construir alojamento e refeitório; um Classe-D come e dorme; salvar/carregar.
- **F2 — População e recursos:** vários Classe-D, estoque de refeição, capacidade de zona.
- **F3 — SCP-173 mínimo:** uma câmara, observadores reservados, perda/recuperação de observação.

## NÃO faremos até F3 estar aceita
Departamentos além de Engenharia e Segurança básica · MTFs · facções · RRT · orçamento · pesquisa · energia · múltiplos andares · outros SCPs · computador do diretor · motins/fugas · multiplayer.

## Decisões técnicas
- Godot 4.6.3, GDScript, renderer Compatibility.
- **Simulação separada da apresentação:** `sim/` não importa nada de `view/` nem de Node de cena. Isso permite testar headless e salvar estado limpo.
- Tick fixo de simulação, independente de FPS.
- Save em JSON versionado (`schema_version`), validado antes de substituir o estado.
- Testes headless: `godot --headless -s tests/run.gd`. Runner próprio, sem addon.
- IDs estáveis para toda entidade (pessoa, objeto, tarefa, reserva).

## Regras de processo
- Cada item do backlog tem: objetivo, regras, estados, critério de pronto testável, fora de escopo.
- Fatia só fecha com **aceitação manual de 10–15 min** registrada em `STATUS.md`.
- Não se abre item de uma fatia futura antes da atual fechar.
- Decisão de design sem número definido fica marcada `[A DEFINIR]`; não inventar valores.
