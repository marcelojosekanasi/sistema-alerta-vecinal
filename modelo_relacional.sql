-- =====================================================
-- MODELO RELACIONAL - SISTEMA WEB MÓVIL DE ALERTA VECINAL
-- Autor: Marcelo Jose Kanasi Canales
-- Fecha: 02/10/2026
-- =====================================================

-- Tabla Usuario
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(20) DEFAULT 'vecino',
    estado BOOLEAN DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla Incidente
CREATE TABLE incidente (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    descripcion TEXT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'pendiente',
    usuario_id INTEGER NOT NULL,
    CONSTRAINT fk_incidente_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- Tabla Ubicacion
CREATE TABLE ubicacion (
    id SERIAL PRIMARY KEY,
    latitud DECIMAL(10, 8) NOT NULL,
    longitud DECIMAL(11, 8) NOT NULL,
    direccion VARCHAR(200),
    incidente_id INTEGER NOT NULL,
    CONSTRAINT fk_ubicacion_incidente FOREIGN KEY (incidente_id) REFERENCES incidente(id)
);

-- Tabla Alerta
CREATE TABLE alerta (
    id SERIAL PRIMARY KEY,
    nivel_riesgo VARCHAR(20) NOT NULL,
    descripcion TEXT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'activa',
    usuario_id INTEGER NOT NULL,
    CONSTRAINT fk_alerta_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- Tabla PrediccionRiesgo
CREATE TABLE prediccion_riesgo (
    id SERIAL PRIMARY KEY,
    probabilidad DECIMAL(5, 4) NOT NULL,
    nivel_riesgo VARCHAR(20) NOT NULL,
    fecha_analisis TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    alerta_id INTEGER,
    CONSTRAINT fk_prediccion_alerta FOREIGN KEY (alerta_id) REFERENCES alerta(id)
);

-- =====================================================
-- CONSULTAS SELECT
-- =====================================================

-- Pregunta 1: ¿Cuántos incidentes ha reportado cada usuario?
SELECT 
    u.nombre,
    u.correo,
    COUNT(i.id) AS total_incidentes
FROM usuario u
LEFT JOIN incidente i ON u.id = i.usuario_id
GROUP BY u.id, u.nombre, u.correo
ORDER BY total_incidentes DESC;

-- Pregunta 2: ¿Cuáles son los tipos de incidentes más frecuentes y su ubicación?
SELECT 
    i.tipo,
    COUNT(*) AS cantidad,
    ROUND(AVG(ub.latitud), 4) AS latitud_promedio,
    ROUND(AVG(ub.longitud), 4) AS longitud_promedio
FROM incidente i
INNER JOIN ubicacion ub ON i.id = ub.incidente_id
GROUP BY i.tipo
ORDER BY cantidad DESC;