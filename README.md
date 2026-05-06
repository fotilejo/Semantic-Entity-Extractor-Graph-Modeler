# Semantic Knowledge Graph Builder: From Flat Data to Entities 🧠🕸️

## 📌 Descripción del Proyecto
Este proyecto representa la **Fase 1 - Capstone** de mi hoja de ruta en Arquitectura de Información. Es un motor de modelado semántico desarrollado en Python que transforma registros bibliográficos estructurados (JSON) en una topología de **Grafo de Conocimiento**.

A diferencia de las bases de datos relacionales tradicionales, este script "explota" los registros para aislar entidades únicas (Documentos, Autores y Temas), estableciendo conexiones lógicas que permiten búsquedas por descubrimiento, sistemas de recomendación y aplicaciones de **GraphRAG**.



## 🎯 El Desafío Semántico
Los sistemas legacy suelen almacenar información de forma redundante y plana. El desafío aquí fue:
1.  **Entidad vs. Texto:** Diferenciar cuando un nombre de autor es solo una cadena de texto y cuándo debe ser un "Nodo" único en una red.
2.  **Control de Autoridades:** Resolver duplicidades por inconsistencias de mayúsculas o espacios (ej: "INTI" vs "inti").
3.  **Descomposición de Atributos:** Procesar campos de autores múltiples (coautoría) para generar múltiples relaciones desde un solo registro.

## 🏗️ Arquitectura de la Solución

El script `03_graph_builder.py` opera mediante una lógica de **Control de Autoridades al vuelo**:

### 1. Extracción y Normalización
El motor procesa el catálogo limpio, aplicando técnicas de *String Normalization* (`.capitalize()`, `.title()`) para asegurar que "Bibliotecología" y "bibliotecología" colapsen en una única entidad semántica.

### 2. Memoria de Entidades (Deduplicación)
Mediante el uso de diccionarios de Python como "libros de autoridades", el sistema verifica la existencia previa de una entidad antes de instanciarla, asignando **UUIDs (Identificadores Únicos)** para mantener la integridad referencial.

### 3. Modelado de Tripletas (Sujeto - Predicado - Objeto)
El output final se estructura en el estándar universal de grafos:
* **Nodes (Nodos):** Entidades con etiquetas específicas (`Documento`, `Autor`, `Tema`).
* **Edges (Relaciones):** Aristas direccionales que definen la semántica: `(Documento)--[ESCRITO_POR]-->(Autor)` o `(Documento)--[TRATA_SOBRE]-->(Tema)`.

## 📊 Impacto de los Datos (Prueba Real)
Tras procesar un catálogo bibliográfico legacy:
* **Materia prima:** 2.500 registros planos (islas de datos).
* **Resultado:** **1.104 Nodos** únicos y **2.237 Relaciones** semánticas.
* **Densidad:** Se logró una red interconectada lista para ingesta en **Neo4j** o visualización en **D3.js**.

## 💻 Tecnologías Utilizadas
* **Lenguaje:** Python 3.x
* **Formatos:** JSON (Entrada/Salida)
* **Estructuras:** Dictionaries, Lists & Nested Loops.

## 🚀 Instalación y Uso

1.  Asegurarse de tener el archivo `bibliotecas.json` (generado por el [Data Normalizer](https://github.com/tu-usuario/data-normalizer-etl)) en la misma carpeta.
2.  Ejecutar el modelador:
    python 03_graph_builder.py
3.  El resultado se encontrará en `grafo_semantico.json`.
