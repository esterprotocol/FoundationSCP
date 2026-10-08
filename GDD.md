# SCP: Site Director — GDD v2 (enxuto)

Fonte única de verdade. O GDD v1.1 vira `docs/archive/GDD_v1.1.html`: banco de ideias, não de requisitos. Nada do v1.1 entra no jogo sem passar por uma entrada em `BACKLOG.md`. O backlog é mutável; as decisões abaixo podem ser revistas quando um teste em jogo mostrar problema.

## Pitch
Construa e administre um Site da Fundação SCP em visão 2D de cima. Pessoas reais da simulação executam o que você planeja; falhas têm causa visível.

## Pilares
1. **Pessoas visíveis:** toda ordem vira trabalho físico de alguém no mapa.
2. **Causa visível:** todo bloqueio ou falha mostra o motivo exato na UI.
3. **Liberdade de construção:** salas são definidas por objetos e acesso, não por formato.

## Loop central
Planejar → construir → pessoas executam → observar gargalo → corrigir.

## Escopo (3 fatias verticais)
- **F1 — Um Classe-D sobrevive:** construir alojamento, refeitório e cozinha; um cozinheiro prepara um lote provisório; a bandeja passa pela janela de serviço; um Classe-D come e dorme; cartão de acesso com nível mínimo em porta; salvar/carregar.
- **F2 — População e recursos:** vários Classe-D, ingredientes com pedido, recebimento e transporte pela LOG, capacidade de zona.
- **F3 — SCP-173 mínimo:** uma câmara, observadores reservados, perda/recuperação de observação.

## NÃO faremos até F3 estar aceita
Departamentos além de Engenharia e Segurança básica · MTFs · facções · RRT · orçamento · pesquisa · energia · múltiplos andares · outros SCPs · computador do diretor · motins/fugas · multiplayer · permissões por setor ou horário · cartão copiado ou transferido · objetos de cozinha com efeito em revolta · horário de refeição por equipe.

Observação: LOG e o cargo de cozinheiro aparecem na F1–F2 como trabalho de pessoas, não como departamentos novos. Se virarem departamento próprio, a decisão volta para revisão.

## Decisões técnicas
- Godot 4.6.3, GDScript, renderer Compatibility.
- **Simulação separada da apresentação:** `sim/` não importa nada de `view/` nem de Node de cena. Isso permite testar headless e salvar estado limpo.
- Tick fixo de simulação, independente de FPS.
- Save em JSON versionado (`schema_version`), validado antes de substituir o estado.
- Testes headless: `godot --headless -s tests/run.gd`. Runner próprio, sem addon.
- IDs estáveis para toda entidade (pessoa, objeto, tarefa, reserva, cartão).
- **Acesso por cartão:** cartão é um item de inventário com `nivel` (0–5) e `id`. Porta tem `nivel_minimo`; pessoa sem cartão tem nível 0. A escala 0–5 é adaptação deste jogo, não regra da wiki. Verificação acontece de novo durante o trajeto. `[A DEFINIR: quem emite cartão além do diretor]`.
- **Comida sem automação:** nenhum objeto produz ou entrega refeição sozinho. Todo lote é trabalho de cozinheiro na bancada. Cozinha é única e multipropósito; o acesso é restrito por cartão. Classe-D recebem comida pela janela de serviço e nunca entram na cozinha.
- **Ingredientes (F2):** pedido do jogador → recebimento → transporte pela LOG até o depósito da cozinha → consumo no preparo. Sem custo financeiro até o módulo de orçamento existir.

## Regras de processo
- Cada item do backlog tem: objetivo, regras, estados, critério de pronto testável, fora de escopo.
- Fatia só fecha com **aceitação manual de 10–15 min** registrada em `STATUS.md`.
- Não se abre item de uma fatia futura antes da atual fechar.
- Decisão de design sem número definido fica marcada `[A DEFINIR]`; não inventar valores.
