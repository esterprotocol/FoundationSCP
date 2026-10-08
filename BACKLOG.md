# Backlog v1.1

Este arquivo descreve **o que fazer**. Status real fica só em `STATUS.md`.
Prioridade = ordem de execução. Dependência é obrigatória.
O backlog é mutável: itens podem ser reescritos, divididos ou removidos quando o teste em jogo mostrar que a premissa estava errada. Mudança registrada em "Histórico" no fim do arquivo.

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
| F1-02 | Navegação ortogonal (A*) com portas e cartão | Porta tem `nivel_minimo`; pessoa sem cartão = nível 0. Porta negada vira aresta bloqueada. Rota recalcula se parede muda ou se o cartão for perdido no trajeto. Sem rota → `bloqueado` com motivo (ex.: "Porta da cozinha exige nível 1. Pessoa: sem cartão.") | Testes: (a) sem cartão não passa por porta nível ≥1; (b) nível suficiente passa; (c) cartão perdido no meio do trajeto força recálculo ou bloqueio com motivo | Permissão por setor, por horário, cartão copiado/transferido, cartões múltiplos |
| F1-03 | Blueprint de parede/porta + fila de tarefas + 1 engenheiro | Tarefa: `pendente→reservada→em_execução→concluída/cancelada`; engenheiro vai até o local e constrói | Parede só existe após trabalho físico; cancelar libera reserva | Custo, materiais, demolição |
| F1-04 | Zonas Alojamento, Refeitório e Cozinha + objetos: cama, assento/mesa, bancada, fogão, janela de serviço | Zona válida exige ≥1 objeto operacional acessível. Capacidade = nº de objetos utilizáveis. Cozinha exige bancada **e** fogão acessíveis. Refeitório e Cozinha se ligam pela janela de serviço. Porta da cozinha: `nivel_minimo = 1` `[A DEFINIR: confirmar nível]`. UI mostra requisito faltante. `[A DEFINIR: exigir sala fechada?]` | Remover objeto reduz capacidade na hora; janela sem cozinha ou refeitório ao lado é inválida | Energia, ventilação, múltiplos andares |
| F1-05 | Classe-D com fome e descanso | Necessidade cai por tick `[A DEFINIR: taxas]`. Fome só é suprida por bandeja retirada da janela no refeitório. Descanso é suprido por cama. Reserva impede uso duplo. | Teste: com cama e bandeja disponível, sobrevive N dias; sem um dos dois, aparece alerta com causa | Morte, saúde, humor, consumo de ingrediente (F2) |
| F1-06 | Painel de pessoa + alertas | Clique mostra tarefa atual, destino, necessidades, impedimento, cartão e nível | Todo estado `bloqueado` exibe motivo em texto | Histórico, relações |
| F1-07 | Save/load cobre mapa, pessoas, tarefas, reservas, inventário e cartões | Salvar no meio de deslocamento, preparo e uso; carregar 2× sem duplicar nada | Teste automatizado + aceitação manual | |
| F1-08 | Cozinheiro prepara lote provisório | Cozinheiro é um cargo de pessoal, não departamento. Ele reserva bancada e fogão, executa o preparo e gera bandejas na janela. Preparo só conclui quando as bandejas existem. Lote é provisório: não consome ingrediente nesta fatia. Cozinheiro precisa de cartão nível 1 para entrar na cozinha. `[A DEFINIR: quantos lotes por dia]` | Bandeja só aparece após conclusão; cozinheiro sem cartão não inicia preparo e a UI mostra o motivo | Ingredientes, depósito, LOG, turnos |

**Dependências internas da F1:** F1-02 antes de F1-04 (porta da cozinha) · F1-03 antes de F1-04 · F1-04 antes de F1-08 · F1-08 antes de F1-05.

**Aceitação F1 (manual, 10–15 min):** construir alojamento, refeitório e cozinha → instalar cama, mesa, bancada, fogão e janela → emitir cartão nível 1 para um cozinheiro → cozinheiro prepara lote → bandeja aparece na janela → Classe-D pega a bandeja no refeitório e come → Classe-D sem cartão é bloqueado na porta da cozinha e a UI mostra o motivo → salvar durante deslocamento → carregar → provocar falta de bandeja e ler a causa na UI.

## F2 — População e recursos
Dependência: F1 aceita. Itens detalhados só quando F1 fechar (evita especificar no escuro).
- F2-01 Múltiplos Classe-D com reserva sem colisão.
- F2-02 Ingredientes: pedido do jogador → recebimento na área de recebimento → transporte pela LOG ao depósito da cozinha → cozinheiro retira itens do depósito e consome **no preparo**, não no consumo. Reserva e consumo só na conclusão, sem duplicar em save/load.
- F2-03 Equipe LOG (cargo ou departamento `[A DEFINIR]`): transporta recebimento → depósito e bandejas → janela de serviço.
- F2-04 Capacidade de zona visível e gargalo diagnosticável (ex.: bandeja atrasada porque nenhum transportador está livre).
- F2-05 Horário de refeição único para Classe-D. Horário por equipe fica fora até existir conflito real de uso da cozinha.

## F3 — SCP-173 mínimo
Dependência: F2 aceita. **Antes de qualquer código:** ficha operacional aprovada por você (condição de observação, nº de observadores, perda de observação, movimento). Valores `[A DEFINIR]`.
- F3-01 Ficha aprovada.
- F3-02 Instância única na câmara, persistente.
- F3-03 Manutenção com observadores reservados (SD e ScD entram aqui).
- F3-04 Perda/recuperação de observação reproduzível em teste.

## Template de item novo
`ID · objetivo · regras · estados · interações · UI/feedback · critério de pronto testável · fora de escopo · dependência`

## Histórico
- **v1.1 (2026-10-08):** cozinha e refeitório substituem "distribuidor". Cozinheiro é cargo de pessoal. Ingredientes e transporte por LOG saem para F2. Acesso por cartão com `nivel_minimo` entra na F1. Horário de refeição por equipe adiado para F2.
- **v1.0 (reset):** backlog inicial.
