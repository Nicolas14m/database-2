-- 3 ******** Consultas ********

USE Obligatorio_BD2_270543_149296_2022;

--a. Mostrar Nombre de Planta y Descripción del Mantenimiento para el último(s)
-- mantenimiento hecho en el año actualSELECT P.nombrepopular,
       M.descripcion
FROM   planta P,
       mantenimiento M
WHERE  P.id = M.idplanta
       AND M.fechamantenimiento = (SELECT Max(M2.fechamantenimiento)
                                   FROM   mantenimiento M2
                                   WHERE  Year(M2.fechamantenimiento) = Year(
                                          Getdate())
                                  ) ;-- sorgo, palo borracho -- 2022-08-12select Max(M.fechamantenimiento) from mantenimiento M where year(M.fechamantenimiento)= Year(Getdate());select * from Mantenimiento;select * from planta;
-- b. Mostrar la(s) plantas que recibieron más cantidad de mantenimientos

SELECT P.id,
       P.nombrepopular,
	   Count(*) as 'Cantidad Mantenimientos'
FROM   planta P,
       mantenimiento M
WHERE  P.id = M.idplanta
GROUP  BY P.id,
          P.nombrepopular
HAVING Count(*) >= ALL (SELECT Count(*)
                        FROM   mantenimiento
                        GROUP  BY idplanta);
						
SELECT idplanta, Count(*)FROM mantenimiento GROUP BY idplanta;
select * from planta;

-- c. Mostrar las plantas que este año ya llevan más de un 20% de costo de mantenimiento
--que el costo de mantenimiento de todo el año anterior para la misma planta ( solo
--considerar plantas nacidas en el año 2019 o antes)
SELECT P.id,
       P.nombrepopular
FROM   planta P
WHERE  dbo.Costomantenimientoporanio(P.id, Year(Getdate())) >
       dbo.Costomantenimientoporanio(P.id, Year(Getdate()) - 1) * 0.20
	   AND dbo.Costomantenimientoporanio(P.id, Year(Getdate()) - 1) > 0
       AND Year(p.fechanac) <= 2019; 

--Arbol del paraiso, Aleluja, Eucaliptus
SELECT P.id, P.nombrepopular, P.nombrepopular,dbo.Costomantenimientoporanio(P.id, Year(Getdate())) FROM planta P;
SELECT P.id, P.nombrepopular, P.nombrepopular,dbo.Costomantenimientoporanio(P.id, Year(Getdate())-1) * 0.2 FROM planta P;
--SELECT P.id, P.nombrepopular, P.nombrepopular,dbo.Costomantenimientoporanio(P.id, Year(Getdate())) FROM planta P;
select * from planta P where Year(p.fechanac) <= 2019;

-- d. Mostrar las plantas que tienen el tag “FRUTAL”, a la vez tienen el tag “PERFUMA” y no
--tienen el tag “TRONCOROTO”. Y que adicionalmente miden medio metro de altura o
-- más y tienen un precio de venta establecido
SELECT P.id,
       P.nombrepopular,
       P.altura,
       P.precioventa
FROM   planta P
WHERE  P.altura >= 50
       AND P.precioventa IS NOT NULL
       AND p.id IN (SELECT PT.idplanta
                    FROM   planta_tag Pt,
                           tag T
                    WHERE  T.id = Pt.idtag
                           AND T.nombre = 'PERFUMA')
       AND p.id IN (SELECT PT.idplanta
                    FROM   planta_tag Pt,
                           tag T
                    WHERE  T.id = Pt.idtag
                           AND T.nombre = 'FRUTAL')
		AND p.id NOT IN (SELECT PT.idplanta
                    FROM   planta_tag Pt,
                           tag T
                    WHERE  T.id = Pt.idtag
                           AND T.nombre = 'TRONCOROTO');

-- ciruelo, eucaliptus
select P.nombrepopular, P.altura, P.precioventa,T.nombre 
from planta P, tag T, Planta_tag PT where p.id= PT.idplanta and PT.idtag = t.id;

--e. Mostrar las Plantas que recibieron mantenimientos que en su conjunto incluyen todos
--los productos existentes
				
SELECT P.id,
       P.nombrepopular
FROM   Planta P,
       Mantenimiento M,
       Mantenimiento_Producto MP
WHERE  P.id = M.idplanta
       AND M.id = MP.idmantenimiento
GROUP  BY P.id,
          P.nombrepopular
HAVING Count(DISTINCT MP.codprod) = (SELECT Count(*)
                                     FROM   producto); 

-- Arbol del Paraiso, Eucaliptus
SELECT P.id,
       P.nombrepopular,
	   PR.codprod
FROM   Planta P,
       Mantenimiento M,
       Mantenimiento_Producto MP,
	   Producto PR
WHERE  P.id = M.idplanta
       AND M.id = MP.idmantenimiento AND PR.codprod = MP.codprod
order by P.id;

select * from Producto;

--f. Para cada Planta con 2 años de vida o más y con un precio menor a 200 dólares:
--sumarizar su costo de Mantenimiento total ( contabilizando tanto mantenimientos de
--tipo “OPERATIVO” como de tipo “NUTRIENTES”) y mostrar solamente las plantas que
--su costo sumarizado es mayor que 100 dólares.

SELECT P.id,
       p.nombrepopular,
       dbo.Costomantenimientoporid(P.id) AS 'Costo Mantenimiento Total',
	   p.fechaNac,
	   p.precioventa
FROM   planta P
WHERE  P.precioventa < 200
       AND Datediff(year, p.fechanac, Getdate()) >= 2
       AND dbo.Costomantenimientoporid(P.id) > 100;

-- Arbol del Paraiso, Bledo, Chumbera, Sorgo, Eucaliptus
select P.nombrepopular, P.fechanac, P.precioventa, dbo.Costomantenimientoporid(P.id) as costoMantenimiento from planta p;