-- Solucion analisis de datos para parranda de deivis.
-- 1. ¿Cuál es el plato más popular entre los asistentes a la fiesta?
SELECT 	B.nombre_plato, 
		COUNT(A.id_plato) AS cantidad 
FROM parranda_deivis.plato_por_invitado A 
INNER JOIN parranda_deivis.plato B ON A.id_plato = B.id_plato 
GROUP BY nombre_plato ORDER BY cantidad DESC; 

-- 2. ¿Qué porcentaje de los asistentes es vegetariano, vegano o carnívoro?
WITH
	UNO AS(
		SELECT * FROM parranda_deivis.plato_por_invitado
	),
	DOS AS(
		SELECT 	C.descripcion,
				COUNT(C.descripcion) AS cantidad,
				((cantidad*100)/(SELECT COUNT(*) FROM UNO)) AS porcentaje
		FROM UNO A 
		INNER JOIN parranda_deivis.plato B ON A.id_plato = B.id_plato 
		INNER JOIN parranda_deivis.categoria_plato C ON B.id_categoria_plato = C.id_categoria_plato
		GROUP BY C.descripcion
		ORDER BY cantidad DESC
	)
SELECT * 
FROM DOS 
WHERE descripcion IN (SELECT descripcion FROM parranda_deivis.categoria_plato cp WHERE descripcion NOT LIKE 'pescetariano' )
ORDER BY cantidad DESC;

-- 3. ¿Cuántos asistentes prefieren música de salsa?
SELECT 	B.descripcion,
		COUNT(A.*) AS cantidad  
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.genero_musical B ON A.id_genero_musical = B.id_genero_musical 
WHERE B.descripcion = 'salsa'
GROUP BY descripcion;

-- 4. ¿Qué género musical es el más mencionado entre los asistentes?
SELECT 	B.descripcion, 
		COUNT(A.*) AS cantidad  
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.genero_musical B ON A.id_genero_musical = B.id_genero_musical 
GROUP BY descripcion
ORDER BY cantidad DESC;

-- 5. ¿Cuántos hombres y mujeres confirmaron su asistencia?
SELECT 	C.descripcion_genero, 
		COUNT(B.id_genero) AS cantidad_invitados_confirmados 
FROM parranda_deivis.plato_por_invitado A
INNER JOIN parranda_deivis.invitados B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.genero C ON B.id_genero = C.id_genero 
WHERE confirmacion = 'S' AND C.id_genero <> 3
GROUP BY C.descripcion_genero;

-- 6. ¿Cuál es la comida preferida de los asistentes que son pescetarianos?
SELECT 	B.nombre_plato, 
		COUNT(*) AS cantidad 
FROM parranda_deivis.plato_por_invitado A
INNER JOIN parranda_deivis.plato B ON A.id_plato = B.id_plato
INNER JOIN parranda_deivis.categoria_plato C ON B.id_categoria_plato = C.id_categoria_plato 
WHERE A.confirmacion = 'S' AND C.id_categoria_plato = 1
GROUP BY B.nombre_plato; 

-- 7. ¿Qué platos fueron seleccionados por los asistentes veganos?
SELECT 	B.nombre_plato, 
		COUNT(*) AS cantidad 
FROM parranda_deivis.plato_por_invitado A
INNER JOIN parranda_deivis.plato B ON A.id_plato = B.id_plato
INNER JOIN parranda_deivis.categoria_plato C ON B.id_categoria_plato = C.id_categoria_plato
WHERE C.id_categoria_plato = 4
GROUP BY B.nombre_plato; 

-- 8. ¿Cuántos asistentes confirmaron su asistencia?
SELECT 	CASE 
			WHEN confirmacion = 'N' THEN 'No han confirmado' 
			WHEN confirmacion = 'S' THEN 'Si han confirmado'	
		END AS confirmacion,
		COUNT(*) AS cantidad_confirmaron 
FROM parranda_deivis.plato_por_invitado
GROUP BY confirmacion;

-- 9. ¿Qué género musical prefieren los hombres en comparación con las mujeres?
-- 1 hombres
SELECT 	C.descripcion, 
		COUNT(*) AS cantidad 
FROM parranda_deivis.invitados A
INNER JOIN parranda_deivis.genero_musical_por_invitado B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.genero_musical C ON B.id_genero_musical = C.id_genero_musical
WHERE A.id_genero = 1
GROUP BY C.descripcion
ORDER BY cantidad DESC;

-- 2 mujeres
SELECT 	C.descripcion, 
		COUNT(*) AS cantidad
FROM parranda_deivis.invitados A
INNER JOIN parranda_deivis.genero_musical_por_invitado B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.genero_musical C ON B.id_genero_musical = C.id_genero_musical
WHERE A.id_genero = 2
GROUP BY C.descripcion
ORDER BY cantidad DESC;

-- 10. ¿Qué platos son elegidos por los asistentes que prefieren la cumbia?
-- cumbia tiene id 3
SELECT C.nombre_plato 
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.plato_por_invitado B ON A.id_invitado = B.id_invitado 
INNER JOIN parranda_deivis.plato C ON B.id_plato = C.id_plato 
WHERE id_genero_musical = 3;	

-- 11. ¿Cuál es la diferencia en preferencias musicales entre los que eligieron comida carnívora y pescetariana?
-- Pescetarianos
SELECT D.descripcion, COUNT(*) AS cantidad
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.plato_por_invitado B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.plato C ON B.id_plato = C.id_plato
INNER JOIN parranda_deivis.genero_musical D ON A.id_genero_musical = D.id_genero_musical 
WHERE C.id_categoria_plato = 1
GROUP BY D.descripcion 
ORDER BY cantidad DESC;

-- Carnivoros
SELECT D.descripcion, COUNT(*) AS cantidad
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.plato_por_invitado B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.plato C ON B.id_plato = C.id_plato
INNER JOIN parranda_deivis.genero_musical D ON A.id_genero_musical = D.id_genero_musical 
WHERE C.id_categoria_plato = 3
GROUP BY D.descripcion
ORDER BY cantidad DESC;

-- 12. ¿Qué porcentaje de los asistentes prefiere música tropical?
-- tropical tiene id 6
SELECT 	'tropical' AS genero_musical ,
		(COUNT(*)*100)/(SELECT COUNT(*) FROM parranda_deivis.genero_musical_por_invitado) AS porcentaje
FROM parranda_deivis.genero_musical_por_invitado gmpi WHERE id_genero_musical = 6
GROUP BY id_genero_musical ; 

-- 13. ¿Cuántos asistentes eligieron cazuela de mariscos como su plato?
-- cazuela de mariscos tiene id 1
SELECT 	'cazuela de mariscos' AS nombre_plato,
		COUNT(*) AS cantidad	
FROM parranda_deivis.plato_por_invitado ppi 
WHERE id_plato = 1;

-- 14. ¿Hay alguna relación entre el género de los asistentes y sus preferencias de comida?
SELECT * FROM parranda_deivis.plato_por_invitado ppi 
INNER JOIN parranda_deivis.invitados i ON ppi.id_invitado = i.id_invitado 
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato 
INNER JOIN parranda_deivis.categoria_plato cp ON p.id_categoria_plato = cp.id_categoria_plato;


-- 15. ¿Qué asistente tiene la preferencia musical más diversa y cuáles son esos géneros?
WITH ID AS (
			SELECT 	id_invitado,
					COUNT(*) AS cantidad
			FROM parranda_deivis.genero_musical_por_invitado
			GROUP BY id_invitado
			ORDER BY cantidad DESC
			LIMIT 1
) 
SELECT 	CONCAT(i.primer_nombre,' ',i.segundo_nombre,' ',i.primer_apellido,' ',i.segundo_apellido) AS nombre_invitado,
		i.id_invitado,		
		B.descripcion,
FROM parranda_deivis.genero_musical_por_invitado A 
JOIN parranda_deivis.genero_musical B ON A.id_genero_musical = B.id_genero_musical 
INNER JOIN parranda_deivis.invitados i ON A.id_invitado = i.id_invitado 
WHERE A.id_invitado = (SELECT id_invitado FROM ID);

-- 16. ¿Cuántos asistentes que confirmaron su asistencia prefieren un plato vegano?
-- vegano tiene id 4
SELECT COUNT(*) AS cantidad_asistentes 
FROM parranda_deivis.plato_por_invitado A 
JOIN parranda_deivis.plato B ON A.id_plato = B.id_plato 
WHERE A.confirmacion = 'S' AND B.id_categoria_plato = (SELECT id_categoria_plato FROM parranda_deivis.categoria_plato WHERE descripcion='vegano');

-- 17. ¿Qué tipo de comida prefieren los asistentes que disfrutan de música de reguetón?
-- regueton tiene id 4
SELECT D.descripcion, COUNT(*) AS cantidad
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.plato_por_invitado B ON A.id_invitado = B.id_invitado 
INNER JOIN parranda_deivis.plato C ON B.id_plato = C.id_plato 
INNER JOIN parranda_deivis.categoria_plato D ON C.id_categoria_plato = D.id_categoria_plato 
WHERE id_genero_musical = 4
GROUP BY D.descripcion 
ORDER BY cantidad DESC;

-- 18. ¿Hay algún asistente que haya confirmado asistencia, pero no haya elegido un plato?
SELECT * 
FROM parranda_deivis.plato_por_invitado 
WHERE confirmacion = 'S' AND id_plato IS NULL;

-- 19. ¿Qué género musical prefieren los asistentes que eligen ensaladas?
SELECT gm.descripcion 
FROM parranda_deivis.genero_musical_por_invitado gmpi 
INNER JOIN parranda_deivis.plato_por_invitado ppi ON gmpi.id_invitado = ppi.id_invitado
INNER JOIN parranda_deivis.genero_musical gm ON gmpi.id_genero_musical = gm.id_genero_musical 
WHERE ppi.id_plato = (SELECT id_plato FROM parranda_deivis.plato p WHERE nombre_plato LIKE 'Ensalada%');

-- 20. ¿Cuántos asistentes tienen como plato favorito algún tipo de pescado o marisco?
SELECT COUNT(*) AS cantidad_asistentes 
FROM parranda_deivis.plato_por_invitado ppi
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato 
WHERE id_categoria_plato = 1;

--OPCIONALES

--  1. ¿Qué plato eligió el asistente con la identificación más alta?
SELECT 	i.id_invitado,
		CONCAT(i.primer_nombre,' ',i.segundo_nombre,' ',i.primer_apellido,' ',i.segundo_apellido) AS nombre_invitado,
		i.identificacion_invitado, 
		p.nombre_plato 
FROM parranda_deivis.plato_por_invitado ppi
INNER JOIN parranda_deivis.invitados i ON ppi.id_invitado = i.id_invitado 
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato 
WHERE ppi.id_invitado = (SELECT id_invitado 
FROM parranda_deivis.invitados i 
WHERE LENGTH(identificacion_invitado) = (SELECT MAX(LENGTH(identificacion_invitado)) FROM parranda_deivis.invitados));

--  2. ¿Cuál es el nombre del asistente que prefiere música vallenata y qué tipo de comida consume?
SELECT 	CONCAT(i.primer_nombre,' ',i.segundo_nombre,' ',i.primer_apellido,' ',i.segundo_apellido) AS nombre_invitado,
		cp.descripcion 
FROM parranda_deivis.plato_por_invitado ppi
INNER JOIN parranda_deivis.invitados i ON ppi.id_invitado = i.id_invitado
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato 
INNER JOIN parranda_deivis.categoria_plato cp ON p.id_categoria_plato = cp.id_categoria_plato 
WHERE ppi.id_invitado IN (SELECT id_invitado FROM parranda_deivis.genero_musical_por_invitado gmpi WHERE id_genero_musical = 1);

--  3. ¿Cuántos asistentes son pescetarianos y prefieren música de tango?
SELECT COUNT(*) AS cantidad 
FROM parranda_deivis.plato_por_invitado ppi 
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato 
INNER JOIN parranda_deivis.genero_musical_por_invitado gmpi ON ppi.id_invitado = gmpi.id_invitado
INNER JOIN parranda_deivis.genero_musical gm ON gmpi.id_genero_musical = gm.id_genero_musical 
WHERE gm.id_genero_musical = 2 and p.id_categoria_plato = 1;

--  4. ¿Qué porcentaje de asistentes no ha confirmado su asistencia?
SELECT 	'No ha confirmado' AS  confirmacion, 
		((COUNT(*)*100)/(SELECT COUNT(*) FROM parranda_deivis.plato_por_invitado ppi)) AS porcentaje
FROM parranda_deivis.plato_por_invitado ppi WHERE confirmacion = 'N'
GROUP BY confirmacion ;

--  5. ¿Qué asistente tiene la combinación más inusual de preferencia de comida y música?
SELECT * FROM parranda_deivis.invitados i 
INNER JOIN parranda_deivis.genero_musical_por_invitado gmpi ON i.id_invitado = gmpi.id_invitado 
INNER JOIN parranda_deivis.plato_por_invitado ppi ON i.id_invitado = ppi.id_invitado 
INNER JOIN parranda_deivis.genero_musical gm ON gmpi.id_genero_musical = gm.id_genero_musical 
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato; 

--  6. ¿Hay más hombres o mujeres que han confirmado su asistencia a la fiesta?
SELECT 
	CASE WHEN i.id_genero = 1 THEN 'hombres'
		 WHEN i.id_genero = 2 THEN 'mujeres'
	END AS genero_asistentes,
	COUNT(*) AS cantidad_asistentes
FROM parranda_deivis.invitados i 
INNER JOIN parranda_deivis.plato_por_invitado ppi ON i.id_invitado = ppi.id_invitado 
WHERE i.id_genero IN (SELECT id_genero FROM parranda_deivis.genero WHERE id_genero <> 3) AND ppi.confirmacion = 'S'
GROUP BY genero_asistentes;

--  7. ¿Cuál es el nombre del asistente que elige un plato vegano y qué música prefiere?
SELECT 	CONCAT(i.primer_nombre,' ',i.segundo_nombre,' ',i.primer_apellido,' ',i.segundo_apellido) AS nombre_invitado,
		gm.descripcion AS genero_musical 
FROM parranda_deivis.invitados i 
INNER JOIN parranda_deivis.plato_por_invitado ppi ON i.id_invitado = ppi.id_invitado 
INNER JOIN parranda_deivis.genero_musical_por_invitado gmpi ON i.id_invitado = gmpi.id_invitado
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato 
INNER JOIN parranda_deivis.genero_musical gm ON gmpi.id_genero_musical = gm.id_genero_musical 
WHERE p.id_categoria_plato = (SELECT id_categoria_plato FROM parranda_deivis.categoria_plato WHERE descripcion = 'vegano');

--  8. ¿Cuántos asistentes tienen preferencia por la música tropical y qué tipo de comida eligen?
SELECT COUNT(*) AS cantidad
FROM parranda_deivis.genero_musical_por_invitado gmpi 
WHERE gmpi.id_genero_musical = (SELECT id_genero_musical FROM parranda_deivis.genero_musical WHERE descripcion = 'tropical');

SELECT p.nombre_plato FROM parranda_deivis.plato_por_invitado ppi 
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato
INNER JOIN parranda_deivis.categoria_plato cp ON p.id_categoria_plato = cp.id_categoria_plato 
WHERE ppi.id_invitado IN 
	(SELECT id_invitado  
	 FROM parranda_deivis.genero_musical_por_invitado gmpi 
	 WHERE gmpi.id_genero_musical = (SELECT id_genero_musical FROM parranda_deivis.genero_musical WHERE descripcion = 'tropical'));

--  9. ¿Qué platos son elegidos únicamente por mujeres?
SELECT DISTINCT p.nombre_plato FROM parranda_deivis.invitados i 
JOIN parranda_deivis.genero g ON i.id_genero = g.id_genero 
JOIN parranda_deivis.plato_por_invitado ppi ON i.id_invitado = ppi.id_invitado 
JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato 
WHERE i.id_genero = (SELECT id_genero FROM  parranda_deivis.genero WHERE descripcion_genero='mujer');
	
-- 10. ¿Cuál es la preferencia de comida de los asistentes que no han confirmado su asistencia y qué género musical prefieren?
SELECT 	CONCAT(i.primer_nombre,' ',i.segundo_nombre,' ',i.primer_apellido,' ',i.segundo_apellido) AS nombre_invitado,
		cp.descripcion,
		gm.descripcion 
FROM parranda_deivis.plato_por_invitado ppi
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato 
INNER JOIN parranda_deivis.categoria_plato cp ON p.id_categoria_plato = cp.id_categoria_plato 
INNER JOIN parranda_deivis.genero_musical_por_invitado gmpi ON ppi.id_invitado = gmpi.id_invitado
INNER JOIN parranda_deivis.genero_musical gm ON gmpi.id_genero_musical = gm.id_genero_musical 
INNER JOIN parranda_deivis.invitados i ON ppi.id_invitado = i.id_invitado 
WHERE ppi.confirmacion ='N';