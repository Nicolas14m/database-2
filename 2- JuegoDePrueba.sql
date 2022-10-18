-- 3 ******** Juego de prueba ********

USE Obligatorio_BD2_270543_149296_2022;
SET DATEFORMAT dmy;

INSERT INTO Planta (nombrePopular, fechaNac, altura, fechaMedicion, precioVenta) VALUES
('Alegria', '20/05/2019', 55, '20/06/2020', 231.50), 
('Arbol del Paraiso', '05/06/2018', 55, '07/06/2019', 115), 
('Bledo', '25/05/2020', 101, '20/06/2020', 95.80),
('Carrizo de las Pampas', '15/12/2021', 500, '03/09/2022', 330), 
('Chumbera', '01/07/1998', 5000, '17/09/2002', 185.50), 
('Falsa Acasia', '01/12/2022', 10.5, '30/12/2022', 50.50),
('Lagartera', '01/01/2022', 7.5, '30/12/2022', null), 
('Mijo', '28/12/2021', null, null, null),
('Sorgo', '20/05/2018', 90.2, '20/04/2022', 150.20),
('Aleluja', '12/06/2017', 700, '03/06/2019', 390),
('Magnolia', '03/11/2018', null, null, 201.50),
('Palo Amarillo', '11/07/2015', 155, '15/07/2016', 145.80),
('Limonero', '13/08/2018', 2000, '19/12/2022', 466),
('Naranjo', '14/05/2012', 1500, '14/06/2022', 650.50),
('Cedro', '19/02/2021', 65.17, '08/10/2022', 155.80),
('Mango', '18/02/2018', 77, '05/01/2019', 190),
('Ciruelo', '22/05/2019', 300, '22/07/2022', 480.90), --17
('Banano', '29/09/2018', 780, '20/06/2022', 266.30),
('Tabaco', '07/04/2018', 80.1, '15/06/2022', 90.20),
('Eucaliptus', '15/07/2018', 65.6, '20/09/2022', 48), -- 20
('Palo Borracho', '07/12/2018', 1800.2, '18/01/2022', 55),
('Fresno', '15/12/2018', 80.3, '14/08/2022', 99),
('Roble', '14/08/2018', null, null, null),
('Palta', '01/08/2002', 150.5, '08/06/2005', 290.20),
('Manzano', '19/05/2009', 78.9, '04/04/2010', 145.21),
('Nogal', '13/10/2018', 350, '20/04/2022', 85.30),
('Palmera', '20/05/2021', 120.5, '20/06/2022', 145.21);


INSERT INTO Tag VALUES
('GIGANTE'), 
('MINIATURA'), 
('SELVATICA'), 
('FRUTAL'), 
('SINFLOR'), 
('CONFLOR'), 
('SOMBRA'), 
('HIERBA'), 
('PERFUMA'),  
('TRONCOROTO'),  
('TRONCODOBLADO'), 
('TRONCORECTO'),
('COLORIDO'),
('EXOTICO'),
('ALTO'),
('INTERIOR'),
('EXTERIOR'),
('MIXTO'),
('NATIVO');

-- Asumimos que al crear la tabla Mantenimiento los id comienzan en 1

INSERT INTO Mantenimiento VALUES
(10,'2022-02-19T11:00:00', 'Poda de Hojas', 'Operativo'), 
(10,'2022-04-11T11:00:00', 'Trasplante de maceta', 'Operativo'), 
(10,'2022-03-05T11:00:00', 'Hacer esquejes', 'Operativo'), 
(10,'2021-05-15T05:00:00', 'Poda ligera', 'Operativo'),
(2,'2022-02-20T10:00:00', 'Trasplante de maceta', 'Operativo'),
(2,'2022-02-11T10:00:00', 'Poda externa', 'Operativo'), 
(2,'2021-07-19T10:00:00', 'Poda ligera interior', 'Operativo'), 
(11,'2021-11-13T11:00:00', 'Se corto alguna rama', 'Operativo'), 
(5,'2005-09-15T05:00:00', 'Se saco tierra', 'Operativo'), 
(5,'2005-07-12T04:00:00', 'Se sacaron caracoles', 'Operativo'),
(18,'2021-07-12T04:00:00', 'Cosecha', 'Operativo'), 
(9,'2022-07-12T04:00:00', 'Poda ligera', 'Operativo'),
(9,'2022-08-12T04:00:00', 'Poda profunda', 'Operativo'),
(20,'2021-07-12T04:00:00', 'Trasplante de maceta', 'Operativo'),
(20,'2022-03-12T04:00:00', 'Agregado de agroquimicos', 'Nutrientes'), 
(3,'2021-07-12T04:00:00', 'Agregado insecticida', 'Nutrientes'),
(3,'2021-09-12T04:00:00', 'Agregado de agroquimicos', 'Nutrientes'),
(10,'2022-05-12T04:00:00', 'Agregado de compost', 'Nutrientes'),
(2,'2022-05-20T04:00:00', 'Agregado de compost importado', 'Nutrientes'),
(2,'2021-05-20T04:00:00', 'Agregado de agroquimicos', 'Nutrientes'),
(20,'2021-05-20T04:00:00', 'Agregado tierra', 'Nutrientes'), 
(20,'2020-05-23T04:00:00', 'Agregado Humus', 'Nutrientes'), 
(10,'2022-05-23T04:00:00', 'Agregado de fertilizante', 'Nutrientes'),
(21,'2022-08-12T04:00:00', 'Agregado de compost', 'Nutrientes'),
(2,'2021-05-20T04:00:00', 'Poda ligera', 'Operativo');


INSERT INTO MantenimientoOperativo VALUES 
(1, 5, 30.5), 
(2, 4, 300.25), 
(3, 5, 25.5),
(4, 2, 20), 
(5, 2, 200),
(6, 2, 15),
(7, 2, 20.30), 
(8, 7, 102.50), 
(9, 2, 25.50), 
(10, 5, 125.50), 
(11, 1, 7.50), 
(12, 5, 80.50), 
(13, 6, 77.50),
(14, 1, 36.50),
(25, 1, 20);

INSERT INTO Producto VALUES 
('FERH1','Fertilizante Sulfato', 'Fertilizante de uso general', 2.5), 
('FIBC1','Fibra de Coco', 'Nutriente para la tierra', 0.5), 
('TRRN1','Tierra con nutrientes', 'Tierra especial para el crecimiento de plantas jovenes', 0.15), 
('HORX1','Hormiguicida Agrimex', 'Para matar todo tipo de hormiga', 2), 
('BIOS1','BioSustrato', 'Mezcla para germinar', 1.5),
('COMP1','Compost', 'Abono rico en nutrientes para la planta', 1.45),
('INSE1','Insecticida Emulcionable', 'Insecticida de uso general', 0.50),
('HUMU1','Humus de Lombriz', 'Humus para nutrir la tierra', 2.95);


INSERT INTO Mantenimiento_Producto (idMantenimiento, codProd, cantUsada) VALUES 
(15, 'FERH1', 15.8),
(15, 'FIBC1', 30.5), 
(15, 'TRRN1', 40), 
(21, 'HORX1', 15),
(21, 'BIOS1', 45.5), 
(21, 'COMP1', 200.5), 
(21, 'INSE1', 10.5), 
(22, 'HUMU1', 300),
(19, 'FERH1', 20.2),
(19, 'FIBC1', 25.5),
(19, 'TRRN1', 1200),
(19, 'HORX1', 450),
(20, 'BIOS1', 5),
(20, 'COMP1', 12),
(20, 'INSE1', 3.2),
(20, 'HUMU1', 3.5),
(16, 'FERH1', 30),
(17, 'BIOS1', 10.5),
(17, 'COMP1', 500),
(18, 'INSE1', 17.5),
(23, 'TRRN1', 50.5),
(23, 'HUMU1', 4.5),
(16, 'INSE1', 3.5),
(15, 'BIOS1', 25), 
(22, 'COMP1', 1.5),
(24, 'COMP1', 18);

-- Asumimos que al crear la tabla Planta los id comienzan en 1
INSERT INTO Planta_Tag VALUES 
(4, 1), 
(9, 1), 
(10, 1), 
(4, 20), 
(9, 20), 
(4, 17), 
(9, 17), 
(2, 11), 
(12, 21),
(15, 12),
(5, 7),
(5, 10),
(15, 7);

select * from planta;
select * from tag;
select * from mantenimiento;
select * from planta_tag;
select * from mantenimientoOperativo;
select * from mantenimiento_producto;
select * from Producto;
