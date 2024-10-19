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


insert into genero_musical values(1,'vallenato','S');
insert into genero_musical values(2,'tango','S');
insert into genero_musical values(3,'cumbia','S');
insert into genero_musical values(4,'reguetón','S');
insert into genero_musical values(5,'bambuco','S');
insert into genero_musical values(6,'tropical','S');
insert into genero_musical values(7,'merengue','S');
insert into genero_musical values(8,'pop','S');
insert into genero_musical values(9,'salsa','S');
insert into genero_musical values(10,'rock','S');

insert into genero values(1,'hombre','S');
insert into genero values(2,'mujer','S');
insert into genero values(3,'otro','S');

insert into categoria_plato values(1,'pescetariano','S');
insert into categoria_plato values(2,'vegetariano','S');
insert into categoria_plato values(3,'carivoro','S');
insert into categoria_plato values(4,'vegano','S');

insert into plato values(1,'cazuela de mariscos',1,'S');
insert into plato values(2,'filete de salmon ',1,'S');
insert into plato values(3,'seviche de camaro',1,'S');
insert into plato values(4,'Arepas de choclo con queso',2,'S');
insert into plato values(5,'Sancocho de guineo',2,'S');
insert into plato values(6,'Ensalada de aguacate y mango',2,'S');
insert into plato values(7,'cerdo apanado en salsas',3,'S');
insert into plato values(8,'solomito asado',3,'S');
insert into plato values(9,'pollo apanado en salsas',3,'S');
insert into plato values(10,'Lentejas guisadas',4,'S');
insert into plato values(11,'Empanadas de yuca',4,'S');
insert into plato values(12,'Frijoles simples',4,'S');

insert into plato_por_invitado values(1,1,'N');
insert into plato_por_invitado values(2,4,'N');
insert into plato_por_invitado values(3,2,'S');
insert into plato_por_invitado values(4,6,'N');
insert into plato_por_invitado values(5,7,'N');
insert into plato_por_invitado values(6,10,'N');
insert into plato_por_invitado values(7,6,'S');
insert into plato_por_invitado values(8,1,'S');
insert into plato_por_invitado values(9,10,'N');
insert into plato_por_invitado values(10,2,'N');
insert into plato_por_invitado values(11,8,'N');
insert into plato_por_invitado values(12,8,'N');
insert into plato_por_invitado values(13,2,'S');
insert into plato_por_invitado values(14,8,'S');
insert into plato_por_invitado values(15,7,'S');
insert into plato_por_invitado values(16,2,'S');
insert into plato_por_invitado values(17,3,'N');
insert into plato_por_invitado values(18,8,'S');
insert into plato_por_invitado values(19,5,'N');
insert into plato_por_invitado values(20,10,'N');
insert into plato_por_invitado values(21,1,'N');
insert into plato_por_invitado values(22,8,'S');
insert into plato_por_invitado values(23,9,'S');
insert into plato_por_invitado values(24,11,'S');
insert into plato_por_invitado values(25,3,'S');
insert into plato_por_invitado values(26,3,'S');
insert into plato_por_invitado values(27,5,'N');
insert into plato_por_invitado values(28,12,'S');
insert into plato_por_invitado values(29,1,'S');
insert into plato_por_invitado values(30,1,'S');
insert into plato_por_invitado values(31,7,'S');

insert into genero_musical_por_invitado values(1,1);
insert into genero_musical_por_invitado values(1,2);
insert into genero_musical_por_invitado values(2,3);
insert into genero_musical_por_invitado values(2,4);
insert into genero_musical_por_invitado values(3,5);
insert into genero_musical_por_invitado values(3,6);
insert into genero_musical_por_invitado values(3,7);
insert into genero_musical_por_invitado values(3,8);
insert into genero_musical_por_invitado values(3,1);
insert into genero_musical_por_invitado values(3,9);
insert into genero_musical_por_invitado values(3,2);
insert into genero_musical_por_invitado values(3,4);
insert into genero_musical_por_invitado values(4,1);
insert into genero_musical_por_invitado values(4,3);
insert into genero_musical_por_invitado values(6,5);
insert into genero_musical_por_invitado values(6,7);
insert into genero_musical_por_invitado values(6,4);
insert into genero_musical_por_invitado values(7,9);
insert into genero_musical_por_invitado values(7,2);
insert into genero_musical_por_invitado values(7,6);
insert into genero_musical_por_invitado values(7,8);
insert into genero_musical_por_invitado values(7,7);
insert into genero_musical_por_invitado values(7,3);
insert into genero_musical_por_invitado values(7,4);
insert into genero_musical_por_invitado values(8,10);
insert into genero_musical_por_invitado values(8,3);
insert into genero_musical_por_invitado values(8,9);
insert into genero_musical_por_invitado values(9,7);
insert into genero_musical_por_invitado values(9,8);
insert into genero_musical_por_invitado values(9,6);
insert into genero_musical_por_invitado values(9,9);
insert into genero_musical_por_invitado values(9,2);
insert into genero_musical_por_invitado values(9,10);
insert into genero_musical_por_invitado values(10,4);
insert into genero_musical_por_invitado values(10,5);
insert into genero_musical_por_invitado values(10,3);
insert into genero_musical_por_invitado values(11,4);
insert into genero_musical_por_invitado values(11,7);
insert into genero_musical_por_invitado values(11,3);
insert into genero_musical_por_invitado values(11,10);
insert into genero_musical_por_invitado values(11,5);
insert into genero_musical_por_invitado values(12,6);
insert into genero_musical_por_invitado values(12,2);
insert into genero_musical_por_invitado values(12,8);
insert into genero_musical_por_invitado values(12,9);
insert into genero_musical_por_invitado values(14,9);
insert into genero_musical_por_invitado values(14,10);
insert into genero_musical_por_invitado values(14,3);
insert into genero_musical_por_invitado values(14,5);
insert into genero_musical_por_invitado values(14,8);
insert into genero_musical_por_invitado values(14,2);
insert into genero_musical_por_invitado values(14,1);
insert into genero_musical_por_invitado values(14,6);
insert into genero_musical_por_invitado values(15,9);
insert into genero_musical_por_invitado values(15,4);
insert into genero_musical_por_invitado values(15,3);
insert into genero_musical_por_invitado values(15,7);
insert into genero_musical_por_invitado values(15,6);
insert into genero_musical_por_invitado values(16,1);
insert into genero_musical_por_invitado values(16,2);
insert into genero_musical_por_invitado values(16,5);
insert into genero_musical_por_invitado values(16,8);
insert into genero_musical_por_invitado values(17,8);
insert into genero_musical_por_invitado values(17,4);
insert into genero_musical_por_invitado values(17,10);
insert into genero_musical_por_invitado values(17,2);
insert into genero_musical_por_invitado values(18,3);
insert into genero_musical_por_invitado values(18,6);
insert into genero_musical_por_invitado values(18,8);
insert into genero_musical_por_invitado values(18,1);
insert into genero_musical_por_invitado values(18,5);
insert into genero_musical_por_invitado values(18,10);
insert into genero_musical_por_invitado values(18,9);
insert into genero_musical_por_invitado values(18,7);
insert into genero_musical_por_invitado values(19,2);
insert into genero_musical_por_invitado values(19,3);
insert into genero_musical_por_invitado values(19,4);
insert into genero_musical_por_invitado values(19,6);
insert into genero_musical_por_invitado values(20,4);
insert into genero_musical_por_invitado values(20,2);
insert into genero_musical_por_invitado values(20,7);
insert into genero_musical_por_invitado values(20,8);
insert into genero_musical_por_invitado values(20,1);
insert into genero_musical_por_invitado values(20,5);
insert into genero_musical_por_invitado values(20,6);
insert into genero_musical_por_invitado values(21,6);
insert into genero_musical_por_invitado values(21,5);
insert into genero_musical_por_invitado values(21,7);
insert into genero_musical_por_invitado values(21,3);
insert into genero_musical_por_invitado values(21,10);
insert into genero_musical_por_invitado values(23,4);
insert into genero_musical_por_invitado values(23,9);
insert into genero_musical_por_invitado values(23,1);
insert into genero_musical_por_invitado values(23,2);
insert into genero_musical_por_invitado values(23,3);
insert into genero_musical_por_invitado values(23,8);
insert into genero_musical_por_invitado values(23,6);
insert into genero_musical_por_invitado values(23,5);
insert into genero_musical_por_invitado values(23,7);
insert into genero_musical_por_invitado values(24,7);
insert into genero_musical_por_invitado values(24,1);
insert into genero_musical_por_invitado values(24,6);
insert into genero_musical_por_invitado values(24,8);
insert into genero_musical_por_invitado values(24,9);
insert into genero_musical_por_invitado values(24,4);
insert into genero_musical_por_invitado values(24,5);
insert into genero_musical_por_invitado values(25,3);
insert into genero_musical_por_invitado values(25,8);
insert into genero_musical_por_invitado values(25,2);
insert into genero_musical_por_invitado values(25,5);
insert into genero_musical_por_invitado values(25,4);
insert into genero_musical_por_invitado values(25,6);
insert into genero_musical_por_invitado values(25,9);
insert into genero_musical_por_invitado values(26,6);
insert into genero_musical_por_invitado values(26,4);
insert into genero_musical_por_invitado values(26,7);
insert into genero_musical_por_invitado values(26,1);
insert into genero_musical_por_invitado values(27,4);
insert into genero_musical_por_invitado values(27,3);
insert into genero_musical_por_invitado values(27,9);
insert into genero_musical_por_invitado values(27,2);
insert into genero_musical_por_invitado values(27,7);
insert into genero_musical_por_invitado values(27,6);
insert into genero_musical_por_invitado values(28,1);
insert into genero_musical_por_invitado values(28,8);
insert into genero_musical_por_invitado values(28,10);
insert into genero_musical_por_invitado values(28,2);
insert into genero_musical_por_invitado values(28,7);
insert into genero_musical_por_invitado values(28,3);
insert into genero_musical_por_invitado values(28,5);
insert into genero_musical_por_invitado values(28,4);
insert into genero_musical_por_invitado values(28,6);
insert into genero_musical_por_invitado values(28,9);
insert into genero_musical_por_invitado values(29,10);
insert into genero_musical_por_invitado values(29,6);
insert into genero_musical_por_invitado values(29,7);
insert into genero_musical_por_invitado values(29,1);
insert into genero_musical_por_invitado values(29,2);
insert into genero_musical_por_invitado values(29,4);
insert into genero_musical_por_invitado values(29,3);
insert into genero_musical_por_invitado values(29,5);
insert into genero_musical_por_invitado values(30,4);
insert into genero_musical_por_invitado values(30,10);
insert into genero_musical_por_invitado values(30,6);
insert into genero_musical_por_invitado values(30,8);
insert into genero_musical_por_invitado values(30,1);
insert into genero_musical_por_invitado values(30,9);
insert into genero_musical_por_invitado values(30,2);
insert into genero_musical_por_invitado values(31,8);
insert into genero_musical_por_invitado values(31,1);
insert into genero_musical_por_invitado values(31,3);
insert into genero_musical_por_invitado values(31,5);

insert into invitados values(1,'Juan','','Espinosa','González','6046390826',1095672677,1);
insert into invitados values(2,'José','Luis','Martínez','','3179054864',1052988648,2);
insert into invitados values(3,'Orlando','Ignacio','Arévalo','Pinzón','3110601680',32057626,3);
insert into invitados values(4,'Andrés','Carlos','Cuéllar','Lara','3183275188',5173540,1);
insert into invitados values(5,'Fabio','','Gómez','','3163866597',1277218634,2);
insert into invitados values(6,'Paulina','Karen','Pineda','','3246891544',2238096,1);
insert into invitados values(7,'Milena','María','Granados','','3063261820',1112962067,3);
insert into invitados values(8,'Nelly','Yolanda','Zapata','Sandoval','6028985122',37048740,2);
insert into invitados values(9,'Josué','','Muñoz','','3144504714',1270174527,1);
insert into invitados values(10,'Eder','Vicente','Luna','','3164281821',32221768,3);
insert into invitados values(11,'Ángela','García','Gómez','','6017673905',1156133390,2);
insert into invitados values(12,'Santiago','','Sánchez','Arango','3116147501',64138677,3);
insert into invitados values(13,'Óscar','','Vega','','6042411683',5672674,2);
insert into invitados values(14,'Samuel','Omar','Benavides','','3201227286',10653477,2);
insert into invitados values(15,'Fernanda','','Hernández','','3036494636',1070806010,2);
insert into invitados values(16,'Adriana','','Agudelo','','6046276898',1061672134,2);
insert into invitados values(17,'Liliana','Leonor','Pineda','Hernández','3214728518',2697221,1);
insert into invitados values(18,'Edinson','','Ramírez','','3081265978',6810745,1);
insert into invitados values(19,'Armando','Antonio','Hurtado','Hernández','18006581340',91431183,2);
insert into invitados values(20,'Milena','','Ojeda','','3059806659',5546198,2);
insert into invitados values(21,'Fernando','Alberto','Sanabria','','6027232626',1203617628,1);
insert into invitados values(22,'Kevin','Javier','Andrade','','3211392954',1238804985,2);
insert into invitados values(23,'Liliana','Jimena','Gutiérrez','Zambrano','3014060093',1181158956,3);
insert into invitados values(24,'Juan','Vargas','Betancur','','3033370751',32267050,2);
insert into invitados values(25,'Estela','Amparo','Rivera','Vega','31011463',1197118561,3);
insert into invitados values(26,'Yolanda','Rocío','Palacios','','3182835486',3536178,3);
insert into invitados values(27,'Gildardo','Víctor','Ramírez','','3203374668',78657032,3);
insert into invitados values(28,'Sofía','Dora','Méndez','Gaviria','3229713',1127221678,2);
insert into invitados values(29,'Edgar','','González','','3158896043',1286547868,1);
insert into invitados values(30,'Jhon','Alexander','Durán','García','60872318',7700492,1);
