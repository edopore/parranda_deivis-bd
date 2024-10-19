-- Tabla Parranda de deivis

--DROP SCHEMA IF EXISTS parranda_deivis;
CREATE SCHEMA IF NOT EXISTS parranda_deivis;

USE parranda_deivis;

DROP TABLE IF EXISTS invitados;
DROP TABLE IF EXISTS genero;
DROP TABLE IF EXISTS genero_musical;
DROP TABLE IF EXISTS plato;
DROP TABLE IF EXISTS categoria_plato;
DROP TABLE IF EXISTS plato_por_invitado;
DROP TABLE IF EXISTS genero_musical_por_invitado;

CREATE TABLE IF NOT EXISTS genero(
	id_genero INT NOT NULL,
	descripcion_genero VARCHAR(10) NOT NULL,
	activo VARCHAR(1) CHECK (activo IN ('S','N')) DEFAULT 'S',
	PRIMARY KEY (id_genero)
);
CREATE TABLE IF NOT EXISTS genero_musical(
	id_genero_musical INT NOT NULL,
	descripcion VARCHAR(10) NOT NULL,
	activo VARCHAR(1) CHECK (activo IN ('S','N')) DEFAULT 'S',
	PRIMARY KEY(id_genero_musical)
);
CREATE TABLE IF NOT EXISTS categoria_plato(
	id_categoria_plato INT NOT NULL,
	descripcion VARCHAR(10) NOT NULL,
	activo VARCHAR(1) CHECK (activo IN ('S','N')) DEFAULT 'S',
	PRIMARY KEY(id_categoria_plato)
);
CREATE TABLE IF NOT EXISTS plato(
	id_plato INT NOT NULL,
	nombre_plato VARCHAR(16) NOT NULL,
	id_categoria_plato INT,
	activo VARCHAR(1) DEFAULT 'S' CHECK (activo IN('S','N')),
	PRIMARY KEY(id_plato),
	FOREIGN KEY (id_categoria_plato) REFERENCES parranda_deivis.categoria_plato(id_categoria_plato)
);
CREATE TABLE IF NOT EXISTS plato_por_invitado(
	id_invitado INT NOT NULL,
	id_plato INT NOT NULL,
	confirmacion VARCHAR(1) CHECK (confirmacion IN('S','N')) DEFAULT 'N',
	PRIMARY KEY(id_invitado,id_plato)
);
CREATE TABLE IF NOT EXISTS genero_musical_por_invitado(
	id_invitado INT NOT NULL,
	id_genero_musical INT NOT NULL,
	PRIMARY KEY(id_invitado,id_genero_musical)
);
CREATE TABLE IF NOT EXISTS invitados(
	id_invitado INT NOT NULL,
	primer_nombre VARCHAR(10) NOT NULL,
	segundo_nombre VARCHAR(10),
	primer_apellido VARCHAR(10) NOT NULL,
	segundo_apellido VARCHAR(10),
	identificacion_invitado VARCHAR(10) NOT NULL,
	telefono_invitado VARCHAR(10) NOT NULL,
	id_genero INT NOT NULL,
	PRIMARY KEY(id_invitado),
	FOREIGN KEY (id_genero) REFERENCES parranda_deivis.genero(id_genero),
);
