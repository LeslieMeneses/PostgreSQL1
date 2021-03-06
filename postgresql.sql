/* 
	
INSTRUCCIONES POSTGRESQL
________________________

INDICE

1.	WHERE
2.	ORDER BY
3.	LEFT JOIN
4.	AGV() - LEFT JOIN - GROUP BY
5.	COUNT() - GROUP BY - HAVING - ORDER BY
6.	SUM() - LEFT JOIN - GROUP BY
7.	SUBSTR()
8.	LENGTH()
9.	RPAD()
10. OPERADORES DE CONPARACION
11.	IN
12.	ARRAY_AGG()

*/

-------------------------------------------Crear base de datos----------------------------------------------

/*
============================================================================================================
	Tabla estudiante
============================================================================================================
*/
CREATE TABLE public.estudiante (
	id_estudiante INTEGER NOT NULL,
	nombre TEXT,
	apellido TEXT,
	id_grupo INTEGER,
	CONSTRAINT estudiante_pkey PRIMARY KEY(id_estudiante)
) 
WITH (oids = false);

/*
============================================================================================================
	Tabla profesor
============================================================================================================
*/
CREATE TABLE public.profesor (
	id_profesor INTEGER NOT NULL,
	nombre TEXT,
	apellido TEXT,
	CONSTRAINT profesor_pkey PRIMARY KEY(id_profesor)
) 
WITH (oids = false);

/*
============================================================================================================
	Tabla grupo
============================================================================================================
*/
CREATE TABLE public.grupo (
	id_grupo INTEGER NOT NULL,
	id_profesor INTEGER,
	nombre TEXT,
	CONSTRAINT grupo_pkey PRIMARY KEY(id_grupo)
) 
WITH (oids = false);

/*
============================================================================================================
	Tabla notas
============================================================================================================
*/
CREATE TABLE public.notas (
	id_nota INTEGER NOT NULL,
	id_estudiante INTEGER,
	id_grupo INTEGER,
	nota NUMERIC,
	CONSTRAINT grupo_pkey PRIMARY KEY(id_grupo)
) 
WITH (oids = false);

-------------------------------------------------Ejercicios-------------------------------------------------

/*
============================================================================================================
	1.  Estudiantes  donde el grupo sea 1-php
			- WHERE
============================================================================================================
*/

SELECT 
	nombre, apellido,id_grupo
FROM 
	estudiante
WHERE
	id_grupo=1;


/*
============================================================================================================
	2.	Imprime todos los estudiantes y los ordena por id_grupo, nombre, apellido
			- ORDER BY
============================================================================================================
*/
SELECT 
	id_grupo, nombre, apellido
FROM 
	estudiante
order by id_grupo, nombre, apellido




/*
============================================================================================================
	3.	LEFT JOIN, mostrar todos los registros de la tabla grupo mas id_estudiante, nombre de estudiante, nota,
			id_profesor nombre de profesor.
			condicion adicional: traer el grupo anque no tenga estudiantes ni profesor. y ordenarlo por id de prupo.
			- LEFT JOIN
			- ORDER BY
============================================================================================================
*/
select 
	e.id_estudiante,
	e.nombre as nombre_estudiante,
	g.nombre as nombre_grupo,
	g.id_grupo as id_de_grupo,
	p.id_profesor,
	p.nombre as nombre_profesor,
	n.nota

from grupo g
left join estudiante e
	on ( g.id_grupo = e.id_grupo )
		
left join profesor p
	on ( g.id_grupo = p.id_profesor )

left join nota n
	on ( g.id_grupo = n.id_grupo and n.id_estudiante = e.id_estudiante )

order by g.id_grupo


/*
============================================================================================================
	4.	Promedio de nota por grupos
			- AVG() -> Funcion para obtener promedios
			- LEFT JOIN
			- GROUP BY
============================================================================================================
*/
select 
	g.id_grupo,
	g.nombre,
	avg(n.nota) as promedioXgrupo

from
	grupo g

left join nota n
	on ( g.id_grupo = n.id_grupo )
		
group by g.id_grupo

/*
============================================================================================================
	5.  Contar la cantidad de estudiantes de cada grupo donde no halla mas de 2 estudiantes
			- COUNT() -> Function for count
			- GROUP BY (Allways you need one function of adding)
			- HAVING 
			- ORDER BY
============================================================================================================
*/
SELECT
	id_grupo,
	count(*) as estudiantes
		
FROM estudiante
WHERE 1=1

group by
	id_grupo

--HAVING condicion dentro del group by
having count(*) > 2
order by
	id_grupo

/*
============================================================================================================
	6.	Suma de tosos los grupos y sacar el promedio
			- SUM() -> Funcion para obtener promedios
			- LEFT JOIN
			- GROUP BY
============================================================================================================
*/
select
	g.id_grupo,
	g.nombre,
	sum(n.nota)
		
from
	grupo g

left join nota n
	on ( g.id_grupo = n.id_grupo )
		
group by g.id_grupo

/*
============================================================================================================
	7.	La funcion substring(Subcadena) empieza a contar desde (1)
			- SUBSTR
============================================================================================================
*/

	substr(nombre,1,3)
from
	estudiante
	 
/* Si el primer parametro esta encerrado en commillas ('') el substring se hara
	 de acuerdo a esa cadena y no a los datos del campo nombre*/
select 
	substring(nombre from 2 for 4)
from 
	estudiante 

/*
============================================================================================================
	8.	La funcion length(longitud) cuenta la longitud del campo
			- LENGTH
============================================================================================================
*/
	select 
	nombre,
	length(nombre)
from
	estudiante
order by length(nombre)

/*
============================================================================================================
	9.	La funcion rpad en este caso concatena los dos campos.
			- RPAD
============================================================================================================
*/

select 
	rpad(nombre, 15, apellido)
from
	estudiante

/*
============================================================================================================
	10.	Operadores de comparacion.

	<	less than
	>	greater than
	<=	less than or equal to
	>=	greater than or equal to
	=	equal
	<> or !=	not equal
	between
	is null
	is not nll
============================================================================================================
*/

select 
	e.nombre,
	n.nota
from
	estudiante e
inner join nota n 
	on e.id_estudiante=n.id_estudiante
where n.nota>4


select 
	e.nombre,
	n.nota
from
	estudiante e
inner join nota n 
	on e.id_estudiante=n.id_estudiante
where n.nota between 4 and 4.7 


/*Trae el resultado donde el campo id_profesor este con valor NULL*/
select 
	nombre, id_grupo
from 
	grupo
where id_profesor IS NULL


/*Trae el resultado donde el campo id_profesor no esten vacidos */
select 
	nombre, id_grupo
from 
	grupo
where id_profesor IS not NULL

/*
============================================================================================================
	11.	Se usa para en la clausula WHERE para mirar si coincide con algun valor de la lista de valores dado
	IN(value1, value2)
============================================================================================================
*/

select 
	e.nombre,
	n.nota
from
	estudiante e
inner join nota n 
	on e.id_estudiante=n.id_estudiante
where n.nota IN (2,5) 

/*
============================================================================================================
	12.	array_agg() - Todos los registros del campo nombre quedan dentro del array.
============================================================================================================
*/

select 
	array_agg(nombre)
from 
	grupo
