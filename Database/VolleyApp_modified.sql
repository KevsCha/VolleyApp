

CREATE DATABASE IF NOT EXISTS `volleyapp` 
USE `volleyapp`;

-- ========================
-- Tabla: usuario
-- ========================
CREATE TABLE IF NOT EXISTS `usuario` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NULL,
  `apellidos` VARCHAR(100) NULL,
  `telefono` VARCHAR(15) NULL,
  `dni` VARCHAR(20) NOT NULL,
  `f_nacimiento` DATETIME NOT NULL,
  PRIMARY KEY (`id`)
) 

-- ========================
-- Tablas de "roles" (herencia por composición)
-- NOTA: estas tablas usan el mismo id que usuario (no AUTO_INCREMENT)
-- ========================

CREATE TABLE IF NOT EXISTS `jugador` (
  `id` INT(11) NOT NULL,
  `categoria` VARCHAR(50) DEFAULT NULL,
  `tutores` VARCHAR(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_jugador_usuario` FOREIGN KEY (`id`) REFERENCES `usuario`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) 

CREATE TABLE IF NOT EXISTS `entrenador` (
  `id` INT(11) NOT NULL,
  `categoria` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_entrenador_usuario` FOREIGN KEY (`id`) REFERENCES `usuario`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) 

CREATE TABLE IF NOT EXISTS `arbitro` (
  `id` INT(11) NOT NULL,
  `titulo_arbitro` VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_arbitro_usuario` FOREIGN KEY (`id`) REFERENCES `usuario`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) 

-- ========================
-- Tabla: equipo (sin id_jugador)
-- ========================
CREATE TABLE IF NOT EXISTS `equipo` (
  `id_equipo` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `categoria` VARCHAR(50) DEFAULT NULL,
  `liga` VARCHAR(50) DEFAULT NULL,
  `id_entrenador` INT(11) DEFAULT NULL,
  PRIMARY KEY (`id_equipo`),
  KEY `FK_equipo_entrenador_idx` (`id_entrenador`),
  CONSTRAINT `FK_equipo_entrenador` FOREIGN KEY (`id_entrenador`) REFERENCES `entrenador`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
)

-- ========================
-- Tabla puente: equipo_jugador (N:M)
-- ========================
CREATE TABLE IF NOT EXISTS `equipo_jugador` (
  `id_equipo` INT(11) NOT NULL,
  `id_jugador` INT(11) NOT NULL,
  `fecha_alta` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id_equipo`, `id_jugador`),
  KEY `idx_ej_equipo` (`id_equipo`),
  KEY `idx_ej_jugador` (`id_jugador`),
  CONSTRAINT `FK_ej_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipo`(`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ej_jugador` FOREIGN KEY (`id_jugador`) REFERENCES `jugador`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
)

-- ========================
-- Tabla: partido
-- ========================
CREATE TABLE IF NOT EXISTS `partido` (
  `id_partido` INT(11) NOT NULL AUTO_INCREMENT,
  `equipo_a` INT(11) DEFAULT NULL,
  `equipo_b` INT(11) DEFAULT NULL,
  `fecha` DATETIME NOT NULL,
  `disputado` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_partido`),
  KEY `idx_partido_equipo_a` (`equipo_a`),
  KEY `idx_partido_equipo_b` (`equipo_b`),
  CONSTRAINT `FK_partido_equipo_a` FOREIGN KEY (`equipo_a`) REFERENCES `equipo`(`id_equipo`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_partido_equipo_b` FOREIGN KEY (`equipo_b`) REFERENCES `equipo`(`id_equipo`) ON DELETE SET NULL ON UPDATE CASCADE
) 

-- ========================
-- Tabla: detalle_set (sets por partido)
-- ========================
CREATE TABLE IF NOT EXISTS `detalle_set` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `numero_set` INT(11) NOT NULL,
  `puntos_local` INT(11) DEFAULT 0,
  `puntos_visitante` INT(11) DEFAULT 0,
  `id_partido` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_detalle_id_partido` (`id_partido`),
  CONSTRAINT `FK_detalle_set_partido` FOREIGN KEY (`id_partido`) REFERENCES `partido`(`id_partido`) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE KEY `ux_partido_numero_set` (`id_partido`, `numero_set`)
) 

-- ========================
-- Tabla: resultado (1 por partido)
-- ========================
CREATE TABLE IF NOT EXISTS `resultado` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_partido` INT(11) NOT NULL,
  `puntos_total_local` INT(11) DEFAULT NULL,
  `puntos_total_visitante` INT(11) DEFAULT NULL,
  `sets_local` INT(11) DEFAULT NULL,
  `sets_visitante` INT(11) DEFAULT NULL,
  `resultado_final` VARCHAR(10) DEFAULT NULL,
  `duracion` TIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_resultado_partido` (`id_partido`),
  CONSTRAINT `FK_resultado_partido` FOREIGN KEY (`id_partido`) REFERENCES `partido`(`id_partido`) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE KEY `ux_resultado_unico_partido` (`id_partido`)
) 

-- ========================
-- Tabla: amonestacion (tarjetas/faltas)
-- ========================
CREATE TABLE IF NOT EXISTS `amonestacion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_partido` INT(11) NOT NULL,
  `id_jugador` INT(11) DEFAULT NULL,
  `id_equipo` INT(11) DEFAULT NULL,
  `punto_actual` INT(11) DEFAULT NULL,
  `numero_set` INT(11) DEFAULT NULL,
  `tipo` VARCHAR(50) DEFAULT NULL,
  `observaciones` VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_amon_id_partido` (`id_partido`),
  KEY `idx_amon_id_jugador` (`id_jugador`),
  KEY `idx_amon_id_equipo` (`id_equipo`),
  CONSTRAINT `FK_amonestacion_partido` FOREIGN KEY (`id_partido`) REFERENCES `partido`(`id_partido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_amonestacion_jugador` FOREIGN KEY (`id_jugador`) REFERENCES `jugador`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_amonestacion_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipo`(`id_equipo`) ON DELETE SET NULL ON UPDATE CASCADE
) 

-- ========================
-- Tabla: sustitucion
-- ========================
CREATE TABLE IF NOT EXISTS `sustitucion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_partido` INT(11) NOT NULL,
  `id_equipo` INT(11) DEFAULT NULL,
  `set_numero` INT(11) NOT NULL,
  `punto_actual` INT(11) DEFAULT NULL,
  `id_jugador_sale` INT(11) DEFAULT NULL,
  `id_jugador_entra` INT(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sub_id_partido` (`id_partido`),
  KEY `idx_sub_equipo` (`id_equipo`),
  KEY `idx_sub_jugador_sale` (`id_jugador_sale`),
  KEY `idx_sub_jugador_entra` (`id_jugador_entra`),
  CONSTRAINT `FK_sub_partido` FOREIGN KEY (`id_partido`) REFERENCES `partido`(`id_partido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_sub_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipo`(`id_equipo`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_sub_jugador_entra` FOREIGN KEY (`id_jugador_entra`) REFERENCES `jugador`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_sub_jugador_sale` FOREIGN KEY (`id_jugador_sale`) REFERENCES `jugador`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) 

-- ========================
-- Tabla: tiempo_muerto
-- ========================
CREATE TABLE IF NOT EXISTS `tiempo_muerto` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_partido` INT(11) NOT NULL,
  `id_equipo` INT(11) DEFAULT NULL,
  `set_numero` INT(11) NOT NULL,
  `punto_actual` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tm_id_partido` (`id_partido`),
  KEY `idx_tm_id_equipo` (`id_equipo`),
  CONSTRAINT `FK_tm_partido` FOREIGN KEY (`id_partido`) REFERENCES `partido`(`id_partido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_tm_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipo`(`id_equipo`) ON DELETE SET NULL ON UPDATE CASCADE
) 

-- ========================
-- Tabla: asignacion (árbitro - partido)
-- ========================
CREATE TABLE IF NOT EXISTS `asignacion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_arbitro` INT(11) NOT NULL,
  `id_partido` INT(11) NOT NULL,
  `rol` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_asig_arbitro` (`id_arbitro`),
  KEY `idx_asig_partido` (`id_partido`),
  CONSTRAINT `FK_asig_arbitro` FOREIGN KEY (`id_arbitro`) REFERENCES `arbitro`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_asig_partido` FOREIGN KEY (`id_partido`) REFERENCES `partido`(`id_partido`) ON DELETE CASCADE ON UPDATE CASCADE
) 

