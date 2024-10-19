
# Breve analisis de datos para la 'Parranda de Deivis'

Este pequeño ejercicio es tomado de las clases del bootcamp en las cuales se hace la creación de la base de datos y su posterior llenado con información, el script con el cual se crea la base de datos y se hace el ingreso de data se encuentra en el siguiente enlace [Enlace a scripts de la base parranda_deivis](https://github.com/edopore/parranda_deivis-bd)

# Respuestas

##### 1. ¿Cuál es el plato más popular entre los asistentes a la fiesta?

Para resolver esta pregunta realicé la siguiente consulta en la base de datos:

```
SELECT B.nombre_plato,
COUNT(A.id_plato) AS cantidad
FROM parranda_deivis.plato_por_invitado A
INNER JOIN parranda_deivis.plato B ON A.id_plato = B.id_plato
GROUP BY nombre_plato ORDER BY cantidad DESC;
```

El resultado obtenido es el siguiente:
|nombre_plato |cantidad|
|----|--------|
|cazuela de mariscos| 5|
|solomito asado| 5|
|filete de salmon| 4|
|seviche de camaro| 3|
|Lentejas guisadas| 3|
|cerdo apanado en salsas| 3|
|Ensalada de aguacate y mango| 2|
|Sancocho de guineo| 2|
|pollo apanado en salsas| 1|
|Empanadas de yuca| 1|
|Arepas de choclo con queso| 1|
|Frijoles simples| 1|
Con base en el resultado anterior se puede observar que entre los asistentes al evento se tienen a la **cazuela de mariscos** y al **solomito** asado como los más populares entre los invitados.

##### 2. ¿Qué porcentaje de los asistentes es vegetariano, vegano o carnívoro?

Para la solución a esta pregunta se realiza la siguiente consulta:

```
WITH
	UNO AS(
		SELECT *
		FROM parranda_deivis.plato_por_invitado
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
```

Obteniendo los siguientes resultados:
|descripcion |cantidad |porcentaje|
|----|----|----|
|carivoro |9 |29,0322580645|
|vegano |5 |16,1290322581|
|vegetariano |5 |16,1290322581|
Se encuentra que en la base de datos que hay gran parte de invitado carnivoro y existe la misma cantidad de invitados veganos y vegetarianos.

##### 3. ¿Cuántos asistentes prefieren música de salsa?

Para responder esta pregunta hice esta aproximacion:

```
SELECT 	B.descripcion,
		COUNT(A.*) AS cantidad
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.genero_musical B ON A.id_genero_musical = B.id_genero_musical
WHERE B.descripcion = 'salsa'
GROUP BY descripcion;
```

El resultado fue el siguiente:
|descripcion| cantidad|
|----|----|
|salsa| 14|

Se encuentran que entre todos los invitados, a 14 les gusta el genero musical **salsa**

##### 4. ¿Qué género musical es el más mencionado entre los asistentes?

La consulta realizada es la siguiente:

```
SELECT 	B.descripcion,
		COUNT(A.*) AS cantidad
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.genero_musical B ON A.id_genero_musical = B.id_genero_musical
GROUP BY descripcion
ORDER BY cantidad DESC;
```

El resultado obtenido se ven en la tabla contigua:
|descripcion|cantidad|
|----|----|
|reguetón |18|
|tropical |18|
|cumbia |17|
|tango |16|
|bambuco |15|
|merengue |15|
|pop |15|
|vallenato |14|
|salsa |14|
|rock |10|

Según la información obtenida el género que más se escucha es **regueton** con 18 coincidencias

##### 5. ¿Cuántos hombres y mujeres confirmaron su asistencia?

Para averiguar la cantidad de personas hombres y mujeres que confirmaron su asistencia se realiza la siguiente consulta:

```
SELECT 	C.descripcion_genero,
		COUNT(B.id_genero) AS cantidad_invitados_confirmados
FROM parranda_deivis.plato_por_invitado A
INNER JOIN parranda_deivis.invitados B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.genero C ON B.id_genero = C.id_genero
WHERE confirmacion = 'S' AND C.id_genero <> 3
GROUP BY C.descripcion_genero;
```

Segun la información alojada en la base de datos, el resultado es el siguiente:
|descripcion_genero| cantidad_invitados_confirmados|
|----|----|
|mujer |8|
|hombre| 3|

De la cantidad total de invitados, solo 8 **hombres** y 3 **mujeres** han confirmado su participación en el evento.

##### 6. ¿Cuál es la comida preferida de los asistentes que son pescetarianos?

Para saber entre los asistentes pescetarianos cual es la comida preferida, se encuentra la siguiente consulta:

```
SELECT 	B.nombre_plato,
		COUNT(*) AS cantidad
FROM parranda_deivis.plato_por_invitado A
INNER JOIN parranda_deivis.plato B ON A.id_plato = B.id_plato
INNER JOIN parranda_deivis.categoria_plato C ON B.id_categoria_plato = C.id_categoria_plato
WHERE A.confirmacion = 'S' AND C.id_categoria_plato = 1
GROUP BY B.nombre_plato;
```

Por lo cual se encuentra el resultado:
|nombre_plato |cantidad|
|----|----|
|seviche de camaro |2|
|filete de salmon |3|
|cazuela de mariscos |3|
Donde se puede ver que los asistentes prefieren más la **cazuela de mariscos** y el **filete de salmon** sobre el **seviche de camaro**, esperaba que la genté gustara mas del ceviche que del salmón.

##### 7. ¿Qué platos fueron seleccionados por los asistentes veganos?

```
SELECT 	B.nombre_plato,
		COUNT(*) AS cantidad
FROM parranda_deivis.plato_por_invitado A
INNER JOIN parranda_deivis.plato B ON A.id_plato = B.id_plato
INNER JOIN parranda_deivis.categoria_plato C ON B.id_categoria_plato = C.id_categoria_plato
WHERE C.id_categoria_plato = 4
GROUP BY B.nombre_plato;
```

| nombre_plato      | cantidad |
| ----------------- | -------- |
| Lentejas guisadas | 3        |
| Empanadas de yuca | 1        |
| Frijoles simples  | 1        |

Como puede notarse la poblacion vegana de la fiesta escoge **lentejas guisadas**, **Empanadas de yuca** y **Frijoles simples** como sus platos elegidos para la fiesta.

##### 8. ¿Cuántos asistentes confirmaron su asistencia?

Con el fin de medir el hype acerca de la fiesta y mirar si hay quorum para el foforro, se decide consultar la base de datos de la siguiente manera:

```
SELECT 	CASE
			WHEN confirmacion = 'N' THEN 'No han confirmado'
			WHEN confirmacion = 'S' THEN 'Si han confirmado'
		END AS confirmacion,
		COUNT(*) AS cantidad_confirmaron
FROM parranda_deivis.plato_por_invitado
GROUP BY confirmacion;
```

| confirmacion      | cantidad_confirmaron |
| ----------------- | -------------------- |
| No han confirmado | 14                   |
| Si han confirmado | 17                   |

Se podría decir que un poco más de la mitad de los invitados ya ha confirmado su participación, por lo menos la gente ya se está poniendo a tono para la fiesta.

##### 9. ¿Qué género musical prefieren los hombres en comparación con las mujeres?

En esta batalla de los sexos y sus gustos musicales realizamos una consulta de la siguiente forma:
**Para los hombres**

```
SELECT 	C.descripcion,
		COUNT(*) AS cantidad
FROM parranda_deivis.invitados A
INNER JOIN parranda_deivis.genero_musical_por_invitado B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.genero_musical C ON B.id_genero_musical = C.id_genero_musical
WHERE A.id_genero = 1
GROUP BY C.descripcion
ORDER BY cantidad DESC;
```

| descripcion | cantidad |
| ----------- | -------- |
| rock        | 6        |
| tropical    | 5        |
| tango       | 5        |
| vallenato   | 5        |
| merengue    | 5        |
| reguetón    | 4        |
| bambuco     | 4        |
| cumbia      | 4        |
| pop         | 4        |
| salsa       | 3        |

**Para las mujeres**

```
SELECT 	C.descripcion,
		COUNT(*) AS cantidad
FROM parranda_deivis.invitados A
INNER JOIN parranda_deivis.genero_musical_por_invitado B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.genero_musical C ON B.id_genero_musical = C.id_genero_musical
WHERE A.id_genero = 2
GROUP BY C.descripcion
ORDER BY cantidad DESC;
```

| descripcion | cantidad |
| ----------- | -------- |
| cumbia      | 7        |
| reguetón    | 7        |
| tropical    | 6        |
| bambuco     | 6        |
| salsa       | 5        |
| pop         | 5        |
| tango       | 5        |
| merengue    | 5        |
| vallenato   | 5        |
| rock        | 4        |

Puede notarse que los hombres prefieren la música **rock** por lo que el tipo de ambiente es más de parchar y hablar entre ellos, mientras que para las mujeres el género predominante es la **cumbia** y el **regueton** por lo que para ellas es mejor plan bailar y recochar que parcharse por ahi, por lo que lo que les gusta a ellos a ellas no.

##### 10. ¿Qué platos son elegidos por los asistentes que prefieren la cumbia?

La consulta que se realizó fue la siguiente:

```
SELECT C.nombre_plato
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.plato_por_invitado B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.plato C ON B.id_plato = C.id_plato
WHERE id_genero_musical = 3;
```

| nombre_plato                 |
| ---------------------------- |
| cazuela de mariscos          |
| filete de salmon             |
| seviche de camaro            |
| Arepas de choclo con queso   |
| Sancocho de guineo           |
| Ensalada de aguacate y mango |
| cerdo apanado en salsas      |
| solomito asado               |
| pollo apanado en salsas      |
| Frijoles simples             |
| cazuela de mariscos          |
| Sancocho de guineo           |
| Ensalada de aguacate y mango |
| cerdo apanado en salsas      |
| solomito asado               |
| cazuela de mariscos          |
| solomito asado               |

Como puede notarse, hay platos variados para aquellas personas que les gusta la cumbia, son buenas palas y comen de todo sin importar si el plato es carnivoro, pescetariano, vegano o vegetariano.

##### 11. ¿Cuál es la diferencia en preferencias musicales entre los que eligieron comida carnívora y pescetariana?

Para entender que diferencias existen entre los gustos musicales de los invitados carnivoros y los invitados pescetarianos se resuelve elaborar dos consultas:

**Para Pescetarianos**

```
SELECT D.descripcion, COUNT(*) AS cantidad
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.plato_por_invitado B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.plato C ON B.id_plato = C.id_plato
INNER JOIN parranda_deivis.genero_musical D ON A.id_genero_musical = D.id_genero_musical
WHERE C.id_categoria_plato = 1
GROUP BY D.descripcion
ORDER BY cantidad DESC;
```

**Para Carnivoros**

```
SELECT D.descripcion, COUNT(*) AS cantidad
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.plato_por_invitado B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.plato C ON B.id_plato = C.id_plato
INNER JOIN parranda_deivis.genero_musical D ON A.id_genero_musical = D.id_genero_musical
WHERE C.id_categoria_plato = 3
GROUP BY D.descripcion
ORDER BY cantidad DESC;
```

| Pescetarianos |          | Carnivoros  |          |
| ------------- | -------- | ----------- | -------- |
| descripcion   | cantidad | descripcion | cantidad |
| tango         | 7        | cumbia      | 6        |
| reguetón      | 7        | pop         | 5        |
| tropical      | 6        | tropical    | 5        |
| vallenato     | 6        | bambuco     | 5        |
| bambuco       | 6        | salsa       | 5        |
| pop           | 5        | merengue    | 4        |
| cumbia        | 5        | vallenato   | 4        |
| rock          | 5        | reguetón    | 3        |
| salsa         | 4        | rock        | 3        |
| merengue      | 4        | tango       | 3        |

Se puede observar que el genero que más gusta para los pescetarianos es el genero musical que meno gusta entre los carnivoros como en el caso del tango y regueton, sin embargo hay generos como el tropical que tiene buena cantidad de aceptación entre los dos tipos de invitados según sus preferencias alimenticias.

##### 12. ¿Qué porcentaje de los asistentes prefiere música tropical?

Para entender el porcentaje de asistentes que prefieren musica tropical se elaboró la siguiente consulta:

```
SELECT 	'tropical' AS genero_musical ,
		(COUNT(*)*100)/(SELECT COUNT(*) FROM parranda_deivis.genero_musical_por_invitado) AS porcentaje
FROM parranda_deivis.genero_musical_por_invitado gmpi WHERE id_genero_musical = 6
GROUP BY id_genero_musical ;
```

| genero_musical | porcentaje    |
| -------------- | ------------- |
| tropical       | 11,8421052632 |

Podemos observar que el 11,84% de los asistentes sienten afinidad con el genero _tropical_ para amenizar la fiesta.

##### 13. ¿Cuántos asistentes eligieron cazuela de mariscos como su plato?

Buscando la cantidad de asistentes que eligen la cazuela de mariscos como su plato preferido se realiza la siguiente consulta:

```
SELECT 	'cazuela de mariscos' AS nombre_plato,
		COUNT(*) AS cantidad
FROM parranda_deivis.plato_por_invitado ppi
WHERE id_plato = 1;
```

| nombre_plato        | count_star() |
| ------------------- | ------------ |
| cazuela de mariscos | 5            |

Según el resultado obtenido, solo **5** de los asistentes quieren cazuela de mariscos para comer en la parranda.

##### 14. ¿Hay alguna relación entre el género de los asistentes y sus preferencias de comida?

No es muy relacionado el gusto musical con respecto al plato preferido, sin embargo los gustos musicales varian con respecto al tipo de alimentos que consumen los invitados, un ejemplo claro está en la respuesta 11, en la cual se observa que la gente pescetariana tiene afinidad por generos tranquilos como tango o más bailables como regueton, por otro lado los carnivoros prefieren generos mas bailables como la cumbia, transversalmente se puede notar que generos como el tropical podría ser un genero en comun aceptado por la mayoria de los asistentes a la fiesta.

##### 15. ¿Qué asistente tiene la preferencia musical más diversa y cuáles son esos géneros?

Para determinar la persona con preferencia musical más diversa y sus generos musicales predilectos se separó en dos consultas, siento la primera que nos ayuda a averiguar quien es aquel invitado con gustos más variados de la parranda.

```
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
```

Se encuentran los siguientes resultados:

| nombre_invitado           | id_invitado | descripcion |
| ------------------------- | ----------- | ----------- |
| Sofía Dora Méndez Gaviria | 28          | vallenato   |
| Sofía Dora Méndez Gaviria | 28          | tango       |
| Sofía Dora Méndez Gaviria | 28          | cumbia      |
| Sofía Dora Méndez Gaviria | 28          | reguetón    |
| Sofía Dora Méndez Gaviria | 28          | bambuco     |
| Sofía Dora Méndez Gaviria | 28          | tropical    |
| Sofía Dora Méndez Gaviria | 28          | merengue    |
| Sofía Dora Méndez Gaviria | 28          | pop         |
| Sofía Dora Méndez Gaviria | 28          | salsa       |
| Sofía Dora Méndez Gaviria | 28          | rock        |

Como se puede notar Sofia Mendez con el id de invitado número 28 es la que más gustos musicales diversos tiene con un total de 10 Sofía es muy crossover para la parranda, que buena invitada.

##### 16. ¿Cuántos asistentes que confirmaron su asistencia prefieren un plato vegano?

```
SELECT COUNT(*) AS cantidad_asistentes
FROM parranda_deivis.plato_por_invitado A
JOIN parranda_deivis.plato B ON A.id_plato = B.id_plato
WHERE A.confirmacion = 'S' AND B.id_categoria_plato = (SELECT id_categoria_plato FROM parranda_deivis.categoria_plato WHERE descripcion='vegano');

```

|cantidad_asistentes|
|--
|2|
Solo se encontraron dos asistentes que confirmaron su asistencia al evento y son de preferencia vegana.

##### 17. ¿Qué tipo de comida prefieren los asistentes que disfrutan de música de reguetón?

Para conseguir esta información se realiza la siguiente consulta:

```
SELECT D.descripcion, COUNT(*) AS cantidad
FROM parranda_deivis.genero_musical_por_invitado A
INNER JOIN parranda_deivis.plato_por_invitado B ON A.id_invitado = B.id_invitado
INNER JOIN parranda_deivis.plato C ON B.id_plato = C.id_plato
INNER JOIN parranda_deivis.categoria_plato D ON C.id_categoria_plato = D.id_categoria_plato
WHERE id_genero_musical = 4
GROUP BY D.descripcion
ORDER BY cantidad DESC;
```

| descripcion  | cantidad |
| ------------ | -------- |
| pescetariano | 7        |
| vegano       | 4        |
| vegetariano  | 4        |
| carivoro     | 3        |

Con base en los resultados se encuentra que los asistentes pescetarianos son los que más disfrutan el genero musical regueton con 7 apariciones, el perreo hasta abajo, los pescetarianos arriba!!!

##### 18. ¿Hay algún asistente que haya confirmado asistencia, pero no haya elegido un plato?

Se realiza la busqueda de invitados que hayan confirmado pero que no hayan realizado elección de plato

```
SELECT *
FROM parranda_deivis.plato_por_invitado
WHERE confirmacion = 'S' AND id_plato IS NULL;
```

El resultado obtenido fue vacío, por lo que para fortuna de Deivis todos los invitados ya escogieron un plato de su preferencia y no tiene que andar preguntando quien falta por confirmar su comida :)

##### 19. ¿Qué género musical prefieren los asistentes que eligen ensaladas?

Para saber que les gusta oir a los invitados que comen ensaladas se realiza la siguiente consulta:

```
SELECT gm.descripcion
FROM parranda_deivis.genero_musical_por_invitado gmpi
INNER JOIN parranda_deivis.plato_por_invitado ppi ON gmpi.id_invitado = ppi.id_invitado
INNER JOIN parranda_deivis.genero_musical gm ON gmpi.id_genero_musical = gm.id_genero_musical
WHERE ppi.id_plato = (SELECT id_plato FROM parranda_deivis.plato p WHERE nombre_plato LIKE 'Ensalada%');
```

El resultado obtenido es el siguiente:
|descripcion|
|--
|vallenato
|tango
|cumbia
|reguetón
|tropical
|merengue
|pop
|salsa
|cumbia
Se puede observar que la gente que come ensalada le gusta el baile y la milonga, son gente muy alegre!!!

##### 20. ¿Cuántos asistentes tienen como plato favorito algún tipo de pescado o marisco?

Para mirar la cantidad de asistentes que tiene como plato favorito algun tipo de pescado o marisco se realiza la siguiente consulta. cabe aclarar que la gente pescetariana tiene el id de categoria de plato numero **1**.

```
SELECT COUNT(*) AS cantidad_asistentes
FROM parranda_deivis.plato_por_invitado ppi
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato
WHERE id_categoria_plato = 1;
```

| cantidad_asistentes |
| ------------------- |
| 12                  |

Se encontró que hubo un total de **12** personas que pidieron pescados o mariscos.

#### OPCIONALES

A continuación se desarrollan unas preguntas opcionales y su posible solución.

##### 21. ¿Qué plato eligió el asistente con la identificación más alta?

```
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

```

| id_invitado | nombre_invitado                   | identificacion_invitado | nombre_plato       |
| ----------- | --------------------------------- | ----------------------- | ------------------ |
| 19          | Armando Antonio Hurtado Hernández | 18006581340             | Sancocho de guineo |

##### 22. ¿Cuál es el nombre del asistente que prefiere música vallenata y qué tipo de comida consume?

```
SELECT 	CONCAT(i.primer_nombre,' ',i.segundo_nombre,' ',i.primer_apellido,' ',i.segundo_apellido) AS nombre_invitado,
		cp.descripcion
FROM parranda_deivis.plato_por_invitado ppi
INNER JOIN parranda_deivis.invitados i ON ppi.id_invitado = i.id_invitado
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato
INNER JOIN parranda_deivis.categoria_plato cp ON p.id_categoria_plato = cp.id_categoria_plato
WHERE ppi.id_invitado IN (SELECT id_invitado FROM parranda_deivis.genero_musical_por_invitado gmpi WHERE id_genero_musical = 1);
```

| nombre_invitado                   | descripcion  |
| --------------------------------- | ------------ |
| Juan Espinosa González            | pescetariano |
| Orlando Ignacio Arévalo Pinzón    | pescetariano |
| Andrés Carlos Cuéllar Lara        | vegetariano  |
| Samuel Omar Benavides             | carivoro     |
| Adriana Agudelo                   | pescetariano |
| Edinson Ramírez                   | carivoro     |
| Milena Ojeda                      | vegano       |
| Liliana Jimena Gutiérrez Zambrano | carivoro     |
| Juan Vargas Betancur              | vegano       |
| Yolanda Rocío Palacios            | pescetariano |
| Sofía Dora Méndez Gaviria         | vegano       |
| Edgar González                    | pescetariano |
| Jhon Alexander Durán García       | pescetariano |

##### 23. ¿Cuántos asistentes son pescetarianos y prefieren música de tango?

```
SELECT COUNT(*) AS cantidad
FROM parranda_deivis.plato_por_invitado ppi
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato
INNER JOIN parranda_deivis.genero_musical_por_invitado gmpi ON ppi.id_invitado = gmpi.id_invitado
INNER JOIN parranda_deivis.genero_musical gm ON gmpi.id_genero_musical = gm.id_genero_musical
WHERE gm.id_genero_musical = 2 and p.id_categoria_plato = 1;
```

| cantidad |
| -------- |
| 7        |

##### 24. ¿Qué porcentaje de asistentes no ha confirmado su asistencia?

```
SELECT 	'No ha confirmado' AS  confirmacion,
		((COUNT(*)*100)/(SELECT COUNT(*) FROM parranda_deivis.plato_por_invitado ppi)) AS porcentaje
FROM parranda_deivis.plato_por_invitado ppi WHERE confirmacion = 'N'
GROUP BY confirmacion ;
```

| confirmacion     | porcentaje    |
| ---------------- | ------------- |
| No ha confirmado | 45,1612903226 |

##### 25. ¿Qué asistente tiene la combinación más inusual de preferencia de comida y música?

```
SELECT 	i.id_invitado,
		CONCAT(i.primer_nombre,' ',i.segundo_nombre,' ',i.primer_apellido,' ',i.segundo_apellido) AS nombre_invitado,
		gm.descripcion,
		p.nombre_plato
FROM parranda_deivis.invitados i
INNER JOIN parranda_deivis.genero_musical_por_invitado gmpi ON i.id_invitado = gmpi.id_invitado
INNER JOIN parranda_deivis.plato_por_invitado ppi ON i.id_invitado = ppi.id_invitado
INNER JOIN parranda_deivis.genero_musical gm ON gmpi.id_genero_musical = gm.id_genero_musical
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato;
```

Revisando la tabla se encuentra que se encuentran combinaciones de gustos musicales como tango y plato preferido cazula de camarones, o regueton con arepa de choclo.
| id_invitado | primer_nombre | segundo_nombre | primer_apellido | segundo_apellido | descripcion | nombre_plato |
|-------------|---------------|----------------|-----------------|------------------|-------------|------------------------------|
| 1 | Juan | | Espinosa | González | vallenato | cazuela de mariscos |
| 1 | Juan | | Espinosa | González | tango | cazuela de mariscos |
| 2 | José | Luis | Martínez | | cumbia | Arepas de choclo con queso |
| 2 | José | Luis | Martínez | | reguetón | Arepas de choclo con queso |
| 3 | Orlando | Ignacio | Arévalo | Pinzón | bambuco | filete de salmon |
| 3 | Orlando | Ignacio | Arévalo | Pinzón | tropical | filete de salmon |
| 3 | Orlando | Ignacio | Arévalo | Pinzón | merengue | filete de salmon |
| 3 | Orlando | Ignacio | Arévalo | Pinzón | pop | filete de salmon |
| 3 | Orlando | Ignacio | Arévalo | Pinzón | vallenato | filete de salmon |
| 3 | Orlando | Ignacio | Arévalo | Pinzón | salsa | filete de salmon |
| 3 | Orlando | Ignacio | Arévalo | Pinzón | tango | filete de salmon |
| 3 | Orlando | Ignacio | Arévalo | Pinzón | reguetón | filete de salmon |
| 4 | Andrés | Carlos | Cuéllar | Lara | vallenato | Ensalada de aguacate y mango |
| 4 | Andrés | Carlos | Cuéllar | Lara | cumbia | Ensalada de aguacate y mango |
| 6 | Paulina | Karen | Pineda | | bambuco | Lentejas guisadas |
| 6 | Paulina | Karen | Pineda | | merengue | Lentejas guisadas |
| 6 | Paulina | Karen | Pineda | | reguetón | Lentejas guisadas |
| 7 | Milena | María | Granados | | salsa | Ensalada de aguacate y mango |
| 7 | Milena | María | Granados | | tango | Ensalada de aguacate y mango |
| 7 | Milena | María | Granados | | tropical | Ensalada de aguacate y mango |
| 7 | Milena | María | Granados | | pop | Ensalada de aguacate y mango |
| 7 | Milena | María | Granados | | merengue | Ensalada de aguacate y mango |
| 7 | Milena | María | Granados | | cumbia | Ensalada de aguacate y mango |
| 7 | Milena | María | Granados | | reguetón | Ensalada de aguacate y mango |
| 8 | Nelly | Yolanda | Zapata | Sandoval | rock | cazuela de mariscos |
| 8 | Nelly | Yolanda | Zapata | Sandoval | cumbia | cazuela de mariscos |
| 8 | Nelly | Yolanda | Zapata | Sandoval | salsa | cazuela de mariscos |
| 9 | Josué | | Muñoz | | merengue | Lentejas guisadas |
| 9 | Josué | | Muñoz | | pop | Lentejas guisadas |
| 9 | Josué | | Muñoz | | tropical | Lentejas guisadas |
| 9 | Josué | | Muñoz | | salsa | Lentejas guisadas |
| 9 | Josué | | Muñoz | | tango | Lentejas guisadas |
| 9 | Josué | | Muñoz | | rock | Lentejas guisadas |
| 10 | Eder | Vicente | Luna | | reguetón | filete de salmon |
| 10 | Eder | Vicente | Luna | | bambuco | filete de salmon |
| 10 | Eder | Vicente | Luna | | cumbia | filete de salmon |
| 11 | Ángela | García | Gómez | | reguetón | solomito asado |
| 11 | Ángela | García | Gómez | | merengue | solomito asado |
| 11 | Ángela | García | Gómez | | cumbia | solomito asado |
| 11 | Ángela | García | Gómez | | rock | solomito asado |
| 11 | Ángela | García | Gómez | | bambuco | solomito asado |
| 12 | Santiago | Sánchez | Arango | | tropical | solomito asado |
| 12 | Santiago | Sánchez | Arango | | tango | solomito asado |
| 12 | Santiago | Sánchez | Arango | | pop | solomito asado |
| 12 | Santiago | Sánchez | Arango | | salsa | solomito asado |
| 14 | Samuel | Omar | Benavides | | salsa | solomito asado |
| 14 | Samuel | Omar | Benavides | | rock | solomito asado |
| 14 | Samuel | Omar | Benavides | | cumbia | solomito asado |
| 14 | Samuel | Omar | Benavides | | bambuco | solomito asado |
| 14 | Samuel | Omar | Benavides | | pop | solomito asado |
| 14 | Samuel | Omar | Benavides | | tango | solomito asado |
| 14 | Samuel | Omar | Benavides | | vallenato | solomito asado |
| 14 | Samuel | Omar | Benavides | | tropical | solomito asado |
| 15 | Fernanda | | Hernández | | salsa | cerdo apanado en salsas |
| 15 | Fernanda | | Hernández | | reguetón | cerdo apanado en salsas |
| 15 | Fernanda | | Hernández | | cumbia | cerdo apanado en salsas |
| 15 | Fernanda | | Hernández | | merengue | cerdo apanado en salsas |
| 15 | Fernanda | | Hernández | | tropical | cerdo apanado en salsas |
| 16 | Adriana | | Agudelo | | vallenato | filete de salmon |
| 16 | Adriana | | Agudelo | | tango | filete de salmon |
| 16 | Adriana | | Agudelo | | bambuco | filete de salmon |
| 16 | Adriana | | Agudelo | | pop | filete de salmon |
| 17 | Liliana | Leonor | Pineda | Hernández | pop | seviche de camaro |
| 17 | Liliana | Leonor | Pineda | Hernández | reguetón | seviche de camaro |
| 17 | Liliana | Leonor | Pineda | Hernández | rock | seviche de camaro |
| 17 | Liliana | Leonor | Pineda | Hernández | tango | seviche de camaro |
| 18 | Edinson | | Ramírez | | cumbia | solomito asado |
| 18 | Edinson | | Ramírez | | tropical | solomito asado |
| 18 | Edinson | | Ramírez | | pop | solomito asado |
| 18 | Edinson | | Ramírez | | vallenato | solomito asado |
| 18 | Edinson | | Ramírez | | bambuco | solomito asado |
| 18 | Edinson | | Ramírez | | rock | solomito asado |
| 18 | Edinson | | Ramírez | | salsa | solomito asado |
| 18 | Edinson | | Ramírez | | merengue | solomito asado |
| 19 | Armando | Antonio | Hurtado | Hernández | tango | Sancocho de guineo |
| 19 | Armando | Antonio | Hurtado | Hernández | cumbia | Sancocho de guineo |
| 19 | Armando | Antonio | Hurtado | Hernández | reguetón | Sancocho de guineo |
| 19 | Armando | Antonio | Hurtado | Hernández | tropical | Sancocho de guineo |
| 20 | Milena | | Ojeda | | reguetón | Lentejas guisadas |
| 20 | Milena | | Ojeda | | tango | Lentejas guisadas |
| 20 | Milena | | Ojeda | | merengue | Lentejas guisadas |
| 20 | Milena | | Ojeda | | pop | Lentejas guisadas |
| 20 | Milena | | Ojeda | | vallenato | Lentejas guisadas |
| 20 | Milena | | Ojeda | | bambuco | Lentejas guisadas |
| 20 | Milena | | Ojeda | | tropical | Lentejas guisadas |
| 21 | Fernando | Alberto | Sanabria | | tropical | cazuela de mariscos |
| 21 | Fernando | Alberto | Sanabria | | bambuco | cazuela de mariscos |
| 21 | Fernando | Alberto | Sanabria | | merengue | cazuela de mariscos |
| 21 | Fernando | Alberto | Sanabria | | cumbia | cazuela de mariscos |
| 21 | Fernando | Alberto | Sanabria | | rock | cazuela de mariscos |
| 23 | Liliana | Jimena | Gutiérrez | Zambrano | reguetón | pollo apanado en salsas |
| 23 | Liliana | Jimena | Gutiérrez | Zambrano | salsa | pollo apanado en salsas |
| 23 | Liliana | Jimena | Gutiérrez | Zambrano | vallenato | pollo apanado en salsas |
| 23 | Liliana | Jimena | Gutiérrez | Zambrano | tango | pollo apanado en salsas |
| 23 | Liliana | Jimena | Gutiérrez | Zambrano | cumbia | pollo apanado en salsas |
| 23 | Liliana | Jimena | Gutiérrez | Zambrano | pop | pollo apanado en salsas |
| 23 | Liliana | Jimena | Gutiérrez | Zambrano | tropical | pollo apanado en salsas |
| 23 | Liliana | Jimena | Gutiérrez | Zambrano | bambuco | pollo apanado en salsas |
| 23 | Liliana | Jimena | Gutiérrez | Zambrano | merengue | pollo apanado en salsas |
| 24 | Juan | | Vargas | Betancur | merengue | Empanadas de yuca |
| 24 | Juan | | Vargas | Betancur | vallenato | Empanadas de yuca |
| 24 | Juan | | Vargas | Betancur | tropical | Empanadas de yuca |
| 24 | Juan | | Vargas | Betancur | pop | Empanadas de yuca |
| 24 | Juan | | Vargas | Betancur | salsa | Empanadas de yuca |
| 24 | Juan | | Vargas | Betancur | reguetón | Empanadas de yuca |
| 24 | Juan | | Vargas | Betancur | bambuco | Empanadas de yuca |
| 25 | Estela | Amparo | Rivera | Vega | cumbia | seviche de camaro |
| 25 | Estela | Amparo | Rivera | Vega | pop | seviche de camaro |
| 25 | Estela | Amparo | Rivera | Vega | tango | seviche de camaro |
| 25 | Estela | Amparo | Rivera | Vega | bambuco | seviche de camaro |
| 25 | Estela | Amparo | Rivera | Vega | reguetón | seviche de camaro |
| 25 | Estela | Amparo | Rivera | Vega | tropical | seviche de camaro |
| 25 | Estela | Amparo | Rivera | Vega | salsa | seviche de camaro |
| 26 | Yolanda | Rocío | Palacios | | tropical | seviche de camaro |
| 26 | Yolanda | Rocío | Palacios | | reguetón | seviche de camaro |
| 26 | Yolanda | Rocío | Palacios | | merengue | seviche de camaro |
| 26 | Yolanda | Rocío | Palacios | | vallenato | seviche de camaro |
| 27 | Gildardo | Víctor | Ramírez | | reguetón | Sancocho de guineo |
| 27 | Gildardo | Víctor | Ramírez | | cumbia | Sancocho de guineo |
| 27 | Gildardo | Víctor | Ramírez | | salsa | Sancocho de guineo |
| 27 | Gildardo | Víctor | Ramírez | | tango | Sancocho de guineo |
| 27 | Gildardo | Víctor | Ramírez | | merengue | Sancocho de guineo |
| 27 | Gildardo | Víctor | Ramírez | | tropical | Sancocho de guineo |
| 28 | Sofía | Dora | Méndez | Gaviria | vallenato | Frijoles simples |
| 28 | Sofía | Dora | Méndez | Gaviria | pop | Frijoles simples |
| 28 | Sofía | Dora | Méndez | Gaviria | rock | Frijoles simples |
| 28 | Sofía | Dora | Méndez | Gaviria | tango | Frijoles simples |
| 28 | Sofía | Dora | Méndez | Gaviria | merengue | Frijoles simples |
| 28 | Sofía | Dora | Méndez | Gaviria | cumbia | Frijoles simples |
| 28 | Sofía | Dora | Méndez | Gaviria | bambuco | Frijoles simples |
| 28 | Sofía | Dora | Méndez | Gaviria | reguetón | Frijoles simples |
| 28 | Sofía | Dora | Méndez | Gaviria | tropical | Frijoles simples |
| 28 | Sofía | Dora | Méndez | Gaviria | salsa | Frijoles simples |
| 29 | Edgar | | González | | rock | cazuela de mariscos |
| 29 | Edgar | | González | | tropical | cazuela de mariscos |
| 29 | Edgar | | González | | merengue | cazuela de mariscos |
| 29 | Edgar | | González | | vallenato | cazuela de mariscos |
| 29 | Edgar | | González | | tango | cazuela de mariscos |
| 29 | Edgar | | González | | reguetón | cazuela de mariscos |
| 29 | Edgar | | González | | cumbia | cazuela de mariscos |
| 29 | Edgar | | González | | bambuco | cazuela de mariscos |
| 30 | Jhon | Alexander | Durán | García | reguetón | cazuela de mariscos |
| 30 | Jhon | Alexander | Durán | García | rock | cazuela de mariscos |
| 30 | Jhon | Alexander | Durán | García | tropical | cazuela de mariscos |
| 30 | Jhon | Alexander | Durán | García | pop | cazuela de mariscos |
| 30 | Jhon | Alexander | Durán | García | vallenato | cazuela de mariscos |
| 30 | Jhon | Alexander | Durán | García | salsa | cazuela de mariscos |
| 30 | Jhon | Alexander | Durán | García | tango | cazuela de mariscos |

##### 26. ¿Hay más hombres o mujeres que han confirmado su asistencia a la fiesta?

```
SELECT
	CASE WHEN i.id_genero = 1 THEN 'hombres'
		 WHEN i.id_genero = 2 THEN 'mujeres'
	END AS genero_asistentes,
	COUNT(*) AS cantidad_asistentes
FROM parranda_deivis.invitados i
INNER JOIN parranda_deivis.plato_por_invitado ppi ON i.id_invitado = ppi.id_invitado
WHERE i.id_genero IN (SELECT id_genero FROM parranda_deivis.genero WHERE id_genero <> 3) AND ppi.confirmacion = 'S'
GROUP BY genero_asistentes;
```

| genero_asistentes | cantidad_asistentes |
| ----------------- | ------------------- |
| hombres           | 3                   |
| mujeres           | 8                   |

##### 27. ¿Cuál es el nombre del asistente que elige un plato vegano y qué música prefiere?

```
SELECT 	CONCAT(i.primer_nombre,' ',i.segundo_nombre,' ',i.primer_apellido,' ',i.segundo_apellido) AS nombre_invitado,
		gm.descripcion AS genero_musical
FROM parranda_deivis.invitados i
INNER JOIN parranda_deivis.plato_por_invitado ppi ON i.id_invitado = ppi.id_invitado
INNER JOIN parranda_deivis.genero_musical_por_invitado gmpi ON i.id_invitado = gmpi.id_invitado
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato
INNER JOIN parranda_deivis.genero_musical gm ON gmpi.id_genero_musical = gm.id_genero_musical
WHERE p.id_categoria_plato = (SELECT id_categoria_plato FROM parranda_deivis.categoria_plato WHERE descripcion = 'vegano');
```

| nombre_invitado           | genero_musical |
| ------------------------- | -------------- |
| Paulina Karen Pineda      | bambuco        |
| Paulina Karen Pineda      | merengue       |
| Paulina Karen Pineda      | reguetón       |
| Josué Muñoz               | merengue       |
| Josué Muñoz               | pop            |
| Josué Muñoz               | tropical       |
| Josué Muñoz               | salsa          |
| Josué Muñoz               | tango          |
| Josué Muñoz               | rock           |
| Milena Ojeda              | reguetón       |
| Milena Ojeda              | tango          |
| Milena Ojeda              | merengue       |
| Milena Ojeda              | pop            |
| Milena Ojeda              | vallenato      |
| Milena Ojeda              | bambuco        |
| Milena Ojeda              | tropical       |
| Juan Vargas Betancur      | merengue       |
| Juan Vargas Betancur      | vallenato      |
| Juan Vargas Betancur      | tropical       |
| Juan Vargas Betancur      | pop            |
| Juan Vargas Betancur      | salsa          |
| Juan Vargas Betancur      | reguetón       |
| Juan Vargas Betancur      | bambuco        |
| Sofía Dora Méndez Gaviria | vallenato      |
| Sofía Dora Méndez Gaviria | pop            |
| Sofía Dora Méndez Gaviria | rock           |
| Sofía Dora Méndez Gaviria | tango          |
| Sofía Dora Méndez Gaviria | merengue       |
| Sofía Dora Méndez Gaviria | cumbia         |
| Sofía Dora Méndez Gaviria | bambuco        |
| Sofía Dora Méndez Gaviria | reguetón       |
| Sofía Dora Méndez Gaviria | tropical       |
| Sofía Dora Méndez Gaviria | salsa          |

##### 28. ¿Cuántos asistentes tienen preferencia por la música tropical y qué tipo de comida eligen?

```
SELECT COUNT(*) AS cantidad
FROM parranda_deivis.genero_musical_por_invitado gmpi
WHERE gmpi.id_genero_musical = (SELECT id_genero_musical FROM parranda_deivis.genero_musical WHERE descripcion = 'tropical');
```

| cantidad |
| -------- |
| 18       |

```
SELECT p.nombre_plato FROM parranda_deivis.plato_por_invitado ppi
INNER JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato
INNER JOIN parranda_deivis.categoria_plato cp ON p.id_categoria_plato = cp.id_categoria_plato
WHERE ppi.id_invitado IN
(SELECT id_invitado
FROM parranda_deivis.genero_musical_por_invitado gmpi
WHERE gmpi.id_genero_musical = (SELECT id_genero_musical FROM parranda_deivis.genero_musical WHERE descripcion = 'tropical'));
```

| nombre_plato                 |
| ---------------------------- |
| cazuela de mariscos          |
| filete de salmon             |
| seviche de camaro            |
| Sancocho de guineo           |
| Ensalada de aguacate y mango |
| cerdo apanado en salsas      |
| solomito asado               |
| pollo apanado en salsas      |
| Lentejas guisadas            |
| Empanadas de yuca            |
| Frijoles simples             |
| cazuela de mariscos          |
| seviche de camaro            |
| Sancocho de guineo           |
| solomito asado               |
| Lentejas guisadas            |
| cazuela de mariscos          |
| solomito asado               |

##### 29. ¿Qué platos son elegidos únicamente por mujeres?

```
SELECT DISTINCT p.nombre_plato
FROM parranda_deivis.invitados i
JOIN parranda_deivis.genero g ON i.id_genero = g.id_genero
JOIN parranda_deivis.plato_por_invitado ppi ON i.id_invitado = ppi.id_invitado
JOIN parranda_deivis.plato p ON ppi.id_plato = p.id_plato
WHERE i.id_genero = (SELECT id_genero FROM  parranda_deivis.genero WHERE descripcion_genero='mujer');
```

| nombre_plato               |
| -------------------------- |
| Sancocho de guineo         |
| Lentejas guisadas          |
| solomito asado             |
| cazuela de mariscos        |
| filete de salmon           |
| Arepas de choclo con queso |
| Frijoles simples           |
| cerdo apanado en salsas    |
| Empanadas de yuca          |

##### 30. ¿Cuál es la preferencia de comida de los asistentes que no han confirmado su asistencia y qué género musical prefieren?

```
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
```

| nombre_invitado                   | descripcion  | descripcion |
| --------------------------------- | ------------ | ----------- |
| Juan Espinosa González            | pescetariano | vallenato   |
| Juan Espinosa González            | pescetariano | tango       |
| José Luis Martínez                | vegetariano  | cumbia      |
| José Luis Martínez                | vegetariano  | reguetón    |
| Andrés Carlos Cuéllar Lara        | vegetariano  | vallenato   |
| Andrés Carlos Cuéllar Lara        | vegetariano  | cumbia      |
| Paulina Karen Pineda              | vegano       | bambuco     |
| Paulina Karen Pineda              | vegano       | merengue    |
| Paulina Karen Pineda              | vegano       | reguetón    |
| Josué Muñoz                       | vegano       | merengue    |
| Josué Muñoz                       | vegano       | pop         |
| Josué Muñoz                       | vegano       | tropical    |
| Josué Muñoz                       | vegano       | salsa       |
| Josué Muñoz                       | vegano       | tango       |
| Josué Muñoz                       | vegano       | rock        |
| Eder Vicente Luna                 | pescetariano | reguetón    |
| Eder Vicente Luna                 | pescetariano | bambuco     |
| Eder Vicente Luna                 | pescetariano | cumbia      |
| Ángela García Gómez               | carivoro     | reguetón    |
| Ángela García Gómez               | carivoro     | merengue    |
| Ángela García Gómez               | carivoro     | cumbia      |
| Ángela García Gómez               | carivoro     | rock        |
| Ángela García Gómez               | carivoro     | bambuco     |
| Santiago Sánchez Arango           | carivoro     | tropical    |
| Santiago Sánchez Arango           | carivoro     | tango       |
| Santiago Sánchez Arango           | carivoro     | pop         |
| Santiago Sánchez Arango           | carivoro     | salsa       |
| Liliana Leonor Pineda Hernández   | pescetariano | pop         |
| Liliana Leonor Pineda Hernández   | pescetariano | reguetón    |
| Liliana Leonor Pineda Hernández   | pescetariano | rock        |
| Liliana Leonor Pineda Hernández   | pescetariano | tango       |
| Armando Antonio Hurtado Hernández | vegetariano  | tango       |
| Armando Antonio Hurtado Hernández | vegetariano  | cumbia      |
| Armando Antonio Hurtado Hernández | vegetariano  | reguetón    |
| Armando Antonio Hurtado Hernández | vegetariano  | tropical    |
| Milena Ojeda                      | vegano       | reguetón    |
| Milena Ojeda                      | vegano       | tango       |
| Milena Ojeda                      | vegano       | merengue    |
| Milena Ojeda                      | vegano       | pop         |
| Milena Ojeda                      | vegano       | vallenato   |
| Milena Ojeda                      | vegano       | bambuco     |
| Milena Ojeda                      | vegano       | tropical    |
| Fernando Alberto Sanabria         | pescetariano | tropical    |
| Fernando Alberto Sanabria         | pescetariano | bambuco     |
| Fernando Alberto Sanabria         | pescetariano | merengue    |
| Fernando Alberto Sanabria         | pescetariano | cumbia      |
| Fernando Alberto Sanabria         | pescetariano | rock        |
| Gildardo Víctor Ramírez           | vegetariano  | reguetón    |
| Gildardo Víctor Ramírez           | vegetariano  | cumbia      |
| Gildardo Víctor Ramírez           | vegetariano  | salsa       |
| Gildardo Víctor Ramírez           | vegetariano  | tango       |
| Gildardo Víctor Ramírez           | vegetariano  | merengue    |
| Gildardo Víctor Ramírez           | vegetariano  | tropical    |

# Este es el final, muchas gracias por llegar hasta acá :D
