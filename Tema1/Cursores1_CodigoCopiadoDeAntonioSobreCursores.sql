use TransactSql

/* SQL est� dise�ado de forma transaccional, es decir, una select o un
update se trae todos los registros que cumplan el where y en el caso
del update, actualiza todos los registros.

En algunos casos, necesitamos recorrer registro a registro para procesar
individualmente cada fila. 
Para lograr esto, necesitamos cursores, para procesar cada fila obtenida
en la select o update.

Hay muchas discursiones donde se recomienda evitar el uso de cursores,
pues sql trata cada registro de forma individual, y el rendimiento del
pc puede disminuir. */

/* Pasos para trabajar cn cursores:
1�) Declarar variables que van a contener los valores de las columnas
que vamos a leer en las SELECT.
--En este ejemplo leemos el n�m, nombre y costo de la materia*/
DECLARE @numero char(4), @nombre varchar(50), @costo decimal (5,2)

/* 2�) Declaramos el cursor. Para crear un cursor, usamos 
DECLARE nombreCursor FOR <sentencia SELECT>.*/
DECLARE materiasComputacion CURSOR
FOR SELECT Mnomateria, Mnombre, Mcostolab
	FROM materia 
	WHERE Mnocarrera = 32

/* 3�) Una vez creado el cursor, lo abrimos usando OPEN NombreCursor */
OPEN materiasComputacion

/* 4�) Leer el 1er registro. Para ello, usamos 
FETCH NEXT FROM NombreCursor.
Cuando lees el cursor, hay que indicar las vbles que vamos a usar para
guardar los valores de cada columna*/
FETCH NEXT FROM materiasComputacion INTO @numero, @nombre, @costo

/* 5�) Crear un bucle para leer cada registro hasta que no haya m�s
registros en el cursor. 
La forma de saber si FETCH fu� exitoso, 
es preguntar si @@FETCH_STATUS = 0
Cualquier otro valor indica que ya no hay registros o existe 
un problema al leerlos */
WHILE @@FETCH_STATUS = 0
BEGIN 
-- L�gica
SELECT 'La materia: ' + @numero + ' - ' + @nombre + ' cuesta: ' 
+ CONVERT(VARCHAR(10), @costo)
-- Antes de continuar con el bucle, intentamos leer otro registro
-- para continuar el bucle con un nuevo registro.
FETCH NEXT FROM materiasComputacion INTO @numero, @nombre, @costo
END
/* 6�) Cuando termina el bucle, cerramos el cursor */
CLOSE materiasComputacion
/* Una buena pr�ctica es borrar el cursor de memoria */
DEALLOCATE materiasComputacion