# Backlog v1.2

Este arquivo descreve **o que fazer**. Status real fica só em `STATUS.md`.
Prioridade = ordem de execução. Dependência é obrigatória.
O backlog é mutável: itens podem ser reescritos, divididos ou removidos quando o teste em jogo mostrar que a premissa estava errada. Mudanças registradas em "Histórico" no fim do arquivo. IDs não são reutilizados.

## F0 — Esqueleto técnico

| ID | Objetivo | Critério de pronto | Fora de escopo |
|---|---|---|---|
| F0-01 | Projeto Godot 4.6.3 criado, estrutura `sim/ view/ tests/ docs/ data/`, repo limpo com `.gitignore` | Abre sem erro; cena principal roda vazia | Qualquer gameplay |
| F0-02 | Relógio de simulação: tick fixo, pausa, velocidades 1×/2×/4× | Teste headless: N ticks produzem estado idêntico em duas execuções | Dia/noite, turnos |
| F0-03 | Runner de testes headless | `godot --headless -s tests/run.gd` retorna código ≠0 se algum teste falhar | Addons de teste |
| F0-04 | Save/load versionado (um slot) com validação antes de aplicar | Round-trip: salvar→carregar→salvar gera JSON idêntico; arquivo corrompido não altera estado | Migração (ainda não há schema antigo) |
| F0-05 | Registro de conteúdo em `data/`: objetos, zonas e cargos definidos por ID em arquivo versionado | Carregar um objeto por ID; ID inexistente gera erro explícito no teste | Conteúdo real além de um objeto de teste |

## F1 — Um Classe-D sobrevive
Dependência: F0 completa.

**Ordem de execução proposta:** F1-01 → F1-09 → F1-02 → F1-10 → F1-11 → F1-03 → F1-04 → F1-08 → F1-05 → F1-06 → F1-07.

| ID | Objetivo | Regras / estados | Critério de pronto | Fora de escopo |
|---|---|---|---|---|
| F1-01 | Grade 24×24, câmera, seleção de célula | Célula: vazia/parede/porta/objeto | Clicar seleciona; câmera move e dá zoom | Mapa 64×64 |
| F1-02 | Navegação ortogonal (A*) com portas e cartão | Porta tem `nivel_minimo`; pessoa sem cartão = nível 0. Porta negada vira aresta bloqueada. Rota recalcula se parede muda ou se o cartão for perdido no trajeto. Sem rota → `bloqueado` com motivo e regra responsável | Testes: (a) sem cartão não passa por porta nível ≥1; (b) nível suficiente passa; (c) cartão perdido no meio do trajeto força recálculo ou bloqueio com motivo | Permissão por setor, por horário, cartão copiado/transferido, cartões múltiplos |
| F1-03 | Blueprint de parede/porta + fila de tarefas + 1 engenheiro | Tarefa: `pendente→reservada→em_execução→concluída/cancelada`; engenheiro vai até o local e constrói. Engenheiro precisa estar `disponível` (F1-09) | Parede só existe após trabalho físico; cancelar libera reserva | Custo, materiais, demolição, reparo de objetos |
| F1-04 | Zonas Alojamento, Refeitório e Cozinha + objetos: cama, assento/mesa, bancada, fogão, janela de serviço | Zona válida exige ≥1 objeto operacional acessível. Capacidade = nº de objetos utilizáveis. Cozinha exige bancada **e** fogão acessíveis. Refeitório e Cozinha se ligam pela janela de serviço. Porta da cozinha: `nivel_minimo = 1` `[A DEFINIR: confirmar nível]`. Janela sem cozinha ou refeitório ao lado é inválida. `[A DEFINIR: exigir sala fechada?]` | Remover objeto reduz capacidade na hora | Energia, ventilação, múltiplos andares |
| F1-05 | Classe-D com fome e descanso | Necessidade cai por tick `[A DEFINIR: taxas]`. Fome só é suprida por bandeja retirada da janela no refeitório. Descanso é suprido por cama. Reserva impede uso duplo. | Teste: com cama e bandeja disponível, sobrevive N dias; sem um dos dois, alerta com causa aparece | Morte, saúde, higiene, medo de teste, consumo de ingrediente (F2) |
| F1-06 | Painel de pessoa + alertas | Clique mostra estado, tarefa atual, destino, necessidades, impedimento, inventário (cartão e nível) e alertas ligados à pessoa. | Todo estado `bloqueado` exibe motivo em texto, com regra ou objeto responsável. Nenhuma informação depende só de cor ou som. | Histórico completo, relações |
| F1-07 | Save/load cobre mapa, pessoas, tarefas, reservas, inventário, cartões e alertas | Salvar no meio de deslocamento, preparo e uso; carregar 2× sem duplicar nada | Teste automatizado + aceitação manual | |
| F1-08 | Cozinheiro prepara lote provisório | Cozinheiro é cargo `[A DEFINIR: cargo da LOG, confirmar]`. Ele reserva bancada e fogão, executa o preparo e gera bandejas na janela. Preparo só conclui quando as bandejas existem. Lote é provisório: não consome ingrediente nesta fatia. Cozinheiro precisa de cartão nível 1 para entrar na cozinha. `[A DEFINIR: quantos lotes por dia]` | Bandeja só aparece após conclusão; cozinheiro sem cartão não inicia preparo e a UI mostra o motivo | Ingredientes, depósito, LOG, turnos |
| F1-09 | Modelo de pessoa e inventário | Campos: `id`, `cargo`, `departamento`, `estado` (`disponível`, `em_tarefa`, `em_deslocamento`, `fadigada`, `folga`), `inventario`, `fome`, `descanso`. Transições de estado são registradas. Ferido e doente não existem nesta fatia. | Teste: pessoa em `folga` não recebe tarefa; pessoa `fadigada` recebe apenas tarefa de descanso; transição inválida é rejeitada | Saúde, experiência, treinamento, higiene |
| F1-10 | Alertas mínimos com causa | Alerta: `natureza` (infraestrutura, rotina, anomalia, saúde), `gravidade` (rotina, atenção, emergência setorial), `localização`, `causa` (regra, objeto ou pessoa), `estado` (aberto/resolvido). Bloqueio de tarefa cria ou aponta alerta. Ao resolver a causa, alerta fecha e vai ao histórico. | Teste: bloqueio por falta de bandeja gera alerta com causa; restaurar a bandeja fecha o alerta; histórico preserva o registro | Confiança da informação (F3), alertas de anomalia |
| F1-11 | Conflito de políticas | Políticas têm escopo (Site, setor, departamento, operação). Quando duas regras se aplicam, a mais restritiva prevalece. Exceção manual tem duração e aparece no histórico. | Teste: duas regras conflitantes → a mais restritiva vale; exceção expira e a regra volta; UI mostra qual regra bloqueou | Editor visual de políticas, delegação a chefes |

**Aceitação F1 (manual, 10–15 min):** construir alojamento, refeitório e cozinha → instalar cama, mesa, bancada, fogão e janela → emitir cartão nível 1 para um cozinheiro → cozinheiro prepara lote → bandeja aparece na janela → Classe-D pega a bandeja no refeitório e come → Classe-D sem cartão é bloqueado na porta da cozinha e a UI mostra o motivo e a regra → salvar durante deslocamento → carregar → provocar falta de bandeja, ler o alerta com causa → restaurar a bandeja e ver o alerta fechar.

## F2 — População e recursos
Dependência: F1 aceita. Itens detalhados só quando F1 fechar (evita especificar no escuro).

- F2-01 Múltiplos Classe-D com reserva sem colisão.
- F2-02 Ingredientes: pedido do jogador → recebimento na área de recebimento → transporte pela LOG ao depósito da cozinha → cozinheiro retira itens e consome **no preparo**, não no consumo. Reserva e consumo só na conclusão, sem duplicar em save/load.
- F2-03 Equipe LOG (cargo ou departamento `[A DEFINIR]`): transporta recebimento → depósito e bandejas → janela de serviço. Prioridade: bandeja antes de ingrediente.
- F2-04 Capacidade de zona visível e gargalo diagnosticável (ex.: bandeja atrasada porque nenhum transportador está livre).
- F2-05 Horário de refeição único para Classe-D. Horário por equipe fica fora até existir conflito real de uso da cozinha.
- F2-06 Rotina completa de Classe-D: chegada, registro, triagem, alojamento, refeições, descanso e convocação. Ordem fixa, com desvios gerando alerta.
- F2-07 Necessidades ampliadas: higiene, medo de teste e descontentamento. Taxas `[A DEFINIR]`.
- F2-08 Experiência por tipo de tarefa: aumenta com prática, reduz o tempo de execução e não gera promoção automática. Perda de pessoal retira experiência da equipe.
- F2-09 Recebimento e depósito como zonas próprias, com capacidade e regra de acesso (LOG entra; Classe-D não entra).

**Aceitação F2 (manual):** Classe-D cumpre a rotina do início ao fim → um ingrediente pedido chega, é transportado e vira refeição → gargalo de transporte aparece com causa na UI → salvar e carregar no meio do preparo sem duplicar material.

## F3 — SCP-173 mínimo
Dependência: F2 aceita. **Antes de qualquer código:** ficha operacional aprovada pelo diretor (você).

- F3-01 Ficha aprovada, com os campos definidos no GDD (fonte, forma física, necessidades, gatilhos, capacidades, percepção, condições de contenção, observação válida, recontenção, testes, interações, adaptações). Valores `[A DEFINIR]`.
- F3-02 Registro de fontes em `docs/sources.md` com autor, licença e URL. Obrigatório antes de F3-01 ser aprovada.
- F3-03 Instância única na câmara, persistente.
- F3-04 Observação válida: observadores reservados, em posição, sem outra tarefa. Câmera não conta como observação direta. Decisão `[A DEFINIR: câmera conta parcialmente?]`.
- F3-05 Perda e recuperação de observação: ocorre só quando observadores válidos deixam de manter a observação. Gatilhos são fatos da simulação (ex.: observador ferido, fadigado ou ausente), nunca sorteio por tempo. Reproduzível em teste.
- F3-06 Manutenção com observadores reservados. Revezamento coordenado pela rotina de SD.
- F3-07 SD entra nesta fatia com postos, observadores e controle de portas.
- F3-08 ScD propõe a ficha e registra observações. Relatório separa **observação**, **hipótese** e **conclusão sustentada**. Não faz experimentos com pessoas.
- F3-09 Alerta de anomalia com confiança da informação (observado, hipótese).

**Aceitação F3 (manual):** observação válida mantida por um turno inteiro → um observador é retirado e a UI mostra a perda com causa → recuperação com novo observador → relatório do ScD mostra o que foi observado e o que é hipótese.

## Pós-F3 (congelado)
Não há itens ativos. Ver `docs/archive/GDD_v1.1.html` para o banco de ideias: MED, AD, ISD, IA, RRT, facções, MTFs (13 especialidades), orçamento, pesquisa ampla, outros SCPs, multiplayer.

## Template de item novo
`ID · objetivo · regras · estados · interações · UI/feedback · critério de pronto testável · fora de escopo · dependência`

## Histórico
- **v1.2 (2026-10-08):** adicionados F0-05, F1-09 a F1-11, F2-06 a F2-09 e F3-02 a F3-09. Ordem de execução da F1 explícita. Aceitação F2 e F3 definidas. SD movida para F3 (F3-07). Acessibilidade e fontes incluídas nos critérios.
- **v1.1 (2026-10-08):** cozinha e refeitório substituem "distribuidor". Cozinheiro é cargo de pessoal. Ingredientes e transporte por LOG saem para F2. Acesso por cartão com `nivel_minimo` entra na F1. Horário de refeição por equipe adiado para F2.
- **v1.0 (reset):** backlog inicial.
