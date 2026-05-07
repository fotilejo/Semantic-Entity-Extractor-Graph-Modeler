// ============================================================================
// SPRINT 2.1: Graph Database Engine (Neo4j)
// Fase: Preparación para Inteligencia Artificial
// Descripción: Extractor de contexto multi-salto para arquitectura GraphRAG.
// ============================================================================

// Extracción del perfil de conocimiento encapsulado de una entidad Autor.
// Flujo: Autor -> [ESCRITO_POR] -> Documentos -> [TRATA_SOBRE] -> Temas
MATCH (a:Autor {nombre: "Litton, G."})<-[:ESCRITO_POR]-(d:Documento)-[:TRATA_SOBRE]->(t:Tema)
RETURN a.nombre AS Autor_Consultado, 
       count(DISTINCT d) AS Total_Publicaciones,
       collect(DISTINCT d.titulo) AS Bibliografia_En_Catalogo, 
       collect(DISTINCT t.termino) AS Mapa_De_Expertise;