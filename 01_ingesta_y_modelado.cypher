// ============================================================================
// SPRINT 2.1: Graph Database Engine (Neo4j)
// Fase: Materialización e Ingesta
// Descripción: Pipeline de ingesta para transformar JSON plano en red topológica.
// Bypass de seguridad local activado leyendo el raw data directo desde GitHub.
// ============================================================================

// BLOQUE 1: Creación dinámica de Nodos (Documentos, Autores, Temas)
CALL apoc.load.json("https://raw.githubusercontent.com/fotilejo/Semantic-Entity-Extractor-Graph-Modeler/refs/heads/main/grafo_biblioteca.json") YIELD value
UNWIND value.nodos AS n
CALL apoc.create.node([n.label], {id: n.id}) YIELD node
SET node += n.propiedades
RETURN count(node) AS Nodos_Creados;

// BLOQUE 2: Construcción Definitiva de Relaciones
// Nota Arquitectónica: Refactorizado con OPTIONAL MATCH y parseo estricto 
// trim(toString()) para tolerar anomalías de espaciado en la ingesta. Se mapea 
// sobre la llave semántica 'enlaces' en lugar de la genérica 'relaciones'.
CALL apoc.load.json("https://raw.githubusercontent.com/fotilejo/Semantic-Entity-Extractor-Graph-Modeler/refs/heads/main/grafo_biblioteca.json") YIELD value
UNWIND value.enlaces AS r
OPTIONAL MATCH (origen) WHERE trim(toString(origen.id)) = trim(toString(r.origen))
OPTIONAL MATCH (destino) WHERE trim(toString(destino.id)) = trim(toString(r.destino))
WITH origen, destino, r
WHERE origen IS NOT NULL AND destino IS NOT NULL
CALL apoc.create.relationship(origen, trim(toString(r.relacion)), {}, destino) YIELD rel
RETURN count(rel) AS Relaciones_Creadas;