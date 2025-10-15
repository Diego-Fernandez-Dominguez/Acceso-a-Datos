
--EJERCICIO 1

create database PJ1DiegoFD

create table SOCIOS(
	DNI varchar(10) primary key,
	Nombre varchar(20) not null,
	Direccion varchar(20),
	Penalizaciones NUMERIC(2) default 0
)

create table LIBROS(
	RefLibro varchar(10) primary key,
	Nombre varchar(30) not null,
	Autor varchar(20) not null,
	Genero varchar(10),
	AñoPublicacion numeric,
	Editorial varchar(10)
)

create table PRESTAMOS(
	DNI varchar(10) not null,
	RefLibro varchar(10) not null,
	FechaPrestamo date not null,
	Duracion numeric(2) default 24
	PRIMARY KEY (DNI, RefLibro, FechaPrestamo)
);

CREATE OR ALTER PROCEDURE listadocuatromasprestados
AS
BEGIN
  
Declare @NombreLibro varchar (30),
@NumP int,
@Genero varchar(10),
@NumLibros int,
@DNISocio varchar(10),
@Fecha varchar(20)

SET @NumLibros = (SELECT COUNT(p.RefLibro) FROM prestamos AS p
INNER JOIN libros AS l ON p.RefLibro=l.RefLibro)

PRINT @NumLibros

if @NumLibros<4
begin
Print 'Hay menos de 4 libros prestados'
end

DECLARE CNumPrestamo CURSOR for
SELECT TOP 4  l.Nombre AS 'Libro', COUNT(p.RefLibro) AS 'Numero de prestamos', l.Genero as 'Genero' FROM prestamos AS p
INNER JOIN libros AS l ON p.RefLibro=l.RefLibro
GROUP BY l.Nombre, l.Genero

OPEN CNumPrestamo
fetch CNumPrestamo into @NombreLibro, @NumP, @Genero
while(@@FETCH_STATUS=0)
BEGIN

PRINT CAST(@NombreLibro AS varchar(20)) +' - '+ CAST(@NumP AS varchar(20)) +' - '+ CAST(@Genero AS varchar(20))
DECLARE CSocio CURSOR for
SELECT p.DNI as 'DNI Socio', p.FechaPrestamo as 'Fecha de prestamo' FROM prestamos AS p
INNER JOIN libros AS l ON l.RefLibro=p.RefLibro
WHERE l.Nombre=@NombreLibro

OPEN CSocio
fetch CSocio into @DNISocio, @Fecha
while(@@FETCH_STATUS=0)
BEGIN
PRINT CAST(@DNISocio AS varchar(20))+' - '+ CAST(@Fecha AS varchar(20))
fetch CSocio into @DNISocio, @Fecha
END
CLOSE CSocio
DEALLOCATE CSocio

fetch CNumPrestamo into @NombreLibro, @NumP, @Genero
END
CLOSE CNumPrestamo
DEALLOCATE CNumPrestamo
END

use PJ1DiegoFD
EXEC listadocuatromasprestados

-----------------------------------
---------VUELTO A HACER------------
-----------------------------------

create or alter procedure listadocuatromasprestados2
as
begin

declare @codLibro varchar(10),
@NumLibros int,
@nombreLibro varchar(30),
@numPrestamo int,
@generoLibro varchar(10),
@dniSocio varchar(10),
@fechaPrestamo date

if not exists (select 1 from LIBROS) OR NOT EXISTS 
				(SELECT 1 FROM SOCIOS) 
    BEGIN
        PRINT 'No hay datos en las tablas.';
    END

SET @NumLibros = (SELECT COUNT(p.RefLibro) FROM prestamos AS p
INNER JOIN libros AS l ON p.RefLibro=l.RefLibro)

PRINT @NumLibros

if @NumLibros<4
begin
Print 'Hay menos de 4 libros prestados'
end


	declare curLibro cursor for
	select top 4 l.reflibro, nombre, COUNT(p.reflibro), Genero
	from LIBROS as l inner join PRESTAMOs as p
	on l.RefLibro=p.RefLibro
	group by Nombre, Genero, l.RefLibro

	open curLibro
	fetch curLibro into @codlibro, @nombrelibro, @numPrestamo, @generoLibro
	while (@@FETCH_STATUS=0)
	begin
	print(concat(@nombrelibro, ' ', @numPrestamo, ' ' , @generoLibro))

	declare curSocio cursor for
	select s.DNI, pr.FechaPrestamo
	from socios as s inner join Prestamos as pr
	on s.DNI=pr.DNI
	where pr.RefLibro=@codLibro

	open curSOcio
	fetch curSocio into @dniSocio, @fechaPrestamo
	while (@@FETCH_STATUS=0)
	begin

	print(concat('	', @dniSocio, ' ', @fechaPrestamo ))

	fetch curSocio into @dniSocio, @fechaPrestamo
	end

	close curSocio
	deallocate curSOcio

	fetch curLibro into @codlibro, @nombrelibro, @numPrestamo, @generoLibro
	end

	close curLibro
	deallocate curLibro

end

exec listadocuatromasprestados2

--EJERCICIO 2

create database PJ2
use PJ2

-- Tablas
CREATE TABLE ALUMNOS (
    DNI VARCHAR(10) NOT NULL PRIMARY KEY,
    APENOM VARCHAR(30),
    DIREC VARCHAR(30),
    POBLA VARCHAR(15),
    TELEF VARCHAR(10)
);

CREATE TABLE ASIGNATURAS (
    COD INT NOT NULL PRIMARY KEY,
    NOMBRE VARCHAR(25) UNIQUE
);

CREATE TABLE NOTAS (
    DNI VARCHAR(10) NOT NULL,
    COD INT NOT NULL,
    NOTA INT,
    CONSTRAINT FK_NOTAS_ALUMNOS FOREIGN KEY (DNI) REFERENCES ALUMNOS(DNI),
    CONSTRAINT FK_NOTAS_ASIGNATURAS FOREIGN KEY (COD) REFERENCES ASIGNATURAS(COD)
);

--Procedure

CREATE OR ALTER PROCEDURE MostrarNotasModulo
    @NombreModulo VARCHAR(25)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ALUMNOS) 
       OR NOT EXISTS (SELECT 1 FROM ASIGNATURAS) 
       OR NOT EXISTS (SELECT 1 FROM NOTAS)
    BEGIN
        PRINT 'Error: No hay datos en las tablas.';
    END

    DECLARE @CodModulo INT;
    SELECT @CodModulo = COD FROM ASIGNATURAS WHERE NOMBRE = @NombreModulo;

    IF @CodModulo IS NULL
    BEGIN
        PRINT 'Error: No existe el módulo.';
    END

    PRINT '- Listado de alumnos del módulo: ' + @NombreModulo + ' -';
    SELECT 
        A.APENOM AS Alumno,
        N.NOTA AS Nota
    FROM NOTAS N
    JOIN ALUMNOS A ON N.DNI = A.DNI
    WHERE N.COD = @CodModulo;

    DECLARE @Suspensos INT = 0, @Aprobados INT = 0, @Notables INT = 0, @Sobresalientes INT = 0;

    SELECT 
        @Suspensos = SUM(CASE WHEN NOTA < 5 THEN 1 ELSE 0 END),
        @Aprobados = SUM(CASE WHEN NOTA BETWEEN 5 AND 6 THEN 1 ELSE 0 END),
        @Notables = SUM(CASE WHEN NOTA BETWEEN 7 AND 8 THEN 1 ELSE 0 END),
        @Sobresalientes = SUM(CASE WHEN NOTA >= 9 THEN 1 ELSE 0 END)
    FROM NOTAS
    WHERE COD = @CodModulo;

    PRINT '------------------------------------------';
    PRINT 'Suspensos: ' + CAST(ISNULL(@Suspensos, 0) AS VARCHAR);
    PRINT 'Aprobados: ' + CAST(ISNULL(@Aprobados, 0) AS VARCHAR);
    PRINT 'Notables: ' + CAST(ISNULL(@Notables, 0) AS VARCHAR);
    PRINT 'Sobresalientes: ' + CAST(ISNULL(@Sobresalientes, 0) AS VARCHAR);
    PRINT '------------------------------------------';

    DECLARE @NotaMax INT, @NotaMin INT;
    SELECT 
        @NotaMax = MAX(NOTA), 
        @NotaMin = MIN(NOTA)
    FROM NOTAS 
    WHERE COD = @CodModulo;

    IF @NotaMax IS NOT NULL
    BEGIN
        PRINT 'Alumnos con la nota más alta (' + CAST(@NotaMax AS VARCHAR) + '):';
        SELECT A.APENOM, N.NOTA 
        FROM NOTAS N JOIN ALUMNOS A ON N.DNI = A.DNI
        WHERE N.COD = @CodModulo AND N.NOTA = @NotaMax;
    END

    IF @NotaMin IS NOT NULL
    BEGIN
        PRINT 'Alumnos con la nota más baja (' + CAST(@NotaMin AS VARCHAR) + '):';
        SELECT A.APENOM, N.NOTA 
        FROM NOTAS N JOIN ALUMNOS A ON N.DNI = A.DNI
        WHERE N.COD = @CodModulo AND N.NOTA = @NotaMin;
    END
END;

EXEC MostrarNotasModulo 'RET';

-- EJERCICIO 3 --

DROP DATABASE PJ3;

CREATE DATABASE PJ3
USE PJ3

CREATE TABLE Productos
(
    CodProducto     VARCHAR(10) NOT NULL,
    Nombre          VARCHAR(20) NOT NULL,
    LineaProducto   VARCHAR(10),
    PrecioUnitario  DECIMAL(10,2),
    Stock           INT,
    CONSTRAINT PK_productos PRIMARY KEY (CodProducto)
);


CREATE TABLE Ventas
(
    CodVenta        VARCHAR(10) NOT NULL,
    CodProducto     VARCHAR(10) NOT NULL,
    FechaVenta      DATE,
    UnidadesVendidas INT,
    CONSTRAINT PK_ventas PRIMARY KEY (CodVenta),
    CONSTRAINT FK_ventas_productos FOREIGN KEY (CodProducto)
        REFERENCES dbo.productos(CodProducto)
);

INSERT INTO productos VALUES ('1','Procesador P133', 'Proc',15000,20);
INSERT INTO productos VALUES ('2','Placa base VX',   'PB',  18000,15);
INSERT INTO productos VALUES ('3','Simm EDO 16Mb',   'Memo', 7000,30);
INSERT INTO productos VALUES ('4','Disco SCSI 4Gb',  'Disc',38000, 5);
INSERT INTO productos VALUES ('5','Procesador K6-2', 'Proc',18500,10);
INSERT INTO productos VALUES ('6','Disco IDE 2.5Gb', 'Disc',20000,25);
INSERT INTO productos VALUES ('7','Procesador MMX',  'Proc',15000, 5);
INSERT INTO productos VALUES ('8','Placa Base Atlas','PB',  12000, 3);
INSERT INTO productos VALUES ('9','DIMM SDRAM 32Mb', 'Memo',17000,12);
 
INSERT INTO ventas VALUES('V1', '2', '22/09/97',2);
INSERT INTO ventas VALUES('V2', '4', '22/09/97',1);
INSERT INTO ventas VALUES('V3', '6', '23/09/97',3);
INSERT INTO ventas VALUES('V4', '5', '26/09/97',5);
INSERT INTO ventas VALUES('V5', '9', '28/09/97',3);
INSERT INTO ventas VALUES('V6', '4', '28/09/97',1);
INSERT INTO ventas VALUES('V7', '6', '02/10/97',2);
INSERT INTO ventas VALUES('V8', '6', '02/10/97',1);
INSERT INTO ventas VALUES('V9', '2', '04/10/97',4);
INSERT INTO ventas VALUES('V10','9', '04/10/97',4);
INSERT INTO ventas VALUES('V11','6', '05/10/97',2);
INSERT INTO ventas VALUES('V12','7', '07/10/97',1);
INSERT INTO ventas VALUES('V13','4', '10/10/97',3);
INSERT INTO ventas VALUES('V14','4', '16/10/97',2);
INSERT INTO ventas VALUES('V15','3', '18/10/97',3);
INSERT INTO ventas VALUES('V16','4', '18/10/97',5);
INSERT INTO ventas VALUES('V17','6', '22/10/97',2);
INSERT INTO ventas VALUES('V18','6', '02/11/97',2);
INSERT INTO ventas VALUES('V19','2', '04/11/97',3);
INSERT INTO ventas VALUES('V20','9', '04/12/97',3);

------Procedure 1a

CREATE OR ALTER PROCEDURE ActualizarStock1a
AS
BEGIN

IF NOT EXISTS (SELECT 1 FROM VENTAS) OR NOT EXISTS (SELECT 1 FROM PRODUCTOS)
    BEGIN
        PRINT 'Error: No hay datos en las tablas.';
        RETURN;
    END

	declare @numVentas int,
	@idProducto varchar(10),
	@cantidadProd int,
	@uVentas int,
	@idVenta varchar(10)

	DECLARE cursor3Ej1 cursor for
	select CodProducto, UnidadesVendidas, CodVenta from Ventas
	
	open cursor3Ej1
	fetch cursor3Ej1 into @idProducto, @uVentas, @idVenta

	while @@FETCH_STATUS = 0
	begin
	set @cantidadProd = (select stock from Productos where @idProducto=CodProducto)
	if (@cantidadProd >= @uVentas)
		begin
		update PRODUCTOS set Stock = Stock- @uVentas
		where CodProducto=@idProducto
		end
	else
		print concat('La venta con codigo ', @idVenta, ' no se pudo añadir')

	fetch cursor3Ej1 into @idProducto, @uVentas, @idVenta
	end

	close cursor3Ej1
	deallocate cursor3Ej1
	end


exec ActualizarStock1a

------Procedure 1b

CREATE OR ALTER PROCEDURE ActualizarStock1b
AS
BEGIN

IF NOT EXISTS (SELECT 1 FROM VENTAS) OR NOT EXISTS (SELECT 1 FROM PRODUCTOS)
    BEGIN
        PRINT 'Error: No hay datos en las tablas.';
        RETURN;
    END

	declare @numVentas int,
	@idProducto varchar(10),
	@cantidadProd int,
	@uVentas int,
	@idVenta varchar(10)

exec ActualizarStock1b




create or alter procedure listadoVentasb
as
begin
	declare @nombreProducto varchar(20),
	@nombreLinea varchar(10),
	@unidadesTotales int,
	@importeTotal int,
	@sumaImporte int
	
	declare lvb cursor for
	select LineaProducto
	from PRODUCTOS

	

	open lVb
	fetch lvb into @nombreLinea
	while @@FETCH_STATUS = 0
	begin
	set @sumaImporte=0
	print(Concat('Linea Producto:' ,@nombreLinea))

	declare lVb2 cursor for
	select Nombre, Stock, (preciounitario*Stock) 
	from PRODUCTOS
	where LineaProducto=@nombreLinea

	open lVb2
	fetch lVb2 into @nombreProducto, @unidadesTotales, @importeTotal

	while @@FETCH_STATUS = 0
	begin
	SET @sumaImporte=@sumaImporte+@importeTotal
	print(concat(@nombreProducto,' ', @unidadestotales,' ', @importetotal))

	fetch lVb2 into @nombreProducto, @unidadesTotales, @importeTotal
	end

	close lVb2
	deallocate lVb2

	fetch lVb into @nombrelinea
	print(concat('Importe total linea ', @nombreLinea, ': ', @sumaImporte))
	print('')
	end

	close lVb
	deallocate lVb
end

exec listadoVentasb