# Evidências de execução — Neo4j Aura

Este registro consolida resultados observados em capturas de tela do Neo4j Aura, fornecidas em 19 de novembro de 2026, durante a execução manual do desafio DIO.

## Ambiente

- Plataforma: Neo4j AuraDB Free
- Instância: `Instance01`
- Banco: instância Aura do projeto
- Dados: dataset sintético `dio-streaming-graph/`
- Banco indicado pela interface como `CYPHER 25`, versão de instância exibida inicialmente como 2026.10.

## Evidências observadas (capturas compartilhadas na conversa)

| Verificação | Resultado observado | Estado |
|---|---|---|
| Constraints de IDs | Primeiro comando retornou `Added 1 constraint`; cinco comandos seguintes com indicadores de sucesso | Confirmado por interface, contagem total de seis inferida a partir das seis execuções |
| Contagem de nós | `40` | Confirmado em consulta |
| Contagem de relacionamentos | `110` | Confirmado em consulta |
| Grafo da usuária `U01` | `10` nós, `15` relacionamentos (5 `WATCHED`, 10 `IN_GENRE`) | Confirmado em visualização |
| Recomendação baseada em conteúdo | `Rota 47` (score 14, 2 gêneros em comum); `Quase Férias` (5); `Entre Estações` (4); `Vidas Cruzadas` (4); `Café de Domingo` (4) | Confirmado em tabela |
| Recomendação colaborativa | `Rota 47` (3 pares, nota média 4,67); `Quase Férias` (2 pares, nota média 4,00) | Confirmado em tabela |

Os números indicam a **execução manual observada**, não execução automatizada pelo repositório ou por um servidor CI. As imagens ainda **não foram incorporadas** ao GitHub. Não se deve declarar testes de integridade completos até executar e registrar as consultas respectivas.

## Interpretação

As duas estratégias demonstrativas de recomendação sugeriram `Rota 47` no topo; isso ilustra, com amostra sintética, como conexões por gêneros e por avaliações de usuários podem se complementar. Não representa medição de precisão preditiva ou performance em produção.

## Etapas pendentes

- [ ] Executar `cypher/02_verificacao.cypher` integralmente, confirmar seis constraints e ausência de resultados nas verificações de anomalias.
- [ ] Capturar/exportar as evidências gráficas e tabulares diretamente do Neo4j.
- [ ] Revisar o PR e seu checklist antes de concluir a entrega.

## Nota de privacidade

As capturas originais contêm dados de interface e informações de conta. Recorte ou oculte informações pessoais e identificadores de conexão antes de publicá-las no repositório público. Não publique senhas, tokens ou credenciais.
