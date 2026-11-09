# Contratos de las APIs

## API 1: Mascotas (puerto 8001)

### POST /mascotas
Registra una mascota. El estado inicial es `disponible`.

Request:
```json
{
  "nombre": "Firulais",
  "especie": "perro",
  "edad": 3
}
```

Response 201:
```json
{
  "id": 1,
  "nombre": "Firulais",
  "especie": "perro",
  "edad": 3,
  "estado": "disponible"
}
```

### GET /mascotas
Lista todas las mascotas. Acepta el filtro opcional `?estado=disponible`.

Response 200:
```json
[
  {
    "id": 1,
    "nombre": "Firulais",
    "especie": "perro",
    "edad": 3,
    "estado": "disponible"
  }
]
```

### GET /mascotas/{id}
Devuelve el detalle de una mascota.

Response 200:
```json
{
  "id": 1,
  "nombre": "Firulais",
  "especie": "perro",
  "edad": 3,
  "estado": "disponible"
}
```

Response 404:
```json
{ "detail": "Mascota no encontrada" }
```

### PUT /mascotas/{id}/estado
Actualiza el estado de la mascota. Valores válidos: `disponible`, `en_proceso`, `adoptado`.

Request:
```json
{ "estado": "adoptado" }
```

Response 200:
```json
{
  "id": 1,
  "nombre": "Firulais",
  "especie": "perro",
  "edad": 3,
  "estado": "adoptado"
}
```

Response 404:
```json
{ "detail": "Mascota no encontrada" }
```

---

## API 2: Adopciones (puerto 8002)

### POST /solicitudes
Registra una solicitud. Antes de guardarla, consulta `GET /mascotas/{id}` en la API 1 y solo la acepta si la mascota está `disponible`.

Request:
```json
{
  "id_mascota": 1,
  "nombre_adoptante": "Ana Pérez",
  "email_adoptante": "ana@correo.com",
  "telefono_adoptante": "3001234567"
}
```

Response 201:
```json
{
  "id": 1,
  "id_mascota": 1,
  "nombre_adoptante": "Ana Pérez",
  "email_adoptante": "ana@correo.com",
  "telefono_adoptante": "3001234567",
  "estado_solicitud": "pendiente",
  "fecha": "2026-11-08T21:00:00"
}
```

Errores:
- 400: la mascota no está disponible.
- 404: la mascota no existe.

### GET /solicitudes
Lista las solicitudes. Acepta el filtro opcional `?estado_solicitud=pendiente`.

Response 200:
```json
[
  {
    "id": 1,
    "id_mascota": 1,
    "nombre_adoptante": "Ana Pérez",
    "email_adoptante": "ana@correo.com",
    "telefono_adoptante": "3001234567",
    "estado_solicitud": "pendiente",
    "fecha": "2026-11-08T21:00:00"
  }
]
```

### PUT /solicitudes/{id}/aprobar
Flujo interno:
1. Hace `GET /mascotas/{id_mascota}` a la API 1.
2. Si el estado no es `disponible`, responde 400.
3. Si es `disponible`, hace `PUT /mascotas/{id_mascota}/estado` con `{"estado": "adoptado"}`.
4. Marca la solicitud como `aprobada`.

Response 200:
```json
{
  "id": 1,
  "estado_solicitud": "aprobada",
  "mensaje": "Adopción aprobada"
}
```

Errores:
- 400: `{ "detail": "La mascota ya fue adoptada" }`
- 404: la solicitud no existe.

### PUT /solicitudes/{id}/rechazar
Marca la solicitud como `rechazada`. No modifica la mascota.

Response 200:
```json
{
  "id": 1,
  "estado_solicitud": "rechazada",
  "mensaje": "Solicitud rechazada"
}
```

Errores:
- 404: la solicitud no existe.

---

## Comunicación entre servicios

La API 2 llama a la API 1 con `httpx`. La URL de la API 1 se configura en la variable de entorno `API_MASCOTAS_URL`.
