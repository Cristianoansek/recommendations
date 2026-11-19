# DIO — Streaming Knowledge Graph (Neo4j)

Solução independente do desafio DIO, criada dentro do fork do exemplo oficial [Neo4j Recommendations](https://github.com/neo4j-graph-examples/recommendations). Os dados são **fictícios** e foram elaborados apenas para demonstrar modelagem e consultas de recomendação.

## Problema e justificativa

Uma plataforma de streaming precisa representar conexões entre usuários, filmes, séries, atores, diretores e gêneros. O banco de grafos permite percorrer essas relações para encontrar afinidades entre conteúdos e usuários, sem reproduzir manualmente múltiplas junções relacionais.

## Modelo

```mermaid
flowchart LR
 U["User · 10"] -->|"WATCHED (rating, watchedAt)"| M["Movie · 5"]
 U -->|"WATCHED"| S["Series · 5"]
 A["Actor · 10"] -->|"ACTED_IN"| M
 A -->|"ACTED_IN"| S
 D["Director · 5"] -->|"DIRECTED"| M
 D -->|"DIRECTED"| S
 M -->|"IN_GENRE"| G["Genre · 5"]
 S -->|"IN_GENRE"| G
```

| Label | Quantidade | Propriedades |
|---|---:|---|
| User | 10 | id, name |
| Movie | 5 | id, title, year |
| Series | 5 | id, title, year |
| Actor | 10 | id, name |
| Director | 5 | id, name |
| Genre | 5 | id, name |

Relações: `WATCHED` (**50**, propriedade `rating` de 1 a 5, `watchedAt` tipo date), `ACTED_IN` (**30**), `DIRECTED` (**10**), `IN_GENRE` (**20**). São **40 nós e 110 relacionamentos esperados**; ainda não são resultados executados no Neo4j. Os IDs têm unicidade por label, protegida por seis constraints.

## Executar

1. Crie um **banco Neo4j 5.x vazio e exclusivo** no Aura, Desktop ou servidor local. Não importe os dumps do fork original neste banco.
2. Abra o Neo4j Browser e execute [01_modelo_e_carga.cypher](cypher/01_modelo_e_carga.cypher), em ordem. Se o Browser não aceitar várias instruções, execute cada bloco terminado em ponto e vírgula separadamente.
3. Execute [02_verificacao.cypher](cypher/02_verificacao.cypher) e confira os totais. O esperado é zero registros inválidos e seis constraints.
4. Execute individualmente as consultas em [03_consultas_negocio.cypher](cypher/03_consultas_negocio.cypher) para ver rankings, recomendações, preferências e caminhos do grafo.
5. Faça capturas reais do Neo4j Browser e acrescente em `docs/evidencias/` antes de entregar à DIO. **Nenhuma captura de execução foi fabricada.**

O script usa `MERGE` para ser reexecutável sem duplicar os pares de relacionamentos, desde que o modelo esteja no banco dedicado. Não requer APOC nem Graph Data Science.

## Consultas de negócio

- Q1: ranking de filmes e séries por avaliação.
- Q2: recomendação de conteúdos por gêneros bem avaliados.
- Q3: recomendação colaborativa a partir de espectadores com preferências similares.
- Q4: visualização do grafo de preferências de U01.
- Q5: obras agrupadas por diretor.
- Q6: preferências de gênero a partir das avaliações.

As recomendações são regras demonstrativas e não representam um sistema de produção. Com apenas 10 usuários, a amostra serve para explicar os caminhos de recomendação, não para avaliar precisão estatística.

## Troubleshooting

- **Constraint existente:** `IF NOT EXISTS` torna a criação repetível. Execute em banco exclusivo para não misturar dados.
- **Nenhum resultado na recomendação:** verifique o ID e os limiares de nota; testes com base pequena podem filtrar todas as opções.
- **Erro ao colar o script inteiro:** execute um comando terminado por `;` de cada vez, na ordem dos arquivos.
- **Contagens divergentes:** confirme que o banco estava vazio e que todos os comandos foram executados.
- **Reexecução sem novas linhas:** é comportamento esperado do `MERGE`.

## Entrega e evidências

As evidências necessárias são: seis constraints, contagem de nós, contagem de relacionamentos, grafo da Q4, recomendações Q2/Q3 e verificação de integridade. Capture imagens diretamente no Neo4j e registre a versão do banco e a data. Não confunda este mini-projeto com a grande base `.dump` do fork original.

## Créditos

Exercício: formação Neo4j / DIO. Referência: Neo4j Graph Examples — Recommendations. Modelo, dados fictícios, carga e consultas desta pasta são implementação independente para o desafio.
