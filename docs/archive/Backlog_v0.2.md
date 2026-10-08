# SCP: Site Director — backlog executável v0.2

**Atualizado:** 6 de outubro de 2026  
**Fonte funcional:** repositório `esterprotocol/scp`, branch `feat/classd-basic-needs`, HEAD `4eb6c2677cf9ed0e3f80448c1a3daee7b1ae1843`.  
**Base técnica verificada:** Godot 4.6.3 stable (`4.6.3.stable.official.7d41c59c4`), GDScript, renderizador Compatibility.

Este backlog atualiza o catálogo v0.1 com o que já existe no GitHub. Status descreve evidência dessa branch; não presume que o trabalho esteja integrado à `main`.

## Status e prioridade

- **FEITO** — implementado e registrado em `docs/PROGRESS.md`/README, com validação automatizada.
- **PARCIAL** — há uma fatia funcional, mas falta a abrangência prevista no catálogo/GDD.
- **PENDENTE** — sem evidência de implementação na branch consultada.
- **P0** — próximo bloqueador ou verificação necessária; **P1** — próximo incremento; **P2** — expansão; **P3** — adiado.

## Estado confirmado no GitHub

| Área | Status | Evidência e limite |
|---|---|---|
| Godot/GDScript e base visual | FEITO | Godot 4.6.3 Compatibility; grade 24 × 24, células de 32 px, câmera, seleção e navegação ortogonal. |
| Construção e demolição | FEITO | Blueprint de paredes, autorização, fila de tarefas, trabalho físico de um engenheiro, cancelamento, demolição física e proteção da saída. |
| Portas e áreas designadas | FEITO | Instalação física de portas abertas/fechadas e áreas Alojamento, Refeitório e Contenção. Área ainda não valida uma sala operacional. |
| Objetos essenciais | FEITO/PARCIAL | Cama, mesa, assento e distribuidor podem ser instalados/demolidos fisicamente. Cama e distribuidor atendem descanso e fome; mesa e assento ainda não têm rotina própria. |
| Classe-D | PARCIAL | Existe somente `classd-001`, com fome/descanso, navegação, uso de cama/distribuidor, reservas e alertas. Não há população, recepção, cota, cooldown, morte, dinheiro ou XP. |
| Save/load | FEITO | Um slot manual, esquema 4, leitura/migração dos esquemas 1–3 e validação antes de substituir o estado. |
| Testes automatizados e captura gráfica | FEITO | `bash tools/validate.sh`: 1.414 verificações, zero falhas; cinco capturas Xvfb/Mesa em 1280 × 720 registradas e inspecionadas. |
| Teste humano no Godot local | PENDENTE | `docs/PROGRESS.md` ainda lista interação humana, animação percebida e monitor/driver físico como pendentes. |
| SCP-173 | PENDENTE | Não implementado; o README exclui SCPs desta entrega. A ficha operacional mínima ainda precisa ser definida. |
| Estoques e instalações médicas | PENDENTE | Não há sistema geral de estoque/consumo, leito médico funcional, triagem ou kits como recursos operacionais. |

### Estado da branch

`feat/classd-basic-needs` está no commit acima. A `main` ainda aponta para `206dfca` (“Initial commit”) e a consulta ao repositório não encontrou pull requests. Assim, o trabalho verificado existe na branch de feature, mas não está incorporado à `main`.

## Backlog por fases

### Fase 0 — Aceitação da base existente

| ID | Prioridade / status | Dependência | Entrega e critério objetivo de pronto |
|---|---|---|---|
| SD-001 | P0 · PENDENTE | Nenhuma | Executar o roteiro manual do README no Godot 4.6.3: navegação, construção, demolição, portas, objetos, necessidades e save/load. Registrar resultado por cenário; nenhum bloqueio crítico, perda de estado ou duplicação. |
| SD-002 | P0 · PENDENTE | SD-001 | Reproduzir o ciclo básico com cliques/teclas reais: construir alojamento e refeitório, instalar cama e distribuidor, observar o Classe-D usar ambos e verificar fome/descanso no painel. Confirmar mensagens, acessos e cancelamentos. |
| SD-003 | P0 · PARCIAL | SD-001 | Fechar verificação de persistência pelo fluxo visual: salvar durante deslocamento e uso, carregar duas vezes e reiniciar. Pessoa, posição, rota, progresso e reserva devem corresponder ao estado salvo, sem duplicação. Testes automatizados já cobrem esse comportamento; falta a sessão manual registrada. |
| SD-004 | P0 · PENDENTE | Revisão do GDD | Resolver a divergência documental antes de adicionar conteúdo: catálogo aponta para GDD v1.3/arquivo versão 2, enquanto a referência mais recente encontrada é GDD v1.4; há dois itens separados com o mesmo nome de arquivo. Registrar qual fonte governa novas regras. |

**Marco M0 — Base aceita:** SD-001 a SD-004 concluídos, com limitações manuais registradas. Nenhuma nova mecânica entra antes desse gate.

### Fase 1 — Fechar a fatia Classe-D sem ampliar população

| ID | Prioridade / status | Dependência | Entrega e critério objetivo de pronto |
|---|---|---|---|
| SD-010 | P1 · FEITO | — | Grade, navegação, obras, portas, áreas, objetos e um trabalhador persistem e executam suas ações conforme os testes existentes. Evitar reimplementar como tarefas novas. |
| SD-011 | P1 · PARCIAL | M0 | Tratar o Classe-D 001 como prova de rotina, não sistema populacional. Aceitação manual de cama/distribuidor é SD-002; sem ampliar para múltiplos NPCs nesta fase. |
| SD-012 | P1 · PENDENTE | M0 | Registrar o primeiro lote aprovado e adiamentos: chão básico como piso da grade; paredes/portas já cobertas; objetos de rotina já cobertos; leito/triagem/estoques e SCP-173 permanecem pendentes. IDs estáveis e proposta/aprovação visíveis para cada item. |
| SD-013 | P1 · PENDENTE | SD-012 | Definir o que torna uma zona funcional sem exigir recinto retangular: requisitos mínimos por zona, acesso, capacidade e objeto operacional. Critério: especificação de Alojamento e Refeitório com condições válidas/inválidas testáveis antes de codificar. |

**Marco M1 — Escopo da etapa zero reconciliado:** o que já está feito é aceito, e o conteúdo residual do primeiro lote fica explicitamente delimitado.

### Fase 2 — Rotina mínima e recursos agregados

| ID | Prioridade / status | Dependência | Entrega e critério objetivo de pronto |
|---|---|---|---|
| SD-020 | P1 · PENDENTE | M1, SD-013 | Tornar Alojamento/Refeitório funcionais por requisitos de zona. Interface informa exatamente o requisito que falta; remover ou tornar inacessível um objeto reduz a capacidade imediatamente. |
| SD-021 | P1 · PENDENTE | M1 | Criar estoques agregados para refeição, limpeza e material médico. Reserva deixa unidade indisponível a outra tarefa; consumo ocorre apenas quando a tarefa conclui sua ação; save/load não duplica nem repõe recursos. |
| SD-022 | P1 · PENDENTE | SD-020, SD-021 | Implementar leito e triagem médicos mínimos. Uma tarefa de atendimento exige leito acessível, profissional e insumo; sem qualquer um, exibe o bloqueio e não cura automaticamente. |
| SD-023 | P2 · PENDENTE | SD-020 | Acrescentar cozinha/produção de refeições apenas após o ciclo com refeição pronta funcionar. Produção tem capacidade e consome ingredientes; não criar estoque infinito. |

**Marco M2 — Rotina básica:** alojamento e refeições operam com capacidade e recursos visíveis; atendimento médico mínimo pode iniciar e concluir uma tarefa com reservas corretas.

### Fase 3 — Ficha e prova mínima do SCP-173

| ID | Prioridade / status | Dependência | Entrega e critério objetivo de pronto |
|---|---|---|---|
| SD-030 | P0 · PENDENTE | M0, fonte do GDD resolvida | Aprovar ficha operacional mínima: condição de observação válida, postos/participantes necessários, perda de observação e condição de movimento. Não inventar tempos ou custos sem decisão registrada. |
| SD-031 | P1 · PENDENTE | SD-030, M1 | Representar uma instância SCP-173 única na câmara; identidade/estado sobrevivem a save/load. Não implementar combate nem outros SCPs. |
| SD-032 | P1 · PENDENTE | SD-031, tarefas e reservas | Executar manutenção com observadores reservados e acessos válidos. Dois trabalhos não podem reservar o mesmo participante; bloqueios indicam a causa. |
| SD-033 | P1 · PENDENTE | SD-032 | Verificar perda e recuperação de observação conforme a ficha. Um teste reproduzível demonstra que observação válida impede movimento e perda real aplica a regra aprovada. |

**Marco M3 — Prova SCP:** rotina mínima, manutenção e resposta à observação funcionam em um único cenário salvo/carregado.

### Fases posteriores — fora do primeiro lote

- **P2 · Fase A:** energia simples, cozinha, bancada de pesquisa e primeiros nós tecnológicos.
- **P2 · Fase B:** armaria e segurança convencional, com equipamento escolhido por função.
- **P2 · Fase C completa:** testes, protocolo ampliado e Epsilon-11 após a prova mínima.
- **P3 · Fases D/E/X/L:** SCP-914/999/008, equipes especializadas, facções, operações externas e Rede Persistente. Dependem de tarefas, saves, reservas e ciclo local estáveis.

## Ordem recomendada agora

1. **SD-001:** teste manual do estado atual na branch `feat/classd-basic-needs`.
2. **SD-002 e SD-003:** fechar a aceitação manual dos objetos, necessidades e save/load.
3. **SD-004 e SD-012/013:** reconciliar a versão de referência e fechar o contrato do que falta na etapa zero.
4. **SD-020/021/022:** completar zonas, estoques e cuidado médico mínimo.
5. **SD-030:** só então definir a ficha mínima antes de implementar o SCP-173.

## Fontes consultadas

- [Branch `feat/classd-basic-needs`](https://github.com/esterprotocol/scp/tree/feat/classd-basic-needs)
- [Commit `4eb6c267`](https://github.com/esterprotocol/scp/commit/4eb6c2677cf9ed0e3f80448c1a3daee7b1ae1843)
- [Progresso da branch](https://github.com/esterprotocol/scp/blob/feat/classd-basic-needs/docs/PROGRESS.md)
- [README da branch](https://github.com/esterprotocol/scp/blob/feat/classd-basic-needs/README.md)
