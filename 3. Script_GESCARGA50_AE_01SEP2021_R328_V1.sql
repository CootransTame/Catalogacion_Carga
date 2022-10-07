--Ejecutar sólo una vez:
/****** Object:  Table [dbo].[Registro_Sincronizacion_APP_CARGA]    Script Date: 27/08/2021 9:40:46 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Registro_Sincronizacion_APP_CARGA](
	[EMPR_Codigo] [smallint] NOT NULL,
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[CATA_OSCA_Codigo] [numeric](18, 0) NOT NULL,
	[Codigo] [numeric](18, 0) NOT NULL,
	[Fecha_Sincronizacion] [datetime] NOT NULL,
	[Mensaje_Sincronizacion] [varchar](250) NULL,
	[Sincronizado] [smallint] NULL,
 CONSTRAINT [PK_Registro_Sincronizacion_APP_CARGA] PRIMARY KEY CLUSTERED 
(
	[EMPR_Codigo] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Registro_Sincronizacion_APP_CARGA]  WITH CHECK ADD  CONSTRAINT [FK_Registro_Sincronizacion_APP_CARGA_Empresas] FOREIGN KEY([EMPR_Codigo])
REFERENCES [dbo].[Empresas] ([Codigo])
GO

ALTER TABLE [dbo].[Registro_Sincronizacion_APP_CARGA] CHECK CONSTRAINT [FK_Registro_Sincronizacion_APP_CARGA_Empresas]
GO

ALTER TABLE [dbo].[Registro_Sincronizacion_APP_CARGA]  WITH CHECK ADD  CONSTRAINT [FK_Registro_Sincronizacion_APP_CARGA_Valor_Catalogos] FOREIGN KEY([EMPR_Codigo], [CATA_OSCA_Codigo])
REFERENCES [dbo].[Valor_Catalogos] ([EMPR_Codigo], [Codigo])
GO

ALTER TABLE [dbo].[Registro_Sincronizacion_APP_CARGA] CHECK CONSTRAINT [FK_Registro_Sincronizacion_APP_CARGA_Valor_Catalogos]
GO


INSERT INTO Catalogos(
EMPR_Codigo,
Codigo,
Nombre_Corto,
Nombre,
Actualizable,
Numero_Columnas,
Numero_Campos_Llave
)
SELECT
Codigo,
238,
'OSCA',
'Origen Sincronización CARGA APP',
0,
2,
1
FROM Empresas 
GO

INSERT INTO Valor_Catalogos(
EMPR_Codigo
,Codigo
,CATA_Codigo
,Campo1
,Estado
,USUA_Codigo_Crea
,Fecha_Crea
)
SELECT
Codigo,
23801,
238,
'Oficinas',
1,
0,
GETDATE()
FROM Empresas
GO
INSERT INTO Valor_Catalogos(
EMPR_Codigo
,Codigo
,CATA_Codigo
,Campo1
,Estado
,USUA_Codigo_Crea
,Fecha_Crea
)
SELECT
Codigo,
23802,
238,
'Empresa/Proveedor GPS',
1,
0,
GETDATE()
FROM Empresas
GO
INSERT INTO Valor_Catalogos(
EMPR_Codigo
,Codigo
,CATA_Codigo
,Campo1
,Estado
,USUA_Codigo_Crea
,Fecha_Crea
)
SELECT
Codigo,
23803,
238,
'Vehículos',
1,
0,
GETDATE()
FROM Empresas
GO
INSERT INTO Valor_Catalogos(
EMPR_Codigo
,Codigo
,CATA_Codigo
,Campo1
,Estado
,USUA_Codigo_Crea
,Fecha_Crea
)
SELECT
Codigo,
23804,
238,
'Propietarios,Tenedores,Administradores',
1,
0,
GETDATE()
FROM Empresas
GO
INSERT INTO Valor_Catalogos(
EMPR_Codigo
,Codigo
,CATA_Codigo
,Campo1
,Estado
,USUA_Codigo_Crea
,Fecha_Crea
)
SELECT
Codigo,
23805,
238,
'Conductores',
1,
0,
GETDATE()
FROM Empresas
GO
--Fin ejecución

PRINT 'gsp_transladar_documento_estudio_seguridad'
GO
DROP PROCEDURE gsp_transladar_documento_estudio_seguridad
GO
CREATE PROCEDURE gsp_transladar_documento_estudio_seguridad   
(          
@par_EMPR_Codigo SMALLINT,          
@par_Numero NUMERIC,          
@par_USUA_Codigo SMALLINT          
)          
AS          
BEGIN       
    
 DECLARE @ValorCondicionDefinitivo INT        
 SELECT @ValorCondicionDefinitivo = (     
        
 SELECT DISTINCT         
 COUNT(*)         
 FROM        
         
 Estudio_Seguridad_Documentos AS TESD       
        
 WHERE        
        
 TESD.EMPR_Codigo = @par_EMPR_Codigo                        
 AND TESD.ENES_Numero = @par_Numero )     
     
   IF (@ValorCondicionDefinitivo > 0)    
        BEGIN    
     DELETE Estudio_Seguridad_Documentos  WHERE           
     EMPR_Codigo = @par_EMPR_Codigo                       
     AND ENES_Numero = @par_Numero      
     AND TDES_Codigo IN (SELECT TDES_Codigo FROM T_Estudio_Seguridad_Documentos WHERE EMPR_Codigo =  @par_EMPR_Codigo AND USUA_Codigo = @par_USUA_Codigo)    
    
      INSERT INTO Estudio_Seguridad_Documentos          
     (             
     EMPR_Codigo,         
     ENES_Numero,          
     EOES_Codigo,          
     TDES_Codigo,          
     Referencia,          
     Emisor,          
     Fecha_Emision,          
     Fecha_Vence,          
     Documento,          
     Nombre_Documento,          
     Extension_Documento,        
     USUA_Crea,        
     Fecha_Crea        
     )          
     SELECT DISTINCT
    EMPR_Codigo,         
    @par_Numero,          
    EOES_Codigo,          
    TDES_Codigo,          
    Referencia,          
    Emisor,          
    Fecha_Emision,          
    Fecha_Vence,          
    Documento,          
    Nombre_Documento,          
    Extension_Documento,        
    @par_USUA_Codigo,        
    GETDATE()        
    FROM          
    T_Estudio_Seguridad_Documentos           
    WHERE           
    EMPR_Codigo = @par_EMPR_Codigo     
    AND USUA_Codigo = @par_USUA_Codigo      
    SELECT @@ROWCOUNT AS Codigo      
    
   END       
  
      ELSE  
     BEGIN  
    INSERT INTO Estudio_Seguridad_Documentos          
     (             
     EMPR_Codigo,         
     ENES_Numero,          
     EOES_Codigo,          
     TDES_Codigo,          
     Referencia,          
     Emisor,          
     Fecha_Emision,          
     Fecha_Vence,          
     Documento,          
     Nombre_Documento,          
     Extension_Documento,        
     USUA_Crea,        
     Fecha_Crea        
     )          
     SELECT DISTINCT   
    EMPR_Codigo,         
    @par_Numero,          
    EOES_Codigo,          
    TDES_Codigo,          
    Referencia,          
    Emisor,          
    Fecha_Emision,          
    Fecha_Vence,          
    Documento,          
    Nombre_Documento,          
    Extension_Documento,        
    @par_USUA_Codigo,        
    GETDATE()        
    FROM          
    T_Estudio_Seguridad_Documentos           
    WHERE           
    EMPR_Codigo = @par_EMPR_Codigo      
    AND USUA_Codigo = @par_USUA_Codigo      
    SELECT @@ROWCOUNT AS Codigo    
  END          
END    

GO



PRINT 'gsp_insertar_sincronizacion_CARGA_APP'
GO
DROP PROCEDURE gsp_insertar_sincronizacion_CARGA_APP
GO
CREATE PROCEDURE gsp_insertar_sincronizacion_CARGA_APP(
@par_EMPR_Codigo smallint,
@par_CATA_OSCA_Codigo NUMERIC(18,0),
@par_Codigo NUMERIC(18,0),
@par_Mensaje_Sincronizacion Varchar(250) = null,
@par_Sincronizo smallint = null
)
AS
BEGIN
	DECLARE @ExisteRegistro NUMERIC(18,0);
	SET @ExisteRegistro = (SELECT COUNT(1) FROM Registro_Sincronizacion_APP_CARGA WHERE EMPR_Codigo = @par_EMPR_Codigo AND CATA_OSCA_Codigo = @par_CATA_OSCA_Codigo AND Codigo = @par_Codigo)

	If ISNULL(@ExisteRegistro,0) > 0
	BEGIN
		UPDATE Registro_Sincronizacion_APP_CARGA SET Mensaje_Sincronizacion = @par_Mensaje_Sincronizacion, Sincronizado = @par_Sincronizo, Fecha_Sincronizacion = GETDATE() WHERE EMPR_Codigo = @par_EMPR_Codigo AND CATA_OSCA_Codigo = @par_CATA_OSCA_Codigo AND Codigo = @par_Codigo
		SELECT ID FROM Registro_Sincronizacion_APP_CARGA WHERE EMPR_Codigo = @par_EMPR_Codigo AND CATA_OSCA_Codigo = @par_CATA_OSCA_Codigo AND Codigo = @par_Codigo
	END
	ELSE
	BEGIN
		INSERT INTO Registro_Sincronizacion_APP_CARGA(
		EMPR_Codigo
		,CATA_OSCA_Codigo
		,Codigo
		,Fecha_Sincronizacion
		,Mensaje_Sincronizacion
		,Sincronizado
		)
		VALUES(
		@par_EMPR_Codigo,
		@par_CATA_OSCA_Codigo,
		@par_Codigo,
		GETDATE(),
		@par_Mensaje_Sincronizacion,
		@par_Sincronizo
		)

		SELECT @@IDENTITY AS ID
	END
END
GO

PRINT 'gsp_consultar_oficinas_sincronizacion_CARGA_APP'
GO
DROP PROCEDURE gsp_consultar_oficinas_sincronizacion_CARGA_APP
GO
CREATE PROCEDURE gsp_consultar_oficinas_sincronizacion_CARGA_APP(
@par_EMPR_Codigo smallint
)
AS
BEGIN
SELECT 
OFIC.Codigo, 
OFIC.Codigo_Alterno, 
OFIC.Nombre, 
OFIC.Fecha_Crea, 
OFIC.Fecha_Modifica
FROM Oficinas AS OFIC
LEFT JOIN Registro_Sincronizacion_APP_CARGA AS RSAC
ON OFIC.EMPR_Codigo = RSAC.EMPR_Codigo  
AND OFIC.Codigo = RSAC.Codigo
AND RSAC.CATA_OSCA_Codigo = 23801 -- Origen Sincronizacion CARGA APP Oficinas
WHERE OFIC.EMPR_Codigo = @par_EMPR_Codigo
AND ISNULL(RSAC.Sincronizado,0) = 0
END
GO

PRINT 'gsp_consultar_proveedores_GPS_sincronizacion_CARGA_APP'
GO
DROP PROCEDURE gsp_consultar_proveedores_GPS_sincronizacion_CARGA_APP
GO
CREATE PROCEDURE gsp_consultar_proveedores_GPS_sincronizacion_CARGA_APP(
@par_EMPR_Codigo smallint,
@par_Perfiles varchar(max)
)
AS
BEGIN
SELECT DISTINCT
LTRIM(RTRIM(CONCAT(TERC.Razon_Social,' ',TERC.Nombre,' ',TERC.Apellido1,' ',TERC.Apellido2))) AS NombreCompleto,
TERC.Codigo_Alterno,
TERC.Codigo
FROM Terceros TERC

LEFT JOIN Registro_Sincronizacion_APP_CARGA AS RSAC
ON TERC.EMPR_Codigo = RSAC.EMPR_Codigo  
AND TERC.Codigo = RSAC.Codigo
AND RSAC.CATA_OSCA_Codigo = 23802 -- Origen Sincronizacion CARGA APP Empresas GPS

INNER JOIN Perfil_Terceros PETE ON
TERC.EMPR_Codigo = PETE.EMPR_Codigo AND
TERC.Codigo = PETE.TERC_Codigo
AND PETE.Codigo IN(SELECT * FROM Func_Dividir_String(@par_Perfiles,','))

WHERE TERC.EMPR_Codigo = @par_EMPR_Codigo
AND ISNULL(RSAC.Sincronizado,0) = 0
END
GO

PRINT 'gsp_consultar_vehiculos_sincronizacion_CARGA_APP'
GO
DROP PROCEDURE gsp_consultar_vehiculos_sincronizacion_CARGA_APP
GO
CREATE PROCEDURE gsp_consultar_vehiculos_sincronizacion_CARGA_APP(
@par_EMPR_Codigo smallint
)
AS
BEGIN
SELECT 
VEHI.Placa,
VEHI.Codigo,
VEHI.Estado,
VEHI.Modelo,
VEHI.CATA_TIVE_Codigo,
TIVE.Campo1 As Tipo_Vehiculo,
VEHI.Numero_Ejes,
ISNULL(SEMI.Placa,'') AS SEMI_Placa,
ISNULL(SEMI.CATA_TICA_Codigo,0) AS SEMI_CATA_TICA_Codigo,
ISNULL(TICA.Campo1,'') AS TipoCarroceriaSemirremolque,
ISNULL(SEMI.Numero_Ejes,0) AS EjesSemirremolque,
SOAT.Fecha_Vence AS fechaExpiracionSOAT,
TEME.Fecha_Vence AS fechaExpiracionTecnicoMecanica,
0 As ReporteExterno ,
0 AS ReporteInterno,
1 AS Satelital,
VEHI.CATA_TICO_Codigo,
TICO.Campo1 AS TipoCombustible,
ISNULL(PGPS.Codigo_Alterno,0) AS CodigoAlternoProveedorGPS,
LTRIM(RTRIM(CONCAT(ISNULL(PGPS.Razon_Social,''),' ',ISNULL(PGPS.Nombre,''),' ',ISNULL(PGPS.Apellido1,''),' ',ISNULL(PGPS.Apellido2,'')))) As NombreEmpresaGPS,
ISNULL(COND.Codigo_Alterno,'') AS CodigoAlternoConductor,
ISNULL(TENE.Codigo_Alterno,'') AS CodigoAlternoTenedor,
ISNULL(PROP.Codigo_Alterno,'') AS CodigoAlternoPropietario,
ISNULL(PROP.Codigo_Alterno,'') AS CodigoAlternoAdministrador,
'userGPS' AS usuarioGPS,
'passwordGPS' AS passwordGPS,
0 AS Articulado
FROM Vehiculos VEHI

LEFT JOIN Valor_Catalogos TIVE ON
VEHI.EMPR_Codigo = TIVE.EMPR_Codigo AND
VEHI.CATA_TIVE_Codigo = TIVE.Codigo

LEFT JOIN Semirremolques SEMI ON
VEHI.EMPR_Codigo = SEMI.EMPR_Codigo AND
VEHI.SEMI_Codigo = SEMI.Codigo

LEFT JOIN Valor_Catalogos TICA ON
VEHI.EMPR_Codigo = TICA.EMPR_Codigo AND
SEMI.CATA_TICA_Codigo = TICA.Codigo

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Vehiculo_Documentos TEME ON
VEHI.EMPR_Codigo = TEME.EMPR_Codigo AND
VEHI.Codigo = TEME.VEHI_Codigo AND
TEME.CDGD_Codigo = 103 --TecnicoMecánica

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Vehiculo_Documentos SOAT ON
VEHI.EMPR_Codigo = SOAT.EMPR_Codigo AND
VEHI.Codigo = SOAT.VEHI_Codigo AND
SOAT.CDGD_Codigo = 102 --SOAT

LEFT JOIN Valor_Catalogos TICO ON
VEHI.EMPR_Codigo = TICO.EMPR_Codigo AND
VEHI.CATA_TICO_Codigo = TICO.Codigo

LEFT JOIN Terceros PGPS ON
VEHI.EMPR_Codigo = PGPS.EMPR_Codigo AND
VEHI.TERC_Codigo_Proveedor_GPS = PGPS.Codigo

LEFT JOIN Terceros COND ON
VEHI.EMPR_Codigo = COND.EMPR_Codigo AND
VEHI.TERC_Codigo_Conductor = COND.Codigo

LEFT JOIN Terceros TENE ON
VEHI.EMPR_Codigo = TENE.EMPR_Codigo AND
VEHI.TERC_Codigo_Tenedor = TENE.Codigo

LEFT JOIN Terceros PROP ON
VEHI.EMPR_Codigo = PROP.EMPR_Codigo AND
VEHI.TERC_Codigo_Propietario = PROP.Codigo

LEFT JOIN Registro_Sincronizacion_APP_CARGA RSAC ON
VEHI.EMPR_Codigo = RSAC.EMPR_Codigo AND
VEHI.Codigo = RSAC.Codigo AND
RSAC.CATA_OSCA_Codigo = 23803 -- Origen Sincronización CARGA APP Vehículos

WHERE VEHI.EMPR_Codigo = @par_EMPR_Codigo
AND ISNULL(RSAC.Sincronizado,0) = 0
END
GO

PRINT 'gsp_consultar_vehiculos_sincronizacion_CARGA_APP_pendientes_modificar'
GO
DROP PROCEDURE gsp_consultar_vehiculos_sincronizacion_CARGA_APP_pendientes_modificar
GO
CREATE PROCEDURE gsp_consultar_vehiculos_sincronizacion_CARGA_APP_pendientes_modificar(
@par_EMPR_Codigo smallint
)
AS
BEGIN
SELECT 
VEHI.Placa,
VEHI.Codigo,
VEHI.Estado,
VEHI.Modelo,
VEHI.CATA_TIVE_Codigo,
TIVE.Campo1 As Tipo_Vehiculo,
VEHI.Numero_Ejes,
ISNULL(SEMI.Placa,'') AS SEMI_Placa,
ISNULL(SEMI.CATA_TICA_Codigo,0) AS SEMI_CATA_TICA_Codigo,
ISNULL(TICA.Campo1,'') AS TipoCarroceriaSemirremolque,
ISNULL(SEMI.Numero_Ejes,0) AS EjesSemirremolque,
SOAT.Fecha_Vence AS fechaExpiracionSOAT,
TEME.Fecha_Vence AS fechaExpiracionTecnicoMecanica,
0 As ReporteExterno ,
0 AS ReporteInterno,
1 AS Satelital,
VEHI.CATA_TICO_Codigo,
TICO.Campo1 AS TipoCombustible,
ISNULL(PGPS.Codigo_Alterno,0) AS CodigoAlternoProveedorGPS,
LTRIM(RTRIM(CONCAT(ISNULL(PGPS.Razon_Social,''),' ',ISNULL(PGPS.Nombre,''),' ',ISNULL(PGPS.Apellido1,''),' ',ISNULL(PGPS.Apellido2,'')))) As NombreEmpresaGPS,
ISNULL(COND.Codigo_Alterno,'') AS CodigoAlternoConductor,
ISNULL(TENE.Codigo_Alterno,'') AS CodigoAlternoTenedor,
ISNULL(PROP.Codigo_Alterno,'') AS CodigoAlternoPropietario,
ISNULL(PROP.Codigo_Alterno,'') AS CodigoAlternoAdministrador,
'userGPS' AS usuarioGPS,
'passwordGPS' AS passwordGPS,
0 AS Articulado
FROM Vehiculos VEHI

LEFT JOIN Valor_Catalogos TIVE ON
VEHI.EMPR_Codigo = TIVE.EMPR_Codigo AND
VEHI.CATA_TIVE_Codigo = TIVE.Codigo

LEFT JOIN Semirremolques SEMI ON
VEHI.EMPR_Codigo = SEMI.EMPR_Codigo AND
VEHI.SEMI_Codigo = SEMI.Codigo

LEFT JOIN Valor_Catalogos TICA ON
VEHI.EMPR_Codigo = TICA.EMPR_Codigo AND
SEMI.CATA_TICA_Codigo = TICA.Codigo

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Vehiculo_Documentos TEME ON
VEHI.EMPR_Codigo = TEME.EMPR_Codigo AND
VEHI.Codigo = TEME.VEHI_Codigo AND
TEME.CDGD_Codigo = 103 --TecnicoMecánica

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Vehiculo_Documentos SOAT ON
VEHI.EMPR_Codigo = SOAT.EMPR_Codigo AND
VEHI.Codigo = SOAT.VEHI_Codigo AND
SOAT.CDGD_Codigo = 102 --SOAT

LEFT JOIN Valor_Catalogos TICO ON
VEHI.EMPR_Codigo = TICO.EMPR_Codigo AND
VEHI.CATA_TICO_Codigo = TICO.Codigo

LEFT JOIN Terceros PGPS ON
VEHI.EMPR_Codigo = PGPS.EMPR_Codigo AND
VEHI.TERC_Codigo_Proveedor_GPS = PGPS.Codigo

LEFT JOIN Terceros COND ON
VEHI.EMPR_Codigo = COND.EMPR_Codigo AND
VEHI.TERC_Codigo_Conductor = COND.Codigo

LEFT JOIN Terceros TENE ON
VEHI.EMPR_Codigo = TENE.EMPR_Codigo AND
VEHI.TERC_Codigo_Tenedor = TENE.Codigo

LEFT JOIN Terceros PROP ON
VEHI.EMPR_Codigo = PROP.EMPR_Codigo AND
VEHI.TERC_Codigo_Propietario = PROP.Codigo

LEFT JOIN Registro_Sincronizacion_APP_CARGA RSAC ON
VEHI.EMPR_Codigo = RSAC.EMPR_Codigo AND
VEHI.Codigo = RSAC.Codigo AND
RSAC.CATA_OSCA_Codigo = 23803 -- Origen Sincronización CARGA APP Vehículos

WHERE VEHI.EMPR_Codigo = @par_EMPR_Codigo
AND ISNULL(RSAC.Sincronizado,0) = 1
AND VEHI.Fecha_Modifica > RSAC.Fecha_Sincronizacion
END
GO


PRINT 'gsp_consultar_terceros_sincronizacion_CARGA_APP'
GO
DROP PROCEDURE gsp_consultar_terceros_sincronizacion_CARGA_APP
GO
CREATE PROCEDURE gsp_consultar_terceros_sincronizacion_CARGA_APP(
@par_EMPR_Codigo smallint,
@par_Perfiles varchar(max)
)
AS
BEGIN
SELECT DISTINCT
LTRIM(RTRIM(CONCAT(TERC.Razon_Social,' ',TERC.Nombre))) AS Nombres,
LTRIM(RTRIM(CONCAT(TERC.Apellido1,' ',TERC.Apellido2))) AS Apellidos,
TERC.Codigo_Alterno,
TERC.Estado,
TERC.Codigo,
TERC.Numero_Identificacion,
TERC.Direccion,
TERC.CIUD_Codigo,
CIUD.Codigo_Alterno As Ciudad,
TERC.Telefonos,
IIF((SELECT COUNT(1) FROM Perfil_Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = TERC.Codigo AND Codigo = 1412) > 0,1,0) As Tenedor,
IIF((SELECT COUNT(1) FROM Perfil_Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = TERC.Codigo AND Codigo = 1408) > 0,1,0) As Propietario,
IIF((SELECT COUNT(1) FROM Perfil_Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = TERC.Codigo AND Codigo = 1408) > 0,1,0) As Administrador,
ISNULL((SELECT TOP(1) Placa FROM Vehiculos WHERE EMPR_Codigo = @par_EMPR_Codigo AND (TERC_Codigo_Conductor = TERC.Codigo OR TERC_Codigo_Tenedor = TERC.Codigo OR TERC_Codigo_Propietario = TERC.Codigo )),'(N/A).') AS PlacaCabezote,
ISNULL((SELECT TOP(1) Placa FROM Semirremolques WHERE EMPR_Codigo = @par_EMPR_Codigo AND Codigo =( SELECT TOP(1) SEMI_Codigo FROM Vehiculos WHERE EMPR_Codigo = @par_EMPR_Codigo AND (TERC_Codigo_Conductor = TERC.Codigo OR TERC_Codigo_Tenedor = TERC.Codigo OR TERC_Codigo_Propietario = TERC.Codigo ))),'(N/A).') AS PlacaTrailer
FROM Terceros TERC

LEFT JOIN Registro_Sincronizacion_APP_CARGA AS RSAC
ON TERC.EMPR_Codigo = RSAC.EMPR_Codigo  
AND TERC.Codigo = RSAC.Codigo
AND RSAC.CATA_OSCA_Codigo = 23804 -- Origen Sincronizacion CARGA APP Terceros

INNER JOIN Perfil_Terceros PETE ON
TERC.EMPR_Codigo = PETE.EMPR_Codigo AND
TERC.Codigo = PETE.TERC_Codigo
AND PETE.Codigo IN(SELECT * FROM Func_Dividir_String(@par_Perfiles,','))

LEFT JOIN Ciudades CIUD ON
TERC.EMPR_Codigo = CIUD.EMPR_Codigo AND
TERC.CIUD_Codigo = CIUD.Codigo


WHERE TERC.EMPR_Codigo = @par_EMPR_Codigo
AND ISNULL(RSAC.Sincronizado,0) = 0
END
GO


PRINT 'gsp_consultar_terceros_sincronizacion_CARGA_APP_pendientes_sincronizar'
GO
DROP PROCEDURE gsp_consultar_terceros_sincronizacion_CARGA_APP_pendientes_sincronizar
GO
CREATE PROCEDURE gsp_consultar_terceros_sincronizacion_CARGA_APP_pendientes_sincronizar(
@par_EMPR_Codigo smallint,
@par_Perfiles varchar(max)
)
AS
BEGIN
SELECT DISTINCT
LTRIM(RTRIM(CONCAT(TERC.Razon_Social,' ',TERC.Nombre))) AS Nombres,
LTRIM(RTRIM(CONCAT(TERC.Apellido1,' ',TERC.Apellido2))) AS Apellidos,
TERC.Codigo_Alterno,
TERC.Estado,
TERC.Codigo,
TERC.Numero_Identificacion,
TERC.Direccion,
TERC.CIUD_Codigo,
CIUD.Codigo_Alterno As Ciudad,
TERC.Telefonos,
IIF((SELECT COUNT(1) FROM Perfil_Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = TERC.Codigo AND Codigo = 1412) > 0,1,0) As Tenedor,
IIF((SELECT COUNT(1) FROM Perfil_Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = TERC.Codigo AND Codigo = 1408) > 0,1,0) As Propietario,
IIF((SELECT COUNT(1) FROM Perfil_Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = TERC.Codigo AND Codigo = 1408) > 0,1,0) As Administrador,
ISNULL((SELECT TOP(1) Placa FROM Vehiculos WHERE EMPR_Codigo = @par_EMPR_Codigo AND (TERC_Codigo_Conductor = TERC.Codigo OR TERC_Codigo_Tenedor = TERC.Codigo OR TERC_Codigo_Propietario = TERC.Codigo )),'(N/A).') AS PlacaCabezote,
ISNULL((SELECT TOP(1) Placa FROM Semirremolques WHERE EMPR_Codigo = @par_EMPR_Codigo AND Codigo =( SELECT TOP(1) SEMI_Codigo FROM Vehiculos WHERE EMPR_Codigo = @par_EMPR_Codigo AND (TERC_Codigo_Conductor = TERC.Codigo OR TERC_Codigo_Tenedor = TERC.Codigo OR TERC_Codigo_Propietario = TERC.Codigo ))),'(N/A).') AS PlacaTrailer
FROM Terceros TERC

LEFT JOIN Registro_Sincronizacion_APP_CARGA AS RSAC
ON TERC.EMPR_Codigo = RSAC.EMPR_Codigo  
AND TERC.Codigo = RSAC.Codigo
AND RSAC.CATA_OSCA_Codigo = 23804 -- Origen Sincronizacion CARGA APP Terceros

INNER JOIN Perfil_Terceros PETE ON
TERC.EMPR_Codigo = PETE.EMPR_Codigo AND
TERC.Codigo = PETE.TERC_Codigo
AND PETE.Codigo IN(SELECT * FROM Func_Dividir_String(@par_Perfiles,','))

LEFT JOIN Ciudades CIUD ON
TERC.EMPR_Codigo = CIUD.EMPR_Codigo AND
TERC.CIUD_Codigo = CIUD.Codigo


WHERE TERC.EMPR_Codigo = @par_EMPR_Codigo
AND ISNULL(RSAC.Sincronizado,0) = 1
AND TERC.Fecha_Modifica > RSAC.Fecha_Sincronizacion
END
GO


PRINT 'gsp_consultar_conductores_sincronizacion_CARGA_APP'
GO
DROP PROCEDURE gsp_consultar_conductores_sincronizacion_CARGA_APP
GO
CREATE PROCEDURE gsp_consultar_conductores_sincronizacion_CARGA_APP(
@par_EMPR_Codigo smallint,
@par_Perfiles varchar(max)
)
AS
BEGIN
SELECT DISTINCT
LTRIM(RTRIM(CONCAT(TERC.Razon_Social,' ',TERC.Nombre))) AS Nombres,
LTRIM(RTRIM(CONCAT(TERC.Apellido1,' ',TERC.Apellido2))) AS Apellidos,
TERC.Codigo_Alterno,
TERC.Estado,
TERC.Codigo,
TERC.Numero_Identificacion,
TERC.Direccion,
TERC.CIUD_Codigo,
TERC.Emails,
IIF(ISNULL(CACO.Campo1,'SIN PARAMETRIZAR') = '','SIN PARAMETRIZAR',ISNULL(CACO.Campo1,'SIN PARAMETRIZAR')) AS DescripcionCategoria,
CACO.Codigo AS CATA_CCCV_Codigo,
ISNULL(ARL.Fecha_Vence,'') AS fechaExpiracionARL,
ISNULL(DIAC.Fecha_Vence,'') AS fechaExpiracionCarnetDIACO,
0 AS Reportes,
0 AS Comparendos,
'' AS ListadoClientesBloqueados,
0 As BloqueadosSeguimientoEspecial,
ISNULL(LICO.Fecha_Vence,'') AS fechaVencimientoLicencia,
ISNULL(SUPE.Fecha_Vence,'') AS fechaVencimientoCarnetMercanciaPeligrosa,
CIUD.Codigo_Alterno As Ciudad,
TERC.Telefonos,
ISNULL((SELECT TOP(1) Placa FROM Vehiculos WHERE EMPR_Codigo = @par_EMPR_Codigo AND (TERC_Codigo_Conductor = TERC.Codigo OR TERC_Codigo_Tenedor = TERC.Codigo OR TERC_Codigo_Propietario = TERC.Codigo )),'(N/A).') AS PlacaCabezote,
ISNULL((SELECT TOP(1) Placa FROM Semirremolques WHERE EMPR_Codigo = @par_EMPR_Codigo AND Codigo =( SELECT TOP(1) SEMI_Codigo FROM Vehiculos WHERE EMPR_Codigo = @par_EMPR_Codigo AND (TERC_Codigo_Conductor = TERC.Codigo OR TERC_Codigo_Tenedor = TERC.Codigo OR TERC_Codigo_Propietario = TERC.Codigo ))),'(N/A).') AS PlacaTrailer
FROM Terceros TERC

LEFT JOIN Registro_Sincronizacion_APP_CARGA AS RSAC
ON TERC.EMPR_Codigo = RSAC.EMPR_Codigo  
AND TERC.Codigo = RSAC.Codigo
AND RSAC.CATA_OSCA_Codigo = 23805 -- Origen Sincronizacion CARGA APP Conductores

INNER JOIN Perfil_Terceros PETE ON
TERC.EMPR_Codigo = PETE.EMPR_Codigo AND
TERC.Codigo = PETE.TERC_Codigo
AND PETE.Codigo IN(SELECT * FROM Func_Dividir_String(@par_Perfiles,','))

LEFT JOIN Ciudades CIUD ON
TERC.EMPR_Codigo = CIUD.EMPR_Codigo AND
TERC.CIUD_Codigo = CIUD.Codigo

LEFT JOIN Tercero_Conductores TECO ON
TERC.EMPR_Codigo = TECO.EMPR_Codigo AND
TERC.Codigo = TECO.TERC_Codigo

LEFT JOIN Valor_Catalogos CACO ON
TERC.EMPR_Codigo = CACO.EMPR_Codigo AND
TECO.CATA_CCCV_Codigo = CACO.Codigo

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Tercero_Documentos ARL ON
TERC.EMPR_Codigo = ARL.EMPR_Codigo AND
TERC.Codigo = ARL.TERC_Codigo AND
ARL.CDGD_Codigo = 203 --ARL

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Tercero_Documentos DIAC ON
TERC.EMPR_Codigo = DIAC.EMPR_Codigo AND
TERC.Codigo = DIAC.TERC_Codigo AND
DIAC.CDGD_Codigo = 10004 --Carné DIACO

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Tercero_Documentos LICO ON
TERC.EMPR_Codigo = LICO.EMPR_Codigo AND
TERC.Codigo = LICO.TERC_Codigo AND
LICO.CDGD_Codigo = 202 --Licencia Conducción

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Tercero_Documentos SUPE ON
TERC.EMPR_Codigo = SUPE.EMPR_Codigo AND
TERC.Codigo = SUPE.TERC_Codigo AND
SUPE.CDGD_Codigo = 305 --Carnet Sustancias Peligrosas

WHERE TERC.EMPR_Codigo = @par_EMPR_Codigo
AND ISNULL(RSAC.Sincronizado,0) = 0
END
GO

PRINT 'gsp_consultar_conductores_sincronizacion_CARGA_APP_pendientes_modificar'
GO
DROP PROCEDURE gsp_consultar_conductores_sincronizacion_CARGA_APP_pendientes_modificar
GO
CREATE PROCEDURE gsp_consultar_conductores_sincronizacion_CARGA_APP_pendientes_modificar
(
@par_EMPR_Codigo smallint,
@par_Perfiles varchar(max)
)
AS
BEGIN
SELECT DISTINCT
LTRIM(RTRIM(CONCAT(TERC.Razon_Social,' ',TERC.Nombre))) AS Nombres,
LTRIM(RTRIM(CONCAT(TERC.Apellido1,' ',TERC.Apellido2))) AS Apellidos,
TERC.Codigo_Alterno,
TERC.Estado,
TERC.Codigo,
TERC.Numero_Identificacion,
TERC.Direccion,
TERC.CIUD_Codigo,
TERC.Emails,
IIF(ISNULL(CACO.Campo1,'SIN PARAMETRIZAR') = '','SIN PARAMETRIZAR',ISNULL(CACO.Campo1,'SIN PARAMETRIZAR')) AS DescripcionCategoria,
CACO.Codigo AS CATA_CCCV_Codigo,
ISNULL(ARL.Fecha_Vence,'') AS fechaExpiracionARL,
ISNULL(DIAC.Fecha_Vence,'') AS fechaExpiracionCarnetDIACO,
0 AS Reportes,
0 AS Comparendos,
'' AS ListadoClientesBloqueados,
0 As BloqueadosSeguimientoEspecial,
ISNULL(LICO.Fecha_Vence,'') AS fechaVencimientoLicencia,
ISNULL(SUPE.Fecha_Vence,'') AS fechaVencimientoCarnetMercanciaPeligrosa,
CIUD.Codigo_Alterno As Ciudad,
TERC.Telefonos,
ISNULL((SELECT TOP(1) Placa FROM Vehiculos WHERE EMPR_Codigo = @par_EMPR_Codigo AND (TERC_Codigo_Conductor = TERC.Codigo OR TERC_Codigo_Tenedor = TERC.Codigo OR TERC_Codigo_Propietario = TERC.Codigo )),'(N/A).') AS PlacaCabezote,
ISNULL((SELECT TOP(1) Placa FROM Semirremolques WHERE EMPR_Codigo = @par_EMPR_Codigo AND Codigo =( SELECT TOP(1) SEMI_Codigo FROM Vehiculos WHERE EMPR_Codigo = @par_EMPR_Codigo AND (TERC_Codigo_Conductor = TERC.Codigo OR TERC_Codigo_Tenedor = TERC.Codigo OR TERC_Codigo_Propietario = TERC.Codigo ))),'(N/A).') AS PlacaTrailer
FROM Terceros TERC

LEFT JOIN Registro_Sincronizacion_APP_CARGA AS RSAC
ON TERC.EMPR_Codigo = RSAC.EMPR_Codigo  
AND TERC.Codigo = RSAC.Codigo
AND RSAC.CATA_OSCA_Codigo = 23805 -- Origen Sincronizacion CARGA APP Conductores

INNER JOIN Perfil_Terceros PETE ON
TERC.EMPR_Codigo = PETE.EMPR_Codigo AND
TERC.Codigo = PETE.TERC_Codigo
AND PETE.Codigo IN(SELECT * FROM Func_Dividir_String(@par_Perfiles,','))

LEFT JOIN Ciudades CIUD ON
TERC.EMPR_Codigo = CIUD.EMPR_Codigo AND
TERC.CIUD_Codigo = CIUD.Codigo

LEFT JOIN Tercero_Conductores TECO ON
TERC.EMPR_Codigo = TECO.EMPR_Codigo AND
TERC.Codigo = TECO.TERC_Codigo

LEFT JOIN Valor_Catalogos CACO ON
TERC.EMPR_Codigo = CACO.EMPR_Codigo AND
TECO.CATA_CCCV_Codigo = CACO.Codigo

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Tercero_Documentos ARL ON
TERC.EMPR_Codigo = ARL.EMPR_Codigo AND
TERC.Codigo = ARL.TERC_Codigo AND
ARL.CDGD_Codigo = 203 --ARL

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Tercero_Documentos DIAC ON
TERC.EMPR_Codigo = DIAC.EMPR_Codigo AND
TERC.Codigo = DIAC.TERC_Codigo AND
DIAC.CDGD_Codigo = 10004 --Carné DIACO

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Tercero_Documentos LICO ON
TERC.EMPR_Codigo = LICO.EMPR_Codigo AND
TERC.Codigo = LICO.TERC_Codigo AND
LICO.CDGD_Codigo = 202 --Licencia Conducción

LEFT JOIN GESCARGA50_DOCU_DESARROLLO.dbo.Tercero_Documentos SUPE ON
TERC.EMPR_Codigo = SUPE.EMPR_Codigo AND
TERC.Codigo = SUPE.TERC_Codigo AND
SUPE.CDGD_Codigo = 305 --Carnet Sustancias Peligrosas

WHERE TERC.EMPR_Codigo = @par_EMPR_Codigo
AND ISNULL(RSAC.Sincronizado,0) = 1 AND
TERC.Fecha_Modifica > RSAC.Fecha_Sincronizacion
END
GO

PRINT 'gsp_insertar_estudio_seguridad_documentos'
GO
DROP PROCEDURE gsp_insertar_estudio_seguridad_documentos
GO
CREATE PROCEDURE gsp_insertar_estudio_seguridad_documentos   

(          
  @par_USUA_Codigo SMALLINT,          
  @par_EMPR_Codigo SMALLINT,                
  @par_ENES_Numero NUMERIC = NULL,          
  @par_EOES_Codigo NUMERIC = NULL,           
  @par_TDES_Codigo NUMERIC = NULL,                    
  @par_Referencia VARCHAR(50) = NULL,         
  @par_Emisor VARCHAR(50) = NULL,          
  @par_Fecha_Emision DATE = NULL,         
  @par_Fecha_Vence DATE = NULL,         
  @par_Documento VARBINARY(MAX) = NULL,                 
  @par_Nombre_Documento VARCHAR(50) = NULL,              
  @par_Extension_Documento CHAR(5) = NULL   
)            
AS            
BEGIN       
    
 DECLARE @ValorCondicionDefinitivo INT      
 SELECT @ValorCondicionDefinitivo = (      
      
 SELECT DISTINCT       
 COUNT(*)       
 FROM      
       
 Estudio_Seguridad_Documentos AS TESD     
      
 WHERE      
      
 TESD.EMPR_Codigo = @par_EMPR_Codigo                      
 AND TESD.ENES_Numero = @par_ENES_Numero      
 AND TESD.TDES_Codigo = @par_TDES_Codigo )     
  
 DECLARE @ValorCondicion INT      
 SELECT @ValorCondicion = (      
      
 SELECT DISTINCT       
 COUNT(*)       
 FROM      
       
 T_Estudio_Seguridad_Documentos AS TESD     
      
 WHERE      
      
 TESD.EMPR_Codigo = @par_EMPR_Codigo             
 AND TESD.USUA_Codigo = @par_USUA_Codigo      
 AND TESD.TDES_Codigo = @par_TDES_Codigo )     
  
   IF (@ValorCondicionDefinitivo = 0)  
   BEGIN  
        
     IF (@ValorCondicion = 0)     
             BEGIN      
      
       INSERT INTO            
       T_Estudio_Seguridad_Documentos         
       (        
       USUA_Codigo,          
       EMPR_Codigo,       
       ENES_Numero,        
       EOES_Codigo,        
       TDES_Codigo,         
       Referencia,        
       Emisor,        
       Fecha_Emision,        
       Fecha_Vence,        
       Documento,        
       Nombre_Documento,        
       Extension_Documento      
       )            
       VALUES            
       (        
       @par_USUA_Codigo,         
       @par_EMPR_Codigo,              
       @par_ENES_Numero,          
       @par_EOES_Codigo,        
       @par_TDES_Codigo,              
       ISNULL(@par_Referencia, ''),          
       ISNULL(@par_Emisor, ''),               
       ISNULL(@par_Fecha_Emision, ''),         
       ISNULL(@par_Fecha_Vence, ''),              
       @par_Documento,              
       ISNULL(@par_Nombre_Documento, NULL),              
       ISNULL(@par_Extension_Documento, NULL)         
       )                 
       SELECT @@ROWCOUNT AS Codigo    
          
                 END     
           ELSE IF (@ValorCondicion > 0)           
                   BEGIN      
          
       IF (@par_Documento IS NULL)     
        BEGIN     
    
        UPDATE            
        T_Estudio_Seguridad_Documentos         
        SET                         
        Referencia = ISNULL(@par_Referencia, ''),        
        Emisor = ISNULL(@par_Emisor, ''),        
        Fecha_Emision = ISNULL(@par_Fecha_Emision, ''),        
        Fecha_Vence = ISNULL(@par_Fecha_Vence, '')  
        WHERE      
        EMPR_Codigo = @par_EMPR_Codigo             
        AND USUA_Codigo = @par_USUA_Codigo      
        AND TDES_Codigo = @par_TDES_Codigo         
        SELECT @@ROWCOUNT AS Codigo  
            
         END  
       ELSE  
         BEGIN  
           UPDATE            
         T_Estudio_Seguridad_Documentos         
         SET                   
        Referencia = ISNULL(@par_Referencia, ''),        
        Emisor = ISNULL(@par_Emisor, ''),        
        Fecha_Emision = ISNULL(@par_Fecha_Emision, ''),        
        Fecha_Vence = ISNULL(@par_Fecha_Vence, ''),        
        Documento = @par_Documento,        
        Nombre_Documento = ISNULL(@par_Nombre_Documento, NULL),        
        Extension_Documento = ISNULL(@par_Extension_Documento, NULL)    
        WHERE      
        EMPR_Codigo = @par_EMPR_Codigo             
        AND USUA_Codigo = @par_USUA_Codigo      
        AND TDES_Codigo = @par_TDES_Codigo  
        SELECT @@ROWCOUNT AS Codigo  
            END     
          
                   END  
       END  
      ELSE  
      BEGIN  
  
   IF (@ValorCondicion > 0)           
    BEGIN      
          
       IF (@par_Documento IS NULL)     
        BEGIN     
    
        UPDATE            
        T_Estudio_Seguridad_Documentos         
        SET                         
        Referencia = ISNULL(@par_Referencia, ''),        
        Emisor = ISNULL(@par_Emisor, ''),        
        Fecha_Emision = ISNULL(@par_Fecha_Emision, ''),        
        Fecha_Vence = ISNULL(@par_Fecha_Vence, '')  
        WHERE      
        EMPR_Codigo = @par_EMPR_Codigo             
        AND USUA_Codigo = @par_USUA_Codigo      
        AND TDES_Codigo = @par_TDES_Codigo         
        SELECT @@ROWCOUNT AS Codigo  
            
         END  
       ELSE  
         BEGIN  
           UPDATE            
         T_Estudio_Seguridad_Documentos         
         SET                   
        Referencia = ISNULL(@par_Referencia, ''),        
        Emisor = ISNULL(@par_Emisor, ''),        
        Fecha_Emision = ISNULL(@par_Fecha_Emision, ''),        
        Fecha_Vence = ISNULL(@par_Fecha_Vence, ''),        
        Documento = @par_Documento,        
        Nombre_Documento = ISNULL(@par_Nombre_Documento, NULL),        
        Extension_Documento = ISNULL(@par_Extension_Documento, NULL)    
        WHERE      
        EMPR_Codigo = @par_EMPR_Codigo             
        AND USUA_Codigo = @par_USUA_Codigo      
        AND TDES_Codigo = @par_TDES_Codigo  
        SELECT @@ROWCOUNT AS Codigo  
            END     
          
    END  
    ELSE  
    BEGIN  
  
       INSERT INTO T_Estudio_Seguridad_Documentos        
      (           
      EMPR_Codigo,       
      ENES_Numero,        
      EOES_Codigo,        
      TDES_Codigo,        
      Referencia,        
      Emisor,        
      Fecha_Emision,        
      Fecha_Vence,        
      Documento,        
      Nombre_Documento,        
      Extension_Documento,  
      USUA_Codigo   
      )        
      SELECT TOP (1)         
       EMPR_Codigo,       
       @par_ENES_Numero,        
       EOES_Codigo,        
       TDES_Codigo,        
        Referencia,        
       Emisor,        
       Fecha_Emision,        
       Fecha_Vence,        
       Documento,        

       Nombre_Documento,        
          Extension_Documento,      
         @par_USUA_Codigo   
       FROM        
       Estudio_Seguridad_Documentos         
       WHERE         
       EMPR_Codigo =  @par_EMPR_Codigo        
       AND TDES_Codigo = @par_TDES_Codigo    
       SELECT @@ROWCOUNT AS Codigo    
       END  
      END  
    END  
	 
GO

PRINT'gsp_consultar_remesas'
GO
DROP PROCEDURE gsp_consultar_remesas
GO
CREATE PROCEDURE gsp_consultar_remesas       
(                                                                  
 @par_EMPR_Codigo SMALLINT,                                                                  
 @par_TIDO_Codigo SMALLINT = NULL,                                                                  
 @par_Numero NUMERIC = NULL,                                                                  
 @par_Fecha_Inicial DATETIME = NULL,                                                                  
 @par_Fecha_Final DATETIME = NULL,                                                                  
 @par_ESOS_Numero_Documento NUMERIC = NULL,                                                                 
 @par_ENMC_Numero INT = NULL,                                                                  
 @par_Cliente VARCHAR(50) = NULL,                                                                  
 @par_Documento_Cliente VARCHAR(30) = NULL,               
 @par_Placa VARCHAR(20) = NULL,                                                                  
 @par_Conductor VARCHAR(50) = NULL,                                                                  
 @par_Tenedor VARCHAR(50) = NULL,            
 @par_CATA_TIRE_Codigo SMALLINT = NULL,                                                                  
 @par_OFIC_Codigo INT = NULL,                                                                  
 @par_Estado SMALLINT = NULL,                                                                  
 @par_Anulado SMALLINT = NULL,                          
 @par_ENPD_Numero_Documento NUMERIC = NULL,                                                                 
 @par_Numero_Contenedor VARCHAR(30) = NULL,                                                  
 @par_NumeroPagina INT = NULL,                                                                  
 @par_RegistrosPagina INT = NULL,                                                                 
 @par_Usuario_Consulta INT = NULL  ,        
 @par_TERC_Codigo_FacturarA NUMERIC(18,0) = NULL        
)                                                                  
AS                                                                  
BEGIN                                                                  
 SET NOCOUNT ON;                                                                   
 DECLARE @CantidadRegistros INT                                                                  
 SELECT @CantidadRegistros =                                                                  
 (                                                                  
  SELECT DISTINCT                                                                  
  COUNT(1)                                                                  
  FROM                                                                  
  Encabezado_Remesas ENRE                                 
          
  LEFT JOIN Terceros CLIE          
  ON ENRE.EMPR_Codigo = CLIE.EMPR_Codigo          
  AND ENRE.TERC_Codigo_Cliente = CLIE.Codigo           
        
  LEFT JOIN Terceros FACA          
  ON ENRE.EMPR_Codigo = FACA.EMPR_Codigo          
  AND ENRE.TERC_Codigo_Facturara = FACA.Codigo         
          
  LEFT JOIN Vehiculos VEHI          
  ON ENRE.EMPR_Codigo = VEHI.EMPR_Codigo          
  AND ENRE.VEHI_Codigo = VEHI.Codigo          
          
  LEFT JOIN Semirremolques SEMI          
  ON ENRE.EMPR_Codigo = SEMI.EMPR_Codigo          
  AND ENRE.SEMI_Codigo = SEMI.Codigo          
          
  LEFT JOIN Rutas RUTA              
  ON ENRE.EMPR_Codigo = RUTA.EMPR_Codigo          
  AND ENRE.RUTA_Codigo = RUTA.Codigo           
          
  LEFT JOIN Encabezado_Solicitud_Orden_Servicios ESOS          
  ON ENRE.EMPR_Codigo = ESOS.EMPR_Codigo          
  AND ENRE.ESOS_Numero = ESOS.Numero          
          
  LEFT JOIN Encabezado_Planilla_Despachos ENPD          
  ON ENRE.EMPR_Codigo = ENPD.EMPR_Codigo          
  AND ENRE.ENPD_Numero = ENPD.Numero          
          
  LEFT JOIN Encabezado_Manifiesto_Carga ENMC          
  ON ENRE.EMPR_Codigo = ENMC.EMPR_Codigo          
  AND ENRE.ENMC_Numero = ENMC.Numero          
          
  LEFT JOIN Encabezado_Cumplido_Planilla_Despachos ECPD          
  ON ENRE.EMPR_Codigo = ECPD.EMPR_Codigo          
  AND ENRE.ECPD_Numero = ECPD.Numero          
           
  LEFT JOIN Encabezado_Facturas ENFA          
  ON ENRE.EMPR_Codigo = ENFA.EMPR_Codigo          
  AND ENRE.ENFA_Numero = ENFA.Numero          
          
  LEFT JOIN Terceros COND          
  ON ENRE.EMPR_Codigo = COND.EMPR_Codigo          
  AND ENRE.TERC_Codigo_Conductor = COND.Codigo          
          
  LEFT JOIN Terceros TENE          
  ON VEHI.EMPR_Codigo = TENE.EMPR_Codigo          
  AND VEHI.TERC_Codigo_Tenedor = TENE.Codigo          
          
  LEFT JOIN V_Tipo_Remesas TIRE          
  ON ENRE.EMPR_Codigo = TIRE.EMPR_Codigo          
  AND ENRE.CATA_TIRE_Codigo = TIRE.Codigo          
          
  LEFT JOIN Oficinas OFIC          
  ON ENRE.EMPR_Codigo = OFIC.EMPR_Codigo          
  AND ENRE.OFIC_Codigo = OFIC.Codigo            
      
  LEFT JOIN Producto_Transportados PRTR                                
  ON ENRE.EMPR_Codigo = PRTR.EMPR_Codigo AND ENRE.PRTR_Codigo = PRTR.Codigo                                
                  
                                      
  WHERE                                          
  ENRE.EMPR_Codigo = @par_EMPR_Codigo                                                                  
  AND ENRE.TIDO_Codigo = 100                                                         
  AND ENRE.Anulado = ISNULL (@par_Anulado,ENRE.Anulado)                  
  AND ((CLIE.Nombre + ' ' + CLIE.Apellido1 + ' ' + CLIE.Apellido2 LIKE '%' + RTRIM(LTRIM(@par_Cliente)) + '%' OR CLIE.Razon_Social LIKE '%' + RTRIM(LTRIM(@par_Cliente)) + '%') OR (@par_Cliente IS NULL))                  
  AND (TENE.Razon_Social + ' ' +TENE.Apellido1 + ' ' + TENE.Apellido2 + ' ' + TENE.Nombre LIKE '%'+@par_Tenedor+'%' or @par_Tenedor is null)                                                
  AND (COND.Nombre + ' ' +COND.Apellido1 + ' ' + COND.Apellido2 + ' ' + COND.Razon_Social LIKE '%'+@par_Conductor+'%' or @par_Conductor is null)                                                     
  AND ENRE.Numero_Documento = ISNULL(@par_Numero, ENRE.Numero_Documento)                                                     
  AND ENRE.Fecha BETWEEN ISNULL(@par_Fecha_Inicial, ENRE.Fecha) AND ISNULL(@par_Fecha_Final, ENRE.Fecha)                                              
  AND ENRE.CATA_TIRE_Codigo = ISNULL(@par_CATA_TIRE_Codigo,ENRE.CATA_TIRE_Codigo)                                                      
  AND ENRE.OFIC_Codigo = ISNULL(@par_OFIC_Codigo, ENRE.OFIC_Codigo)                                                             
  AND ENRE.Estado = ISNULL(@par_Estado,ENRE.Estado)                                                                  
  AND (ENRE.Documento_Cliente  LIKE'%'+@par_Documento_Cliente+'%' OR @par_Documento_Cliente IS NULL)                                    
  AND (ENRE.Numero_Contenedor = @par_Numero_Contenedor or @par_Numero_Contenedor is null)                                              
  AND (ESOS.Numero_Documento = @par_ESOS_Numero_Documento OR @par_ESOS_Numero_Documento IS NULL)                                                 
  AND (ENPD.Numero_Documento = @par_ENPD_Numero_Documento OR @par_ENPD_Numero_Documento IS NULL)                                   
  AND ( ENMC.Numero_Documento = @par_ENMC_Numero OR @par_ENMC_Numero IS NULL  )                                                              
  AND TENE.Numero_Identificacion = ISNULL(@par_Tenedor,TENE.Numero_Identificacion)                                                       
  AND VEHI.Placa = ISNULL(@par_Placa, VEHI.Placa)                                                
  AND COND.Numero_Identificacion = ISNULL(@par_Conductor,COND.Numero_Identificacion)                                                  
  AND  CLIE.Numero_Identificacion = ISNULL(@par_Documento_Cliente,CLIE.Numero_Identificacion)                             
  AND (ENRE.OFIC_Codigo IN (                          
  SELECT USOF.OFIC_Codigo FROM Usuario_Oficinas USOF WHERE USOF.USUA_Codigo = @par_Usuario_Consulta                     
  ) OR @par_Usuario_Consulta IS NULL)              
  --AND ENRE.TERC_Codigo_Facturara = ISNULL(@par_TERC_Codigo_FacturarA,ENRE.TERC_Codigo_Facturara)      
  AND ((ENRE.TERC_Codigo_Facturara = @par_TERC_Codigo_FacturarA )OR @par_TERC_Codigo_FacturarA IS NULL)      
 );                                                                  
 WITH Pagina                                                           
 AS                                                                  
 (                          
  SELECT DISTINCT          
      
  ENRE.EMPR_Codigo,                                                                  
  ENRE.Numero,                                                                  
  ENRE.TIDO_Codigo,                                                                  
  --TIDO.Nombre AS TipoDocumento,                                                            
ENRE.Numero_Documento,                 
  ENRE.Fecha,                                                                  
  CONCAT(ISNULL(CLIE.Razon_Social,''),CLIE.Nombre,' ',CLIE.Apellido1,' ',CLIE.Apellido2) AS NombreCliente,                                                                  
  VEHI.Placa,                                                                  
  ISNULL(SEMI.Placa,'') AS PlacaSemirremolque,                                                         
  RUTA.Nombre AS NombreRuta,                   
  ESOS.Numero_Documento AS OrdenServicio,                                                        
  ISNULL(ENPD.Numero_Documento,0) AS NumeroDocumentoPlanilla,                                                                  
  ISNULL(ENMC.Numero_Documento,0) AS NumeroDocumentoManifiesto,                                                                  
  ISNULL(ECPD.Numero_Documento,0) AS NumeroCumplido,                                                                  
  ISNULL(ENFA.Numero_Documento,0) AS NumeroFactura,         
     PRTR.Nombre AS NombreProducto,        
     ENRE.Cantidad_Cliente,                                
   ENRE.Peso_Cliente,                                
   ENRE.Peso_Volumetrico_Cliente,        
  ENRE.Anulado,                                                                  
  ENRE.Estado,               
  ENRE.DT_SAP,        
  ENRE.Entrega_SAP,        
  ENRE.TERC_Codigo_Facturara,        
  RTRIM(LTRIM(CONCAT(FACA.Razon_Social,' ',FACA.Nombre,' ',FACA.Apellido1,' ',FACA.Apellido2))) AS NombreFacturarA,        
  ROW_NUMBER() OVER (ORDER BY ENRE.Numero DESC) AS RowNumber                                                                  
  FROM                     
  Encabezado_Remesas ENRE             
          
  LEFT JOIN Terceros CLIE          
  ON ENRE.EMPR_Codigo = CLIE.EMPR_Codigo          
  AND ENRE.TERC_Codigo_Cliente = CLIE.Codigo          
          
  LEFT JOIN Terceros FACA          
  ON ENRE.EMPR_Codigo = FACA.EMPR_Codigo          
  AND ENRE.TERC_Codigo_Facturara = FACA.Codigo         
          
  LEFT JOIN Vehiculos VEHI          
  ON ENRE.EMPR_Codigo = VEHI.EMPR_Codigo          
  AND ENRE.VEHI_Codigo = VEHI.Codigo          
          
  LEFT JOIN Semirremolques SEMI          
  ON ENRE.EMPR_Codigo = SEMI.EMPR_Codigo          
  AND ENRE.SEMI_Codigo = SEMI.Codigo          
          
  LEFT JOIN Rutas RUTA              
  ON ENRE.EMPR_Codigo = RUTA.EMPR_Codigo          
  AND ENRE.RUTA_Codigo = RUTA.Codigo           
          
  LEFT JOIN Encabezado_Solicitud_Orden_Servicios ESOS          
  ON ENRE.EMPR_Codigo = ESOS.EMPR_Codigo          
  AND ENRE.ESOS_Numero = ESOS.Numero          
          
  LEFT JOIN Encabezado_Planilla_Despachos ENPD          
  ON ENRE.EMPR_Codigo = ENPD.EMPR_Codigo          
  AND ENRE.ENPD_Numero = ENPD.Numero          
          
  LEFT JOIN Encabezado_Manifiesto_Carga ENMC          
  ON ENRE.EMPR_Codigo = ENMC.EMPR_Codigo          
  AND ENRE.ENMC_Numero = ENMC.Numero          
          
  LEFT JOIN Encabezado_Cumplido_Planilla_Despachos ECPD          
  ON ENRE.EMPR_Codigo = ECPD.EMPR_Codigo          
  AND ENRE.ECPD_Numero = ECPD.Numero          
            
  LEFT JOIN Encabezado_Facturas ENFA          
  ON ENRE.EMPR_Codigo = ENFA.EMPR_Codigo          
  AND ENRE.ENFA_Numero = ENFA.Numero          
          
  LEFT JOIN Terceros COND          
  ON ENRE.EMPR_Codigo = COND.EMPR_Codigo          
  AND ENRE.TERC_Codigo_Conductor = COND.Codigo          
          
  LEFT JOIN Terceros TENE          
  ON VEHI.EMPR_Codigo = TENE.EMPR_Codigo          
  AND VEHI.TERC_Codigo_Tenedor = TENE.Codigo          
          
  LEFT JOIN V_Tipo_Remesas TIRE          
  ON ENRE.EMPR_Codigo = TIRE.EMPR_Codigo          
  AND ENRE.CATA_TIRE_Codigo = TIRE.Codigo          
          
  LEFT JOIN Oficinas OFIC          
  ON ENRE.EMPR_Codigo = OFIC.EMPR_Codigo          
  AND ENRE.OFIC_Codigo = OFIC.Codigo            
    LEFT JOIN Producto_Transportados PRTR                                
  ON ENRE.EMPR_Codigo = PRTR.EMPR_Codigo AND ENRE.PRTR_Codigo = PRTR.Codigo                                
            
  WHERE                                                                  
  ENRE.EMPR_Codigo = @par_EMPR_Codigo                                                                  
  AND ENRE.TIDO_Codigo = 100                                                         
  AND ENRE.Anulado = ISNULL (@par_Anulado,ENRE.Anulado)                  
  AND ((CLIE.Nombre + ' ' + CLIE.Apellido1 + ' ' + CLIE.Apellido2 LIKE '%' + RTRIM(LTRIM(@par_Cliente)) + '%' OR CLIE.Razon_Social LIKE '%' + RTRIM(LTRIM(@par_Cliente)) + '%') OR (@par_Cliente IS NULL))                  
  AND (TENE.Razon_Social + ' ' +TENE.Apellido1 + ' ' + TENE.Apellido2 + ' ' + TENE.Nombre LIKE '%'+@par_Tenedor+'%' or @par_Tenedor is null)                                                
  AND (COND.Nombre + ' ' +COND.Apellido1 + ' ' + COND.Apellido2 + ' ' + COND.Razon_Social LIKE '%'+@par_Conductor+'%' or @par_Conductor is null)                                                     
  AND ENRE.Numero_Documento = ISNULL(@par_Numero, ENRE.Numero_Documento)                                                     
  AND ENRE.Fecha BETWEEN ISNULL(@par_Fecha_Inicial, ENRE.Fecha) AND ISNULL(@par_Fecha_Final, ENRE.Fecha)                                              
  AND ENRE.CATA_TIRE_Codigo = ISNULL(@par_CATA_TIRE_Codigo,ENRE.CATA_TIRE_Codigo)                                                      
  AND ENRE.OFIC_Codigo = ISNULL(@par_OFIC_Codigo, ENRE.OFIC_Codigo)                                                             
  AND ENRE.Estado = ISNULL(@par_Estado,ENRE.Estado)                                                                  
  AND (ENRE.Documento_Cliente  LIKE'%'+@par_Documento_Cliente+'%' OR @par_Documento_Cliente IS NULL)                                    
  AND (ENRE.Numero_Contenedor = @par_Numero_Contenedor or @par_Numero_Contenedor is null)                                      
  AND (ESOS.Numero_Documento = @par_ESOS_Numero_Documento OR @par_ESOS_Numero_Documento IS NULL)                                                 
  AND (ENPD.Numero_Documento = @par_ENPD_Numero_Documento OR @par_ENPD_Numero_Documento IS NULL)                                   
  AND ( ENMC.Numero_Documento = @par_ENMC_Numero OR @par_ENMC_Numero IS NULL  )                                                              
  AND TENE.Numero_Identificacion = ISNULL(@par_Tenedor,TENE.Numero_Identificacion)                                                       
  AND VEHI.Placa = ISNULL(@par_Placa, VEHI.Placa)                                                
  AND COND.Numero_Identificacion = ISNULL(@par_Conductor,COND.Numero_Identificacion)                                                  
  AND  CLIE.Numero_Identificacion = ISNULL(@par_Documento_Cliente,CLIE.Numero_Identificacion)                             
  AND (ENRE.OFIC_Codigo IN (                          
  SELECT USOF.OFIC_Codigo FROM Usuario_Oficinas USOF WHERE USOF.USUA_Codigo = @par_Usuario_Consulta                       ) OR @par_Usuario_Consulta IS NULL)               
  --AND ENRE.TERC_Codigo_Facturara = ISNULL(@par_TERC_Codigo_FacturarA,ENRE.TERC_Codigo_Facturara)        
  AND ((ENRE.TERC_Codigo_Facturara = @par_TERC_Codigo_FacturarA )OR @par_TERC_Codigo_FacturarA IS NULL)      
          
 )                                                                  
 SELECT          
 EMPR_Codigo,                                                                  
 Numero,                                                                  
 TIDO_Codigo,                                                                  
 Numero_Documento,                                                                  
 Fecha,                                                                  
 NombreRuta,                                        
 NombreCliente,                                                                  
 Anulado,                                                                  
 Estado,                                                                  
 OrdenServicio,                                                                  
 NumeroDocumentoPlanilla,                                                                  
 NumeroDocumentoManifiesto,                                                                  
 NumeroCumplido,                                                                  
 NumeroFactura,      
 NombreProducto,      
 Cantidad_Cliente,                                
 Peso_Cliente,                                
 Peso_Volumetrico_Cliente,       
 Placa,                                                                  
 PlacaSemirremolque,          
 DT_SAP,        
 Entrega_SAP,        
 TERC_Codigo_Facturara,        
 NombreFacturarA,        
 @CantidadRegistros AS TotalRegistros,                                                                  
 @par_NumeroPagina AS PaginaObtener,                                                       
 @par_RegistrosPagina AS RegistrosPagina,                
 '(NO APLICA)' As Naviera               
 FROM Pagina          
 WHERE RowNumber > (ISNULL(@par_NumeroPagina, 1) - 1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)                                                                  
 AND RowNumber <= ISNULL(@par_NumeroPagina, 1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)                                                              
 ORDER BY Numero                                                                  
END 

GO
