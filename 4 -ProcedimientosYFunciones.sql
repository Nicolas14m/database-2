-- 4 ******** Procedimientos y Funciones **********

USE Obligatorio_BD2_270543_149296_2022;
SET DATEFORMAT dmy;
-- a.

-- Implementar un procedimiento AumentarCostosPlanta que reciba por parámetro: un Id de
--Planta, un porcentaje y un rango de fechas. El procedimiento debe aumentar en el
--porcentaje dado, para esa planta, los costos de mantenimiento que se dieron en ese rango
--de fechas. Esto tanto para mantenimientos de tipo “OPERATIVO” donde se aumenta el
--costo por concepto de mano de obra (no se aumentan las horas, solo el costo) como de
--tipo “NUTRIENTES” donde se debe aumentar los costos por concepto de uso de producto
--(no se debe aumentar ni los gramos de producto usado ni actualizar nada del maestro de
--productos)
--El procedimiento debe retornar cuanto fue el aumento total de costo en dólares para la
--planta en cuestión


CREATE PROCEDURE Spu_AumentarCostosPlanta @idPlanta   INT,
                                                   @procentaje DECIMAL (10, 2),
                                                   @fecha1     DATE,
                                                   @fecha2     DATE,
                                                   @aumento    DECIMAL(10, 2) output
AS
  BEGIN
      DECLARE @existe NUMERIC(6)

      SELECT @existe = Count(*)
      FROM   Mantenimiento M
      WHERE  M.idplanta = @idPlanta

      IF @existe = 0
        PRINT 'Esa planta no tiene mantenimientos registrados.'
      ELSE
        BEGIN
            DECLARE @costoInicial DECIMAL(10, 2);
            DECLARE @costoFinal DECIMAL(10, 2);

            SET @costoInicial = dbo.Costomantenimientoporid(@idPlanta);

            UPDATE mantenimientooperativo
            SET    costo = costo + costo * ( @procentaje / 100 )
            WHERE  idmantenimiento IN (SELECT id
                                       FROM   mantenimiento
                                       WHERE  idplanta = @idPlanta
                                              AND fechamantenimiento BETWEEN
                                                  @fecha1 AND @fecha2);

            UPDATE mantenimiento_producto
            SET    costoaplicacion = costoaplicacion + costoaplicacion * (
                                                       @procentaje / 100 )
            WHERE  idmantenimiento IN (SELECT id
                                       FROM   mantenimiento
                                       WHERE  idplanta = @idPlanta
                                              AND fechamantenimiento BETWEEN
                                                  @fecha1 AND @fecha2);

            SET @costoFinal = dbo.Costomantenimientoporid(@idPlanta);
            SET @aumento = @costoFinal - @costoInicial;
        END
  END

---- Prueba de aumento de la planta 2 para los mantenimientos del año 2022

---- Calculamos solo el costo del 2022 
--  declare @costo as decimal (10,2)
--  set @costo = dbo.CostoMantenimientoPorAnio(2, 2022);
--  print @costo

---- Aumentamos usando la función un 10% a la planta 2
--  declare @retornoAumento as decimal(10,2);
--  EXEC dbo.Spu_AumentarCostosPlanta 2, 10, '01/01/2022', '31/12/2022', @retornoAumento output
--  print @retornoAumento


--b.
--	 Mediante una función que recibe como parámetro un año: retornar el costo promedio de
--   los mantenimientos de tipo “OPERATIVO” de ese añoCREATE FUNCTION AvgCostoOperativoPorAnio(@anio AS INT)
returns DECIMAL(10, 2)
AS
  BEGIN
      DECLARE @costo AS DECIMAL (10, 2);

      SELECT @costo = Avg(MO.costo)
      FROM   mantenimiento M,
             mantenimientooperativo MO
      WHERE  M.id = MO.idmantenimiento
             AND Year(M.fechamantenimiento) = @anio

      IF( @costo IS NULL )
        SET @costo = 0;

      RETURN @costo
  END 


  -- Prueba costos operativo 2021
 --declare @AvgCostoOperativo as decimal (10,2);
 --declare @anio as int;

 --set @anio = 2021;
 --set @AvgCostoOperativo = dbo.AvgCostoOperativoPorAnio(@anio);
 --print 'El promedio de costo operativo para el año fue de ' + CONVERT(varchar(4), @anio ) + ': ' + CONVERT(varchar(20), @AvgCostoOperativo);

 --select AVG(MantenimientoOperativo.costo) from MantenimientoOperativo, Mantenimiento 
 --where MantenimientoOperativo.idmantenimiento = Mantenimiento.id 
 --AND year(Mantenimiento.fechamantenimiento) = 2021;