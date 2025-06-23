

declare @mensaje varchar(100)
set @mensaje = 'Hola Mundo...'
Print @mensaje
Go

-- simar dos numero
DECLARE @numero_uno int = 30, @numero_dos int = 70, @suma int
SET @suma = @numero_uno + @numero_dos
PRINT 'El valor de la sumatoria es: ' + CAST(@suma AS VARCHAR)
GO


--candeas de texto
DECLARE @nombre varchar(60), @apellido varchar(90)
SET @nombre = 'Pamela'
SET @apellido = 'Raupa Velásquez'
PRINT 'Persona: ' + UPPER(@apellido) + ', ' + @nombre

-- 4. Calcular la deda de una persona a partir de su fecha de nacimieinto 
SET DATEFORMAT dmy;
DECLARE @fecha_nacimiento date, @edad int
SET @fecha_nacimiento = '06/06/1999'
SET @edad = DATEDIFF(year, @fecha_nacimiento, GETDATE())
PRINT 'Tu edad es: ' + CONVERT(varchar(3), @edad)


--como hacer el formato de la moneda , el resultado sea en dolares
--5. Calcular total para factura
DECLARE @monto decimal(8,2) = 1000, @igv decimal(8,2), @total decimal(8,2)
SET @igv = @monto * 0.18
SET @total = @monto + @igv
PRINT 'El monto es: ' + CONVERT(varchar(10), @monto)
PRINT 'El IGV es: ' + CONVERT(varchar(10), @igv)
PRINT 'El total es: ' + CONVERT(varchar(10), @total)


-- A. Ejemplo de FORMATO simple
PRINT 'A. Formato simple:'
PRINT 'Monto: $' + CONVERT(varchar(20), @monto)
PRINT 'IGV: $' + CONVERT(varchar(20), @igv)
PRINT 'Total: $' + CONVERT(varchar(20), @total)
PRINT ''

-- B. FORMATO con cadenas de formato personalizadas (SQL Server 2012+)
PRINT 'B. Formato personalizado:'
PRINT FORMAT(@monto, '$#,##0.00')
PRINT FORMAT(@igv, '$#,##0.00')
PRINT FORMAT(@total, '$#,##0.00')
PRINT ''

-- C. FORMATO con tipos numéricos
PRINT 'C. Formato con tipos numéricos:'
PRINT 'Monto: ' + FORMAT(@monto, 'C', 'en-US')
PRINT 'IGV: ' + FORMAT(@igv, 'C', 'en-US')
PRINT 'Total: ' + FORMAT(@total, 'C', 'en-US')
PRINT ''

-- D. FORMATO con STR (alternativa para versiones anteriores)
PRINT 'D. Formato con STR:'
PRINT 'Monto: $' + LTRIM(STR(@monto, 10, 2))
PRINT 'IGV: $' + LTRIM(STR(@igv, 10, 2))
PRINT 'Total: $' + LTRIM(STR(@total, 10, 2))

use dbEnrollment
--1.- Obtener datos de profesor a partr de su id

SELECT * FROM TEACHERS;
SET DATEFORMAT dmy;
DECLARE @id int = 1, @fecha_registro date, @nombres varchar(60), @apellidos varchar(100)
DECLARE @especialidad varchar(90), @celular char(9), @correo varchar(100)

SELECT
    @fecha_registro = register_date,
    @nombres = names,
    @apellidos = last_names,
    @especialidad = specialty,
    @celular = phone,
    @correo = email
FROM TEACHERS
WHERE id = @id;

-- Agregar los prints
PRINT 'Datos del Profesor:'
PRINT 'ID: ' + CAST(@id AS varchar(10))
PRINT 'Fecha de Registro: ' + CONVERT(varchar(10), @fecha_registro, 103)
PRINT 'Nombres: ' + @nombres
PRINT 'Apellidos: ' + @apellidos
PRINT 'Especialidad: ' + @especialidad
PRINT 'Celular: ' + @celular
PRINT 'Correo: ' + @correo

-- 2 .- A partie de id de carrera odtener nombre de carrera , cruso y profesor respectivo 


DECLARE @id_carrera int = 2; -- Puedes cambiar este valor al ID de carrera que necesites
DECLARE @nombre_carrera varchar(90);
DECLARE @descripcion varchar(2500);
DECLARE @duracion int;
DECLARE @resultado varchar(MAX) = '';

-- Obtener información básica de la carrera
SELECT 
    @nombre_carrera = names,
    @descripcion = descriptions,
    @duracion = durations
FROM careers
WHERE id = @id_carrera;

-- Construir el encabezado del reporte
SET @resultado = 'REPORTE DE CARRERA' + CHAR(13) + CHAR(10);
SET @resultado = @resultado + '====================' + CHAR(13) + CHAR(10);
SET @resultado = @resultado + 'Carrera: ' + @nombre_carrera + CHAR(13) + CHAR(10);
SET @resultado = @resultado + 'Duración: ' + CAST(@duracion AS varchar(2)) + ' ciclos' + CHAR(13) + CHAR(10);
SET @resultado = @resultado + 'Descripción: ' + @descripcion + CHAR(13) + CHAR(10);
SET @resultado = @resultado + CHAR(13) + CHAR(10);
SET @resultado = @resultado + 'CURSOS Y PROFESORES:' + CHAR(13) + CHAR(10);
SET @resultado = @resultado + '====================' + CHAR(13) + CHAR(10);

-- Obtener los cursos y profesores
DECLARE @curso_nombre varchar(100);
DECLARE @creditos int;
DECLARE @profesor_nombre varchar(70);
DECLARE @profesor_apellido varchar(150);
DECLARE @especialidad varchar(120);

DECLARE curso_cursor CURSOR FOR
SELECT 
    cr.names,
    cr.credits,
    t.names,
    t.last_names,
    t.specialty
FROM 
    CAREERS_DETAIL cd
JOIN 
    course cr ON cd.course_code = cr.code
JOIN 
    TEACHERS t ON cd.teachers_id = t.id
WHERE 
    cd.careers_id = @id_carrera
ORDER BY 
    cr.names;

OPEN curso_cursor;
FETCH NEXT FROM curso_cursor INTO @curso_nombre, @creditos, @profesor_nombre, @profesor_apellido, @especialidad;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @resultado = @resultado + '• Curso: ' + @curso_nombre + CHAR(13) + CHAR(10);
    SET @resultado = @resultado + '  Créditos: ' + CAST(@creditos AS varchar(2)) + CHAR(13) + CHAR(10);
    SET @resultado = @resultado + '  Profesor: ' + @profesor_apellido + ', ' + @profesor_nombre + CHAR(13) + CHAR(10);
    SET @resultado = @resultado + '  Especialidad: ' + @especialidad + CHAR(13) + CHAR(10);
    SET @resultado = @resultado + CHAR(13) + CHAR(10);
    
    FETCH NEXT FROM curso_cursor INTO @curso_nombre, @creditos, @profesor_nombre, @profesor_apellido, @especialidad;
END

CLOSE curso_cursor;
DEALLOCATE curso_cursor;

-- Mostrar el resultado final
PRINT @resultado;


--averiguar sobre el plan de ejecucon en sql server . tunnig de base de datos 


SET DATEFORMAT dmy;
DECLARE @fecha_nac date, @edades int
SET @fecha_nac = '11/12/1999'
SET @edades = DATEDIFF(year, @fecha_nac, GETDATE())
IF @edades >= 18
BEGIN
    PRINT 'Tu edad es: ' + CONVERT(varchar(2), @edades)
    PRINT 'Eres mayor de edad'
END
ELSE
BEGIN
    PRINT 'Tu edad es: ' + CONVERT(varchar(2), @edades)
    PRINT 'Eres menor de edad'
END
GO
