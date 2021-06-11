--Consultas

/*
 Script con un ejemplo de cada una de los siguientes tipos de
consulta: básica (solo incluye una tabla), subconsulta (al menos 3 niveles), compuesta
(3 tablas al menos deben estar involucradas en un JOIN), paginación, CROSSTAB,
función de ventana, agrupación (debe resolver el mismo problema que la función de
ventana).
 */

--1)Básica (solo incluye una tabla)
/*
 Nombre y apellido paterno (app) de aquellos empleados cuyo app empiece con S y que hayan nacido
 antes de 1990. Los resultados serán ordenados por app de forma ascendente.
 */
SELECT nombre, app Apellido
FROM empleado
WHERE app LIKE 'S%' AND EXTRACT(YEAR FROM fecha_nacimiento) < 1990
ORDER BY app;

--2)Subconsulta (al menos 3 niveles)
/*
 Nombre de aquellos clientes que en cuyas visitas tienen un número de jugadores mayor al promedio
 y además tengan su membresía activa
 */
SELECT nombre
FROM cliente
WHERE id_cliente IN (
    SELECT DISTINCT id_cliente
    FROM orden
    WHERE num_jugadores > (
        SELECT AVG(num_jugadores)
        FROM orden))
  AND id_cliente IN (
    SELECT id_cliente
    FROM membresia
    WHERE activo = true
);

--3)Compuesta (3 tablas al menos deben estar involucradas en un JOIN)
/*
Nombre de la membresía más vendida a los clientes, así como el número total de ventas de este tipo.
 */

SELECT etiqueta_ctipomembresia Membresia, total total_Vendidas
FROM (SELECT etiqueta_ctipomembresia, COUNT(cliente.id_cliente) total
      FROM ctipomembresia
               JOIN membresia ON ctipomembresia.id_ctipomembresia = membresia.id_ctipomembresia
               JOIN cliente ON membresia.id_cliente = cliente.id_cliente
      GROUP BY etiqueta_ctipomembresia) T1
WHERE total = (SELECT MAX(total)
               FROM (SELECT etiqueta_ctipomembresia, COUNT(cliente.id_cliente) total
                     FROM ctipomembresia
                              JOIN membresia ON ctipomembresia.id_ctipomembresia = membresia.id_ctipomembresia
                              JOIN cliente ON membresia.id_cliente = cliente.id_cliente
                     GROUP BY etiqueta_ctipomembresia) T2);

--4)Paginación
-- Los 5 alimentos con más ingredientes omitiendo el aquel con mayor número ingredientes.

SELECT nombre, total_ingredientes
FROM alimentos
         JOIN (SELECT id_alimento, COUNT(id_ingredientes) total_ingredientes
               FROM ingredientes_alimentos
               GROUP BY id_alimento) T1 ON T1.id_alimento = alimentos.id_alimento
ORDER BY total_ingredientes DESC
OFFSET 1 LIMIT 5;

--5)CROSSTAB
-- Número de empleados por tipo y año de nacimiento
CREATE EXTENSION tablefunc;
SELECT *
FROM CROSSTAB(
         'SELECT ''RECEPCIONISTA'' tipo,EXTRACT(YEAR FROM fecha_nacimiento) ano, COUNT(id_empleado) total
         FROM empleado JOIN ctipoempleado ON empleado.id_ctipoempleado = ctipoempleado.id_ctipoempleado
         WHERE empleado.id_ctipoempleado = 1
         GROUP BY EXTRACT(YEAR FROM fecha_nacimiento)
         UNION ALL
         SELECT ''CALZADO'' tipo,EXTRACT(YEAR FROM fecha_nacimiento) ano, COUNT(id_empleado)
         FROM empleado JOIN ctipoempleado ON empleado.id_ctipoempleado = ctipoempleado.id_ctipoempleado
         WHERE empleado.id_ctipoempleado = 2
         GROUP BY EXTRACT(YEAR FROM fecha_nacimiento)
         UNION ALL
         SELECT ''MESERO'' tipo,EXTRACT(YEAR FROM fecha_nacimiento) ano, COUNT(id_empleado)
         FROM empleado JOIN ctipoempleado ON empleado.id_ctipoempleado = ctipoempleado.id_ctipoempleado
         WHERE empleado.id_ctipoempleado = 3
         GROUP BY EXTRACT(YEAR FROM fecha_nacimiento)
         UNION ALL
         SELECT ''COCINERO'' tipo,EXTRACT(YEAR FROM fecha_nacimiento) ano, COUNT(id_empleado)
         FROM empleado JOIN ctipoempleado ON empleado.id_ctipoempleado = ctipoempleado.id_ctipoempleado
         WHERE empleado.id_ctipoempleado = 4
         GROUP BY EXTRACT(YEAR FROM fecha_nacimiento)
         UNION ALL
         SELECT ''CAJERO'' tipo,EXTRACT(YEAR FROM fecha_nacimiento) ano, COUNT(id_empleado)
         FROM empleado JOIN ctipoempleado ON empleado.id_ctipoempleado = ctipoempleado.id_ctipoempleado
         WHERE empleado.id_ctipoempleado = 5
         GROUP BY EXTRACT(YEAR FROM fecha_nacimiento)
         ORDER BY tipo, ano', 'SELECT DISTINCT EXTRACT(YEAR FROM fecha_nacimiento) ano
         FROM empleado
         ORDER BY ano') resultado(
                                       otipo TEXT, o1964 BIGINT, o1965 BIGINT, o1966 BIGINT, o1967 BIGINT
             ,  o1968 BIGINT, o1969 BIGINT, o1970 BIGINT, o1971 BIGINT, o1972 BIGINT,
             o1973 BIGINT, o1974 BIGINT, o1975 BIGINT, o1976 BIGINT, o1977 BIGINT, o1978 BIGINT,
             o1979 BIGINT, o1980 BIGINT, o1981 BIGINT, o1982 BIGINT, o1983 BIGINT, o1984 BIGINT, o1985 BIGINT,
             o1986 BIGINT, o1987 BIGINT, o1988 BIGINT, o1989 BIGINT, o1990 BIGINT, o1991 BIGINT, o1992 BIGINT,
             o1993 BIGINT, o1994 BIGINT, o1995 BIGINT, o1996 BIGINT, o1997 BIGINT, o1998 BIGINT, o1999 BIGINT,
             o2000 BIGINT, o2001 BIGINT);


--6)Función de ventana
--Ocupación y el número total de ordenes asociadas a los clientes con tal ocupación
SELECT DISTINCT  nombre_ocupacion, COUNT(id_orden) OVER( PARTITION BY id_ocupacion ) total_por_ocupacion
FROM (cliente JOIN orden o on cliente.id_cliente = o.id_cliente)T1
JOIN cocupacion ON T1.id_ocupacion = cocupacion.id_cocupacion;


--7) Agrupación (debe resolver el mismo problema que la función de ventana)
SELECT  nombre_ocupacion,COUNT(id_orden)total_por_ocupacion
FROM (cliente JOIN orden o on cliente.id_cliente = o.id_cliente)T1
JOIN cocupacion ON T1.id_ocupacion = cocupacion.id_cocupacion
GROUP BY nombre_ocupacion;

--Consultas