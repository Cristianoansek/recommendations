// Q1 — ranking de obras (filmes + séries)
MATCH (:User)-[r:WATCHED]->(c)
WITH c, count(r) AS avaliacoes, avg(r.rating) AS media
RETURN c.title AS obra, labels(c) AS tipo, avaliacoes, round(media * 100)/100.0 AS notaMedia
ORDER BY notaMedia DESC, avaliacoes DESC LIMIT 10;

// Q2 — recomendações por gênero para U01
MATCH (u:User {id:'U01'})-[w:WATCHED]->(visto)-[:IN_GENRE]->(g:Genre)
WHERE w.rating >= 4
MATCH (g)<-[:IN_GENRE]-(rec)
WHERE NOT EXISTS { MATCH (u)-[:WATCHED]->(rec) }
WITH rec, count(DISTINCT g) AS generosEmComum, sum(w.rating) AS score
RETURN rec.title AS sugestao, generosEmComum, score
ORDER BY score DESC LIMIT 10;

// Q3 — filtragem colaborativa, mesma obra bem avaliada
MATCH (u:User {id:'U01'})-[a:WATCHED]->(obra)<-[b:WATCHED]-(par:User)
WHERE a.rating >= 4 AND b.rating >= 4
WITH DISTINCT u, par
MATCH (par)-[w:WATCHED]->(rec)
WHERE w.rating >= 4 AND NOT EXISTS { MATCH (u)-[:WATCHED]->(rec) }
RETURN rec.title AS recomendacao, count(DISTINCT par) AS usuariosSemelhantes, avg(w.rating) AS notaDosPares
ORDER BY usuariosSemelhantes DESC, notaDosPares DESC LIMIT 10;

// Q4 — grafo para evidência visual
MATCH p=(u:User {id:'U01'})-[:WATCHED]->(c)-[:IN_GENRE]->(g:Genre)
RETURN p LIMIT 25;

// Q5 — diretores e obras
MATCH (d:Director)-[:DIRECTED]->(c)
RETURN d.name AS diretor, collect(c.title) AS obras ORDER BY diretor;

// Q6 — preferências por gênero
MATCH (u:User {id:'U01'})-[w:WATCHED]->(c)-[:IN_GENRE]->(g:Genre)
RETURN g.name AS genero, count(c) AS total, avg(w.rating) AS media
ORDER BY media DESC;
