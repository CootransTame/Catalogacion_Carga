
INSERT INTO Configuracion_Controles(
EMPR_Codigo
,MEAP_Codigo
,Codigo
,Control
,Visible
,Obligatorio
)
SELECT
Codigo,
400306,
20,
'Valor CVT',
0,
0

FROM
Empresas
GO
UPDATE Configuracion_Controles SET Visible = 1 WHERE EMPR_Codigo = 13 AND Codigo = 20
GO


PRINT 'gsp_insertar_encabezado_liquidacion_planilla_despachos'
GO
DROP PROCEDURE gsp_insertar_encabezado_liquidacion_planilla_despachos
GO
CREATE PROCEDURE gsp_insertar_encabezado_liquidacion_planilla_despachos    
(                
 @par_EMPR_Codigo NUMERIC,                
 @par_TIDO_Codigo NUMERIC,                
 @par_Fecha DATE,                
 @par_Fecha_Entrega DATE,                
 @par_ENPD_Numero NUMERIC,                
 @par_ENMC_Numero NUMERIC,                
 @par_Observaciones VARCHAR(500),                
 @par_Valor_Flete_Transportador MONEY,                
 @par_Valor_Conceptos_Liquidacion MONEY,    
 @par_Valor_Cvt MONEY = null,    
 @par_Valor_Base_Impuestos MONEY,                
 @par_Valor_Impuestos MONEY,                
 @par_Valor_Pagar MONEY,                
 @par_Estado SMALLINT,                
 @par_Peso_Cargue MONEY,                
 @par_Peso_Cumplido MONEY NULL,                
 @par_Peso_Faltante MONEY NULL,                
 @par_Cantidad MONEY NULL,                
 @par_USUA_Codigo_Crea SMALLINT,                
 @par_OFIC_Codigo SMALLINT                
)                
AS                
BEGIN                
 DECLARE @NumeroIdentity NUMERIC                
 DECLARE @NumeroDocumentoGenerado NUMERIC                
 DECLARE @NumeroLiquidacion NUMERIC                
                
 SELECT                
 @NumeroLiquidacion = ELPD_Numero                
 FROM                
 Encabezado_Planilla_Despachos                
 WHERE                
 EMPR_Codigo = @par_EMPR_Codigo                
 AND Numero = @par_ENPD_Numero                
 AND Anulado = 0            
                
 IF ISNULL(@NumeroLiquidacion,0) = 0 BEGIN                
                 
 EXEC gsp_generar_consecutivo @par_EMPR_Codigo, @par_TIDO_Codigo, @par_OFIC_Codigo, @NumeroDocumentoGenerado OUTPUT                
                
 INSERT INTO                
 Encabezado_Liquidacion_Planilla_Despachos                
 (                
 EMPR_Codigo,                
 TIDO_Codigo,                
 Numero_Documento,                
 Fecha,                
 Fecha_Entrega,                
 ENPD_Numero,                
 ENMC_Numero,                
 Observaciones,                
 Valor_Flete_Transportador,                
 Valor_Conceptos_Liquidacion,                
 Valor_Base_Impuestos,                
 Valor_Impuestos,                
 Valor_Pagar,                
 Anulado,                
 Estado,                
 Fecha_Crea,                
 USUA_Codigo_Crea,                
 OFIC_Codigo,                
 Numeracion,          
 Peso_Cumplido ,        
 Peso_Cargue,        
 Peso_Faltante,      
 Cantidad,    
 Valor_CVT    
 )                
 VALUES                
 (                
 @par_EMPR_Codigo,                
 @par_TIDO_Codigo,                
 @NumeroDocumentoGenerado,                
 @par_Fecha,                
 @par_Fecha_Entrega,                
 @par_ENPD_Numero,                
 @par_ENMC_Numero,                
 @par_Observaciones,                
 @par_Valor_Flete_Transportador,                
 @par_Valor_Conceptos_Liquidacion,                
 @par_Valor_Base_Impuestos,                
 @par_Valor_Impuestos,                
 @par_Valor_Pagar,                
 0,                
 @par_Estado,                
 GETDATE(),                
 @par_USUA_Codigo_Crea,                
 @par_OFIC_Codigo,                
 '',          
 @par_Peso_Cumplido ,        
 @par_Peso_Cargue,        
 @par_Peso_Faltante,      
 @par_Cantidad,    
 @par_Valor_Cvt    
 )                
                
 SET @NumeroIdentity = @@identity                
    
 UPDATE                
 Encabezado_Planilla_Despachos                
 SET                
 ELPD_Numero = @NumeroIdentity                
 WHERE                
 EMPR_Codigo = @par_EMPR_Codigo                
 AND Numero = @par_ENPD_Numero                
              
 SELECT                
 Numero = @NumeroIdentity,                
 @NumeroDocumentoGenerado AS NumeroDocumento                
              
 END                
 ELSE BEGIN                
 SELECT                
 Numero = -1,                
 NumeroDocumento = -1                
 END                
END    

GO


PRINT 'gsp_obtener_terceros_sincronizacion_CARGAAPP'
GO
DROP PROCEDURE gsp_obtener_terceros_sincronizacion_CARGAAPP
GO
CREATE PROCEDURE gsp_obtener_terceros_sincronizacion_CARGAAPP(
@par_EMPR_Codigo smallint,
@par_identificacion varchar(max),
@par_nombre varchar(max) = Null
)
AS
BEGIN
SELECT DISTINCT
LTRIM(RTRIM(CONCAT(TERC.Razon_Social,' ',TERC.Nombre))) AS nombres,
LTRIM(RTRIM(CONCAT(TERC.Apellido1,' ',TERC.Apellido2))) AS apellidos,
TERC.Codigo_Alterno,
TERC.Estado,
TERC.Codigo,
TERC.Numero_Identificacion AS identificacion,
TERC.Direccion,
TERC.CIUD_Codigo,
CIUD.Codigo_Alterno As Ciudad,
TERC.Telefonos,
IIF((SELECT COUNT(1) FROM Perfil_Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = TERC.Codigo AND Codigo = 1412) > 0,1,0) As esTenedor,
IIF((SELECT COUNT(1) FROM Perfil_Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = TERC.Codigo AND Codigo = 1408) > 0,1,0) As esPropietario,
IIF((SELECT COUNT(1) FROM Perfil_Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = TERC.Codigo AND Codigo = 1408) > 0,1,0) As esAdministrador,
IIF((SELECT COUNT(1) FROM Perfil_Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = TERC.Codigo AND Codigo = 1403) > 0,1,0) As esConductor
FROM Terceros TERC

LEFT JOIN Ciudades CIUD ON
TERC.EMPR_Codigo = CIUD.EMPR_Codigo AND
TERC.CIUD_Codigo = CIUD.Codigo


WHERE TERC.EMPR_Codigo = @par_EMPR_Codigo
AND TERC.Numero_Identificacion = @par_identificacion 
AND ((CONCAT(TERC.Razon_Social,' ',TERC.Nombre,' ',TERC.Apellido1,' ',TERC.Apellido2) LIKE @par_nombre +'%') OR @par_nombre IS NULL)

END
GO

PRINT 'gsp_modificar_terceros_sincronizacion_CARGAAPP'
GO
DROP PROCEDURE gsp_modificar_terceros_sincronizacion_CARGAAPP
GO
CREATE PROCEDURE gsp_modificar_terceros_sincronizacion_CARGAAPP(
@par_EMPR_Codigo smallint,
@par_Identificacion varchar(max),
@par_nombre varchar(max) = null,
@par_apellidos varchar(max) = null,
@par_direccion varchar(max) = null,
@par_ciudad varchar(max) = null,
@par_email varchar(max) = null,
@par_celular varchar(max) = null,
@par_codigoNovedad numeric(18,0) = null,
@par_activo smallint = null

)
AS
BEGIN
UPDATE Terceros SET 
Nombre = ISNULL(@par_nombre,Nombre), 
Apellido1 = ISNULL(@par_apellidos,Apellido1), 
Direccion = ISNULL(@par_direccion,Direccion),
CIUD_Codigo = ISNULL((SELECT TOP (1) Codigo FROM Ciudades WHERE EMPR_Codigo = @par_EMPR_Codigo AND Codigo_Alterno = ISNULL(@par_ciudad,'')),CIUD_Codigo),
Emails = ISNULL(@par_email,Emails),
Telefonos = ISNULL(@par_celular,Telefonos),
Estado = ISNULL(@par_activo,Estado)
WHERE EMPR_Codigo = @par_EMPR_Codigo AND Numero_Identificacion = @par_Identificacion

INSERT INTO Tercero_Novedades(
EMPR_Codigo,
TERC_Codigo,
CATA_NOTE_Codigo,
Fecha_Crea,
USUA_Codigo_Crea,
Estado
)VALUES(@par_EMPR_Codigo,
(SELECT TOP (1) Codigo FROM Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND Numero_Identificacion = @par_Identificacion),
ISNULL(@par_codigoNovedad,22214),--22214 Actualización Datos
GETDATE(),
0,
ISNULL(@par_activo,1))
SELECT @@IDENTITY AS identificacion
END
GO



PRINT 'gsp_modificar_vehiculos_sincronizacion_CARGAAPP'
GO
DROP PROCEDURE gsp_modificar_vehiculos_sincronizacion_CARGAAPP
GO
CREATE PROCEDURE gsp_modificar_vehiculos_sincronizacion_CARGAAPP(
@par_EMPR_Codigo smallint,
@par_placa varchar(max),
@par_placaTrailer varchar(max) = null,
@par_codigoTipoCombustible numeric(18,0) = null,
@par_codigoAlternoEmpresaGPS varchar(max) = null,
@par_usuarioGPS varchar(max) = null,
@par_passwordGPS varchar(max) = null,
@par_tipoVehiculo numeric(18,0) = null,
@par_modelo numeric(18,0) = null,
@par_activo smallint = null

)
AS
BEGIN
UPDATE Vehiculos SET 
SEMI_Codigo = ISNULL((SELECT TOP(1) Codigo FROM Semirremolques WHERE EMPR_Codigo = @par_EMPR_Codigo AND Placa = ISNULL(@par_placaTrailer,'')),SEMI_Codigo), 
CATA_TICO_Codigo = ISNULL((SELECT TOP(1) Codigo FROM Valor_Catalogos WHERE EMPR_Codigo = @par_EMPR_Codigo AND Codigo = ISNULL(@par_codigoTipoCombustible,'')),CATA_TICO_Codigo), 
Usuario_GPS = ISNULL(@par_usuarioGPS,Usuario_GPS),
Clave_GPS = ISNULL(@par_passwordGPS,Usuario_GPS),
CATA_TIVE_Codigo = ISNULL((SELECT TOP(1) Codigo FROM Valor_Catalogos WHERE EMPR_Codigo = @par_EMPR_Codigo AND Codigo = ISNULL(@par_tipoVehiculo,'')),CATA_TIVE_Codigo), 
Modelo = ISNULL(@par_modelo,Modelo),
Estado = ISNULL(@par_activo,Estado),
TERC_Codigo_Proveedor_GPS = ISNULL((SELECT Codigo FROM Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND Codigo_Alterno = ISNULL(@par_codigoAlternoEmpresaGPS,'')),TERC_Codigo_Proveedor_GPS)
WHERE EMPR_Codigo = @par_EMPR_Codigo AND Placa = @par_placa


SELECT @par_modelo AS modelo
END
GO