// Esperado: 40 nós, 110 relacionamentos.
MATCH (n) RETURN labels(n) AS label, count(*) AS total ORDER BY label;

MATCH ()-[r]->() RETURN type(r) AS tipo, count(*) AS total ORDER BY tipo;

// Esperado: zero
MATCH (u:User)-[w:WATCHED]->(c)
WHERE w.rating < 1 OR w.rating > 5 OR w.rating IS NULL OR w.watchedAt IS NULL
RETURN u.id AS usuario, c.id AS obra, w.rating AS nota;

// Esperado: zero
MATCH (c) WHERE c:Movie OR c:Series
WITH c, count { MATCH (:Actor)-[:ACTED_IN]->(c) } AS atores,
 count { MATCH (:Director)-[:DIRECTED]->(c) } AS diretores,
 count { MATCH (c)-[:IN_GENRE]->(:Genre) } AS generos
WHERE atores=0 OR diretores=0 OR generos=0
RETURN c.id, atores, diretores, generos;

// Esperado: 6 constraints
SHOW CONSTRAINTS YIELD name, type
WHERE name ENDS WITH '_id_unique'
RETURN name, type ORDER BY name;
