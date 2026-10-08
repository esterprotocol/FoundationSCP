# Backlog v1.0 (reset)

Este arquivo descreve **o que fazer**. Status real fica só em `STATUS.md`.
Prioridade = ordem de execução. Dependência é obrigatória.

## F0 — Esqueleto técnico

| ID | Objetivo | Critério de pronto | Fora de escopo |
|---|---|---|---|
| F0-01 | Projeto Godot 4.6.3 criado, estrutura `sim/ view/ tests/ docs/ data/`, repo limpo com `.gitignore` | Abre sem erro; cena principal roda vazia | Qualquer gameplay |
| F0-02 | Relógio de simulação: tick fixo, pausa, velocidades 1×/2×/4× | Teste headless: N ticks produzem estado idêntico em duas execuções | Dia/noite, turnos |
| F0-03 | Runner de testes headless | `godot --headless -s tests/run.gd` retorna código ≠0 se algum teste falhar | Addons de teste |
| F0-04 | Save/load versionado (um slot) com validação antes de aplicar | Round-trip: salvar→carregar→salvar gera JSON idêntico; arquivo corrompido não altera estado | Migração (ainda não há schema antigo) |

## F1 — Um Classe-D sobrevive
Dependência: F0 completa.

| ID | Objetivo | Regras / estados | Critério de pronto | Fora de escopo |
|---|---|---|---|---|
| F1-01 | Grade 24×24, câmera, seleção de célula | Célula: vazia/parede/porta/objeto | Clicar seleciona; câmera move e dá zoom | Mapa 64×64 |
| F1-02 | Navegação ortogonal (A*) com portas | Rota recalcula se parede muda; sem rota → estado `bloqueado` com motivo | Teste: caminho existe/não existe/porta fechada | Controle de acesso por autorização |
| F1-03 | Blueprint de parede/porta + fila de tarefas + 1 engenheiro | Tarefa: `pendente→reservada→em_execução→concluída/cancelada`; engenheiro vai até o local e constrói | Parede só existe após trabalho físico; cancelar libera reserva | Custo, materiais, demolição |
| F1-04 | Zonas Alojamento e Refeitório + objetos cama e distribuidor | Zona válida exige: ≥1 objeto operacional acessível. Capacidade = nº de objetos. UI mostra requisito faltante `[A DEFINIR: exigir sala fechada?]` | Remover objeto reduz capacidade na hora | Mesa, assento, energia |
| F1-05 | Classe-D com fome e descanso | Necessidade cai por tick `[A DEFINIR: taxas]`; abaixo de limiar busca cama/distribuidor; reserva impede uso duplo | Teste: com cama+distribuidor sobrevive N dias; sem um deles aparece alerta com causa | Morte, saúde, humor |
| F1-06 | Painel de pessoa + alertas | Clique mostra tarefa atual, destino, necessidades, impedimento | Todo estado `bloqueado` exibe motivo em texto | Histórico, relações |
| F1-07 | Save/load cobre mapa, pessoas, tarefas, reservas | Salvar no meio de deslocamento e uso; carregar 2× sem duplicar nada | Teste automatizado + aceitação manual | |

**Aceitação F1 (manual, 10–15 min):** construir alojamento e refeitório → instalar cama e distribuidor → ver o Classe-D usar ambos → salvar durante deslocamento → carregar → provocar falta de cama e ler o motivo na UI.

## F2 — População e recursos
Dependência: F1 aceita. Itens detalhados só quando F1 fechar (evita especificar no escuro).
- F2-01 Múltiplos Classe-D com reserva sem colisão.
- F2-02 Estoque agregado de refeição: reserva, consumo só na conclusão, sem duplicar em save/load.
- F2-03 Capacidade de zona visível e gargalo diagnosticável.

## F3 — SCP-173 mínimo
Dependência: F2 aceita. **Antes de qualquer código:** ficha operacional aprovada por você (condição de observação, nº de observadores, perda de observação, movimento). Valores `[A DEFINIR]`.
- F3-01 Ficha aprovada.
- F3-02 Instância única na câmara, persistente.
- F3-03 Manutenção com observadores reservados.
- F3-04 Perda/recuperação de observação reproduzível em teste.

## Template de item novo
`ID · objetivo · regras · estados · interações · UI/feedback · critério de pronto testável · fora de escopo · dependência`
