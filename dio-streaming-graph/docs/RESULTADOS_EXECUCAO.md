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

Os números indicam a **execução manual observada**, não execução automatizada pelo repositório ou por um servidor CI. As imagens ainda **não foram incorporadas** ao GitHub, mas as verificações de avaliações e cobertura do catálogo foram executadas e confirmadas em capturas de tela.

## Interpretação

As duas estratégias demonstrativas de recomendação sugeriram `Rota 47` no topo; isso ilustra, com amostra sintética, como conexões por gêneros e por avaliações de usuários podem se complementar. Não representa medição de precisão preditiva ou performance em produção.

## Etapas pendentes

- [x] Seis constraints executadas individualmente com mensagens de sucesso (o resultado completo de SHOW CONSTRAINTS ainda não foi anexado).
- [x] Carga e totais globais conferidos: 40 nós e 110 relacionamentos.
- [x] Consultas de recomendações por gênero e colaboração executadas.
- [x] Integridade das avaliações: 50 registros; zero inválidos; zero duplicados.
- [x] Integridade do catálogo: 10 obras; zero sem ator, diretor ou gênero.
- [ ] Adicionar ao GitHub as sete capturas recortadas, sem dados pessoais.
- [ ] Concluir revisão do PR e integrá-lo à `main`.

## Nota de privacidade

As capturas originais contêm dados de interface e informações de conta. Recorte ou oculte informações pessoais e identificadores de conexão antes de publicá-las no repositório público. Não publique senhas, tokens ou credenciais.


## Integridade de avaliações — verificada em 19/11/2026

A captura fornecida da execução do Neo4j Aura confirma:

| `totalAvaliacoes` | `avaliacoesInvalidas` | `duplicadas` |
|---:|---:|---:|
| 50 | 0 | 0 |

A consulta contou relacionamentos `WATCHED`, avaliou notas nulas ou fora da faixa 1–5 e datas ausentes, além de duplicidades por par usuário/conteúdo. **Resultado observado e aprovado.** A checagem de cobertura do catálogo também foi executada com sucesso. As capturas ainda precisam ser publicadas com informações pessoais ocultadas.

## Integridade do catálogo — confirmada em 19/11/2026

| totalObras | semAtores | semDiretores | semGeneros |
|---:|---:|---:|---:|
| 10 | 0 | 0 | 0 |

Todas as dez obras possuem pelo menos um ator, um diretor e um gênero associados.

## Capturas disponíveis para anexação

Sete capturas reais foram recortadas para ocultar identificadores de conta e conexão. Para encerrar o PR, publicá-las sob `dio-streaming-graph/docs/evidencias/` com os nomes:

- `01_constraints.png` — comandos de constraints (a imagem mostra cinco; o sexto foi executado antes)
- `02_contagens.png` — 40 nós e 110 relacionamentos
- `03_grafo_ana_lima.png` — visualização do grafo U01
- `04_recomendacao_conteudo.png` — recomendações por gêneros
- `05_recomendacao_colaborativa.png` — recomendações por pares
- `06_integridade_avaliacoes.png` — 50, 0, 0
- `07_integridade_catalogo.png` — 10, 0, 0, 0

Estas imagens ainda não foram incorporadas à branch. O pacote foi disponibilizado separadamente na conversa do projeto.
