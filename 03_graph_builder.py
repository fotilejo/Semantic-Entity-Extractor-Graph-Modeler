import json

print("🧠 Iniciando construcción del Knowledge Graph...")

# 1. Cargamos tu catálogo limpio (la materia prima)
with open('biblioteca.json', 'r', encoding='utf-8') as f:
    catalogo = json.load(f)

# Estas dos listas van a ser la estructura de nuestro Grafo
nodos = []
enlaces = []

# Diccionarios de Memoria (Acá ocurre la magia de desduplicación)
memoria_autores = {}
memoria_descriptores = {}

# Contadores para inventar IDs únicos
id_libro_contador = 1
id_autor_contador = 1
id_desc_contador = 1

# 2. BUCLE PRINCIPAL: Recorremos cada registro del JSON original
for registro in catalogo:
    
    # A) NODO DEL LIBRO: Creamos la entidad principal
    id_libro = f"DOC_{id_libro_contador}"
    id_libro_contador += 1
    
    nodos.append({
        "id": id_libro,
        "label": "Documento",
        "propiedades": {
            "titulo": registro.get("titulo", ""),
            "anio": registro.get("anio", "")
        }
    })

    # B) NODOS DE AUTORES (Múltiples autores permitidos)
    autores_texto = str(registro.get("autor", ""))
    if autores_texto.strip(): # Si la celda no está vacía...
        
        # Rompemos el texto en una lista real separando por punto y coma (;)
        lista_autores = [a.strip() for a in autores_texto.split(';') if a.strip()]
        
        for autor_nombre in lista_autores:
            
            # Normalizamos el nombre: .title() pone mayúscula a cada palabra ("Falcato, Pedro")
            autor_nombre = autor_nombre.title()
            
            # Si el autor es nuevo, lo registramos en la memoria y creamos su Nodo
            if autor_nombre not in memoria_autores:
                id_nuevo_autor = f"AUT_{id_autor_contador}"
                memoria_autores[autor_nombre] = id_nuevo_autor
                id_autor_contador += 1
                
                nodos.append({
                    "id": id_nuevo_autor,
                    "label": "Autor",
                    "propiedades": {"nombre": autor_nombre}
                })
            
            # Independientemente de si es nuevo o viejo, lo conectamos con el libro
            id_autor_actual = memoria_autores[autor_nombre]
            enlaces.append({
                "origen": id_libro,
                "relacion": "ESCRITO_POR",
                "destino": id_autor_actual
            })

    # C) NODOS DE DESCRIPTORES (Bucle anidado para la lista)
    descriptores = registro.get("descriptores", [])
    for desc in descriptores:
        # Limpiamos espacios y forzamos a que solo la primera letra sea mayúscula (Capitalize)
        # Así, "Centros de Documentación" y "centros de documentación" se convierten en "Centros de documentación"
        desc_normalizado = desc.strip().capitalize()
        
        # Misma lógica, pero usando el término ya normalizado
        if desc_normalizado not in memoria_descriptores:
            id_nuevo_desc = f"DESC_{id_desc_contador}"
            memoria_descriptores[desc_normalizado] = id_nuevo_desc
            id_desc_contador += 1
            
            nodos.append({
                "id": id_nuevo_desc,
                "label": "Tema",
                "propiedades": {"termino": desc_normalizado}
            })
        
        # Conectamos el libro con su tema
        id_desc_actual = memoria_descriptores[desc_normalizado]
        enlaces.append({
            "origen": id_libro,
            "relacion": "TRATA_SOBRE",
            "destino": id_desc_actual
        })

# 3. Empaquetar y exportar el formato universal de grafos
grafo_final = {
    "nodos": nodos,
    "enlaces": enlaces
}

with open('grafo_biblioteca.json', 'w', encoding='utf-8') as f:
    json.dump(grafo_final, f, ensure_ascii=False, indent=4)

print(f"✅ Grafo construido exitosamente.")
print(f"📊 Se generaron {len(nodos)} Nodos y {len(enlaces)} Relaciones.")