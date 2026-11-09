CREATE TABLE mascotas (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  especie VARCHAR(50) NOT NULL,
  edad INT NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'disponible'
    CHECK (estado IN ('disponible', 'en_proceso', 'adoptado'))
);

CREATE TABLE solicitudes (
  id SERIAL PRIMARY KEY,
  id_mascota INT NOT NULL REFERENCES mascotas(id),
  nombre_adoptante VARCHAR(100) NOT NULL,
  email_adoptante VARCHAR(100) NOT NULL,
  telefono_adoptante VARCHAR(30),
  estado_solicitud VARCHAR(20) NOT NULL DEFAULT 'pendiente'
    CHECK (estado_solicitud IN ('pendiente', 'aprobada', 'rechazada')),
  fecha TIMESTAMP NOT NULL DEFAULT NOW()
);
