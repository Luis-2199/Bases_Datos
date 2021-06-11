--CREA_INTEGRIDAD

--csexo--1
ALTER TABLE csexo ADD CONSTRAINT pk_csexo_id_csexo
    PRIMARY KEY (id_csexo);
ALTER TABLE csexo ADD CONSTRAINT chk_csexo_etiqueta_sexo
    CHECK ( etiqueta_sexo IN ('M', 'H') );
ALTER TABLE csexo ADD CONSTRAINT unq_csexo_etiqueta_sexo
    UNIQUE(etiqueta_sexo);

--cmetodo_pago--2
ALTER TABLE cmetodo_pago ADD CONSTRAINT pk_cmetodo_pago_id_cmetodo_pago
    PRIMARY KEY (id_cmetodo_pago);
ALTER TABLE cmetodo_pago ADD CONSTRAINT unq_cmetodo_pago_nombre_metodo_pago
    UNIQUE(nombre_metodo_pago);
ALTER TABLE cmetodo_pago ALTER  COLUMN nombre_metodo_pago SET NOT NULL;

--ctipoempleado--3
ALTER TABLE ctipoempleado ADD CONSTRAINT pk_ctipoempleado_id_ctipoempleado
    PRIMARY KEY (id_ctipoempleado);
ALTER TABLE ctipoempleado ADD CONSTRAINT unq_ctipoempleado_puesto
    UNIQUE (puesto);
ALTER TABLE ctipoempleado ALTER  COLUMN puesto SET NOT NULL;

--ctalla--4
ALTER TABLE ctalla ADD CONSTRAINT pk_ctalla_id_ctalla
    PRIMARY KEY (id_ctalla);
ALTER TABLE ctalla ADD CONSTRAINT unq_ctalla_num_calzado
    UNIQUE (num_calzado);
ALTER TABLE ctalla ALTER  COLUMN num_calzado SET NOT NULL;

--cocupacion--5
ALTER TABLE cocupacion ADD CONSTRAINT pk_cocupacion_id_cocupacion
    PRIMARY KEY (id_cocupacion);
ALTER TABLE cocupacion ADD CONSTRAINT chk_cocupacion_nombre_ocupacion
    CHECK ( nombre_ocupacion IN ('Estudiante', 'Trabajador', 'Otro') );
ALTER TABLE cocupacion ADD CONSTRAINT unq_cocupacion_nombre_ocupacion
    UNIQUE(nombre_ocupacion);

--ctipomembresia--6
ALTER TABLE ctipomembresia ADD CONSTRAINT pk_ctipomembresia_id_ctipomembresia
    PRIMARY KEY (id_ctipomembresia);
ALTER TABLE ctipomembresia ADD CONSTRAINT unq_ctipomembresia_etiqueta_ctipomembresia
    UNIQUE (etiqueta_ctipomembresia);
ALTER TABLE ctipomembresia ALTER  COLUMN etiqueta_ctipomembresia SET NOT NULL;
ALTER TABLE ctipomembresia ALTER  COLUMN descuento SET NOT NULL;


--alimentos--7
ALTER TABLE alimentos ADD CONSTRAINT pk_alimentos_id_alimento
    PRIMARY KEY (id_alimento);
ALTER TABLE alimentos ADD CONSTRAINT chk_alimentos_precio
    CHECK ( precio>0 );
ALTER TABLE alimentos ALTER  COLUMN nombre SET NOT NULL;
ALTER TABLE alimentos ALTER  COLUMN precio SET NOT NULL;

--pista--8
ALTER TABLE pista ADD CONSTRAINT pk_pista_id_pista
    PRIMARY KEY (id_pista);
ALTER TABLE pista ADD CONSTRAINT chk_pista_capacidad
    CHECK ( capacidad>0 AND capacidad<6 );
ALTER TABLE pista ADD CONSTRAINT chk_pista_costo_hora CHECK (costo_hora > 0);
ALTER TABLE pista ALTER  COLUMN capacidad SET NOT NULL;


--ingredientes--9
ALTER TABLE ingredientes ADD CONSTRAINT pk_ingedientes_id_ingredientes
    PRIMARY KEY (id_ingredientes);
ALTER TABLE ingredientes ADD CONSTRAINT chk_ingredientes_costo
     CHECK ( ingredientes_costo > 0 );
ALTER TABLE ingredientes ALTER COLUMN ingredientes_nombre SET NOT NULL;

--ingredientes_alimentos--10
ALTER TABLE ingredientes_alimentos ADD CONSTRAINT pk_ingredientes_alimentos_id_alimnetoid_ingredientes
    PRIMARY KEY (id_alimento,id_ingredientes);
ALTER TABLE ingredientes_alimentos ADD CONSTRAINT fk_indregientes_alimentos_id_alimento
    FOREIGN KEY (id_alimento) REFERENCES alimentos (id_alimento)ON DELETE CASCADE;
ALTER TABLE  ingredientes_alimentos ADD CONSTRAINT fk_ingredientes_alimentos_id_ingredientes
    FOREIGN KEY (id_ingredientes) REFERENCES ingredientes (id_ingredientes)ON DELETE CASCADE;
ALTER TABLE  ingredientes_alimentos ADD CONSTRAINT chk_ingredientes_alimentos_cantidad
    CHECK ( cantidad_ingredientes_alimentos >0 );

--proveedor--11
ALTER TABLE proveedor ADD CONSTRAINT pk_proveedor_id_proveedor
    PRIMARY KEY (id_proveedor);
ALTER TABLE proveedor ADD CONSTRAINT unq_proovedor_etiqueta_proveedor
    UNIQUE(etiqueta_proveedor);
ALTER TABLE proveedor ALTER COLUMN etiqueta_proveedor SET NOT NULL;

--contacto--12
ALTER TABLE contacto ADD CONSTRAINT pk_contacto_id_contacto PRIMARY KEY (id_contacto);
ALTER TABLE contacto ADD CONSTRAINT unq_contacto_telefono UNIQUE (telefono);
ALTER TABLE contacto ADD CONSTRAINT unq_contacto_correo UNIQUE (correo);
ALTER TABLE contacto ALTER  COLUMN telefono SET NOT NULL;
ALTER TABLE contacto ALTER  COLUMN correo SET NOT NULL;
ALTER TABLE contacto ADD CONSTRAINT fk_contacto_id_proveedor
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor);

--calzado--13
ALTER TABLE calzado ADD CONSTRAINT pk_calzado_id_calzado
    PRIMARY KEY (id_calzado);
ALTER TABLE calzado ADD CONSTRAINT fk_calzado_id_proovedor
    FOREIGN KEY (id_proveedor) REFERENCES proveedor (id_proveedor)ON DELETE CASCADE;
ALTER TABLE calzado ADD CONSTRAINT fk_calzado_id_ctalla
    FOREIGN KEY (id_ctalla) REFERENCES ctalla (id_ctalla)ON DELETE CASCADE;
ALTER TABLE calzado ALTER  COLUMN color SET NOT NULL;
ALTER TABLE calzado ADD CONSTRAINT chk_calzado_costo_renta CHECK ( costo_renta > 0 );

--empleado--14
ALTER TABLE empleado ADD CONSTRAINT pk_empleado_id_empleado
    PRIMARY KEY (id_empleado);
ALTER TABLE empleado ADD CONSTRAINT fk_empleado_idctipoempleado
    FOREIGN KEY (id_ctipoempleado) REFERENCES ctipoempleado(id_ctipoempleado)ON DELETE CASCADE;
ALTER TABLE empleado ADD CONSTRAINT fk_empleado_id_csexo
    FOREIGN KEY (id_csexo) REFERENCES csexo(id_csexo) ON DELETE CASCADE;
ALTER TABLE empleado ALTER COLUMN nombre SET NOT NULL;
ALTER TABLE empleado ALTER COLUMN app SET NOT NULL;
ALTER TABLE empleado ALTER COLUMN apm SET NOT NULL;
ALTER TABLE empleado ALTER COLUMN fecha_nacimiento SET NOT NULL;

--cliente--15
ALTER TABLE cliente ADD CONSTRAINT pk_cliente_id_cliente
    PRIMARY KEY (id_cliente);
ALTER TABLE cliente ADD CONSTRAINT fk_cliente_id_ocupacion
    FOREIGN KEY (id_ocupacion) REFERENCES cocupacion (id_cocupacion)ON DELETE CASCADE;
ALTER TABLE cliente ADD CONSTRAINT fk_cliente_id_csexo
    FOREIGN KEY (id_csexo) REFERENCES csexo (id_csexo)ON DELETE CASCADE;
ALTER TABLE cliente ALTER  COLUMN nombre SET NOT NULL;
ALTER TABLE cliente ALTER  COLUMN app SET NOT NULL;
ALTER TABLE cliente ALTER  COLUMN fechanacimiento SET NOT NULL;

--correo--16 --
ALTER TABLE correo ADD CONSTRAINT pk_correo_id_correo
    PRIMARY KEY (id_correo);
ALTER TABLE correo ADD CONSTRAINT fk_correo_id_cliente
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE ;
ALTER TABLE correo ALTER  COLUMN correo_cliente SET NOT NULL;

-- membresia--17
ALTER TABLE membresia ADD CONSTRAINT pk_membresia_id_membresia
    PRIMARY KEY (id_membresia);
ALTER TABLE membresia ADD CONSTRAINT fk_membresia_id_cliente
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)ON DELETE CASCADE;
ALTER TABLE membresia ADD CONSTRAINT fk_membresia_id_ctipomembresia
    FOREIGN KEY (id_ctipomembresia) REFERENCES ctipomembresia(id_ctipomembresia)ON DELETE CASCADE;
ALTER TABLE membresia ALTER COLUMN ini_vig SET NOT NULL;

--orden--18
ALTER TABLE orden ADD CONSTRAINT pk_orden_id_orden
    PRIMARY KEY (id_orden);
ALTER TABLE orden ADD CONSTRAINT fk_orden_id_cliente
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)ON DELETE CASCADE;
ALTER TABLE orden ADD CONSTRAINT fk_orden_id_cmetodo_pago
    FOREIGN KEY (id_cmetodo_pago) REFERENCES cmetodo_pago (id_cmetodo_pago)ON DELETE CASCADE;
ALTER TABLE orden ADD CONSTRAINT fk_orden_id_empleado
    FOREIGN KEY (id_empleado) REFERENCES empleado (id_empleado)ON DELETE CASCADE;
ALTER TABLE orden ALTER  COLUMN fecha SET NOT NULL;
ALTER TABLE orden ALTER  COLUMN hora SET NOT NULL;
ALTER TABLE orden ADD CONSTRAINT chk_orden_num_jugadores
    CHECK (num_jugadores >0 AND num_jugadores <= 5);

--orden_calzado--19
ALTER TABLE orden_calzado ADD CONSTRAINT pk_orden_calzado_id_ordenid_calzado
    PRIMARY KEY (id_orden, id_calzado);
ALTER TABLE orden_calzado ADD CONSTRAINT fk_orden_calzado_id_orden
    FOREIGN KEY (id_orden) REFERENCES orden(id_orden)ON DELETE CASCADE;
ALTER TABLE orden_calzado ADD CONSTRAINT fk_orden_calzado_id_calzado
    FOREIGN KEY (id_calzado) REFERENCES calzado(id_calzado)ON DELETE CASCADE;
ALTER TABLE orden_calzado ADD CONSTRAINT chk_orden_calzado_cantidad
    CHECK (cantidad_orden_calzado >= 0 and cantidad_orden_calzado <= 5);

--orden_alimentos--20
ALTER TABLE orden_alimentos ADD CONSTRAINT pk_orden_alimentos_id_ordenid_alimento
    PRIMARY KEY (id_orden,id_alimento);
ALTER TABLE orden_alimentos ADD CONSTRAINT fk_orden_alimentos_id_orden
    FOREIGN KEY (id_orden) REFERENCES orden (id_orden)ON DELETE CASCADE;
ALTER TABLE orden_alimentos ADD CONSTRAINT fk_orden_alimentos_id_alimentos
    FOREIGN KEY (id_alimento) REFERENCES alimentos (id_alimento)ON DELETE CASCADE;
ALTER TABLE orden_alimentos ADD CONSTRAINT chk_orden_alimentos_cantidad
    CHECK ( cantidad_orden_alimentos > 0 );

--orden_pista--21
ALTER TABLE orden_pista ADD CONSTRAINT pk_orden_pista_idorden_idpista
    PRIMARY KEY (id_orden,id_pista);
ALTER TABLE orden_pista ADD CONSTRAINT fk_orden_pista_idorden
    FOREIGN KEY (id_orden) REFERENCES orden (id_orden)ON DELETE CASCADE;
ALTER TABLE orden_pista ADD CONSTRAINT fk_orden_pista_idpista
    FOREIGN KEY (id_pista) REFERENCES pista (id_pista)ON DELETE CASCADE;
ALTER TABLE orden_pista ADD CONSTRAINT chk_orden_pista_tiempo_renta
    CHECK ( tiempo_renta > 0 );

--Crea_Integridad
