-- 4. ******** Triggers ********

USE Obligatorio_BD2_270543_149296_2022;

-- a. Auditar cualquier cambio del maestro de Productos. Se debe llevar un registro detallado de
--las inserciones, modificaciones y borrados, en todos los casos registrar desde que PC se
--hacen los movimientos, la fecha y la hora, el usuario y todos los datos que permitan una
--correcta auditoría (si son modificaciones que datos se modificaron, qué datos había antes,
--que datos hay ahora, etc). La/s estructura/s necesaria para este punto es libre y queda a
--criterio del alumno

CREATE TRIGGER TrgRegistro_Historico_Prod
ON Producto
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @operacion CHAR(8)
		SET @operacion = CASE
				WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
					THEN 'Update'
				WHEN EXISTS(SELECT * FROM inserted)
					THEN 'Insert'
				WHEN EXISTS(SELECT * FROM deleted)
					THEN 'Delete'
				ELSE NULL
		END
	IF @operacion = 'Delete'
			INSERT INTO RegistroHistoricoProd (Operacion, FechaOperacion, CodProd, NomAnterior, DescAnterior, PrecioPorGrmAnterior, Usuario, Pc)
			SELECT @operacion, GETDATE(),  d.codProd, d.nombre, d.descripcion, d.precioPorGramo, CURRENT_USER, CONVERT(varchar(50),SERVERPROPERTY('MachineName')) 
			FROM deleted d
 
	IF @operacion = 'Insert'
			INSERT INTO RegistroHistoricoProd (Operacion, FechaOperacion, CodProd,  NomNuevo, DescNueva, PrecioPorGrmNuevo, Usuario, Pc)
			SELECT @operacion, GETDATE(), i.codProd, i.nombre, i.descripcion, i.precioPorGramo, CURRENT_USER, CONVERT(varchar(50),SERVERPROPERTY('MachineName')) 
			FROM inserted i
 
	IF @operacion = 'Update'
			INSERT INTO RegistroHistoricoProd (Operacion, FechaOperacion, CodProd, NomNuevo, NomAnterior, DescNueva, DescAnterior, PrecioPorGrmNuevo, 
			PrecioPorGrmAnterior, Usuario, Pc)
			SELECT @operacion, GETDATE(), i.codProd, i.nombre, d.nombre, i.descripcion, d.descripcion, i.precioPorGramo, d.precioPorGramo, CURRENT_USER, 
			CONVERT(varchar(50),SERVERPROPERTY('MachineName')) 
			FROM deleted d, inserted i
END

-- Prueba de operaciones con productos para ver el funcionamiento del Registro Historico

--INSERT INTO Producto VALUES 
--('FERES','Fertilizante Especial', 'Fertilizante especial', 1.75), 
--('FIBP1','Fibra de Palmera', 'Nutriente para la tierra a base de palmeras', 0.5),
--('FIBX1','Fibra de Xi', 'Fibra china importada', 2.5)

--DELETE FROM Producto WHERE codprod = 'FERES';

--UPDATE Producto SET descripcion = 'Nutriente a base de palmeras' where codprod = 'FIBP1'; 

---- Para ver los log en la tabla:
--SELECT * FROM RegistroHistoricoProd


-- b. Controlar que no se pueda dar de alta un mantenimiento cuya fecha-hora es menor que la
-- fecha de nacimiento de la planta

CREATE TRIGGER trgCheckFechaNacimiento
ON mantenimiento
instead OF INSERT, UPDATE
AS
  BEGIN
      IF NOT EXISTS(SELECT *
                    FROM   inserted)
        RETURN

      IF NOT EXISTS(SELECT *
                    FROM   inserted)
         AND NOT EXISTS(SELECT *
                        FROM   deleted)
        RETURN

      INSERT INTO mantenimiento
      SELECT I.idplanta,
             I.fechamantenimiento,
             I.descripcion,
             I.tipo
      FROM   inserted I
             LEFT JOIN planta p
                    ON p.id = I.idplanta
      WHERE  I.fechamantenimiento >= p.fechanac;
  END

 
 -- Prueba de funcionamiento con 3 Inserts en mantenimiento, uno no cumpliendo la condición.

--INSERT INTO Mantenimiento VALUES
--(10,'2023-02-19T11:00:00', 'Poda de Hojas', 'Operativo'), -- Se registra
--(10,'2016-04-11T11:00:00', 'Trasplante de maceta', 'Operativo'), -- NO se registra, la fecha de mantenimiento es menor al nacimiento de la planta 10.
--(10,'2023-03-05T11:00:00', 'Hacer esquejes', 'Operativo'); -- Se registra

--select * from mantenimiento;