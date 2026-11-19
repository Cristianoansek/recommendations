// DIO STREAMING — Neo4j 5.x; execute num banco vazio exclusivo.
// Reexecutável com MERGE. Não execute em base do projeto original.
CREATE CONSTRAINT user_id_unique IF NOT EXISTS FOR (n:User) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT movie_id_unique IF NOT EXISTS FOR (n:Movie) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT series_id_unique IF NOT EXISTS FOR (n:Series) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT actor_id_unique IF NOT EXISTS FOR (n:Actor) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT director_id_unique IF NOT EXISTS FOR (n:Director) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT genre_id_unique IF NOT EXISTS FOR (n:Genre) REQUIRE n.id IS UNIQUE;

// Nós
UNWIND [{id: 'U01', name: 'Ana Lima'}, {id: 'U02', name: 'Bruno Rocha'}, {id: 'U03', name: 'Camila Torres'}, {id: 'U04', name: 'Diego Santos'}, {id: 'U05', name: 'Elisa Nunes'}, {id: 'U06', name: 'Felipe Costa'}, {id: 'U07', name: 'Gabriela Alves'}, {id: 'U08', name: 'Hugo Martins'}, {id: 'U09', name: 'Isabela Pinto'}, {id: 'U10', name: 'João Freitas'}] AS row
MERGE (n:User {id: row.id})
SET n.name = row.name;

UNWIND [{id: 'A01', name: 'Sofia Duarte'}, {id: 'A02', name: 'Rafael Leal'}, {id: 'A03', name: 'Marina Prado'}, {id: 'A04', name: 'Caio Teixeira'}, {id: 'A05', name: 'Luiza Tavares'}, {id: 'A06', name: 'Pedro Viana'}, {id: 'A07', name: 'Helena Paes'}, {id: 'A08', name: 'André Campos'}, {id: 'A09', name: 'Bianca Monteiro'}, {id: 'A10', name: 'Lucas Ribeiro'}] AS row
MERGE (n:Actor {id: row.id})
SET n.name = row.name;

UNWIND [{id: 'D01', name: 'Laura Monte'}, {id: 'D02', name: 'Marcos Vale'}, {id: 'D03', name: 'Renata Luz'}, {id: 'D04', name: 'Thiago Serra'}, {id: 'D05', name: 'Paula Reis'}] AS row
MERGE (n:Director {id: row.id})
SET n.name = row.name;

UNWIND [{id: 'G01', name: 'Ficção científica'}, {id: 'G02', name: 'Drama'}, {id: 'G03', name: 'Suspense'}, {id: 'G04', name: 'Comédia'}, {id: 'G05', name: 'Aventura'}] AS row
MERGE (n:Genre {id: row.id})
SET n.name = row.name;

UNWIND [{id: 'M01', title: 'Horizonte de Titã', year: 2022}, {id: 'M02', title: 'Segredos do Farol', year: 2020}, {id: 'M03', title: 'Quase Férias', year: 2023}, {id: 'M04', title: 'Frequência Zero', year: 2024}, {id: 'M05', title: 'Entre Estações', year: 2021}] AS row
MERGE (n:Movie {id: row.id})
SET n.title = row.title, n.year = row.year;

UNWIND [{id: 'S01', title: 'Código Aurora', year: 2025}, {id: 'S02', title: 'Vidas Cruzadas', year: 2022}, {id: 'S03', title: 'Rota 47', year: 2024}, {id: 'S04', title: 'Café de Domingo', year: 2023}, {id: 'S05', title: 'Ecos do Amanhã', year: 2026}] AS row
MERGE (n:Series {id: row.id})
SET n.title = row.title, n.year = row.year;

UNWIND [{user: 'U01', content: 'M01', rating: 5, watchedAt: '2026-09-01'}, {user: 'U01', content: 'M04', rating: 4, watchedAt: '2026-09-03'}, {user: 'U01', content: 'M02', rating: 2, watchedAt: '2026-09-05'}, {user: 'U02', content: 'M01', rating: 5, watchedAt: '2026-09-06'}, {user: 'U02', content: 'M04', rating: 5, watchedAt: '2026-09-08'}, {user: 'U03', content: 'M02', rating: 5, watchedAt: '2026-09-11'}, {user: 'U03', content: 'M05', rating: 5, watchedAt: '2026-09-13'}, {user: 'U03', content: 'M01', rating: 2, watchedAt: '2026-09-15'}, {user: 'U04', content: 'M02', rating: 5, watchedAt: '2026-09-16'}, {user: 'U04', content: 'M04', rating: 4, watchedAt: '2026-09-18'}, {user: 'U05', content: 'M03', rating: 5, watchedAt: '2026-09-21'}, {user: 'U05', content: 'M05', rating: 4, watchedAt: '2026-09-23'}, {user: 'U05', content: 'M02', rating: 3, watchedAt: '2026-09-25'}, {user: 'U06', content: 'M03', rating: 4, watchedAt: '2026-09-26'}, {user: 'U06', content: 'M01', rating: 4, watchedAt: '2026-09-28'}, {user: 'U06', content: 'M04', rating: 2, watchedAt: '2026-09-02'}, {user: 'U07', content: 'M04', rating: 5, watchedAt: '2026-09-04'}, {user: 'U07', content: 'M01', rating: 4, watchedAt: '2026-09-06'}, {user: 'U07', content: 'M05', rating: 2, watchedAt: '2026-09-07'}, {user: 'U08', content: 'M05', rating: 4, watchedAt: '2026-09-09'}, {user: 'U08', content: 'M02', rating: 4, watchedAt: '2026-09-10'}, {user: 'U08', content: 'M03', rating: 3, watchedAt: '2026-09-12'}, {user: 'U09', content: 'M03', rating: 4, watchedAt: '2026-09-14'}, {user: 'U09', content: 'M04', rating: 4, watchedAt: '2026-09-15'}, {user: 'U09', content: 'M01', rating: 3, watchedAt: '2026-09-16'}, {user: 'U10', content: 'M05', rating: 5, watchedAt: '2026-09-19'}, {user: 'U10', content: 'M03', rating: 5, watchedAt: '2026-09-20'}] AS row
MATCH (a:User {id:row.user})
MATCH (b:Movie {id:row.content})
MERGE (a)-[r:WATCHED]->(b)
SET r.rating = row.rating, r.watchedAt = date(row.watchedAt);

UNWIND [{user: 'U01', content: 'S01', rating: 5, watchedAt: '2026-09-02'}, {user: 'U01', content: 'S05', rating: 4, watchedAt: '2026-09-04'}, {user: 'U02', content: 'S01', rating: 4, watchedAt: '2026-09-07'}, {user: 'U02', content: 'S05', rating: 4, watchedAt: '2026-09-09'}, {user: 'U02', content: 'S03', rating: 3, watchedAt: '2026-09-10'}, {user: 'U03', content: 'S02', rating: 4, watchedAt: '2026-09-12'}, {user: 'U03', content: 'S04', rating: 4, watchedAt: '2026-09-14'}, {user: 'U04', content: 'S03', rating: 4, watchedAt: '2026-09-17'}, {user: 'U04', content: 'S05', rating: 3, watchedAt: '2026-09-19'}, {user: 'U04', content: 'S02', rating: 3, watchedAt: '2026-09-20'}, {user: 'U05', content: 'S04', rating: 5, watchedAt: '2026-09-22'}, {user: 'U05', content: 'S02', rating: 4, watchedAt: '2026-09-24'}, {user: 'U06', content: 'S03', rating: 5, watchedAt: '2026-09-27'}, {user: 'U06', content: 'S01', rating: 3, watchedAt: '2026-09-01'}, {user: 'U07', content: 'S05', rating: 5, watchedAt: '2026-09-03'}, {user: 'U07', content: 'S01', rating: 4, watchedAt: '2026-09-05'}, {user: 'U08', content: 'S02', rating: 5, watchedAt: '2026-09-08'}, {user: 'U08', content: 'S04', rating: 5, watchedAt: '2026-09-11'}, {user: 'U09', content: 'S03', rating: 5, watchedAt: '2026-09-13'}, {user: 'U09', content: 'S05', rating: 2, watchedAt: '2026-09-17'}, {user: 'U10', content: 'S04', rating: 4, watchedAt: '2026-09-18'}, {user: 'U10', content: 'S02', rating: 4, watchedAt: '2026-09-21'}, {user: 'U10', content: 'S01', rating: 2, watchedAt: '2026-09-22'}] AS row
MATCH (a:User {id:row.user})
MATCH (b:Series {id:row.content})
MERGE (a)-[r:WATCHED]->(b)
SET r.rating = row.rating, r.watchedAt = date(row.watchedAt);

UNWIND [{actor: 'A01', content: 'M01'}, {actor: 'A02', content: 'M01'}, {actor: 'A04', content: 'M01'}, {actor: 'A03', content: 'M02'}, {actor: 'A05', content: 'M02'}, {actor: 'A07', content: 'M02'}, {actor: 'A06', content: 'M03'}, {actor: 'A08', content: 'M03'}, {actor: 'A09', content: 'M03'}, {actor: 'A01', content: 'M04'}, {actor: 'A07', content: 'M04'}, {actor: 'A10', content: 'M04'}, {actor: 'A02', content: 'M05'}, {actor: 'A05', content: 'M05'}, {actor: 'A09', content: 'M05'}] AS row
MATCH (a:Actor {id:row.actor})
MATCH (b:Movie {id:row.content})
MERGE (a)-[r:ACTED_IN]->(b);

UNWIND [{actor: 'A01', content: 'S01'}, {actor: 'A03', content: 'S01'}, {actor: 'A10', content: 'S01'}, {actor: 'A02', content: 'S02'}, {actor: 'A05', content: 'S02'}, {actor: 'A06', content: 'S02'}, {actor: 'A04', content: 'S03'}, {actor: 'A07', content: 'S03'}, {actor: 'A08', content: 'S03'}, {actor: 'A06', content: 'S04'}, {actor: 'A09', content: 'S04'}, {actor: 'A10', content: 'S04'}, {actor: 'A01', content: 'S05'}, {actor: 'A03', content: 'S05'}, {actor: 'A07', content: 'S05'}] AS row
MATCH (a:Actor {id:row.actor})
MATCH (b:Series {id:row.content})
MERGE (a)-[r:ACTED_IN]->(b);

UNWIND [{director: 'D01', content: 'M01'}, {director: 'D02', content: 'M02'}, {director: 'D03', content: 'M03'}, {director: 'D04', content: 'M04'}, {director: 'D05', content: 'M05'}] AS row
MATCH (a:Director {id:row.director})
MATCH (b:Movie {id:row.content})
MERGE (a)-[r:DIRECTED]->(b);

UNWIND [{director: 'D01', content: 'S01'}, {director: 'D05', content: 'S02'}, {director: 'D02', content: 'S03'}, {director: 'D03', content: 'S04'}, {director: 'D04', content: 'S05'}] AS row
MATCH (a:Director {id:row.director})
MATCH (b:Series {id:row.content})
MERGE (a)-[r:DIRECTED]->(b);

UNWIND [{genre: 'G01', content: 'M01'}, {genre: 'G05', content: 'M01'}, {genre: 'G02', content: 'M02'}, {genre: 'G03', content: 'M02'}, {genre: 'G04', content: 'M03'}, {genre: 'G05', content: 'M03'}, {genre: 'G01', content: 'M04'}, {genre: 'G03', content: 'M04'}, {genre: 'G02', content: 'M05'}, {genre: 'G04', content: 'M05'}] AS row
MATCH (a:Movie {id:row.content})
MATCH (b:Genre {id:row.genre})
MERGE (a)-[r:IN_GENRE]->(b);

UNWIND [{genre: 'G01', content: 'S01'}, {genre: 'G03', content: 'S01'}, {genre: 'G02', content: 'S02'}, {genre: 'G04', content: 'S02'}, {genre: 'G05', content: 'S03'}, {genre: 'G03', content: 'S03'}, {genre: 'G04', content: 'S04'}, {genre: 'G02', content: 'S04'}, {genre: 'G01', content: 'S05'}, {genre: 'G02', content: 'S05'}] AS row
MATCH (a:Series {id:row.content})
MATCH (b:Genre {id:row.genre})
MERGE (a)-[r:IN_GENRE]->(b);

