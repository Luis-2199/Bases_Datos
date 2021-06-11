--Funciones
/*
 > Script con un ejemplo de una función que devuelve un
valor, un ejemplo de función que devuelve una tabla y un ejemplo de función que
realiza una acción en su BD (asignación e inserción, asignación y actualización,
asignación y borrado).

 */

--1) Función que devuelve un valor
/*
 Función que permite obtener la cantidad total a pagar por cada orden. Tomando en cuenta si el cliente cuenta
 con una membresía para poder aplicar el descuento correspondiente.
 */
CREATE OR REPLACE FUNCTION fnc_total_orden(
    pid_orden INTEGER
)
    RETURNS NUMERIC
AS
$$
DECLARE vtotal_pista    NUMERIC;
DECLARE vtotal_calzado  NUMERIC;
DECLARE vtotal_alimento NUMERIC;
DECLARE vtotal_global   NUMERIC;

BEGIN

    IF ((SELECT tiempo_renta
         FROM orden_pista
         WHERE id_orden = pid_orden) IS NOT NULL)
    THEN
        vtotal_pista = (SELECT tiempo_renta
                        FROM orden_pista
                        WHERE id_orden = pid_orden);
    ELSE
        vtotal_pista = 0;
    END IF;

    IF ((SELECT cantidad_orden_calzado
         FROM orden_calzado
                  JOIN orden ON orden_calzado.id_orden = orden.id_orden
         WHERE orden.id_orden = pid_orden) IS NOT NULL)
    THEN
        vtotal_calzado = (SELECT cantidad_orden_calzado
                          FROM orden_calzado
                          WHERE id_orden = pid_orden);
    ELSE
        vtotal_calzado = 0;

    END IF;

    IF ((SELECT DISTINCT id_orden
         FROM orden_alimentos
                  JOIN alimentos ON orden_alimentos.id_alimento = alimentos.id_alimento
         WHERE id_orden = pid_orden) IS NOT NULL)
    THEN
        vtotal_alimento = (SELECT SUM(semitotal)
                           FROM (SELECT id_orden,
                                        cantidad_orden_alimentos,
                                        precio,
                                        cantidad_orden_alimentos * precio semitotal
                                 FROM orden_alimentos
                                          JOIN alimentos ON orden_alimentos.id_alimento = alimentos.id_alimento
                                 WHERE id_orden = pid_orden) T1);
    ELSE
        vtotal_alimento = 0;

    END IF;

    vtotal_global = (vtotal_calzado * 30) + (vtotal_pista * 380) + vtotal_alimento;


    CASE
        WHEN (((SELECT id_ctipomembresia
                FROM orden
                         JOIN cliente ON orden.id_cliente = cliente.id_cliente
                         JOIN membresia ON cliente.id_cliente = membresia.id_cliente
                WHERE id_orden = pid_orden) = 1) AND
              ((SELECT activo
                FROM orden
                         JOIN cliente ON orden.id_cliente = cliente.id_cliente
                         JOIN membresia ON cliente.id_cliente = membresia.id_cliente
                WHERE id_orden = pid_orden) = true)
            )
            THEN vtotal_global = vtotal_global * (1 - .15);
        WHEN (((SELECT id_ctipomembresia
                FROM orden
                         JOIN cliente ON orden.id_cliente = cliente.id_cliente
                         JOIN membresia ON cliente.id_cliente = membresia.id_cliente
                WHERE id_orden = pid_orden) = 2) AND
              ((SELECT activo
                FROM orden
                         JOIN cliente ON orden.id_cliente = cliente.id_cliente
                         JOIN membresia ON cliente.id_cliente = membresia.id_cliente
                WHERE id_orden = pid_orden) = true)
            )
            THEN vtotal_global = vtotal_global * (1 - .1);
        WHEN (((SELECT id_ctipomembresia
                FROM orden
                         JOIN cliente ON orden.id_cliente = cliente.id_cliente
                         JOIN membresia ON cliente.id_cliente = membresia.id_cliente
                WHERE id_orden = pid_orden) = 3) AND
              ((SELECT activo
                FROM orden
                         JOIN cliente ON orden.id_cliente = cliente.id_cliente
                         JOIN membresia ON cliente.id_cliente = membresia.id_cliente
                WHERE id_orden = pid_orden) = true)
            )
            THEN vtotal_global = vtotal_global * (1 - .05);

        ELSE vtotal_global = vtotal_global;
        END CASE;

    RETURN vtotal_global;
END;
$$ LANGUAGE 'plpgsql' VOLATILE;

SELECT *
FROM fnc_total_orden(11);

--2) Función que devuelve una tabla
--El top 10 de los meseros con más órdenes atendidas en cierto mes y año.


CREATE OR REPLACE FUNCTION fnc_top10_meseros(panio INTEGER,
                                             pmes INTEGER)
    RETURNS TABLE
            (
                onompre_completo VARCHAR(32),
                orcf             VARCHAR(32),
                ototal           BIGINT
            )
AS
$$
BEGIN
    IF (panio IN (SELECT DISTINCT EXTRACT(YEAR FROM fecha)
                  FROM orden)) THEN
        RETURN QUERY SELECT nombre, rfc, COUNT(id_orden) total
                     FROM orden
                              JOIN empleado ON orden.id_empleado = empleado.id_empleado
                     WHERE EXTRACT(MONTH FROM fecha) = pmes
                       AND EXTRACT(YEAR FROM fecha) = panio
                     GROUP BY empleado.id_empleado
                     Order by total DESC
                     LIMIT 10;


    ELSE
        RETURN QUERY (SELECT CAST('No hay datos para este año' as VARCHAR(32)),
                             CAST('No hay datos para este mes' as VARCHAR(32)),
                             CAST(0 AS BIGINT) total
                      FROM cliente);
    END IF;
END ;

$$ LANGUAGE 'plpgsql' VOLATILE;

SELECT *
FROM fnc_top10_meseros(2020,08);

--3) Función que realiza una acción en su BD
-- (asignación e inserción, asignación y actualización,asignación y borrado).

-- Función que SI el cliente lo desea, puede hacer:
-- a) Dar de altar un correo extra.
-- b) Actualizar el último correo dado de alta.
-- c) Elimina último correo registrado (solo si tiene 2 o mas)

--NOTA pindicar: 0=dar de alta, 1=actualizar, 2=Eliminar
CREATE OR REPLACE FUNCTION fnc_cliente_AEI(pidcliente INTEGER,
                                           pcorreo_new VARCHAR(64),
                                           pindicador INTEGER)
    RETURNS INTEGER AS
$$
DECLARE vid_correo INTEGER;
DECLARE vidcorreoultimo INTEGER;
BEGIN
    vid_correo = ((SELECT MAX(id_correo) FROM correo) + 1);
    vidcorreoultimo = (SELECT MAX(id_correo)
                       FROM correo
                       WHERE id_cliente = pidcliente);


    CASE WHEN (pindicador = 0) THEN
        INSERT INTO correo (id_correo, correo_cliente, id_cliente) VALUES (vid_correo, pcorreo_new, pidcliente);
        RETURN 1;
        WHEN (pindicador = 1) THEN
            UPDATE correo SET correo_cliente= pcorreo_new WHERE id_correo = vidcorreoultimo;
            RETURN 1;
        WHEN (pindicador = 2) THEN
            IF ((SELECT COUNT(id_correo)
                 FROM correo
                    WHERE id_cliente = pidcliente
                 GROUP BY id_cliente) > 1) THEN
                DELETE FROM correo WHERE id_correo = vidcorreoultimo;
                RETURN 1;
            ELSE
                RETURN 0;

            END IF;
        ELSE RETURN 0;
        END CASE;
        END;

$$ LANGUAGE 'plpgsql' VOLATILE;

SELECT cliente.id_cliente,id_correo,correo_cliente
FROM cliente JOIN correo ON cliente.id_cliente = correo.id_cliente
WHERE cliente.id_cliente=1000;

SELECT *
FROM fnc_cliente_AEI(1000,'prueba1@',0);

SELECT *
FROM fnc_cliente_AEI(1000,'prueba2@',1);

SELECT *
FROM fnc_cliente_AEI(1000,NULL,2)

--Crea_Funciones