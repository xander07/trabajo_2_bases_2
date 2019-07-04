-- Tipo coordenada para la columna tipada de CajeroSucursal

CREATE OR REPLACE TYPE coord_type AS OBJECT(
	x NUMBER(2),
	y NUMBER(2)
);

--Tipo Cajero-Sucursal para la tabla tipada CajeroSucursal
CREATE OR REPLACE TYPE caj_suc_type AS OBJECT(
	identificador VARCHAR(10),
	coordenada coord_type
);

--Tabla tipada CajeroSucursal
CREATE TABLE CajeroSucursal OF caj_suc_type(
	identificador PRIMARY KEY
);

--Validaciones de la tabla CajeroSucursal
--Las coordenadas no deben ser negativas
--Las coordenadas no deben ser mayores a 100
ALTER TABLE CajeroSucursal
ADD CONSTRAINT CK_coord_x_pos
CHECK(coordenada.x>0 AND coordenada.x<100);

ALTER TABLE CajeroSucursal
ADD CONSTRAINT CK_coord_y_pos
CHECK(coordenada.y>0 AND coordenada.y<100);	

-- Tipo para la columna tipada Operaciones de la tabla tipada Cuenta
CREATE OR REPLACE TYPE op_type AS OBJECT(
	idoper NUMBER(10),
	tipo VARCHAR2(1),
	fecha NUMBER(10),
	valor NUMBER(10),
	lugar REF caj_suc_type
);

-- Lista de tipo op_type
CREATE OR REPLACE TYPE op_det AS TABLE OF op_type;

-- Tipo de cuenta para la tabla tipada Cuenta
CREATE OR REPLACE TYPE cuenta_type AS OBJECT(
	numeroCuenta NUMBER(10),
	operaciones op_det --Lista anidada de tipo op_type
);

--Tabla tipada cuenta
CREATE TABLE cuenta OF cuenta_type
	(numeroCuenta PRIMARY KEY)
	NESTED TABLE operaciones STORE AS store_prueba
	--Restricciones de la tabla anidada
	--idoper y fecha deben ser únicos
	--idoper, valor y fecha no pueden ser negativos
	--El tipo de operacion solamente puede ser R o C
	((PRIMARY KEY (NESTED_TABLE_ID,idoper),
		CHECK(idoper > 0),
		CHECK(fecha > 0 ),
		CHECK(valor > 0), 
		CHECK(tipo = 'R' OR tipo = 'C'),
		UNIQUE(fecha)
	)
	);