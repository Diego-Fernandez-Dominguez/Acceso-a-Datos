use SCOTT


/*Ejercicio 1

Haz una función llamada DevolverCodDept que reciba el 
nombre de un departamento y devuelva su código.*/

create or alter function DevolverCodDept 
(
@NombreDept varchar(14)
)
returns int
as
begin
return(
select DEPTNO from DEPT
WHERE DNAME=@NombreDept
)

end

select * from DEPT

select dbo.DevolverCodDept('SALES') as 'Codigo'

/*Ejercicio 2

Realiza un procedimiento llamado HallarNumEmp que recibiendo 
un nombre de departamento, muestre en pantalla el número de 
empleados de dicho departamento. Puedes utilizar la función 
creada en el ejercicio 1.

Si el departamento no tiene empleados deberá mostrar un mensaje 
informando de ello. Si el departamento no existe se tratará 
la excepción correspondiente.*/

create or alter procedure HallarNumEmp
(
@NombreDept varchar(14)
)
as
begin
declare @CodigoDept int,
@NumEmpl int
set @CodigoDept=dbo.DevolverCodDept(@NombreDept)

set @NumEmpl=(select count(EMPNO) from EMP where DEPTNO=@CodigoDept)

if @CodigoDept is null
print 'El departamento no existe'

else
if @NumEmpl=0
print 'El departamento no tiene empleados'

else
print CONCAT('El departamento tiene ' , @NumEmpl , ' empleados')

end

exec HallarNumEmp 'SALES'

/*Ejercicio 3

Realiza una función llamada CalcularCosteSalarial que reciba un nombre de 
departamento y devuelva la suma de los salarios y comisiones de los empleados 
de dicho departamento. Trata las excepciones que consideres necesarias.*/

create or alter function CalcularCosteSalarial(
@NombreDept varchar(14)
)
returns real
as
begin
declare @SumaTodito real,
@CodigoDeptEJ4 int
set @CodigoDeptEJ4=dbo.DevolverCodDept(@NombreDept)

set @SumaTodito=(select sum(sal)+SUM(COMM) from EMP WHERE DEPTNO=@CodigoDeptEJ4)
return @SumaTodito
end

select dbo.CalcularCosteSalarial('ACCOUNTING') AS 'Dinero'

/*Ejercicio 4 Cr

Realiza un procedimiento MostrarCostesSalariales que muestre los nombres de todos los 
departamentos y el coste salarial de cada uno de ellos. Puedes usar la función del ejercicio 3.*/

create or alter procedure MostrarCostesSalariales
as
begin
declare @DeptN varchar (17),
@CostSal decimal (7,2)

declare cur4 cursor for
select DNAME, sum(SAL) as 'Salario' from DEPT as D inner join EMP as E
on E.DEPTNO=D.DEPTNO
group by DNAME

open cur4

fetch cur4 into @DeptN, @CostSal


while @@FETCH_STATUS = 0
begin

print CONCAT(@DeptN ,' - ', @CostSal)
fetch cur4 into @DeptN, @CostSal

end

close cur4
deallocate cur4
end

exec MostrarCostesSalariales


/*------------ NO CR ---------*/

create or alter procedure MostrarCostesSalariales2
as
begin
select DNAME, sum(SAL) as 'Salario' from DEPT as D inner join EMP as E
on E.DEPTNO=D.DEPTNO
group by DNAME
end

exec MostrarCostesSalariales2


/*Ejercicio 5

Realiza un procedimiento MostrarAbreviaturas que muestre las tres primeras letras del nombre de 
cada empleado.*/

create or alter procedure MostrarAbreviaturas
as
begin
select ename, left(ENAME,1) as 'First letter' from EMP
end

exec MostrarAbreviaturas


/*Ejercicio 6 cr ---------------ESTA MAL--------------

Realiza un procedimiento MostrarMasAntiguos que muestre el nombre del empleado más antiguo de cada 
departamento junto con el nombre del departamento. Trata las excepciones que consideres necesarias.*/


create or alter procedure MostrarMasAntiguos
as
begin
declare @EmpName varchar(150),
@DeptName varchar(17),
@Fecha date

declare cur6 cursor for
select ename, dname, HIREDATE from EMP as E inner join DEPT AS D
on D.DEPTNO=E.DEPTNO
where HIREDATE in (select MIN(hiredate) from EMP group by DEPTNO)

open cur6

fetch cur6 into @EmpName, @DeptName, @Fecha
while @@FETCH_STATUS = 0
begin

print concat(@EmpName, ' - ', @DeptName,' - ' ,@Fecha)
fetch cur6 into @EmpName, @DeptName, @Fecha

end

close cur6
deallocate cur6

end

exec MostrarMasAntiguos

/*------------ NO CR --------- ENCIMA MAL */

create or alter procedure MostrarMasAntiguos2
as
begin
select top 1 ename from EMP
order by HIREDATE ASC
end

exec MostrarMasAntiguos2

select * from EMP


/*Ejercicio 7 CR 

Realiza un procedimiento MostrarJefes que reciba el nombre de un departamento y muestre los
nombres de los empleados de ese departamento que son jefes de otros empleados.Trata las 
excepciones que consideres necesarias.*/

create or alter procedure MostrarJefes  
    @NombreDepto varchar(14)  
as  
begin  

declare @CodigoDept int,  
@EmpId int,
@EmpNombre varchar(10) 

set @Codigodept = dbo.DevolverCodDept(@nombredepto)

if @CodigoDept is null  
begin  
print 'Departamento no existe'
return;  
end  

declare cur cursor for  
select empno, ename  
from emp  
where deptno = @codigodept 

open cur
fetch cur into @empid, @empnombre
while @@fetch_status = 0  
begin  
if exists (  
select 1  
from emp  
where mgr = @empid  
)  
begin  
print @empnombre;  
end  
fetch cur into @empid, @empnombre
end  

close cur
deallocate cur
end

exec MostrarJefes 'RESEARCH'

/*Ejercicio 8

Realiza un procedimiento MostrarMejoresVendedores que muestre los nombres de los dos vendedores con 
más comisiones. Trata las excepciones que consideres necesarias.*/

create or alter procedure MostrarMejoresVendedores
as
begin
select top 2 ename, comm
from EMP
order by COMM DESC
end

exec MostrarMejoresVendedores

select * from EMP

/*Ejercicio 10
Realiza un procedimiento RecortarSueldos que recorte el sueldo un 20% a los empleados cuyo nombre
empiece por la letra que recibe como parámetro. Trata las excepciones que consideres necesarias*/

create or alter procedure RecortarSueldos (
@LetraDesgracia varchar(1)
)
as
begin

update emp set sal = sal- (sal * 0.2)
where left(ENAME,1)=@LetraDesgracia

end

exec RecortarSueldos 'K' 

SELECT * FROM EMP

/* Ejercicio 11 cr
 
Realiza un procedimiento BorrarBecarios que borre a los dos empleados más nuevos de cada 
departamento. Trata las excepciones que consideres necesarias.*/

create or alter procedure BorrarBecarios
as
begin

declare @EmpCod int,
@EmpName varchar(150),
@DeptCod varchar(17),
@Fecha date

declare cur11 cursor for 
select empno, ename, deptno, hiredate from EMP
where HIREDATE in (select top 2 MAX(HIREDATE) from EMP group by DEPTNO)
group by DEPTNO

open cur11

fetch cur11 into @EmpCod ,@EmpName, @DeptCod, @Fecha
while @@FETCH_STATUS =0
begin

delete from EMP where EMPNO = @EmpCod

print concat('Empleado despedido: ', @empcod, @EmpName, ' - ', @DeptCod,' - ' ,@Fecha)

fetch cur11 into @EmpCod ,@EmpName, @DeptCod, @Fecha

end

close cur11
deallocate cur11

end

exec BorrarBecarios

select * from EMP