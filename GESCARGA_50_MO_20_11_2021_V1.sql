PRINT 'gsp_consultar_remesa_por_planilla_recoleccion'
GO
DROP PROCEDURE gsp_consultar_remesa_por_planilla_recoleccion
GO
CREATE PROCEDURE gsp_consultar_remesa_por_planilla_recoleccion(
	@par_EMPR_Codigo SMALLINT,
	@par_Numero numeric = NULL,
	@par_FechaInicial Date = NULL,
	@par_FechaFinal Date = NULL,              
	@par_OFIC_Codigo NUMERIC = NULL,                       
	@par_CIUD_Codigo_Remitente NUMERIC = NULL,
	@par_CIUD_Codigo_Destinatario NUMERIC = NULL,
	@par_TERC_Codigo_Cliente NUMERIC = NULL,
	@par_Documento_Cliente VARCHAR(30) = NULL,
	@par_Codigo_Remitente NUMERIC = NULL,
	@par_NumeroPagina INT = NULL,                                                                  
	@par_RegistrosPagina INT = NULL
)                                                                              
AS                                                                            
BEGIN                                                                              
	IF @par_FechaInicial <> NULL BEGIN                                                                              
	SET @par_FechaInicial = CONVERT(DATE, @par_FechaInicial, 101)                                                              
	END                                                                              
                                           
	IF @par_FechaFinal <> NULL BEGIN                                                                              
	SET @par_FechaFinal = CONVERT(DATE, @par_FechaFinal, 101)                                                           
	END                                                                              
                                                                              
	SET NOCOUNT ON;                                                                                    
	DECLARE @CantidadRegistros INT                                                            
	SELECT                                                                              
	@CantidadRegistros = (SELECT DISTINCT                                                           
	COUNT(1)                                                                              
	FROM Remesas_Paqueteria ENRP                                                                              
                                                                              
	INNER JOIN Encabezado_Remesas AS ENRE                                                                        
	ON ENRP.EMPR_Codigo = ENRE.EMPR_Codigo                                                                              
	AND ENRP.ENRE_Numero = ENRE.Numero                                                                              
                                                                              
	INNER JOIN Oficinas AS OFIC ON                                                                
	ENRE.EMPR_Codigo = OFIC.EMPR_Codigo                                                                
	AND ENRE.OFIC_Codigo = OFIC.Codigo                                                                
                                                                       
	LEFT JOIN Ciudades CIOR                                                                     
	ON ENRP.EMPR_Codigo = CIOR.EMPR_Codigo                                                                       
	AND ENRP.CIUD_Codigo_Origen = CIOR.Codigo                                                                              
                                                                              
	LEFT JOIN Ciudades CIDE                                                                              
	ON ENRP.EMPR_Codigo = CIDE.EMPR_Codigo                                                                              
	AND ENRP.CIUD_Codigo_Destino = CIDE.Codigo
	
	LEFT JOIN Terceros AS CLIE                                                       
	ON ENRE.EMPR_Codigo = CLIE.EMPR_Codigo                                                                              
	AND ENRE.TERC_Codigo_Cliente = CLIE.Codigo                                                                  
         
	LEFT JOIN Terceros AS REMI                                                                              
	ON ENRE.EMPR_Codigo = REMI.EMPR_Codigo                                                            
	AND ENRE.TERC_Codigo_Remitente = REMI.Codigo    
	
	WHERE ENRE.EMPR_Codigo = @par_EMPR_Codigo                         
	AND (ENRE.Numero_Documento = @par_Numero OR @par_Numero IS NULL)
	AND ENRE.Fecha >= ISNULL(@par_FechaInicial, ENRE.Fecha)                                                                              
	AND ENRE.Fecha <= ISNULL(@par_FechaFinal, ENRE.Fecha)
	AND ENRE.TIDO_Codigo = 110
	AND (ENRE.OFIC_Codigo = @par_OFIC_Codigo OR @par_OFIC_Codigo IS NULL)
	AND ENRE.ENPR_Numero = 0 --Asinacion previa de planilla recoleccion
	AND (ENRE.TERC_Codigo_Cliente = @par_TERC_Codigo_Cliente OR @par_TERC_Codigo_Cliente IS NULL)
	AND (ENRP.CIUD_Codigo_Origen = @par_CIUD_Codigo_Remitente OR @par_CIUD_Codigo_Remitente IS NULL)
	AND (ENRP.CIUD_Codigo_Destino = @par_CIUD_Codigo_Destinatario OR @par_CIUD_Codigo_Destinatario IS NULL)
	AND (ENRE.Documento_Cliente = @par_Documento_Cliente OR @par_Documento_Cliente IS NULL)
	AND (ENRE.TERC_Codigo_Remitente = @par_Codigo_Remitente OR @par_Codigo_Remitente IS NULL)
	AND ENRE.Anulado = 0

	);                                                                              
	WITH Pagina                                                                              
	AS                                                                              
	(                                            
	SELECT                                                                              
	ENRE.EMPR_Codigo                                      
	,ENRE.Numero                                                                              
	,ENRE.Numero_Documento                                         
	,ENRE.Numeracion
	,ENRE.Fecha                  
	,ENRP.CIUD_Codigo_Origen
	,ENRP.CIUD_Codigo_Destino
	,CIOR.Nombre AS CiudadOrigen                 
	,CIDE.Nombre AS CiudadDestino
	,ENRE.TERC_Codigo_Cliente
	,ISNULL(CLIE.Razon_Social, '') + ' ' + ISNULL(CLIE.Nombre, '') + ' ' + ISNULL(CLIE.Apellido1, '') + ' ' + ISNULL(CLIE.Apellido2, '') AS NombreCliente
	,ENRE.TERC_Codigo_Remitente
	,ISNULL(REMI.Razon_Social, '') + ' ' + ISNULL(REMI.Nombre, '') + ' ' + ISNULL(REMI.Apellido1, '') + ' ' + ISNULL(REMI.Apellido2, '') AS NombreRemitente
	,ISNULL(ENRP.OFIC_Codigo_Origen, 0) AS OFIC_Codigo_Origen                                                              
	,ISNULL(OFIC.Nombre, '') AS NombreOficinaOrigen                                                                 
	,ENRE.Observaciones                                                                
	,ENRE.Cantidad_Cliente                                                                              
	,ENRE.Peso_Cliente                                     
	,ENRP.Peso_Volumetrico                                    
	,ENRP.Peso_A_Cobrar                                                               
	,ENRE.Estado                                                                              
	,ENRE.Anulado
	,ENRE.Documento_Cliente
	,ENRE.OFIC_Codigo
	,OFIC.Nombre As NombreOficina
	,ROW_NUMBER() OVER (ORDER BY ENRP.ENRE_Numero) AS RowNumber                                                                              
	FROM Remesas_Paqueteria ENRP                                                                              
                                                                              
	INNER JOIN Encabezado_Remesas AS ENRE                                                                        
	ON ENRP.EMPR_Codigo = ENRE.EMPR_Codigo                                                                              
	AND ENRP.ENRE_Numero = ENRE.Numero                                                                              
                                                                              
	INNER JOIN Oficinas AS OFIC ON                                                                
	ENRE.EMPR_Codigo = OFIC.EMPR_Codigo                                                                
	AND ENRE.OFIC_Codigo = OFIC.Codigo                                                                
                                                                       
	LEFT JOIN Ciudades CIOR                                                                     
	ON ENRP.EMPR_Codigo = CIOR.EMPR_Codigo                                                                       
	AND ENRP.CIUD_Codigo_Origen = CIOR.Codigo                                                                              
                                                                              
	LEFT JOIN Ciudades CIDE                                                                              
	ON ENRP.EMPR_Codigo = CIDE.EMPR_Codigo                                                                              
	AND ENRP.CIUD_Codigo_Destino = CIDE.Codigo

	LEFT JOIN Terceros AS CLIE                                                       
	ON ENRE.EMPR_Codigo = CLIE.EMPR_Codigo                                                                              
	AND ENRE.TERC_Codigo_Cliente = CLIE.Codigo                                                                  
         
	LEFT JOIN Terceros AS REMI                                                                              
	ON ENRE.EMPR_Codigo = REMI.EMPR_Codigo                                                            
	AND ENRE.TERC_Codigo_Remitente = REMI.Codigo    
	
	WHERE ENRE.EMPR_Codigo = @par_EMPR_Codigo                         
	AND (ENRE.Numero_Documento = @par_Numero OR @par_Numero IS NULL)
	AND ENRE.Fecha >= ISNULL(@par_FechaInicial, ENRE.Fecha)                                                                              
	AND ENRE.Fecha <= ISNULL(@par_FechaFinal, ENRE.Fecha)
	AND ENRE.TIDO_Codigo = 110
	AND (ENRE.OFIC_Codigo = @par_OFIC_Codigo OR @par_OFIC_Codigo IS NULL)
	AND ENRE.ENPR_Numero = 0 --Asinacion previa de planilla recoleccion
	AND (ENRE.TERC_Codigo_Cliente = @par_TERC_Codigo_Cliente OR @par_TERC_Codigo_Cliente IS NULL)
	AND (ENRP.CIUD_Codigo_Origen = @par_CIUD_Codigo_Remitente OR @par_CIUD_Codigo_Remitente IS NULL)
	AND (ENRP.CIUD_Codigo_Destino = @par_CIUD_Codigo_Destinatario OR @par_CIUD_Codigo_Destinatario IS NULL)
	AND (ENRE.Documento_Cliente = @par_Documento_Cliente OR @par_Documento_Cliente IS NULL)
	AND (ENRE.TERC_Codigo_Remitente = @par_Codigo_Remitente OR @par_Codigo_Remitente IS NULL)
	AND ENRE.Anulado = 0                              
	)                                                                              
	SELECT DISTINCT                                        
	0 AS Obtener                                                                              
	,EMPR_Codigo                                                                
	,Numero                                                                              
	,Numero_Documento
	,Numeracion                                                                                                          
	,Fecha              
	,CIUD_Codigo_Origen                                                                              
	,CIUD_Codigo_Destino                                     
	,CiudadOrigen                                                                              
	,CiudadDestino
	,TERC_Codigo_Cliente
	,NombreCliente
	,TERC_Codigo_Remitente
	,NombreRemitente
	,OFIC_Codigo_Origen                                                                
	,NombreOficinaOrigen                                                                        
	,Observaciones                                                                              
	,Cantidad_Cliente                                                           
	,Peso_Cliente                            
	,Peso_Volumetrico                                    
	,Peso_A_Cobrar                                                                              
	,Estado                                                          
	,Anulado                                                                                                                     
	,Documento_Cliente                         
	,OFIC_Codigo                                                                
	,NombreOficina
	,@CantidadRegistros AS TotalRegistros                                                                              
	,@par_NumeroPagina AS PaginaObtener                                                                              
	,@par_RegistrosPagina AS RegistrosPagina                                                                   
	FROM Pagina                                                                              
	WHERE RowNumber > (ISNULL(@par_NumeroPagina, 1) - 1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)                                                                       
	AND RowNumber <= ISNULL(@par_NumeroPagina, 1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)                                                                              
	ORDER BY Numero ASC                                                                   
END
GO
---------------------------------------------------------------
PRINT 'gsp_obtener_remesa_paqueteria'
GO
DROP PROCEDURE gsp_obtener_remesa_paqueteria
GO
CREATE PROCEDURE gsp_obtener_remesa_paqueteria
(                        
	@par_EMPR_Codigo smallint,                    
	@par_Numero Numeric                    
)                        
AS                    
BEGIN                    
	select DISTINCT                         
	1 as Obtener,                        
	ENRE.EMPR_Codigo,                          
	ENRE.Fecha,                          
	ENRE.Numero,                        
	ENRE.Numeracion,                         
	ENRE.Numero_Documento,                          
	ENRE.Remesa_Cortesia,                        
	ENRE.Documento_Cliente,                          
	ENRE.Observaciones,                          
	ENRE.Fecha_Documento_Cliente,                          
	ENRE.CATA_FOPR_Codigo,                          
	ENRE.TERC_Codigo_Cliente,                          
	ENRE.DTCV_Codigo,                          
	ENRE.PRTR_Codigo,                          
	ENRE.Peso_Cliente,                          
	ENRE.Cantidad_Cliente,                          
	ENRE.Valor_Comercial_Cliente,                          
	ENRE.Peso_Volumetrico_Cliente,                          
	ENPR.CATA_TERP_Codigo,                          
	ENPR.CATA_TTRP_Codigo,                          
	ENPR.CATA_TDRP_Codigo,                          
	ENPR.CATA_TIRP_Codigo,                          
	ENPR.CATA_TPRP_Codigo,                          
	ENPR.CATA_TSRP_Codigo,                          
                        
	ENRE.TERC_Codigo_Remitente,                          
	ENRE.CIUD_Codigo_Remitente,                          
	ENRE.Direccion_Remitente,                          
	ENRE.Telefonos_Remitente,                          
	ENRE.TERC_Codigo_Destinatario,                          
	ENRE.CIUD_Codigo_Destinatario,                          
	ENRE.Direccion_Destinatario,                          
	ENRE.Telefonos_Destinatario,                          
	ENRE.Valor_Flete_Cliente,                          
	ENRE.Valor_Manejo_Cliente,                          
	ENRE.Valor_Seguro_Cliente,                          
	ENRE.Valor_Descuento_Cliente,                          
	ENRE.Total_Flete_Cliente,                        
	ENRE.Valor_Comision_Oficina,                        
	ENRE.Valor_Comision_Agencista,                        
	ENRE.Total_Flete_Transportador,                          
	ENRE.Estado,
	ENRE.Anulado,
	ISNULL(ENPR.OFIC_Codigo_Origen,0) AS OFIC_Codigo_Origen,                        
	ISNULL(OFOR.Nombre, '') AS NombreOficinaOrigen,                        
	ISNULL(DTCV.ETCV_Numero,DTCV2.ETCV_Numero) As ETCV_Numero,                        
	ISNULL(DTCV.LNTC_Codigo,DTCV2.LNTC_Codigo) As LNTC_Codigo,                          
	ISNULL(DTCV.TLNC_Codigo,DTCV2.TLNC_Codigo) As TLNC_Codigo,                        
	ISNULL(DTCV.RUTA_Codigo,DTCV2.RUTA_Codigo) As RUTA_Codigo,                        
	ISNULL(DTCV.TATC_Codigo,DTCV2.TATC_Codigo) As TATC_Codigo,                        
	ISNULL(TTTC.NombreTarifa,'') As NombreTarifa,                        
	ISNULL(DTCV.TTTC_Codigo,DTCV2.TTTC_Codigo) As TTTC_Codigo,                        
	ISNULL(TTTC.Nombre,'') As NombreTipoTarifa,                        
                        
	ENPR.Fecha_Interfaz_Cargue_Archivo,                        
	ENPR.Fecha_Interfaz_Cargue_WMS,                        
	ISNULL(ENRE.VEHI_Codigo,0) as VEHI_Codigo,              
	ISNULL(VEHI.Placa,'') As VEHI_Placa,  
	ISNULL(VEHI.Codigo_Alterno,'') As VEHI_CodigoAlterno,  
	ISNULL(ENRE.SEMI_Codigo,0) As SEMI_Codigo,                         
                        
	ENRE.CATA_TIRE_Codigo,                         
	ISNULL(ENPR.Reexpedicion,0) As Reexpedicion,                        
	ISNULL(ENRE.Valor_Reexpedicion,0) As Valor_Reexpedicion,              
	REMI.CATA_TIID_Codigo As TIID_Remitente,                        
	REMI.Numero_Identificacion As Identificacion_Remitente,                        
	RTRIM(LTRIM(ISNULL(REMI.Razon_Social,'') + ISNULL(REMI.Nombre,'') + ' ' + ISNULL(REMI.Apellido1, '') + ' ' + ISNULL(REMI.Apellido2,''))) As NombreRemitente,                        
	ISNULL(REMI.Correo_Facturacion, '') AS Correo_Remitente,                        
	ISNULL(ENRE.Barrio_Remitente,'') As Barrio_Remitente,      
	ISNULL(ENRE.Codigo_Postal_Remitente,'') As Codigo_Postal_Remitente,                        
	ISNULL(ENPR.Observaciones_Remitente,'') As Observaciones_Remitente,                        
                        
	DEST.CATA_TIID_Codigo As TIID_Destinatario,                        
	DEST.Numero_Identificacion As Identificacion_Destinatario,                        
	LTRIM(RTRIM(ISNULL(DEST.Razon_Social,'') + ISNULL(DEST.Nombre,'') + ' ' + ISNULL(DEST.Apellido1, '') + ' ' + ISNULL(DEST.Apellido2,''))) As NombreDestinatario,                        
	ISNULL(DEST.Correo_Facturacion, '') AS Correo_Destinatario,                        
	ISNULL(ENRE.Barrio_Destinatario,'') As Barrio_Destinatario,                          
                          
                         
	ISNULL(ENRE.Codigo_Postal_Destinatario, '') As Codigo_Postal_Destinatario,                        
	ISNULL(ENPR.Observaciones_Destinatario,'') As Observaciones_Destinatario,                        
	ISNULL(ENPR.Descripcion_Mercancia,'') As Descripcion_Mercancia,                        
	ISNULL(ENPR.OFIC_Codigo_Origen,0) As OFIC_Codigo_Origen,                        
	ISNULL(ENPR.OFIC_Codigo_Destino,0) As OFIC_Codigo_Destino,                           
	ISNULL(ENPR.OFIC_Codigo_Actual,0) As OFIC_Codigo_Actual,                        
	--ISNULL(OFOR.Nombre,'') As NombreOficinaOrigen,                        
	ISNULL(OFDE.Nombre,'') As NombreOficinaDestino,                        
	ISNULL(OFAC.Nombre,'') As NombreOficinaActual,                        
                     
	ENPR.CATA_ESRP_Codigo,              
	DERP.Fecha_Crea AS Fecha_Estado_Remesa,          
	OFER.Nombre AS Oficina_Nombre_Estado_Remesa,          
	ESRP.Nombre As NombreEstadoRemesa,                        
	ENRE.ENPD_Numero,                          
	CASE                         
	WHEN ENRE.ENPR_Numero = 0 THEN                         
	--(CASE WHEN ENPD.Numero_Documento = 0 THEN ENPE.Numero_Documento ELSE ENPD.Numero_Documento END )                         
	IIF(ENRE.ENPD_Numero = 0,ENPE.Numero_Documento,ENPD.Numero_Documento)                        
	ELSE EPRE.Numero_Documento END  AS NumeroDocumentoPlanilla,               
	ENPD.Fecha AS FechaPlanillaActual,                     
	ISNULL(ENFA.Numero_Documento, 0) AS ENFA_Numero_Documento,                      
	ISNULL(COND.Razon_Social,'') + ISNULL(COND.Nombre,'') + ' ' + ISNULL(COND.Apellido1, '') + ' ' + ISNULL(COND.Apellido2,'') As NombreConductor,                        
	ENRE.OFIC_Codigo,                        
	OFIC.Nombre As NombreOficina,                          
	ENPR.Centro_Costo,                          
	ENPR.CATA_LISC_Codigo,                          
	SICA.Nombre AS SitioCargue,                        
	ENPR.SICD_Codigo_Cargue,                          
	SIDE.Nombre AS SitioDescargue,                          
	ENPR.SICD_Codigo_Descargue,                          
	ENPR.Fecha_Entrega,                          
	ENRE.Valor_Flete_Transportador,                          
	ENRE.Total_Flete_Transportador,                        
	ENPR.Largo,                        
	ENPR.Alto,                        
	ENPR.Ancho,                        
	ENPR.Peso_Volumetrico,                        
	ENPR.Peso_A_Cobrar,                        
	ENPR.Flete_Pactado,                        
	ENPR.Ajuste_Flete,                          
	ENPR.CATA_LNPA_Codigo,                          
	ENPR.Recoger_Oficina_Destino,                        
	ENPR.OFIC_Codigo_Recibe,                        
	OFRE.Nombre AS OFIC_Nombre_Recibe,                        
	ENPR.Maneja_Detalle_Unidades,                        
	ENPR.ZOCI_Codigo_Entrega,                        
	ENPR.Latitud,                        
	ENPR.Longitud,                        
	ENPR.CATA_HERP_Codigo,                          
	ENPR.Liquidar_Unidad,                        
	ISNULL(ENRE.Valor_Otros, 0) Valor_Otros,                        
	ISNULL(ENRE.Valor_Cargue, 0) Valor_Cargue,                        
	ISNULL(ENRE.Valor_Descargue, 0) Valor_Descargue,                      
	ISNULL(ENPR.Devolucion, '') Devolucion,                      
	ISNULL(ENPR.Fecha_Devolucion, '') Fecha_Devolucion,          
	ISNULL(ELRG.Numero_Documento, 0) ELRG_NumeroDocumento,                
	ISNULL(ENPR.TERC_Codigo_Aforador, 0) TERC_Codigo_Aforador,                  
	ISNULL(ENPR.OFIC_Codigo_Registro_Manual, 0) OFIC_Codigo_Registro_Manual,      
	ISNULL(NERP.Campo1, '') AS NovedadRecibe,    
	ISNULL(ELGU.Numero_Documento, 0) AS ELGU_NumeroDocumento    
      
	from         
	Remesas_Paqueteria as ENPR                        
                          
	LEFT JOIN Sitios_Cargue_Descargue AS SICA ON                          
	ENPR.EMPR_Codigo = SICA.EMPR_Codigo                          
	AND ENPR.SICD_Codigo_Cargue = SICA.Codigo                          
                          
	LEFT JOIN Sitios_Cargue_Descargue AS SIDE ON                          
	ENPR.EMPR_Codigo = SIDE.EMPR_Codigo                          
	AND ENPR.SICD_Codigo_Descargue = SIDE.Codigo                          
                          
	INNER JOIN Encabezado_Remesas AS ENRE                          
	ON ENPR.EMPR_Codigo = ENRE.EMPR_Codigo                        
	AND ENPR.ENRE_Numero = ENRE.Numero                          
                          
	INNER JOIN Terceros As REMI ON                        
	ENRE.EMPR_Codigo = REMI.EMPR_Codigo                        
	AND ENRE.TERC_Codigo_Remitente = REMI.Codigo                          
                         
	INNER JOIN Terceros As DEST ON                        
	ENRE.EMPR_Codigo = DEST.EMPR_Codigo                        
	AND ENRE.TERC_Codigo_Destinatario = DEST.Codigo                         
                         
	INNER JOIN V_Estado_Remesa_Paqueteria AS ESRP ON                        
	ENPR.EMPR_Codigo = ESRP.EMPR_Codigo                        
	AND ENPR.CATA_ESRP_Codigo = ESRP.Codigo                        
                        
	INNER JOIn Oficinas AS OFIC ON                        
	ENRE.EMPR_Codigo = OFIC.EMPR_Codigo                        
	AND ENRE.OFIC_Codigo = OFIC.Codigo                        
                        
	LEFT JOIN Oficinas As OFOR ON                        
	ENPR.EMPR_Codigo = OFOR.EMPR_Codigo                        
	AND ENPR.OFIC_Codigo_Origen = OFOR.Codigo                        
                        
	LEFT JOIN Oficinas As OFDE ON                        
	ENPR.EMPR_Codigo = OFDE.EMPR_Codigo                        
	AND ENPR.OFIC_Codigo_Destino = OFDE.Codigo                        
                         
	LEFT JOIN Oficinas As OFAC ON                        
	ENPR.EMPR_Codigo = OFAC.EMPR_Codigo                        
	AND ENPR.OFIC_Codigo_Actual = OFAC.Codigo                        
                        
	LEFT JOIN Oficinas As OFRE ON                        
	ENPR.EMPR_Codigo = OFRE.EMPR_Codigo                        
	AND ENPR.OFIC_Codigo_Recibe = OFRE.Codigo                        
                           
	LEFT JOIN Detalle_Tarifario_Carga_Ventas AS DTCV                          
	ON ENPR.EMPR_Codigo = DTCV.EMPR_Codigo                         
	AND ENRE.DTCV_Codigo = DTCV.Codigo                        
                          
	LEFT JOIN Detalle_Tarifario_Carga_Ventas AS DTCV2                          
	ON ENPR.EMPR_Codigo = DTCV2.EMPR_Codigo                          
	AND ENRE.EMPR_Codigo = DTCV2.EMPR_Codigo                          
	AND ENRE.ETCV_Numero = DTCV2.ETCV_Numero                          
	AND ENRE.CIUD_Codigo_Remitente = DTCV2.CIUD_Codigo_Origen                          
	AND ENRE.CIUD_Codigo_Destinatario= DTCV2.CIUD_Codigo_Destino                        
	AND ENRE.CATA_FOPR_Codigo= DTCV2.CATA_FPVE_Codigo                      
                         
	LEFT JOIN V_Tipo_Tarifa_Transporte_Carga As TTTC ON                        
	ISNULL(DTCV.EMPR_Codigo,DTCV2.EMPR_Codigo) = TTTC.EMPR_Codigo                        
	AND ISNULL(DTCV.TATC_Codigo,DTCV2.TATC_Codigo) = TTTC.TATC_Codigo                        
	AND ISNULL(DTCV.TTTC_Codigo,DTCV2.TTTC_Codigo) = TTTC.Codigo                        
                        
	LEFT JOIN Vehiculos AS VEHI ON                        
	ENRE.EMPR_Codigo = VEHI.EMPR_Codigo                        
	AND ENRE.VEHI_Codigo = VEHI.Codigo                        
                        
	LEFT JOIN Terceros As COND ON                        
	ENRE.EMPR_Codigo = COND.EMPR_Codigo                        
	AND ENRE.TERC_Codigo_Conductor = COND.Codigo            
	AND ENRE.TERC_Codigo_Conductor > 0            
              
	LEFT JOIN Encabezado_Planilla_Despachos As ENPD ON                        
	ENPD.EMPR_Codigo = ENPR.EMPR_Codigo                        
	AND ENPD.Numero = ENPR.ENPD_Numero_Ultima_Planilla          
                        
	LEFT JOIN Encabezado_Planilla_Despachos As EPRE ON                        
	EPRE.EMPR_Codigo = ENRE.EMPR_Codigo                     
	AND EPRE.Numero = ENRE.ENPR_Numero                         
                        
	LEFT JOIN Encabezado_Planilla_Despachos As ENPE ON                        
	ENPE.EMPR_Codigo = ENRE.EMPR_Codigo                        
	AND ENPE.Numero = ENRE.ENPE_Numero                      
                      
	LEFT JOIN Encabezado_Facturas As ENFA ON                        
	ENRE.EMPR_Codigo = ENFA.EMPR_Codigo                        
	AND ENRE.ENFA_Numero = ENFA.Numero                    
          
	LEFT JOIN Detalle_Legalizacion_Recaudo_Guias As DLRG ON                        
	ENRE.EMPR_Codigo = DLRG.EMPR_Codigo                        
	AND ENRE.Numero = DLRG.ENRE_Numero                    
                    
	LEFT JOIN Encabezado_Legalizacion_Recaudo_Guias As ELRG ON                        
	DLRG.EMPR_Codigo = ELRG.EMPR_Codigo                        
	AND DLRG.ELRG_Numero = ELRG.Numero              
              
	LEFT JOIN (              
	SELECT TOP 1 ERPA.* FROM Detalle_Estados_Remesas_Paqueteria ERPA              
	LEFT JOIN Encabezado_Planilla_Despachos ENDP1 ON              
	ERPA.EMPR_Codigo = ENDP1.EMPR_Codigo              
	AND ERPA.ENPD_Numero = ENDP1.Numero      
     
	WHERE ERPA.EMPR_Codigo = @par_EMPR_Codigo              
	AND ERPA.ENRE_Numero = @par_Numero              
	AND ISNULL(ENDP1.Anulado, 0) = 0          
	AND ERPA.OFIC_Codigo IS NOT NULL          
              
	ORDER BY ID DESC              
	) AS DERP ON              
	ENPR.EMPR_Codigo = DERP.EMPR_Codigo                        
	AND ENPR.CATA_ESRP_Codigo = DERP.CATA_ESPR_Codigo          
          
	LEFT JOIN Oficinas OFER ON          
	DERP.EMPR_Codigo = OFER.EMPR_Codigo          
	AND DERP.OFIC_Codigo = OFER.Codigo       
       
	LEFT JOIN Valor_Catalogos NERP ON          
	ENPR.EMPR_Codigo = NERP.EMPR_Codigo          
	AND ENPR.CATA_NERP_Codigo = NERP.Codigo     
     
	LEFT JOIN (      
	SELECT DLGU.EMPR_Codigo, DLGU.ENRE_Numero, MAX(ENLG.Numero_Documento) AS Numero_Documento FROM Detalle_Legalizacion_Guias DLGU      
	INNER JOIN Encabezado_Legalizacion_Guias ENLG ON            
	ENLG.EMPR_Codigo = DLGU.EMPR_Codigo            
	AND ENLG.Numero = DLGU.ELGU_Numero      
	WHERE DLGU.EMPR_Codigo = @par_EMPR_Codigo      
	AND DLGU.ENRE_Numero = @par_Numero    
	AND ENLG.Estado = 1    
	AND ENLG.Anulado = 0    
	group by DLGU.EMPR_Codigo, DLGU.ENRE_Numero      
	) AS ELGU ON      
	ENRE.EMPR_Codigo = ELGU.EMPR_Codigo            
	AND ENRE.Numero = ELGU.ENRE_Numero              
             
	WHERE                      
	ENRE.EMPR_Codigo = @par_EMPR_Codigo                        
	AND ENRE.Numero = @par_Numero                        
	AND ENRE.TIDO_Codigo = 110 --> Guía                        
END
GO
--------------------------------------------------
PRINT 'gsp_Reporte_Encabezado_Manifiesto'
GO
DROP PROCEDURE gsp_Reporte_Encabezado_Manifiesto
GO
CREATE PROCEDURE gsp_Reporte_Encabezado_Manifiesto
(                                                                    
	@par_EMPR_Numero NUMERIC,                                                                        
	@par_Numero NUMERIC,                                                            
	@par_USUA_Codigo numeric = NULL                                                        
)                                                                        
AS BEGIN                                                                         
SELECT  TOP(1)                                                                      
EMPR.Nombre_Razon_Social AS NombreEmpresa                                                                        
,EMPR.Numero_Identificacion AS Nit_Empresa                                                                        
,EMPR.Direccion AS DireccionEmpresa                                                                         
,CIEM.Nombre AS CiudadEmpresa                                                                        
,EMPR.Telefonos AS TelefonoEmpresa                                                                         
,EMPR.Codigo_Alterno AS CodigoInterno                                                                        
,ENMA.Numero_Manifiesto_Electronico                                                                         
,ENMA.Numero_Documento AS NumeroInternoManifiesto                                                                         
,ENMA.Fecha_Crea AS FechaExpedicion                                                                        
,CIOR.Nombre AS CiudadOrigen                                                                        
,CIDE.Nombre AS CiudadDestino                                                                        
,DATEADD(DAY,15,ENMA.Fecha_Crea) AS FechaLimite                                                                         
,ISNULL(TENE.Razon_Social,'')+' '+ISNULL(TENE.Nombre,'')                                                                          
+' '+ISNULL(TENE.Apellido1,'')+' '+ISNULL(TENE.Apellido2,'') AS TitutlarManifiesto                                                                        
,TENE.Numero_Identificacion AS IdentificacionTitular                                                                         
,TENE.Direccion AS DireccionTitular                                                                          
,TENE.Telefonos AS TelefonoTitular                                                                        
,CITE.Nombre AS CiudadTitular                                                                        
,RUTA.Nombre AS NombreRuta      
,RUPL.Nombre as RutaPLanilla    
,VEHI.Placa AS PlacaVehiculo                                                                     
,VEHI.Peso_Bruto                                                                       
,VEHI.Peso_Tara                                                                       
,VEHI.CATA_TIDV_Codigo                                                                       
,MAVE.Nombre AS MarcaVehiculo                                                                        
,SEMI.Placa AS PlacaSemiremolque                                                                         
,ISNULL(TEPR.Razon_Social,'')+' '+ISNULL(TEPR.Nombre,'')                                                                          
+' '+ISNULL(TEPR.Apellido1,'')+' '+ISNULL(TEPR.Apellido2,'') AS TitutlarPropietario                                                                        
,TEPR.Numero_Identificacion AS IdentificacionPropietario                                                                         
,TEPR.Direccion AS DireccionPropietario                                                                        
,TEPR.Telefonos AS TelefonoPropietario                                                                        
,CIPR.Nombre AS CiudadPropietario                 
,ISNULL(TENE.Razon_Social,'')+' '+ISNULL(TENE.Nombre,'')               
+' '+ISNULL(TENE.Apellido1,'')+' '+ISNULL(TENE.Apellido2,'') AS TitutlarTenedor                                                                        
,TENE.Numero_Identificacion AS IdentificacionTenedor                                
,TENE.Direccion AS DireccionTenedor                                           
,TENE.Telefonos AS TelefonoTitular                                               
,CITE.Nombre AS CiudadTenedor                                          
,ISNULL(TECO.Razon_Social,'')+' '+ISNULL(TECO.Nombre,'')                                                                
+' '+ISNULL(TECO.Apellido1,'')+' '+ISNULL(TECO.Apellido2,'') AS TitutlarConductor                                                                             
,TECO.Numero_Identificacion AS IdentificacionConductor                                                                        
,TECO.Direccion AS DireccionConductor        
,TECO.Telefonos  AS TelefonoConductor                                                                        
,CICO.Nombre AS CiudadConductor                     
,CASE              
WHEN(ISNULL(TECO2.Numero_Identificacion,'')) = '' THEN 'xxxxxx' ELSE (ISNULL(TECO2.Razon_Social,'')+' '+ISNULL(TECO2.Nombre,'') +' '+ISNULL(TECO2.Apellido1,'')+' '+ISNULL(TECO2.Apellido2,'')) END TitularSegundoConductor                    
,CASE               
WHEN ISNULL(TECO2.Numero_Identificacion,'') = '' THEN 'xxxxxx' ELSE TECO2.Numero_Identificacion END IdentificacionSegundoConductor              
,CASE               
WHEN ISNULL(TECO2.Numero_Identificacion,'') = '' THEN 'xxxxxx' ELSE TECO2.Direccion END DireccionSegundoConductor              
,CASE               
WHEN ISNULL(TECO2.Numero_Identificacion,'') = '' THEN 'xxxxxx' ELSE TECO2.Telefonos END TelefonoSegundoConductor              
,CASE               
WHEN ISNULL(TECO2.Numero_Identificacion,'') = '' THEN 'xxxxxx' ELSE CICO2.Nombre END CiudadSegundoConductor              
              
,ENMA.Valor_Flete AS ValoPagarPactado                                        
,dbo.funcCantidadConLetra(ENMA.Valor_Flete) AS ValoPagarPactadoletra                                            
,ENMA.Valor_Flete_Neto  AS ValorNetoPagar                                                                        
,ENMA.Valor_Anticipo AS ValorAnticipo                                                                        
,ENMA.Valor_Pagar AS SaldoPagar                                               
,ENMA.Fecha_Cumplimiento AS FechaPagoSaldo                                                                        
,CIDE.Nombre AS LugarSaldoPaga                                                                        
,ISNULL(POLI.Razon_Social,'')+' '+ISNULL(POLI.Nombre,'')                                               
+' '+ISNULL(POLI.Apellido1,'')+' '+ISNULL(POLI.Apellido2,'') AS CompañiaSeguro                                                                                                                    
                                                                    
,ENMA.Valor_ICA AS ICA                                                                        
,ENMA.Valor_Retencion_Fuente AS ReteFuente                                                                        
,EMPR.Prefijo PreEmpresa                                                                        
,ENMA.QRManifiesto                            
,ENMA.Codigo_Seguridad_Manifiesto_Electronico                                          
--,CASE WHEN ENMA.Observacion_Manifiesto_Electronico IS NOT NULL THEN SUBSTRING(REPLACE(ENMA.Observacion_Manifiesto_Electronico,' ALERTA003 OBSERVACIONESQR: ',''),1,120) ELSE '' END AS Observacion_Manifiesto_Electronico                                   
  
   
,CASE WHEN ENMA.Observacion_Manifiesto_Electronico IS NOT NULL THEN REPLACE(ENMA.Observacion_Manifiesto_Electronico,' ALERTA003 OBSERVACIONESQR: ','') ELSE '' END AS Observacion_Manifiesto_Electronico                    
,CASE WHEN ENMA.Observacion_Manifiesto_Electronico IS NOT NULL THEN REPLACE(ENMA.Observacion_Manifiesto_Electronico,' ALERTA003 OBSERVACIONESQR: ','') ELSE '' END AS Observacion_Manifiesto        
,USCR.Codigo_Usuario UsuarioCrea                                                                    
,USCR.Nombre NombreUsuario                                          
,USCM.Nombre AS UsuarioCrea2                                    
,COVE.Nombre ColorVehiculo                                                        
,ENMA.Observaciones                                                             
,VEHI.Modelo                                                      
,TICA.Campo1 AS TipoCarroceria                                                  
,CALC.Campo1 AS CategoriaLicencia                                                  
,(SELECT TOP(1) VEDC.Documento FROM GESCARGA50_DOCU..Fotos_Vehiculos AS VEDC WHERE VEDC.EMPR_Codigo = VEHI.EMPR_Codigo AND VEDC.VEHI_Codigo = VEHI.Codigo) AS FotoVehiculo                                                  
--,VEDC.Documento AS FotoVehiculo                                                  
,(SELECT TOP(1) TEDC.Archivo FROM GESCARGA50_DOCU..Tercero_Fotos AS TEDC WHERE TEDC.EMPR_Codigo = TECO.EMPR_Codigo AND TEDC.TERC_Codigo = TECO.Codigo) AS FotoConductor                                                  
--,TEDC.Archivo AS FotoConductor                                                  
,LIVE.Nombre AS LineaVehiculo                          
--,VEDC.Nombre_Documento SEGURO                           |                                         
--,VEDC.Fecha_Vence FECHAVENCESEGURO                             
--,VEDC.Referencia NumeroSeguro                                                     
,DPOS.Fecha_Cargue                                                  
,DPOS.Fecha_Descargue                                              
/*                                               
MODIFICACION:                                              
 REALIZADA POR: SANTIAGO CORREA                                              
 FECHA: 03/09/2019                         
 OBJETIVO: DETERMINAR QUIEN PAGARA EL VALOR CARGUE Y EL VALOR DESCARGUE                                              
 UBICACION: PRODUCT BACKLOG ITEM #83                                              
 DESCRIPCION: "SI EL VALOR DEL CARGUE ES DIFERENTE DE CERO "0", EL CARGUE LO PAGA EL TRANSPORTADOR. DE LO CONTRARIO LO PAGA EL REMITENTE.                                              
     SI EL VALOR DEL DESCARGUE ES DIFERENTE DE CERO "0", L DESCARGUE LO PAGA EL TRANSPORTADOR. DE LO CONTRARIO LO PAGA EL DESTINATARIO."                                              
                                              
*/                                              
,IIF(ISNULL(DPOS.Valor_Cargue_Cliente,0) <> 0,'TRANSPORTADOR','REMITENTE') AS Paga_Cargue                                              
,IIF(ISNULL(DPOS.Valor_Descargue_Cliente,0) <> 0,'TRANSPORTADOR','DESTINATARIO') AS Paga_Descargue                                               
,IIF(ENMA.Numero_Manifiesto_Electronico <> 0,'1','0')        
/**/        
,ENMA.Fecha_Reporte_Manifiesto_Electronico        
,TIMA.Nombre AS Tipo_Manifiesto        
,TIVE.Campo5 as Configuracion_Vehiculo                 
,VEHI.Fecha_Vencimiento_SOAT AS VencimientoPoliza                                                                         
,VEHI.Referencia_SOAT AS NumeroPoliza              
,TECA.Numero_Licencia         
,SEMI.Peso_Vacio AS PesoVacioRemolque      
,CASE       
WHEN ENMA.Anulado = 1 THEN 'ANULADO'      
WHEN ENMA.Estado  = 1 THEN 'DEFINITIVO'      
WHEN ENMA.Estado  = 0 THEN 'BORRADOR'END AS Estado      
         
FROM                                                                         
Encabezado_Manifiesto_Carga ENMA                                                                        
LEFT JOIN Empresas EMPR ON                                                                        
ENMA.EMPR_Codigo = EMPR.Codigo                                                                         
                                                                        
LEFT JOIN Oficinas OFIC ON                                                              
ENMA.EMPR_Codigo = OFIC.EMPR_Codigo                                                                         
AND ENMA.OFIC_Codigo = OFIC.Codigo                                             
                                             
LEFT JOIN Terceros TEPR ON                                                                         
ENMA.EMPR_Codigo = TEPR.EMPR_Codigo                                                                         
AND ENMA.TERC_Codigo_Propietario = TEPR.Codigo                                                            
                                      
LEFT JOIN Terceros TENE ON                                                                         
ENMA.EMPR_Codigo = TENE.EMPR_Codigo             
AND ENMA.TERC_Codigo_Tenedor = TENE.Codigo                                                                        
                                       
LEFT JOIN Terceros TECO ON                                                                         
ENMA.EMPR_Codigo = TECO.EMPR_Codigo                                                       
AND ENMA.TERC_Codigo_Conductor = TECO.Codigo                                                                        
                                                  
LEFT JOIN Tercero_Conductores TECA ON                                                                         
ENMA.EMPR_Codigo = TECA.EMPR_Codigo                                                                         
AND ENMA.TERC_Codigo_Conductor = TECA.TERC_Codigo                                                     
                                                  
LEFT JOIN Valor_Catalogos AS CALC ON                                                  
TECA.EMPR_Codigo = CALC.EMPR_Codigo                                                  
AND TECA.CATA_CALC_Codigo = CALC.Codigo           
    
LEFT JOIN Rutas RUTA ON                                                                         
ENMA.EMPR_Codigo = RUTA.EMPR_Codigo                                                                         
AND ENMA.RUTA_Codigo = RUTA.Codigo          
    
--MODIFICACION DC:23/06/2021                  
LEFT JOIN Encabezado_Planilla_Despachos AS ENPD    
 ON ENMA.EMPR_Codigo = ENPD.EMPR_Codigo    
 AND   ENMA.Numero = ENPD.ENMC_Numero    
      
  LEFT JOIN Rutas RUPL ON                                                                         
ENPD.EMPR_Codigo = RUPL.EMPR_Codigo                                                                         
AND ENPD.RUTA_Codigo = RUPL.Codigo     
--FIN MODIFICACION        
    
LEFT JOIN  Ciudades CIEM ON                                          
EMPR.Codigo = CIEM.EMPR_Codigo                                                                         
AND EMPR.CIUD_Codigo = CIEM.Codigo                                                                          
                                     
LEFT JOIN Ciudades CIOR ON                                                                         
RUTA.EMPR_Codigo = CIOR.EMPR_Codigo                                                                        
AND RUTA.CIUD_Codigo_Origen = CIOR.Codigo                                                                        
                                              
LEFT JOIN Ciudades CIDE ON                                                                         
RUTA.EMPR_Codigo = CIDE.EMPR_Codigo                                                                    
AND RUTA.CIUD_Codigo_Destino = CIDE.Codigo                                                                        
                                                                        
LEFT JOIN Ciudades CIPR ON                                                                         
TEPR.EMPR_Codigo = CIPR.EMPR_Codigo                                                                       
AND TEPR.CIUD_Codigo = CIPR.Codigo                                                                        
                                                    
LEFT JOIN Ciudades CITE ON                                   
TENE.EMPR_Codigo = CITE.EMPR_Codigo                                                                         
AND TENE.CIUD_Codigo = CITE.Codigo                                                                        
                                 
LEFT JOIN Ciudades CICO ON                                                                         
TECO.EMPR_Codigo = CICO.EMPR_Codigo                                                                        
AND TECO.CIUD_Codigo = CICO.Codigo                                                             
                                                                        
LEFT JOIN Vehiculos VEHI ON                                                                     
ENMA.EMPR_Codigo = VEHI.EMPR_Codigo                                                                        
AND ENMA.VEHI_Codigo = VEHI.Codigo                                                           
                       
LEFT JOIN Valor_Catalogos AS TIVE ON                      
VEHI.EMPR_Codigo = TIVE.EMPR_Codigo                                        
AND VEHI.CATA_TIVE_Codigo = TIVE.Codigo                                        
                                        
LEFT JOIN Terceros POLI ON                             
VEHI.EMPR_Codigo = POLI.EMPR_Codigo                                                                         
AND VEHI.TERC_Codigo_Aseguradora_SOAT = POLI.Codigo                                                                        
                                                                                                        
LEFT JOIN Color_Vehiculos COVE ON                                                                   
VEHI.EMPR_Codigo = COVE.EMPR_Codigo                                                                   
AND VEHI.COVE_Codigo = COVE.Codigo                                                                  
                                                                  
--LEFT JOIN GESCARGA50_DOCU_DESARROLLO..Fotos_Vehiculos VEDC ON                                                                     
--VEHI.EMPR_Codigo = VEDC.EMPR_Codigo                                                                     
--AND VEHI.Codigo  = VEDC.VEHI_Codigo                                                     
                                                  
--LEFT JOIN GESCARGA50_DOCU_DESARROLLO..Tercero_Fotos TEDC ON                                                                     
--TECO.EMPR_Codigo = TEDC.EMPR_Codigo                                                                     
--AND TECO.Codigo  = TEDC.TERC_Codigo                                                     
                                                                        
LEFT JOIN Marca_Vehiculos MAVE ON                                                                         
VEHI.EMPR_Codigo = MAVE.EMPR_Codigo                                                                        
AND VEHI.MAVE_Codigo = MAVE.Codigo                                                      
                                                  
LEFT JOIN Linea_Vehiculos AS LIVE ON                         
VEHI.EMPR_Codigo = LIVE.EMPR_Codigo                                                  
AND VEHI.LIVE_Codigo = LIVE.Codigo                                                  
                                             
LEFT JOIN  Semirremolques SEMI                                                                        
ON ENMA.EMPR_Codigo = SEMI.EMPR_Codigo                                                                
AND ENMA.SEMI_Codigo = SEMI.Codigo                                                                        
                                                  
LEFT JOIN Valor_Catalogos AS TICA                                                  
ON VEHI.EMPR_Codigo =TICA.EMPR_Codigo                                                  
AND VEHI.CATA_TICA_Codigo = TICA.Codigo                                                  
                                                  
LEFT JOIN Detalle_Despacho_Orden_Servicios AS DDOS                                                  
ON ENMA.EMPR_Codigo = DDOS.EMPR_Codigo                                     
AND ENMA.Numero = DDOS.ENMC_Numero                                                  
                                            
LEFT JOIN Detalle_Programacion_Orden_Servicios AS DPOS                                                  
ON DDOS.EMPR_Codigo = DPOS.EMPR_Codigo                                                  
AND DDOS.DPOS_ID = DPOS.ID                                                  
                                     
 LEFT JOIN USUARIOS USCM                                 
ON ENMA.EMPR_Codigo = USCM.EMPR_Codigo                                         
AND ENMA.USUA_Codigo_Crea = USCM.Codigo                                    
                                    
LEFT JOIN USUARIOS USCR                                                                 
ON ENMA.EMPR_Codigo = USCR.EMPR_Codigo                          
              
LEFT JOIN Detalle_Conductores_Planilla_Despachos SECO ON              
ENMA.EMPR_Codigo = SECO.EMPR_Codigo AND              
ENMA.ENPD_Numero = SECO.ENPD_Numero AND             
ENMA.TERC_Codigo_Conductor <> SECO.TERC_Codigo_Conductor                    
              
LEFT JOIN Terceros TECO2 ON              
ENMA.EMPR_Codigo = TECO2.EMPR_Codigo AND              
SECO.TERC_Codigo_Conductor = TECO2.Codigo                       
              
LEFT JOIN Ciudades CICO2 ON              
TECO2.EMPR_Codigo = CICO2.EMPR_Codigo AND              
TECO2.CIUD_Codigo = CICO2.Codigo            
        
LEFT JOIN V_Tipo_Manifiesto TIMA ON        
ENMA.EMPR_Codigo =  TIMA.EMPR_Codigo        
AND ENMA.CATA_TIMA_Codigo = TIMA.Codigo        
        
                                                                   
WHERE                                                                         
ENMA.EMPR_Codigo = @par_EMPR_Numero                                                                         
AND ENMA.Numero = @par_Numero                                                               
AND USCR.Codigo = ISNULL(@par_USUA_Codigo,ENMA.USUA_Codigo_Crea)                                                        
END
GO
