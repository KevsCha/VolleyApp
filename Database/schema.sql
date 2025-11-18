-- Elimina la base de datos si ya existe

DROP TABLE IF EXISTS VolleyBBDD;

-- Crea la base de datos

CREATE DATABASE VolleyBBDD;

-- Selecciona la base de datos para usarla

USE VolleyBBDD;

-- TABLA USUARIOS

CREATE TABLE Usuarios (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL
)

-- TABLA JUGADORES QUE RECIBE LA CLAVE ID DE USUARIOS Y TIENE SUS PROPIAS COLUMNAS
CREATE TABLE Jugadores (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    UsuarioID INT,
    Nivel INT DEFAULT 1,
    Puntos INT DEFAULT 0,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(ID)
)