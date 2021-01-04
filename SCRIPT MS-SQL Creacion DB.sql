
/*************************************************************************************************************/
									
									--   CREACION DE LA BASE DE DATOS    --
									
/************************************************************************************************************/

CREATE DATABASE DB_ALQUILER_AUTOS
ON PRIMARY
(
	Name = 'DB_ALQUILER_AUTOS_Data',
	Filename = 'C:\HNL\DB_ALQUILER_AUTOS.MDF',
	Size = 10MB,
	MAXSIZE = 25,
	FILEGROWTH = 2MB
)

LOG ON
(
	Name = 'DB_ALQUILER_AUTOS_Log',
	Filename = 'C:\HNL\DB_ALQUILER_AUTOS.LDF',
	Size = 4MB,
	MAXSIZE = 10,
	FILEGROWTH = 20%
)
GO
-----------ENFOCAR DB---------------------
USE DB_ALQUILER_AUTOS
GO
------------------------------------------	


/*************************************************************************************************************/
									
									--   CREACION DE LAS TABLAS   --
									
/************************************************************************************************************/

CREATE TABLE AUTOS_TB
(
	id_Auto VARCHAR(8) NOT NULL PRIMARY KEY,
	Marca_Auto VARCHAR(20) NOT NULL,
	Modelo_Auto VARCHAR(20) NOT NULL,
	Year_Auto INT NOT NULL,
	Tipo_Estado VARCHAR(10) NOT NULL,

)
GO
/*
		INSERTAR DATOS DE ALGUNOS AUTOS
*/
INSERT INTO AUTOS_TB (id_Auto, Marca_Auto, Modelo_Auto, Year_Auto,Tipo_Estado) 
				VALUES('93625879', 'Hyundai', 'i10', 2017, 'Disponible')
INSERT INTO AUTOS_TB (id_Auto, Marca_Auto, Modelo_Auto, Year_Auto,Tipo_Estado) 
				VALUES('BL365487', 'Suzuki', 'Swift', 2016, 'Ocupado')
INSERT INTO AUTOS_TB (id_Auto, Marca_Auto, Modelo_Auto, Year_Auto,Tipo_Estado) 
				VALUES('AC632578', 'Toyota', 'Corolla', 2016, 'Disponible')
INSERT INTO AUTOS_TB (id_Auto, Marca_Auto, Modelo_Auto, Year_Auto,Tipo_Estado) 
				VALUES('CV457896', 'Nissan', 'xTrail', 2016, 'Ocupado')
INSERT INTO AUTOS_TB (id_Auto, Marca_Auto, Modelo_Auto, Year_Auto,Tipo_Estado) 
				VALUES('78542369', 'Mitsubishi', 'Eclipse', 2018, 'Disponible')
INSERT INTO AUTOS_TB (id_Auto, Marca_Auto, Modelo_Auto, Year_Auto,Tipo_Estado) 
				VALUES('DF458722', 'Hyundai', 'Tucson', 2018, 'Disponible')
INSERT INTO AUTOS_TB (id_Auto, Marca_Auto, Modelo_Auto, Year_Auto,Tipo_Estado) 
				VALUES('BX112893', 'Suzuki', 'Vitara', 2019, 'Ocupado')
INSERT INTO AUTOS_TB (id_Auto, Marca_Auto, Modelo_Auto, Year_Auto,Tipo_Estado) 
				VALUES('AH421128', 'Nissan', 'Navara', 2018, 'Disponible')
INSERT INTO AUTOS_TB (id_Auto, Marca_Auto, Modelo_Auto, Year_Auto,Tipo_Estado) 
				VALUES('12884037', 'Toyota', 'Hilux', 2017, 'Disponible')
INSERT INTO AUTOS_TB (id_Auto, Marca_Auto, Modelo_Auto, Year_Auto,Tipo_Estado) 
				VALUES('BR110974', 'Mitsubishi', 'Mirage', 2017, 'Disponible')

SELECT * FROM AUTOS_TB where Tipo_Estado = 'Disponible'
SELECT * FROM AUTOS_TB where Tipo_Estado = 'OCUPADO'

/*
	CREAR TABLA ALQUILER 
*/
CREATE TABLE ALQUILER_TB

(
	id_Alquiler INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_Cliente VARCHAR(12) NOT NULL,
	Nombre_Cliente VARCHAR(20) NOT NULL,
	Apellido_Cliente VARCHAR(20) NOT NULL,
	Telefono_Cliente VARCHAR(9) NOT NULL,
	id_Auto VARCHAR(8) NOT NULL
CONSTRAINT FK_TB_ALQUILER_TB_ID_AUTO 
FOREIGN KEY (id_Auto) REFERENCES AUTOS_TB(id_Auto)
)
GO

SELECT * FROM ALQUILER_TB


/*
	CREAR TABLA HISTORIAL (NO SE UTILIZA EN EL MODELO FINAL)
*/
CREATE TABLE HISTORIAL_TB
(
	id_Historial INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_Alquiler INT NOT NULL,
	id_Cliente VARCHAR(12) NOT NULL,
CONSTRAINT FK_TB_HISTORIAL_TB_ID_ALQUILER 
FOREIGN KEY (id_Alquiler) REFERENCES ALQUILER_TB(id_Alquiler)
)
GO

/*************************************************************************************************************/
									--     PROCEDIMIENTOS ALMACENADOS  --
									--          NO LOS UTILICE         --
/************************************************************************************************************/

--PROCEDIMIENTO PARA REGISTRAR ALQUILER
CREATE PROCEDURE PROC_Alquiler_Registrar
	@ID_Auto VARCHAR(8),
	@ID_Cliente VARCHAR(12),
	@Nombre VARCHAR(20),
	@Apellido VARCHAR(20),
	@Telefono VARCHAR(9),
	@msgErr VARCHAR(100)= '' OUTPUT
AS
	BEGIN
	BEGIN TRAN
		
		IF (@ID_Auto <> '' AND @ID_Cliente <> '' AND @Nombre <> '' AND @Apellido  <> '' AND  @Telefono <> '')
			BEGIN
				BEGIN TRY
					
					IF EXISTS (SELECT id_Auto FROM AUTOS_TB WHERE id_Auto = @ID_Auto AND Tipo_Estado = 'disponible')
					
					INSERT INTO ALQUILER_TB(id_Cliente, Nombre_Cliente, Apellido_Cliente, Telefono_Cliente, id_Auto)
					VALUES (@ID_Cliente,  @Nombre, @Apellido, @Telefono, @ID_Auto)

					UPDATE AUTOS_TB SET Tipo_Estado = 'Ocupado' WHERE id_auto = @ID_Auto
					
					IF @@ROWCOUNT > 0
					BEGIN
						SET @msgErr = 'Se ha Registrado Exitosamente el Alquiler'
						COMMIT
						END
					ELSE
					BEGIN
						SET @msgErr = 'No se Registró. Verifique los Campos Solicitados'
						ROLLBACK
						END
				END TRY

				BEGIN CATCH
					DECLARE @NERROR INT
					SET @NERROR = @@ERROR
					IF @NERROR<>0
						BEGIN
							SET @msgErr = 'El Auto no se encuentra Disponible. Intente de Nuevo'
							PRINT @msgErr
							ROLLBACK
						END
				END CATCH
			END
		ELSE
			BEGIN
				SET @msgErr = 'Se requiere la Información Personal y del Auto para poder registrar el Alquiler'
			END
	END
GO

exec PROC_Alquiler_Registrar '78542369', '8-342-3122', 'Alexander', 'Madrid', '6238-5490'
go
exec PROC_Alquiler_Registrar '93625879', '9-652-1391', 'Margareth', 'Soler', '6781-3320'
go
exec PROC_Alquiler_Registrar '12884037', '4-663-258', 'Carlos', 'Muñoz', '6284-6674'
go

SELECT * FROM AUTOS_TB WHERE Tipo_Estado = 'DISPONIBLE'
SELECT * FROM ALQUILER_TB


--PROCEDIMIENTO PARA CONSULTAR AUTOS SEGUN ESTADO DE DISPONIBILIDAD
CREATE PROCEDURE PROC_Autos_POR_ESTADO
	@Estado VARCHAR (10),
	@msgErr VARCHAR(100)= '' OUTPUT
AS
	BEGIN
		IF NOT EXISTS (SELECT * FROM AUTOS_TB WHERE Tipo_Estado = @Estado)
			BEGIN
				SET @msgErr = 'No existen Autos Ocupados'
				PRINT @msgErr
			END
		ELSE
			BEGIN
				SELECT id_Auto AS 'Matricula', Marca_Auto AS 'Marca', Modelo_Auto AS 'Modelo', Year_Auto AS 'Año', Tipo_Estado AS 'Estado'
				FROM AUTOS_TB WHERE Tipo_Estado = @Estado
			END
	END
GO

EXEC PROC_Autos_POR_ESTADO 'ocupado'


--PROCEDIMIENTO PARA CONSULTAR TODOS LOS AUTOS
CREATE PROCEDURE PROC_Autos_TODOS
	@msgErr VARCHAR(100)= '' OUTPUT
AS
	BEGIN
		IF NOT EXISTS (SELECT * FROM AUTOS_TB )
			BEGIN
				SET @msgErr = 'No existen Autos Registrados'
				PRINT @msgErr
			END
		ELSE
			BEGIN
				SELECT id_Auto AS 'Matricula', Marca_Auto AS 'Marca', Modelo_Auto AS 'Modelo', Year_Auto AS 'Año', Tipo_Estado AS 'Estado'
				FROM AUTOS_TB 
			END
	END
GO


-- PROCEDIMINENTO PARA VERIFICAR LOS CLIENTES REGISTRADOS
/*
	SOLO SI UTILIZABA LA TABLA CLIENTES E HISTORIAL (NO CREADAS EN EL MODELO FINAL)
*/
--VERIFICA EL CLIENTE
CREATE PROCEDURE PROC_Historial_Clientes_Verificar
	@ID_Cliente VARCHAR(12),
	@msgErr VARCHAR(100)= '' OUTPUT
AS
	BEGIN TRY
		IF EXISTS (SELECT fv.id_Historial  FROM HISTORIAL_TB FV INNER JOIN CLIENTE_TB E ON E.id_Cliente = FV.id_Cliente WHERE FV.id_Cliente LIKE '%'+ @ID_Cliente +'%')
			BEGIN
				SET @msgErr = ''
			END
		ELSE
			BEGIN
				SET @msgErr = 'NO SE ENCUENTRAN ALQUILERES RELACIONADOS CON ESTE COMPRADOR'
			END
	END TRY
	BEGIN CATCH
		SET @msgErr = 'NO SE ENCUENTRAN ALQUILERES RELACIONADOS CON ESTE COMPRADOR'
	END CATCH
GO

--BUSCA Y DEVUELVE LOS REGISTROS DEL CLIENTE
CREATE PROCEDURE PROC_Historial_Cliente_Buscar
	@ID_Cliente VARCHAR(12)
AS
	BEGIN
		IF NOT EXISTS (SELECT * FROM HISTORIAL_TB FV INNER JOIN CLIENTE_TB E ON E.id_Cliente = FV.id_Cliente WHERE FV.id_Cliente LIKE '%'+ @ID_Cliente +'%')
			BEGIN
				 PRINT'No se encontraron coincidencias'
				
			END
		ELSE
			BEGIN
				SELECT id_Historial, E.id_Cliente, Nombre_Cliente, Apellido_Cliente, Edad_Cliente, Telefono_Cliente, A.id_Auto
				FROM HISTORIAL_TB FV
				INNER JOIN CLIENTE_TB E
				ON E.id_Cliente = FV.id_Cliente
				INNER JOIN ALQUILER_TB A
				ON A.id_Cliente = FV.id_Cliente
				WHERE FV.id_Cliente = @ID_Cliente 
			END
	END
GO


