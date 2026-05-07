# Semantic Knowledge Graph Builder: From Flat Data to Neo4j Backend 🧠🕸️

## 📌 Descripción del Proyecto
Este proyecto representa el ciclo de vida completo (ETL + Database Engineering) de mi hoja de ruta en Arquitectura de Información. Transforma registros bibliográficos estructurados pero "planos" en una topología viva de **Grafo de Conocimiento**, materializada en un motor **Neo4j**.

El proyecto se divide en dos fases:
* **Fase 1 (Python):** Despiece algorítmico del catálogo en tripletas semánticas (Nodos y Relaciones).
* **Fase 2.1 (Cypher/Neo4j):** Ingesta arquitectónica, bypass de seguridad local y diseño de motores de recomendación analíticos.

---

## 🎯 Fase 1: El Desafío Semántico (ETL en Python)
Los sistemas legacy suelen almacenar información de forma redundante y plana. El script `03_graph_builder.py` opera mediante una lógica de **Control de Autoridades al vuelo** para resolverlo:

1.  **Deduplicación y Normalización:** Aplica *String Normalization* (`.capitalize()`) para asegurar que "Bibliotecología" y "bibliotecología" colapsen en una única entidad semántica.
2.  **Memoria de Entidades:** Utiliza diccionarios de Python para verificar la existencia previa de una entidad antes de instanciarla, asignando **UUIDs**.
3.  **Modelado de Tripletas:** El output final se estructura en el estándar universal de grafos (Sujeto - Predicado - Objeto), exportado en un archivo `grafo_biblioteca.json`.

---

## 🏗️ Fase 2: Motor Backend (Neo4j & Cypher)
Una vez curados los datos, el proyecto se despliega en una base de datos de grafos para habilitar búsquedas de *n* saltos, inalcanzables para SQL tradicional. Esta fase consta de tres scripts fundamentales alojados en este repositorio:

### 1. Ingesta y Modelado (`01_ingesta_y_modelado.cypher`)
Script que levanta la base de datos transformando el JSON remoto en un grafo físico.
* **💡 Decisión Arquitectónica (Human-in-the-loop):** Durante la materialización, evadí los bloqueos de seguridad locales de la librería APOC forzando la lectura del archivo maestro directamente desde el *raw* de GitHub. 
* **Debugging Silencioso:** Detecté una discrepancia semántica en el pipeline (el motor buscaba la llave genérica `relaciones` cuando el ETL producía `enlaces`). Refactoricé la consulta integrando `OPTIONAL MATCH` y `trim(toString())` para lograr una ingesta 100% tolerante a fallos.

### 2. Motor de Recomendación (`02_motor_recomendacion.cypher`)
Algoritmo de **Content-Based Filtering** que calcula la distancia semántica entre documentos mediante la contabilidad de descriptores temáticos compartidos, sugiriendo lecturas afines con un costo computacional mínimo (evitando JOINs).

### 3. Extracción GraphRAG (`03_extraccion_graphrag.cypher`)
Consulta multi-salto diseñada para extraer el contexto exacto de una entidad (ej. el perfil de un Autor, su bibliografía y sus descriptores) para alimentar sistemas de IA Generativa sin riesgo de alucinaciones.

---

## 📊 Impacto de los Datos (Prueba Real)
Tras procesar el catálogo bibliográfico legacy del INTI:
* **Materia prima:** 2.500 registros planos (islas de datos).
* **Resultado:** **1.104 Nodos únicos** y **2.237 Relaciones semánticas**.
* **Deploy:** Red totalmente interconectada y operativa en el backend de Neo4j.

---

## 💻 Tecnologías Utilizadas
* **Lenguajes:** Python 3.x, Cypher (Query Language)
* **Databases:** Neo4j (Property Graph)
* **Librerías/Plugins:** APOC (Neo4j)
* **Formatos:** JSON (Puente de datos estructurado)

---

## 🚀 Instalación y Uso

**Para generar el Grafo (Python):**
1. Ejecutar el modelador: `python 03_graph_builder.py` (requiere el JSON base en la carpeta).
2. El resultado será `grafo_biblioteca.json`.

**Para levantar el Backend (Neo4j):**
1. Iniciar una instancia de Neo4j Desktop (v5.x+).
2. Abrir la herramienta **Query**.
3. Ejecutar secuencialmente los scripts provistos en este repositorio (`01_ingesta...`, `02_motor...`, `03_extraccion...`). *Nota: El script de ingesta ya está configurado para consumir el JSON directamente desde la nube, evitando problemas de permisos locales.*
