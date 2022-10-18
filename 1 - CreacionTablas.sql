-- 1 ******** Creación de Tablas ********

CREATE DATABASE  Obligatorio_BD2_270543_149296_2022;

USE Obligatorio_BD2_270543_149296_2022;
SET DATEFORMAT dmy;

-- Tabla Planta
CREATE TABLE Planta
  (
     id            INT IDENTITY PRIMARY KEY,
     nombrepopular VARCHAR(30) NOT NULL,
     fechanac      DATE NOT NULL,
     altura        DECIMAL (6, 1) CHECK (altura <= 12000),
     fechamedicion DATETIME,
     precioventa   DECIMAL(10, 2) CHECK (precioventa >= 0),
     CONSTRAINT control_fecha CHECK (altura IS NOT NULL AND fechamedicion IS NOT
     NULL AND (fechamedicion >= fechanac) OR (altura IS NULL AND fechamedicion
     IS NULL))
  ); 

-- Tabla Tag
CREATE TABLE Tag
  (
     id     INT IDENTITY PRIMARY KEY,
     nombre VARCHAR(30) NOT NULL
  ); 

-- Tabla Planta Tag
CREATE TABLE Planta_tag
  (
     idtag    INT REFERENCES tag(id) NOT NULL,
     idplanta INT REFERENCES planta (id) NOT NULL
     PRIMARY KEY (idtag, idplanta)
  ); 

CREATE INDEX I_1 ON Planta_tag(idPlanta);

-- Tabla Mantenimiento
CREATE TABLE Mantenimiento
  (
     id                 INT IDENTITY PRIMARY KEY,
     idplanta           INT REFERENCES planta(id) NOT NULL,
     fechamantenimiento DATETIME NOT NULL,
     descripcion        VARCHAR(250),
     tipo               VARCHAR(15) CHECK (tipo IN ('Operativo', 'Nutrientes'))
  ); 

CREATE INDEX I_2 ON Mantenimiento(idPlanta);


-- ****************** Función que trae el tipo de mantenimiento (Nutrientes u Operativo) segun el Id de un Mantenimiento. ******************
-- Se usa para la tabla MantenimientoOperativo y Mantenimiento_Producto, se chequea que el tipo de mantenimiento sea el correcto.

CREATE FUNCTION TipoMantenimientoPorId(@idMantenimiento AS INT)
returns VARCHAR(15)
AS
  BEGIN
      DECLARE @tipo AS VARCHAR(15);

      SELECT @tipo = M.tipo
      FROM   mantenimiento M
      WHERE  M.id = @idMantenimiento;

      RETURN @tipo
  END 

  -- Tabla Mantenimiento Operativo
CREATE TABLE MantenimientoOperativo
  (
     idmantenimiento INT PRIMARY KEY REFERENCES mantenimiento(id),
     cantidadhoras   DECIMAL(4, 2) NOT NULL CHECK (cantidadHoras > 0) ,
     costo           DECIMAL (10, 2) NOT NULL CHECK (costo >= 0),
     CONSTRAINT ctrl_tipo_operativo CHECK
     (dbo.Tipomantenimientoporid(idmantenimiento) = 'Operativo')
  ); 

  -- Tabla Producto
CREATE TABLE Producto
  (
     codprod        CHAR(5) PRIMARY KEY,
     nombre         VARCHAR(30) NOT NULL,
     descripcion    VARCHAR(200) UNIQUE NOT NULL,
     precioporgramo DECIMAL(10, 2) CHECK(precioporgramo >= 0) NOT NULL
  ); 

  -- Tabla Mantenimiento producto
CREATE TABLE mantenimiento_producto
  (
     idmantenimiento INT REFERENCES mantenimiento (id) NOT NULL,
     codprod         CHAR(5) REFERENCES producto(codprod) NOT NULL,
     cantusada       DECIMAL (10, 2) CHECK(cantusada > 0) NOT NULL,
     costoaplicacion DECIMAL(10, 2) NOT NULL CHECK (costoaplicacion >= 0),
     PRIMARY KEY (idmantenimiento, codprod),
     CONSTRAINT ctrl_tipo_nutrientes CHECK
     (dbo.Tipomantenimientoporid(idmantenimiento) = 'Nutrientes')
  ); 

CREATE INDEX I_3 ON Mantenimiento_Producto(codProd);

-- Tabla utilizada para el tigger de la parte 4 .a del obligatorio
CREATE TABLE RegistroHistoricoProd
  (
     id                   INT PRIMARY KEY IDENTITY,
     fechaoperacion       DATETIME DEFAULT Getdate() NOT NULL,
     operacion            CHAR(8) NOT NULL,
     pc                   VARCHAR(25) NOT NULL,
     codProd			  CHAR(5),
     nomanterior          VARCHAR(30),
     nomnuevo             VARCHAR(30),
     descanterior         VARCHAR(200),
     descnueva            VARCHAR(200),
     precioporgrmanterior DECIMAL (10, 2),
     precioporgrmnuevo    DECIMAL (10, 2),
     usuario              VARCHAR(100) NOT NULL,
  ); 
  

-- RNE 

--El mantenimiento tiene que ser tipo 'Operativo' para que tenga asociado cantidad de horas y costo en la tabla MantenimientoOperativo
--El mantenimiento tiene que ser tipo 'nutriente' para que tenga asociado un producto en la tabla Mantenimiento_Producto
--El costo de aplicación de la tabla Mantenimiento_Producto es calculado, el precio de producto esta en la tabla Producto

-- ********** Nota: Las RNE detectadas fueron resueltas con triggers o un check que utiliza una función. **********

-- ****************** Ejecutar las siguientes funciones ******************
-- ****************** Funciones utilizadas para algunas consultas o checks *******************

-- 1) Función que trae el costo de un producto, segun su codigo identificatorio. 
CREATE FUNCTION CostoProductoPorCod(@codProd AS CHAR(5))
returns DECIMAL(10, 2)
AS
  BEGIN
      DECLARE @costo AS DECIMAL (10, 2);

      SELECT @costo = producto.precioporgramo
      FROM   producto
      WHERE  producto.codprod = @codProd

      RETURN @costo
  END 


--2) Trigger para crear el costoAplicion automaticamente al hacer un insert en la tabla mantenimiento_producto.
CREATE TRIGGER trgAgregarCostoAplicacion
ON mantenimiento_producto
instead OF INSERT
AS
  BEGIN
      INSERT INTO mantenimiento_producto
      SELECT I.idmantenimiento,
             I.codprod,
             I.cantusada,
             dbo.Costoproductoporcod(I.codprod) * I.cantusada
      FROM   inserted I;
  END 

-- 3) Función que trae el costo de mantenimiento de una planta, dado su ID y su año.
CREATE FUNCTION CostoMantenimientoPorAnio(@idPlanta AS INT,
                                          @anio     AS INT)
returns DECIMAL(10, 2)
AS
  BEGIN
      DECLARE @costo AS DECIMAL (10, 2);

      -- Operativo
      SELECT @costo = Sum(MO.costo)
      FROM   planta P,
             mantenimiento M,
             mantenimientooperativo MO
      WHERE  P.id = M.idplanta
             AND M.id = MO.idmantenimiento
             AND Year(M.fechamantenimiento) = @anio
             AND P.id = @idPlanta
      GROUP  BY P.id;

      -- Nutriente
      IF( @costo IS NULL )
        SET @costo = 0;

      SELECT @costo += Sum(MP.costoaplicacion)
      FROM   planta P,
             mantenimiento M,
             mantenimiento_producto MP
      WHERE  P.id = M.idplanta
             AND M.id = MP.idmantenimiento
             AND Year(M.fechamantenimiento) = @anio
             AND P.id = @idPlanta
      GROUP  BY P.id;

      RETURN @costo
  END

-- 4) Función que nos trae el costo de mantenimiento total dado el ID de una planta.
CREATE FUNCTION CostoMantenimientoPorId(@idPlanta AS INT)
returns DECIMAL(10, 2)
AS
  BEGIN
      DECLARE @costo AS DECIMAL (10, 2);

      -- Operativo
      SELECT @costo = Sum(MO.costo)
      FROM   planta P,
             mantenimiento M,
             mantenimientooperativo MO
      WHERE  P.id = M.idplanta
             AND M.id = MO.idmantenimiento
             AND P.id = @idPlanta
      GROUP  BY P.id;

      -- Nutriente
      IF( @costo IS NULL )
        SET @costo = 0;

      SELECT @costo += Sum(MP.costoaplicacion)
      FROM   planta P,
             mantenimiento M,
             mantenimiento_producto MP
      WHERE  P.id = M.idplanta
             AND M.id = MP.idmantenimiento
             AND P.id = @idPlanta
      GROUP  BY P.id;

      RETURN @costo;
  END 