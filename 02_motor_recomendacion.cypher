// ============================================================================
// SPRINT 2.1: Graph Database Engine (Neo4j)
// Fase: Analítica de Red
// Descripción: Content-Based Filtering Recommendation Engine.
// Calcula la distancia semántica evitando múltiples JOINs relacionales.
// ============================================================================

// Paso 1: Ubicamos el documento origen y navegamos hacia sus descriptores temáticos
MATCH (doc_base:Documento {titulo: "La biblioteca universitaria"})-[:TRATA_SOBRE]->(t:Tema)

// Paso 2: Desde esos temas, ejecutamos un salto inverso para encontrar otros documentos asociados
MATCH (t)<-[:TRATA_SOBRE]-(doc_recomendado:Documento)

// Paso 3: Excluimos el documento original para evitar autorecomendación
WHERE doc_base <> doc_recomendado

// Paso 4: Agrupamos, calculamos el peso de la similitud y empaquetamos los vectores
WITH doc_recomendado, count(t) AS peso_similitud, collect(t.termino) AS temas_comunes

// Paso 5: Renderizamos el Top 5 ordenado por afinidad semántica
ORDER BY peso_similitud DESC
RETURN doc_recomendado.titulo AS Libro_Recomendado, 
       peso_similitud AS Nivel_Coincidencia, 
       temas_comunes AS Temas_Compartidos
LIMIT 5;