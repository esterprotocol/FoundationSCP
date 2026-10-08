# SCP: Site Director — GDD v2.1

Fonte única de verdade. O GDD v1.1 vira `docs/archive/GDD_v1.1.html`: banco de ideias, não de requisitos. Nada do v1.1 entra no jogo sem passar por uma entrada em `BACKLOG.md`. O backlog é mutável; as decisões abaixo podem ser revistas quando um teste em jogo mostrar problema. Mudança de regra de design entra no GDD e no backlog no mesmo commit.

## Pitch
Construa e administre um Site da Fundação SCP em visão 2D de cima. Pessoas reais da simulação executam o que você planeja; falhas têm causa visível e a instalação pode se recuperar delas.

## Pilares
1. **Pessoas visíveis:** toda ordem vira trabalho físico de alguém no mapa, com estado próprio (disponível, ocupada, fadigada).
2. **Causa visível:** todo bloqueio, alerta ou falha mostra o motivo exato na UI e aponta a regra ou o objeto responsável.
3. **Departamentos dependentes:** cada equipe resolve um problema próprio e depende de outras. Nenhuma equipe funciona sozinha.
4. **Recuperação:** perder uma ala, um objeto ou uma equipe abre um caminho de reconstrução. A instalação não termina no primeiro erro.
5. **Liberdade de construção:** salas são definidas por objetos, acesso e serviços, não por formato.

## Loop central
Planejar → construir → pessoas executam → observar gargalo → corrigir → recuperar quando algo falhar.

## Escopo (3 fatias verticais)
- **F1 — Um Classe-D sobrevive:** construir alojamento, refeitório e cozinha; um cozinheiro prepara um lote provisório; a bandeja passa pela janela de serviço; um Classe-D come e dorme; cartão de acesso com nível mínimo em porta; alertas com causa; salvar/carregar.
- **F2 — População e recursos:** vários Classe-D, ingredientes com pedido e transporte pelo SG, capacidade de zona, rotina completa de Classe-D, experiência de pessoal.
- **F3 — SCP-173 mínimo:** uma câmara, observadores reservados, observação válida, perda e recuperação de observação, relatório que separa observação de hipótese.

## Modelo de pessoas (mínimo para F1)
Cada pessoa tem `id` estável, `cargo`, `departamento`, `estado`, `inventario` e necessidades.

- **Estados:** `disponível`, `em_tarefa`, `em_deslocamento`, `fadigada`, `folga`. Ferido, doente e morto ficam fora da F1 e entram com saúde (fase posterior, `[A DEFINIR]`).
- **Necessidades F1:** fome e descanso. Higiene, medo de teste e descontentamento entram na F2.
- **Inventário:** lista de itens. Na F1 contém o cartão de acesso. Mesma estrutura serve depois para ferramentas e ingredientes.
- **Experiência:** por tipo de tarefa, com valor numérico `[A DEFINIR: escala]`. Aumenta com prática e não vira promoção automática. Entra na F2.
- **Cargo x departamento:** departamento tem uma ou mais filas de tarefas, uma por função. Função é o que a pessoa executa. Uma função nova só entra quando suas tarefas não cabem em nenhuma função existente.

## Alertas (mínimo para F1)
Alerta tem `natureza` (infraestrutura, rotina, anomalia, saúde), `gravidade` (rotina, atenção, emergência setorial), `localização`, `causa` (regra, objeto ou pessoa responsável) e `estado` (aberto, resolvido). Confiança da informação entra na F3, quando houver observação e hipótese.

Todo bloqueio de tarefa cria ou aponta um alerta com causa. Quando a causa é resolvida, o alerta fecha e fica registrado no histórico.

## Políticas e conflito de regras
- Políticas têm escopo: Site, setor, departamento ou operação.
- Quando duas regras se aplicam, **a mais restritiva prevalece**.
- Exceção manual tem duração definida e aparece no histórico. Expirada, a regra volta a valer.
- A UI informa qual regra bloqueou a tarefa. Exemplo: "Porta da cozinha exige nível 1 — regra do setor C." Funcionário nunca ignora o requisito em silêncio.

Esta regra vale para cartão de acesso desde a F1.

## Dependências entre equipes
- Obra depende de engenheiro livre e de bancada, quando for o caso.
- Cozinha depende de cartão nível 1 para o cozinheiro e de bancada e fogão acessíveis.
- Refeição depende de bandeja na janela de serviço.
- Ingrediente (F2) depende de recebimento, transporte pelo SG e depósito.
- Observação do SCP-173 (F3) depende de observadores válidos e do revezamento que a SD organiza.

Quando uma dependência falha, a UI mostra qual equipe ou objeto está faltando.

## Serviços Gerais: funções e filas
- SG é o departamento de serviços da instalação: cozinha e distribuição na F1–F2; limpeza no futuro.
- Cada função tem **fila própria** dentro do SG. Cada pessoa exerce uma função. Cada tarefa exige uma função.
- Cozinheiro não limpa. Zelador não prepara lote. Distribuidor não cozinha.
- Prioridade vale só dentro da mesma função. Não existe prioridade automática entre funções.
- Realocação entre funções é manual, decidida pelo diretor. A UI mostra o efeito: a fila de origem perde a pessoa.
- Funções previstas: Cozinheiro (F1), Distribuidor (F2), Zelador (reservada, sem agendamento).

## Áreas restritas
Uma área restrita só é restrita de fato quando três camadas funcionam:

1. **Permissão:** a zona tem `nivel_minimo`. A navegação só leva pessoas com nível suficiente. Classe-D (nível 0) nunca recebem rota para zona restrita.
2. **Detecção:** entrada sem permissão gera **intrusão** somente se a zona tem cobertura de vigilância ativa (posto ou câmera). Sem cobertura, a entrada acontece sem registro.
3. **Resposta:** a intrusão gera alerta para o setor responsável. Na F1 o alerta vai ao painel do diretor com estado "sem resposta". Na F3 a SD responde. Sem resposta, a intrusão continua aberta.

Estados mostrados na UI:
- **Restrita de fato:** permissão, cobertura e resposta disponível.
- **Restrita no papel:** falta cobertura ou resposta. A UI diz qual camada falta.
- **Aberta:** sem permissão nenhuma.

Como uma intrusão acontece: a navegação não leva Classe-D a zonas restritas. A brecha vem de porta deixada aberta por funcionário ou porta danificada. Forçar porta fica para depois da F3. Por isso portas precisam de estado aberto/fechado, registrado em F1-02.

Câmera é cobertura de detecção, não resposta. Mesma regra da F3-04 para observação.

Nota: a forma como o Prison Architect trata áreas restritas não foi verificada nesta revisão. O modelo de três camadas é decisão deste GDD.

## Equipes e status

| Equipe / cargo | Fatia | Estado |
|---|---|---|
| ENG — Engenharia | F1 | Ativa. Obras e portas. |
| Cozinheiro | F1 | Função do SG. Confirmado pelo diretor. |
| SG — Serviços Gerais | F1 (cozinha), F2 (distribuição) | Departamento com filas por função: Cozinheiro, Distribuidor e, no futuro, Zelador. Limpeza fora de escopo até agendamento. |
| SD — Segurança | F3 | Postos, observadores e portas. Não existe antes da F3. |
| ScD — Científico | F3 | Propõe e registra a ficha e as observações do SCP-173. Não faz experimentos com pessoas. |
| MED, AD, ISD, IA, RRT | Pós-F3 | Congeladas. Entram quando houver tarefa que as justifique. |
| 13 especialidades MTF | Pós-F3 | Congeladas. Texto completo no archive. |

## Comida e cozinha
- Nenhum objeto produz ou entrega refeição sozinho. Todo lote é trabalho de cozinheiro na bancada.
- Cozinha é única e multipropósito. Acesso restrito por cartão.
- Classe-D recebem comida pela janela de serviço e nunca entram na cozinha.
- Horário de refeição é único para Classe-D na F2. Horário por equipe fica fora até existir conflito real.
- Objetos de cozinha que possam ferir ficam marcados com `risco_de_arma` como dado. Efeito em revolta fica fora até existir revolta.

## Anomalias
### Princípios (valem para qualquer SCP)
- Comportamento vem de fatos da simulação, não de rolagem aleatória por tempo.
- Câmera e vigilância administrativa são informação. Não substituem observação direta quando a ficha exigir observador.
- Cada anomalia adiciona decisões diferentes. Não repete a mesma mecânica com números maiores.
- Cada ficha registra fonte. Nenhum conteúdo de wiki entra sem `docs/sources.md` atualizado.

### Ficha mínima (preenchida só na F3 para o SCP-173)
Fonte · forma física · necessidades · gatilhos · capacidades · percepção · condições de contenção · observação válida · procedimento de recontenção · testes disponíveis · interações suportadas · adaptações feitas pelo jogo `[A DEFINIR: valores]`.

### SCP-173 (F3)
- Observação válida exige observadores reservados e em posição.
- Perda de observação só ocorre quando observadores válidos deixam de manter a observação, não quando a câmera falha.
- O revezamento é coordenado pela rotina, não sorteado.

## Pesquisa
- Pesquisa e testes ficam fora de F1–F3, exceto o SCP-173.
- Modelo completo (propor, reservar, verificar, executar, interromper, relatar) fica no archive.
- Relatório separa **observação**, **hipótese** e **conclusão sustentada**. Essa distinção começa na F3.

## Ritmo e tempo
- Tick fixo de simulação. Velocidades 1×, 2× e 4×. Pausa permite ordens, construção planejada e leitura de relatórios.
- Duração de um dia de jogo: `[A DEFINIR: teste de jogabilidade]`. O v1.1 sugeria cerca de 24 minutos; isso não foi testado.

## Interface e acessibilidade
- Idioma inicial: português brasileiro, com siglas preservadas.
- Nenhuma informação depende só de cor ou só de som. Alarme tem equivalente visual.
- Bloqueios e alertas têm texto, não apenas ícone.
- Escala de texto e velocidade configuráveis. `[A DEFINIR: quais configurações entram na F1]`.

## Fontes e atribuição
- Conteúdo derivado da SCP Wiki é registrado em `docs/sources.md` com autor, licença e URL.
- Nenhuma ficha de anomalia é publicada antes desse registro.
- O projeto não tem plano de publicação ou venda. Esta regra existe para manter o controle de origem, não para uma distribuição futura.

## Premissas e riscos
- **Escopo de hobby:** o maior risco é a lista crescer antes de a F1 ser jogável. Mitigação: a lista NÃO faremos é lida antes de cada item novo.
- **Excesso de siglas:** siglas de equipe podem confundir. Mitigação: nome completo na primeira aparição em cada tela.
- **Cargo x departamento:** sem essa distinção clara, cada equipe nova vira exceção. Mitigação: uma fila por função, e função nova só com tarefas próprias.
- **Área restrita no papel:** zona com permissão mas sem vigilância parece segura e não é. Mitigação: UI mostra a camada faltante em cada zona restrita.
- **Números não testados:** taxas de necessidade, duração do dia e tamanhos de equipe são hipóteses. Mitigação: todos ficam `[A DEFINIR]` até o teste.

## NÃO faremos até F3 estar aceita
Departamentos além de Engenharia, Serviços Gerais e ScD · Segurança (SD) antes da F3 · MTFs · facções · RRT · MED · AD · ISD · IA · orçamento · pesquisa além do SCP-173 · energia · múltiplos andares · outros SCPs · computador do diretor como sistema separado · motins e fugas · saúde e ferimentos · permissões por setor ou horário · cartão copiado ou transferido · efeito de objetos de cozinha em revolta · horário de refeição por equipe · multiplayer.

## Decisões técnicas
- Godot 4.6.3, GDScript, renderer Compatibility.
- **Simulação separada da apresentação:** `sim/` não importa nada de `view/` nem de Node de cena. Isso permite testar headless e salvar estado limpo.
- Tick fixo de simulação, independente de FPS.
- Save em JSON versionado (`schema_version`), validado antes de substituir o estado.
- Testes headless: `godot --headless -s tests/run.gd`. Runner próprio, sem addon.
- IDs estáveis para toda entidade (pessoa, objeto, tarefa, reserva, cartão, alerta).
- **Acesso por cartão:** item de inventário com `nivel` (0–5) e `id`. Porta tem `nivel_minimo`; pessoa sem cartão tem nível 0. A escala 0–5 é adaptação deste jogo, não regra da wiki. Verificação acontece de novo durante o trajeto. `[A DEFINIR: quem emite cartão além do diretor]`.
- **Dados de conteúdo em `data/`:** objetos, zonas e cargos são definidos em arquivos de dados versionados, referenciados por ID.

## Regras de processo
- Cada item do backlog tem: objetivo, regras, estados, critério de pronto testável, fora de escopo, dependência.
- Fatia só fecha com **aceitação manual de 10–15 min** registrada em `STATUS.md`.
- Não se abre item de uma fatia futura antes da atual fechar.
- Decisão de design sem número definido fica marcada `[A DEFINIR]`; não inventar valores.
- Histórias de aceitação de cada fatia ficam em `BACKLOG.md`.

## Histórico
- **v2.2 (2026-10-08):** Logística renomeada para Serviços Gerais (SG). Funções com filas próprias dentro do SG. Áreas restritas em três camadas (permissão, detecção, resposta). Limpeza adiada.
- **v2.1 (2026-10-08):** cinco pilares; modelo mínimo de pessoas, alertas e políticas; dependências entre equipes; princípios e ficha mínima de anomalias; pesquisa limitada ao SCP-173; interface, fontes e riscos. Corrigido: SD só entra na F3.
- **v2 (2026-10-08):** versão enxuta com três fatias verticais e decisões de cozinha e cartão.
