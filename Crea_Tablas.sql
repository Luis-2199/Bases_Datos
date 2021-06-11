--CREA_TABLAS

--------------------°1
CREATE TABLE csexo(
    id_csexo INTEGER,
    etiqueta_sexo CHAR(1)
);

--------------------°2
CREATE TABLE cmetodo_pago(
    id_cmetodo_pago INTEGER,
    nombre_metodo_pago VARCHAR(32)
);

--------------------°3
CREATE TABLE ctipoempleado(
    id_ctipoempleado INTEGER,
    puesto VARCHAR(32)
);

--------------------°4
CREATE TABLE ctalla(
    id_ctalla INTEGER,
    num_calzado INTEGER
);

--------------------°5
CREATE TABLE cocupacion(
    id_cocupacion INTEGER,
    nombre_ocupacion VARCHAR(32)
);

--------------------°6
CREATE TABLE ctipomembresia(
    id_ctipomembresia INTEGER,
    etiqueta_ctipomembresia VARCHAR(32),
    descuento      DECIMAL
);


--------------------°7
CREATE TABLE alimentos
( id_alimento INTEGER,
  nombre     VARCHAR(32),
  precio     NUMERIC
);

--------------------°8
CREATE TABLE  pista(
  id_pista INTEGER,
  capacidad INTEGER,
  costo_hora NUMERIC
);

--------------------°9
CREATE TABLE ingredientes(
    id_ingredientes INTEGER,
    ingredientes_nombre VARCHAR(32),
    ingredientes_costo NUMERIC
);
--------------------°10
CREATE TABLE ingredientes_alimentos(
  cantidad_ingredientes_alimentos INTEGER,
  id_alimento INTEGER,
  id_ingredientes INTEGER
);
--------------------°11
CREATE TABLE proveedor(
    id_proveedor INTEGER,
    etiqueta_proveedor VARCHAR(64)
);

--------------------°12
CREATE TABLE contacto(
    id_contacto INTEGER,
    telefono VARCHAR(32) ,
    correo VARCHAR(64),
    id_proveedor INTEGER
);
--------------------°13
CREATE TABLE calzado(
    id_calzado INTEGER,
    color   VARCHAR(32) ,
    id_proveedor INTEGER,
    id_ctalla    INTEGER,
    costo_renta  NUMERIC
);

--------------------°14
CREATE TABLE empleado(
    id_empleado INTEGER,
    nombre VARCHAR(32),
    app VARCHAR(32),
    apm VARCHAR(32),
    rfc VARCHAR(32),
    fecha_nacimiento   DATE,
    id_ctipoempleado INTEGER,
    id_csexo INTEGER

);

--------------------°15
CREATE TABLE cliente(
    id_cliente INTEGER,
    nombre VARCHAR(32) ,
    app VARCHAR(32) ,
    fechanacimiento DATE,
    id_ocupacion INTEGER,
    id_csexo INTEGER
) ;

--------------------°16
CREATE TABLE correo (
  id_correo INTEGER,
  correo_cliente VARCHAR(64),
  id_cliente INTEGER
);
--Se modifico etiqueta_proovedor a VAR(64)
--------------------°17
CREATE TABLE membresia(
    id_membresia INTEGER,
    ini_vig DATE,
    fin_vig DATE,
    activo BOOLEAN,
    id_cliente INTEGER,
    id_ctipomembresia INTEGER
);

--------------------°18
CREATE TABLE orden(
    id_orden INTEGER,
    fecha    DATE  ,
    hora    TIME  ,
    id_cliente    INTEGER,
    id_empleado INTEGER,
    id_cmetodo_pago INTEGER,
    num_jugadores INTEGER
);

--------------------°19
CREATE TABLE orden_calzado(
id_orden INTEGER,
id_calzado INTEGER,
cantidad_orden_calzado INTEGER --------------CANTIDAD
);

--------------------°20
CREATE TABLE orden_alimentos(
    id_orden INTEGER,
    id_alimento   INTEGER,
    cantidad_orden_alimentos INTEGER ----------------CANTIDAD
);

--------------------°21
CREATE TABLE orden_pista (
    id_orden INTEGER,
    id_pista INTEGER,
    tiempo_renta INTEGER
);

--Crea_Tablas