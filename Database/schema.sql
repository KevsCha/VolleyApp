
-- Volcando estructura de base de datos para VolleyApp
CREATE DATABASE IF NOT EXISTS `volleyapp` 
USE `VolleyApp`;

-- Volcando estructura para tabla VolleyApp.amonestacion
CREATE TABLE IF NOT EXISTS `amonestacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_partido` int(11) NOT NULL DEFAULT 0,
  `id_jugador` int(11) DEFAULT NULL,
  `id_equipo` int(11) DEFAULT NULL,
  `punto_actual` int(11) DEFAULT NULL,
  `numero_set` int(11) NOT NULL DEFAULT 0,
  `tipo` varchar(50) NOT NULL DEFAULT '0',
  `observaciones` varchar(500) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_partido` (`id_partido`),
  KEY `id_jugador` (`id_jugador`),
  KEY `id_equipo` (`id_equipo`),
  CONSTRAINT `FK__amonestacion_partido` FOREIGN KEY (`id_partido`) REFERENCES `partido` (`id_partido`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_amonestacion_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipo` (`id_equipo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_amonestacion_jugador` FOREIGN KEY (`id_jugador`) REFERENCES `jugador` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



-- Volcando estructura para tabla VolleyApp.arbitro
CREATE TABLE IF NOT EXISTS `arbitro` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo_arbitro` varchar(100) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  CONSTRAINT `id` FOREIGN KEY (`id`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



-- Volcando estructura para tabla VolleyApp.asignacion
CREATE TABLE IF NOT EXISTS `asignacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_arbitro` int(11) NOT NULL,
  `id_partido` int(11) NOT NULL,
  `rol` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_arbitro` (`id_arbitro`),
  KEY `id_partido` (`id_partido`),
  CONSTRAINT `FK_asignacion_arbitro` FOREIGN KEY (`id_arbitro`) REFERENCES `arbitro` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_asignacion_partido` FOREIGN KEY (`id_partido`) REFERENCES `partido` (`id_partido`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



-- Volcando estructura para tabla VolleyApp.detalle_set
CREATE TABLE IF NOT EXISTS `detalle_set` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_set` int(11) DEFAULT NULL,
  `puntos_local` int(11) DEFAULT NULL,
  `puntos_visitante` int(11) DEFAULT NULL,
  `id_partido` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_partido` (`id_partido`),
  CONSTRAINT `FK_detalle_set_partido` FOREIGN KEY (`id_partido`) REFERENCES `partido` (`id_partido`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Volcando estructura para tabla VolleyApp.entrenador
CREATE TABLE IF NOT EXISTS `entrenador` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoria` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  CONSTRAINT `FK__usuario_entrenador` FOREIGN KEY (`id`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



-- Volcando estructura para tabla VolleyApp.equipo
CREATE TABLE IF NOT EXISTS `equipo` (
  `id_equipo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL DEFAULT '0',
  `categoria` varchar(50) NOT NULL DEFAULT '0',
  `liga` varchar(50) NOT NULL DEFAULT '0',
  `id_entrenador` int(11) NOT NULL DEFAULT 0,
  `id_jugador` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_equipo`),
  KEY `id_entrenador` (`id_entrenador`),
  KEY `id_jugador` (`id_jugador`),
  CONSTRAINT `FK1` FOREIGN KEY (`id_entrenador`) REFERENCES `entrenador` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_equipo_jugador` FOREIGN KEY (`id_jugador`) REFERENCES `jugador` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



-- Volcando estructura para tabla VolleyApp.jugador
CREATE TABLE IF NOT EXISTS `jugador` (
  `id` int(11) NOT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `tutores` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  CONSTRAINT `FK__usuario_jugador` FOREIGN KEY (`id`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Volcando estructura para tabla VolleyApp.partido
CREATE TABLE IF NOT EXISTS `partido` (
  `id_partido` int(11) NOT NULL AUTO_INCREMENT,
  `equipo_a` int(11) DEFAULT NULL,
  `equipo_b` int(11) DEFAULT NULL,
  `fecha` datetime NOT NULL,
  `disputado` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_partido`),
  KEY `equipo_a` (`equipo_a`),
  KEY `equipo_b` (`equipo_b`),
  CONSTRAINT `FK_partido_equipo_a` FOREIGN KEY (`equipo_a`) REFERENCES `equipo` (`id_equipo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_partido_equipo_b` FOREIGN KEY (`equipo_b`) REFERENCES `equipo` (`id_equipo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



-- Volcando estructura para tabla VolleyApp.resultado
CREATE TABLE IF NOT EXISTS `resultado` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_partido` int(11) NOT NULL DEFAULT 0,
  `puntos_total_local` int(11) DEFAULT NULL,
  `puntos_total_visitante` int(11) DEFAULT NULL,
  `sets_local` int(11) DEFAULT NULL,
  `sets_visitante` int(11) DEFAULT NULL,
  `resultado_final` varchar(3) DEFAULT NULL,
  `duracion` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_partido` (`id_partido`),
  CONSTRAINT `FK__resultado_partido` FOREIGN KEY (`id_partido`) REFERENCES `partido` (`id_partido`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



-- Volcando estructura para tabla VolleyApp.sustitucion
CREATE TABLE IF NOT EXISTS `sustitucion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_partido` int(11) NOT NULL DEFAULT 0,
  `id_equipo` int(11) DEFAULT NULL,
  `set_numero` int(10) NOT NULL,
  `punto_actual` int(10) DEFAULT NULL,
  `id_jugador_sale` int(11) DEFAULT NULL,
  `id_jugador_entra` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_partido` (`id_partido`),
  KEY `id_equipo` (`id_equipo`),
  KEY `id_jugador_sale` (`id_jugador_sale`),
  KEY `id_jugador_entra` (`id_jugador_entra`),
  CONSTRAINT `FK__partido` FOREIGN KEY (`id_partido`) REFERENCES `partido` (`id_partido`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_sustitucion_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipo` (`id_equipo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_sustitucion_jugador` FOREIGN KEY (`id_jugador_entra`) REFERENCES `jugador` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_sustitucion_jugador_sale` FOREIGN KEY (`id_jugador_sale`) REFERENCES `jugador` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



-- Volcando estructura para tabla VolleyApp.tiempo_muerto
CREATE TABLE IF NOT EXISTS `tiempo_muerto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_partido` int(11) DEFAULT NULL,
  `id_equipo` int(11) DEFAULT NULL,
  `set_numero` int(10) NOT NULL,
  `punto_actual` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_partido` (`id_partido`),
  KEY `id_equipo` (`id_equipo`),
  CONSTRAINT `FK_tiempo_muerto_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipo` (`id_equipo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tiempo_muerto_partido` FOREIGN KEY (`id_partido`) REFERENCES `partido` (`id_partido`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



-- Volcando estructura para tabla VolleyApp.usuario
CREATE TABLE IF NOT EXISTS `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL DEFAULT '0',
  `apellidos` varchar(100) NOT NULL DEFAULT '0',
  `telefono` varchar(10) NOT NULL DEFAULT '0',
  `dni` varchar(10) NOT NULL,
  `f_nacimiento` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  CONSTRAINT `FK_usuario` FOREIGN KEY (`id`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
