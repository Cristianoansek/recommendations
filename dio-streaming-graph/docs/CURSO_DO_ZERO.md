# Curso prático: reconstruindo o desafio Neo4j / DIO sem IA

**Base didática:** implementação real em `dio-streaming-graph/`, executada no Neo4j Aura em 19/11/2026. Este curso explica os padrões das instruções efetivamente publicadas em `cypher/01_modelo_e_carga.cypher` (77 linhas, parte das quais são listas extensas em uma única linha), `cypher/02_verificacao.cypher` (22 linhas) e `cypher/03_consultas_negocio.cypher` (36 linhas).

**Meta de aprendizagem:** partir de um enunciado em linguagem natural, escolher o modelo, construir e testar o grafo, publicar um repositório novo e justificar as decisões sem assistência.

## 1. Primeiro: pensar antes de escrever

Problema: um streaming quer recomendar obras com base em conteúdos, gêneros e preferências de outras pessoas. Perguntas iniciais: quais objetos precisam existir? Quais fatos são conexões entre objetos? Quais consultas o negócio fará? Qual é a identidade única de cada objeto?

O desafio exige seis labels (`User`, `Movie`, `Series`, `Actor`, `Director`, `Genre`), quatro tipos de relacionamento (`WATCHED`, `ACTED_IN`, `DIRECTED`, `IN_GENRE`), avaliação `rating` no relacionamento `WATCHED`, IDs únicos e uma pequena base de dados.

**Decisão 1 — 5 filmes + 5 séries:** o enunciado exige pelo menos dez obras de ambos os tipos. A divisão igual facilita conferir as quantidades, mas não é a única solução correta.

**Decisão 2 — 5 diretores:** quantidade escolhida para permitir que diretores sejam compartilhados entre obras; não era uma contagem fixa do desafio.

**Decisão 3 — gênero como nó:** a mesma categoria pode ser reutilizada por muitas obras; colocá-la num nó cria trajetos úteis para recomendação. Com uma string dentro do filme, seria possível filtrar, mas não teríamos explicitamente o nó de gênero exigido.

**Decisão 4 — avaliação na relação:** a nota depende do par (usuário, obra). A mesma obra tem notas diferentes de usuários diferentes. Por isso: `(u)-[w:WATCHED {rating:5}]->(m)`.

**Decisão 5 — direção das relações:** a leitura humana é `User → WATCHED → Movie`, `Actor → ACTED_IN → Movie`, `Director → DIRECTED → Movie` e `Movie → IN_GENRE → Genre`. Direção é convenção importante para escrita e consulta, não implica que a travessia no sentido inverso seja impossível.

**Decisão 6 — dados fictícios:** criamos nomes e obras imaginárias, para demonstrar caminhos controlados. Não confundir demonstração didática com acurácia de um recomendador de produção.

**Limite da modelagem:** um ator também pode dirigir; numa aplicação maior seria razoável modelar ambos como `Person`, com papéis, mas separar `Actor` e `Director` respeita o enunciado. Um modelo também poderia adicionar `Content` como label comum a filmes e séries, mas não foi necessário aqui.

## 2. Gramática mínima de Cypher

~~~cypher
(n:User {id: 'U01'})
~~~

- `( )`: descreve um nó; `n` é uma variável local à consulta.
- `:User`: label do nó (sua categoria).
- `{id: 'U01'}`: mapa de propriedades que filtra ou configura o nó.
- `'U01'` é texto; `2024` sem aspas seria número.

~~~cypher
(u:User)-[w:WATCHED]->(m:Movie)
~~~

- `[ ]` envolve um relacionamento.
- `w` é uma variável para acessar as propriedades do relacionamento.
- `:WATCHED` é seu tipo.
- `->` indica a direção armazenada.
- Para buscar na direção oposta: `(m)<-[:WATCHED]-(u)`.

## 3. Leitura literal das seis constraints do arquivo de carga

~~~cypher
CREATE CONSTRAINT user_id_unique IF NOT EXISTS
FOR (n:User)
REQUIRE n.id IS UNIQUE;
~~~

| Trecho | Significado |
|---|---|
| `CREATE CONSTRAINT` | Cria uma regra do esquema do banco |
| `user_id_unique` | Nome escolhido para identificar a regra |
| `IF NOT EXISTS` | Evita tentar recriar uma constraint de mesmo nome/esquema |
| `FOR (n:User)` | Aplica aos nós com label `User`; `n` é alias local |
| `REQUIRE n.id IS UNIQUE` | Dois nós `User` não podem ter o mesmo valor de `id` |
| `;` | Termina a instrução |

As cinco linhas seguintes repetem o padrão para `Movie`, `Series`, `Actor`, `Director` e `Genre`. **Importante:** unicidade não obriga todo nó a ter `id`: existência é uma regra distinta. Uma constraint não cria dez usuários; apenas restringe inserções futuras.

## 4. Como ler as seis instruções de criação dos nós

Trecho real simplificado, conservando a lógica:

~~~cypher
UNWIND [
  {id: 'U01', name: 'Ana Lima'},
  {id: 'U02', name: 'Bruno Rocha'}
] AS row
MERGE (n:User {id: row.id})
SET n.name = row.name;
~~~

| Linha | Raciocínio |
|---|---|
| `UNWIND [ ... ] AS row` | Converte cada item da lista em uma linha lógica, chamada `row` |
| `{id: ..., name: ...}` | Cada item é um mapa com duas propriedades |
| `MERGE (n:User {id: row.id})` | Procura usuário com aquele ID; se não houver, cria |
| `SET n.name = row.name` | Atualiza/define o nome no nó encontrado ou criado |
| `;` | Conclui a consulta |

Por que separar `MERGE` e `SET`? Porque o ID é a identidade estável e o nome pode mudar. Se o nome estivesse dentro do mapa do `MERGE`, um usuário renomeado poderia deixar de corresponder ao padrão esperado e causar erro ou tentativa de duplicação.

As outras cinco instruções de criação de nós repetem esse mesmo raciocínio. `Actor`, `Director` e `Genre` têm `id` + `name`. `Movie` e `Series` usam `id` + `title` + `year`. `SET n.title = row.title, n.year = row.year` atualiza duas propriedades.

**Diferenças essenciais:** `CREATE` sempre cria um novo padrão; `MATCH` encontra um padrão existente; `MERGE` encontra ou cria. `MERGE` sozinho não significa que todos os dados estejam válidos ou que qualquer nova relação seja impossível; a disciplina de IDs e padrões é indispensável.

## 5. Como ler os oito blocos de criação de relações

A base usa quatro tipos de relações, repetidos para `Movie` e `Series`: portanto, são oito blocos. Nos trechos reais, as listas são longas, mas o algoritmo é o mesmo.

### 5.1 WATCHED (dois blocos)

~~~cypher
UNWIND [{user: 'U01', content: 'M01',
         rating: 5, watchedAt: '2026-09-01'}] AS row
MATCH (a:User {id: row.user})
MATCH (b:Movie {id: row.content})
MERGE (a)-[r:WATCHED]->(b)
SET r.rating = row.rating,
    r.watchedAt = date(row.watchedAt);
~~~

`row.user` é o ID do usuário; `row.content` é o ID da obra; os dois `MATCH` procuram os nós antes de ligar. O `MERGE` verifica se já existe a relação daquele tipo de `a` até `b`. `r.rating` grava a nota na aresta (não no filme); `date(row.watchedAt)` converte texto no tipo temporal DATE. O bloco para séries troca somente `Movie` por `Series`.

Observação importante: nosso modelo representa **uma avaliação atual por par usuário/obra**. Se quisesse histórico de visualizações repetidas, usaríamos eventos separados e outro identificador. A unicidade de relações por par é uma política da nossa carga, não uma constraint nativa criada por essas seis constraints de nó.

### 5.2 ACTED_IN (dois blocos)

~~~cypher
UNWIND [{actor: 'A01', content: 'M01'}] AS row
MATCH (a:Actor {id: row.actor})
MATCH (b:Movie {id: row.content})
MERGE (a)-[r:ACTED_IN]->(b);
~~~

Busca ator e filme por ID; cria a ligação se estiver ausente. Para séries, basta trocar o label de destino. O alias `r` poderia ser omitido porque não guardamos propriedades nesse relacionamento.

### 5.3 DIRECTED (dois blocos)

~~~cypher
UNWIND [{director: 'D01', content: 'M01'}] AS row
MATCH (a:Director {id: row.director})
MATCH (b:Movie {id: row.content})
MERGE (a)-[r:DIRECTED]->(b);
~~~

Reutiliza a mesma estrutura. Um diretor pode direcionar várias obras: isso é uma relação de muitos conteúdos para um diretor no exemplo, mas tecnicamente o grafo suporta múltiplos diretores por obra.

### 5.4 IN_GENRE (dois blocos)

~~~cypher
UNWIND [{genre: 'G01', content: 'M01'}] AS row
MATCH (a:Movie {id: row.content})
MATCH (b:Genre {id: row.genre})
MERGE (a)-[r:IN_GENRE]->(b);
~~~

Aqui a direção muda: **obra → gênero**. A mesma categoria pode ser usada por diversas obras, o que cria caminhos para descobrir conteúdo semelhante.

## 6. Explicando todas as consultas de negócio

### Q1 — Ranking por avaliação

~~~cypher
MATCH (:User)-[r:WATCHED]->(c)
WITH c, count(r) AS avaliacoes, avg(r.rating) AS media
RETURN c.title AS obra, labels(c) AS tipo, avaliacoes,
       round(media * 100)/100.0 AS notaMedia
ORDER BY notaMedia DESC, avaliacoes DESC LIMIT 10;
~~~

`MATCH` percorre cada avaliação. Não precisamos dar nome à variável do usuário, por isso `(:User)`. `WITH c` agrupa por obra; `count(r)` conta as avaliações e `avg(r.rating)` calcula a média. `RETURN` define as colunas. `labels(c)` retorna os labels. `round(media*100)/100.0` arredonda para duas casas. `ORDER BY ... DESC` ordena maiores notas primeiro. `LIMIT 10` restringe o resultado.

### Q2 — Recomendação por gênero (content-based)

~~~cypher
MATCH (u:User {id:'U01'})-[w:WATCHED]->(visto)-[:IN_GENRE]->(g:Genre)
WHERE w.rating >= 4
MATCH (g)<-[:IN_GENRE]-(rec)
WHERE NOT EXISTS { MATCH (u)-[:WATCHED]->(rec) }
WITH rec, count(DISTINCT g) AS generosEmComum,
          sum(w.rating) AS score
RETURN rec.title AS sugestao, generosEmComum, score
ORDER BY score DESC LIMIT 10;
~~~

A primeira linha encontra a pessoa, as obras assistidas, a avaliação e seus gêneros. O primeiro `WHERE` escolhe os conteúdos de que ela gostou. O segundo `MATCH` encontra outras obras nos mesmos gêneros. `NOT EXISTS` elimina o que ela já assistiu. `DISTINCT g` impede contar um gênero repetido como se fossem vários gêneros distintos. `sum(w.rating)` soma as notas das correspondências de gênero e gera nosso **score heurístico** (não é predição probabilística). Ordenamos pelo score.

### Q3 — Recomendação colaborativa

~~~cypher
MATCH (u:User {id:'U01'})-[a:WATCHED]->(obra)<-[b:WATCHED]-(par:User)
WHERE a.rating >= 4 AND b.rating >= 4
WITH DISTINCT u, par
MATCH (par)-[w:WATCHED]->(rec)
WHERE w.rating >= 4 AND NOT EXISTS { MATCH (u)-[:WATCHED]->(rec) }
RETURN rec.title AS recomendacao,
       count(DISTINCT par) AS usuariosSemelhantes,
       avg(w.rating) AS notaDosPares
ORDER BY usuariosSemelhantes DESC, notaDosPares DESC LIMIT 10;
~~~

O primeiro `MATCH` procura dois usuários que assistiram **à mesma obra**. As duas notas devem ser altas. `WITH DISTINCT u, par` conserva cada par de usuários sem repetição. A segunda busca encontra outros conteúdos bem avaliados pelo semelhante. `NOT EXISTS` exclui conteúdos que o usuário alvo já viu. O resultado ordena primeiro pela quantidade de usuários que recomendaram a obra; empates usam média de nota.

**Atenção:** ter uma obra em comum não garante grande semelhança. Este algoritmo simples é didático; versões mais sofisticadas usam similaridade (Jaccard, cosseno, pesos, normalização).

### Q4 — Visualizar caminhos

~~~cypher
MATCH p=(u:User {id:'U01'})-[:WATCHED]->(c)-[:IN_GENRE]->(g:Genre)
RETURN p LIMIT 25;
~~~

`p=` atribui a uma variável o **caminho completo**. `RETURN p` permite ao Neo4j Browser renderizar nós e arestas; `LIMIT 25` limita a quantidade de caminhos retornados, não necessariamente a quantidade de nós únicos.

### Q5 — Diretor e suas obras

~~~cypher
MATCH (d:Director)-[:DIRECTED]->(c)
RETURN d.name AS diretor, collect(c.title) AS obras ORDER BY diretor;
~~~

`collect(c.title)` transforma vários títulos do mesmo diretor em uma lista. O nome do diretor determina o agrupamento.

### Q6 — Preferências por gênero

~~~cypher
MATCH (u:User {id:'U01'})-[w:WATCHED]->(c)-[:IN_GENRE]->(g:Genre)
RETURN g.name AS genero, count(c) AS total, avg(w.rating) AS media
ORDER BY media DESC;
~~~

Agrupa por gênero, conta títulos assistidos e calcula média de avaliações associadas a esse gênero. Uma obra de dois gêneros contribui para ambos.

## 7. Como ler as verificações de integridade

`MATCH (n) RETURN labels(n), count(*)` conta nós por label. `MATCH ()-[r]->() RETURN type(r), count(*)` conta arestas por tipo.

`WHERE w.rating < 1 OR w.rating > 5 OR w.rating IS NULL OR w.watchedAt IS NULL` encontra notas fora do intervalo, notas faltantes e datas ausentes. Resultado esperado: nenhuma linha.

`WHERE c:Movie OR c:Series` seleciona as obras. Para cada obra, `count { MATCH (:Actor)-[:ACTED_IN]->(c) }` conta elencos; consultas semelhantes contam diretores e gêneros. `WHERE atores=0 OR diretores=0 OR generos=0` retorna apenas problemas de cobertura. Resultado esperado: nenhuma linha.

`SHOW CONSTRAINTS YIELD name, type` lista regras existentes e a cláusula `WHERE name ENDS WITH '_id_unique'` seleciona as nossas. Esperado: seis regras.

As consultas agregadas que executamos no Aura também comprovaram: **50 avaliações, zero inválidas, zero duplicadas; dez obras, nenhuma sem elenco, direção ou gênero**.

## 8. Git e GitHub do zero

**Glossário:** repositório = histórico e arquivos de um projeto; `commit` = registro de uma alteração; `branch` = linha de trabalho; `remote` = repositório remoto; `fork` = cópia sob outra conta; `pull request` = proposta de integração e revisão; `merge` = integração de mudanças.

Fluxo sugerido no terminal para aprender num repositório **separado, seu**, com Git configurado:

~~~bash
git clone https://github.com/Cristianoansek/recommendations.git
cd recommendations
git remote -v
git status
git switch -c estudo-neo4j-do-zero
git log --oneline -5
~~~

`clone` baixa os arquivos e histórico. `cd` entra no diretório. `remote -v` mostra os remotos. `status` informa situação local. `switch -c` cria e troca para uma branch. `log --oneline -5` mostra os cinco commits mais recentes.

Após **criar um arquivo de estudo** nessa nova branch:

~~~bash
git status
git diff
git add dio-streaming-graph/docs/minhas-anotacoes.md
git commit -m "docs: registrar anotações de Cypher"
git push -u origin estudo-neo4j-do-zero
~~~

`diff` mostra modificações ainda não preparadas. `add` escolhe conteúdo para o próximo commit. `commit` registra localmente. `push` envia ao GitHub. `-u` configura a branch remota de acompanhamento. Abra um PR na interface do GitHub apenas quando desejar revisar e integrar. Antes de qualquer comando, confira o repositório e a branch de destino; não publique credenciais. O PR do exercício atual continua em rascunho.

## 9. Exercícios sem consulta à IA

**Prática A (papel):** desenhe três nós (um usuário, dois filmes) e três relacionamentos (dois WATCHED e um IN_GENRE exigirá também um nó de Genre). Identifique a propriedade de cada nó/relação e explique por que gênero é reutilizável.

**Prática B (Neo4j):** no banco de treino, use labels diferentes dos usados na entrega (por exemplo, `PracticeUser` e `PracticeMovie`), para não contaminar as 40 entidades reais. Crie um usuário, dois filmes e relações WATCHED; consulte a nota e depois mude uma nota usando `MATCH` + `SET`.

**Prática C (predição):** antes de executar uma query, escreva quantas linhas espera. Em seguida compare o resultado com sua hipótese e explique o motivo das diferenças.

**Prática D (modelagem):** crie uma solução para plataforma de livros com `Reader`, `Book`, `Author`, `Category`; modele `READ`, `WROTE` e `IN_CATEGORY`. Faça ranking e recomende leituras, sem olhar o código de filmes.

**Prática E (Git):** crie branch, altere README, execute `git diff`, faça commit, push e abra um PR de revisão. Explique o que cada comando fez antes de executá-lo.

**Prática F (reconstrução):** sem colar o script existente, crie constraints, dados, relacionamentos, consultas, verificações, documentação e evidências para uma base diferente. Ao final, explique oralmente cada comando.

## 10. Critério de independência

Você dominou o projeto quando consegue: (1) justificar o modelo antes de abrir o editor; (2) escrever pelo menos uma query de cada tipo sem referência; (3) prever quando haverá duplicação; (4) diagnosticar contagens incorretas; (5) criar um repositório do zero com histórico, documentação e PR; (6) explicar limitações da recomendação e o que mudaria numa base real.

**Referências primárias:** [Manual Cypher — MERGE](https://neo4j.com/docs/cypher-manual/current/clauses/merge/), [UNWIND](https://neo4j.com/docs/cypher-manual/current/clauses/unwind/), [Constraints](https://neo4j.com/docs/cypher-manual/current/schema/constraints/), [GitHub — Pull requests](https://docs.github.com/en/pull-requests/concepts/writing-code-for-a-project) e [Neo4j GraphAcademy](https://graphacademy.neo4j.com/).
