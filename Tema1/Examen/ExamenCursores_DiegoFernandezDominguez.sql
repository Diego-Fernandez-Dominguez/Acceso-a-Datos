create database cursores2526Diego

use cursores2526Diego

--Creacion de las tablas
CREATE TABLE EMPLEADOS (
 IdEmpleado VARCHAR(10) PRIMARY KEY,
 Nombre VARCHAR(30) NOT NULL,
 Ciudad VARCHAR(20),
 PuntosFidelidad INT DEFAULT 0
);
CREATE TABLE PRODUCTOS (
 CodProducto VARCHAR(10)PRIMARY KEY,
 Nombre VARCHAR(30) NOT NULL,
 Categoria VARCHAR(20),
 Precio DECIMAL(8,2),
 Stock INT
);
CREATE TABLE VENTAS (
 IdEmpleado VARCHAR(10) ,
 CodProducto VARCHAR(10),
 FechaVenta DATE NOT NULL,
 Cantidad INT DEFAULT 1,
 primary key (idEmpleado, CodProducto, fechaVenta),
 FOREIGN KEY (idEmpleado) REFERENCES EMPLEADOS(idEmpleado),
 FOREIGN KEY (CodProducto) REFERENCES PRODUCTOS(CodProducto)
);--Insert de las tablasINSERT INTO EMPLEADOS VALUES
('C01', 'Laura Pérez', 'Madrid', 150),
('C02', 'Juan Gómez', 'Barcelona', 80),
('C03', 'Ana López', 'Sevilla', 120),
('C04', 'Pedro Ruiz', 'Valencia', 60),
('C05', 'Marta Díaz', 'Bilbao', 40);
INSERT INTO PRODUCTOS VALUES
('P01', 'Camiseta Roja', 'Ropa', 19.99, 50),
('P02', 'Pantalón Jeans', 'Ropa', 39.99, 30),
('P03', 'Zapatillas Running', 'Calzado', 59.99, 20),
('P04', 'Sudadera Negra', 'Ropa', 29.99, 25),
('P05', 'Mochila Deportiva', 'Accesorios', 24.99, 15);
INSERT INTO VENTAS VALUES
('C01', 'P01', '2024-10-01', 2),
('C02', 'P01', '2024-10-02', 1),
('C03', 'P02', '2024-10-03', 1),
('C04', 'P02', '2024-10-04', 3),
('C05', 'P03', '2024-10-05', 1),
('C01', 'P03', '2024-10-06', 2),
('C02', 'P03', '2024-10-07', 1),
('C03', 'P04', '2024-10-08', 1),
('C01', 'P05', '2024-10-09', 1);

create or alter procedure ListadoTresMasVendidos
as
begin

--Error si no existe la tabla productos
if not exists (select 1 from PRODUCTOS)
begin 
print('La tabla productos esta vacia')
return ''
end

--Error si no existe la tabla ventas
else if not exists (select 1 from VENTAS)
begin
print('La tabla ventas esta vacia')
return ''
end

--Declaracion de variables
declare @numVentasTotales int,
@idProducto varchar(10),
@nombreProducto varchar(30),
@numVentasProductos int,
@categoriaProducto varchar(20),
@idEmpleado varchar(10),
@nombreEmpleado varchar(30),
@fechaVenta date

--Error menos de tres ventas
set @numVentasTotales= (select count(CodProducto) from VENTAS)
if (@numVentasTotales < 3)
begin
print('Se han realizado menos de 3 ventas')
return
end


--Cursor Productos
declare cursorCaracProduct cursor for
select top 3 count(v.CodProducto), p.CodProducto ,Nombre ,Categoria
from PRODUCTOS as p inner join VENTAS as V
on	p.CodProducto=V.CodProducto
where p.CodProducto=V.CodProducto
group by p.CodProducto, Nombre, Categoria

open cursorCaracProduct
fetch cursorCaracProduct into @numVentasProductos, @idProducto, @nombreProducto, @categoriaProducto

while(@@FETCH_STATUS=0)
begin

--Print Exterior
print(concat(@nombreProducto, ' ', @numVentasProductos, ' ', @categoriaProducto, ' ' ))

--Cursor anidado
declare cursorEmpleados cursor for
select e.idEmpleado, Nombre, fechaVenta
from EMPLEADOS as e inner join VENTAS as v
on e.IdEmpleado=v.IdEmpleado
where v.CodProducto=@idProducto

open cursorEmpleados
fetch cursorEmpleados into @idEmpleado, @nombreEmpleado, @fechaVenta
while(@@FETCH_STATUS=0)
begin

--Print interior
print(concat('	', @idEmpleado, ' ', @nombreEmpleado, ' ', @fechaVenta))

--Fetch cursor interior
fetch cursorEmpleados into @idEmpleado, @nombreEmpleado, @fechaVenta
end

--Cierro del cursor interior
close cursorEmpleados
deallocate cursorEmpleados

--Fetch cursor exterior
fetch cursorCaracProduct into @numVentasProductos, @idProducto, @nombreProducto, @categoriaProducto
end

--Cierre del cursor exterior
close cursorCaracProduct
deallocate cursorCaracProduct

end

--Ejecucion del procedimiento
exec ListadoTresMasVendidos