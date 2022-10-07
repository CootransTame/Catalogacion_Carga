PRINT 'Consultar Listados Mensajeria'
GO
UPDATE Menu_Aplicaciones SET Url_Pagina = '#!ConsultarListadosMensajeria' where Codigo = 4603
GO
--------------------------------------------------------
PRINT 'Listado Contenedor Postal'
GO
UPDATE Menu_Aplicaciones SET Nombre = 'Contenedor Postal', Url_Pagina = 'lstContenedorPostal' where Codigo = 460301
GO
--------------------------------------------------------
PRINT 'Mensajeria -> Listados -> Despacho Mensajeria'
GO
INSERT INTO Menu_Aplicaciones(
EMPR_Codigo
,Codigo
,MOAP_Codigo
,Nombre
,Padre_Menu
,Orden_Menu
,Mostrar_Menu
,Aplica_Habilitar
,Aplica_Consultar
,Aplica_Actualizar
,Aplica_Eliminar_Anular
,Aplica_Imprimir
,Aplica_Contabilidad
,Opcion_Permiso
,Opcion_Listado
,Aplica_Ayuda
,Url_Pagina
,Url_Ayuda
,Imagen)
VALUES
(
1
,460302
,46
,'Despacho Mensajería'
,4603
,20
,0
,1
,1
,1
,1
,1
,0
,1
,1
,0
,'lstDespachoMensajeria'
,'#'
,NULL
)
GO
---------------------------------------------------
PRINT 'Mensajeria -> Listados -> Guías Mensajería Pendientes Por Cumplir'
GO
INSERT INTO Menu_Aplicaciones(
EMPR_Codigo
,Codigo
,MOAP_Codigo
,Nombre
,Padre_Menu
,Orden_Menu
,Mostrar_Menu
,Aplica_Habilitar
,Aplica_Consultar
,Aplica_Actualizar
,Aplica_Eliminar_Anular
,Aplica_Imprimir
,Aplica_Contabilidad
,Opcion_Permiso
,Opcion_Listado
,Aplica_Ayuda
,Url_Pagina
,Url_Ayuda
,Imagen)
VALUES
(
1
,460303
,46
,'Guías Mensajería Pendientes Por Cumplir'
,4603
,30
,0
,1
,1
,1
,1
,1
,0
,1
,1
,0
,'lstGuiasMensajeriaPorCumplir'
,'#'
,NULL
)
GO
---------------------------------------------------
PRINT 'Mensajeria -> Listados -> Guías Mensajería Pendientes Por Facturar'
GO
INSERT INTO Menu_Aplicaciones(
EMPR_Codigo
,Codigo
,MOAP_Codigo
,Nombre
,Padre_Menu
,Orden_Menu
,Mostrar_Menu
,Aplica_Habilitar
,Aplica_Consultar
,Aplica_Actualizar
,Aplica_Eliminar_Anular
,Aplica_Imprimir
,Aplica_Contabilidad
,Opcion_Permiso
,Opcion_Listado
,Aplica_Ayuda
,Url_Pagina
,Url_Ayuda
,Imagen)
VALUES
(
1
,460304
,46
,'Guías Mensajería Pendientes Por Facturar'
,4603
,40
,0
,1
,1
,1
,1
,1
,0
,1
,1
,0
,'lstGuiasMensajeriaPorFacturar'
,'#'
,NULL
)
GO
---------------------------------------------------
PRINT 'Mensajeria -> Listados -> Guías Mensajería ventas por oficina'
GO
INSERT INTO Menu_Aplicaciones(
EMPR_Codigo
,Codigo
,MOAP_Codigo
,Nombre
,Padre_Menu
,Orden_Menu
,Mostrar_Menu
,Aplica_Habilitar
,Aplica_Consultar
,Aplica_Actualizar
,Aplica_Eliminar_Anular
,Aplica_Imprimir
,Aplica_Contabilidad
,Opcion_Permiso
,Opcion_Listado
,Aplica_Ayuda
,Url_Pagina
,Url_Ayuda
,Imagen)
VALUES
(
1
,460305
,46
,'Ventas Por Oficina'
,4603
,50
,0
,1
,1
,1
,1
,1
,0
,1
,1
,0
,'lstGuiasVentasOficinaMensajeria'
,'#'
,NULL
)
GO
---------------------------------------------------
PRINT 'gsp_listado_contenedor_postal'
GO
DROP PROCEDURE gsp_listado_contenedor_postal
GO
CREATE PROCEDURE gsp_listado_contenedor_postal(
	@par_EMPR_Codigo SMALLINT,
	@par_Fecha_Inicial date = NULL,              
	@par_Fecha_Final date = NULL,
	@par_Numero_Inicial NUMERIC = NULL,
	@par_Numero_Final NUMERIC = NULL,
	@par_CIUD_Origen_Codigo NUMERIC = NULL,
	@par_CIUD_Destino_Codigo NUMERIC = NULL,
	@par_Oficina_Codigo NUMERIC = NULL,
	@par_Estado NUMERIC = NULL,
	@par_Anulado NUMERIC = NULL
)
AS
BEGIN
	SELECT 
	ECPM.Numero AS ECPM_Numero,
	ECPM.Numero_Documento AS ECPM_Numero_Documento,
	ECPM.Fecha AS ECPM_Fecha,
	ECPM.Peso AS ECPM_Peso,
	CIOR.Nombre AS CIOR_Nombre,
	CIDE.Nombre AS CIDE_Nombre,
	ENRE.Numero_Documento AS ENRE_Numero_Documento,
	IIF(ENRE.TERC_Codigo_Cliente = 0 OR ENRE.TERC_Codigo_Cliente IS NULL, TRIM(CONCAT(ISNULL(REMI.Razon_Social,''),' ',ISNULL(REMI.Nombre,''),' ',ISNULL(REMI.Apellido1,''),' ',ISNULL(REMI.Apellido2,''))), TRIM(CONCAT(ISNULL(CLIE.Razon_Social,''),' ',ISNULL(CLIE.Nombre,''),' ',ISNULL(CLIE.Apellido1,''),' ',ISNULL(CLIE.Apellido2,'')))) AS NombreCliente,
	TRIM(CONCAT(ISNULL(DEST.Razon_Social,''),' ',ISNULL(DEST.Nombre,''),' ',ISNULL(DEST.Apellido1,''),' ',ISNULL(DEST.Apellido2,''))) AS NombreDestinatario,
	ENRE.Cantidad_Cliente AS ENRE_Cantida,
	REPA.Peso_A_Cobrar AS ENRE_Peso,
	OFIC.Nombre AS OFIC_Nombre,
	CASE ECPM.Anulado WHEN 1 THEN 'A' ELSE                        
	CASE ECPM.Estado WHEN 1 THEN 'D' ELSE 'B'
	END                                   
	END AS Estado

	FROM Detalle_Remesas_Contenedor_Postal DRCP

	INNER JOIN Encabezado_Remesas ENRE
	ON DRCP.EMPR_Codigo = ENRE.EMPR_Codigo
	AND DRCP.ENRE_Numero = ENRE.Numero

	LEFT JOIN Terceros CLIE
	ON ENRE.EMPR_Codigo = CLIE.EMPR_Codigo
	AND ENRE.TERC_Codigo_Cliente = CLIE.Codigo

	LEFT JOIN Terceros REMI
	ON ENRE.EMPR_Codigo = REMI.EMPR_Codigo
	AND ENRE.TERC_Codigo_Remitente = REMI.Codigo

	LEFT JOIN Terceros DEST
	ON ENRE.EMPR_Codigo = DEST.EMPR_Codigo
	AND ENRE.TERC_Codigo_Destinatario = DEST.Codigo

	INNER JOIN Remesas_Paqueteria REPA
	ON ENRE.EMPR_Codigo = REPA.EMPR_Codigo
	AND ENRE.Numero = REPA.ENRE_Numero

	INNER JOIN Encabezado_Contenedor_Postal_Mensajeria ECPM
	ON DRCP.EMPR_Codigo = ECPM.EMPR_Codigo
	AND DRCP.ECPM_Numero = ECPM.Numero

	LEFT JOIN Ciudades CIOR
	ON ECPM.EMPR_Codigo = CIOR.EMPR_Codigo
	AND ECPM.CIUD_Codigo_Origen = CIOR.Codigo

	LEFT JOIN Ciudades CIDE
	ON ECPM.EMPR_Codigo = CIDE.EMPR_Codigo
	AND ECPM.CIUD_Codigo_Destino = CIDE.Codigo

	INNER JOIN Oficinas OFIC
	ON ECPM.EMPR_Codigo = OFIC.EMPR_Codigo
	AND ECPM.OFIC_Codigo = OFIC.Codigo
	
	WHERE  ECPM.EMPR_Codigo = @par_EMPR_Codigo              
    AND (ECPM.Fecha >= @par_Fecha_Inicial OR @par_Fecha_Inicial IS NULL)              
    AND (ECPM.Fecha <= @par_Fecha_Final OR @par_Fecha_Final IS NULL)
	AND (ECPM.Numero_Documento >= @par_Numero_Inicial OR @par_Numero_Inicial IS NULL)
	AND (ECPM.Numero_Documento <= @par_Numero_Final OR @par_Numero_Final IS NULL)
	AND (ECPM.CIUD_Codigo_Origen = @par_CIUD_Origen_Codigo OR @par_CIUD_Origen_Codigo IS NULL)
	AND (ECPM.CIUD_Codigo_Destino = @par_CIUD_Destino_Codigo OR @par_CIUD_Destino_Codigo IS NULL)
	AND (ECPM.OFIC_Codigo = @par_Oficina_Codigo OR @par_Oficina_Codigo IS NULL)
	AND (ECPM.Estado = @par_Estado OR @par_Estado IS NULL)
	AND (ECPM.Anulado = @par_Anulado OR @par_Anulado IS NULL)

	ORDER BY ECPM.Numero ASC
END
GO
---------------------------------------------------
PRINT 'gsp_listado_despacho_mensajeria'
GO
DROP PROCEDURE gsp_listado_despacho_mensajeria
GO
CREATE PROCEDURE gsp_listado_despacho_mensajeria(
	@par_EMPR_Codigo SMALLINT,
	@par_Fecha_Inicial date = NULL,              
	@par_Fecha_Final date = NULL,
	@par_Numero_Inicial NUMERIC = NULL,
	@par_Numero_Final NUMERIC = NULL,
	@par_TERC_Codigo_Proveedor NUMERIC = NULL,
	@par_Ruta_Codigo NUMERIC = NULL,
	@par_CATA_FPVE_Codigo NUMERIC = NULL,
	@par_VEHI_Codigo NUMERIC = NULL,
	@par_Oficina_Codigo NUMERIC = NULL,
	@par_Estado NUMERIC = NULL,
	@par_Anulado NUMERIC = NULL
)
AS
BEGIN
	SELECT
	EDCP.Numero AS EDCP_Numero,
	EDCP.Numero_Documento AS EDCP_Numero_Documento,
	EDCP.Fecha AS EDCP_Fecha,
	EDCP.Cantidad AS EDCP_Cantidad,
	EDCP.Peso AS EDCP_Peso,
	EDCP.Valor_Flete AS EDCP_Valor_Flete,
	EDCP.Valor_Anticipo AS EDCP_Valor_Anticipo,
	EDCP.Valor_Total AS EDCP_Valor_Total,
	TRIM(CONCAT(ISNULL(PROV.Razon_Social,''),' ',ISNULL(PROV.Nombre,''),' ',ISNULL(PROV.Apellido1,''),' ',ISNULL(PROV.Apellido2,''))) AS NombreProveedor,
	RUTA.Nombre AS RUTA_Nombre,
	FPVE.Campo1 AS FPVE_Nombre,
	Vehi.Placa AS VEHI_Placa,
	ECPM.Numero_Documento AS ECPM_Numero_Documento,
	ECPM.Fecha AS ECPM_Fecha,
	ECPM.Peso AS ECPM_Peso,
	CIOR.Nombre AS CIOR_Nombre,
	CIDE.Nombre AS CIDE_Nombre,
	OFIC.Nombre AS OFIC_Nombre,
	CASE EDCP.Anulado WHEN 1 THEN 'A' ELSE                        
	CASE EDCP.Estado WHEN 1 THEN 'D' ELSE 'B'
	END                                   
	END AS Estado

	FROM Detalle_Despacho_Contenedor_Postal DDCP

	INNER JOIN Encabezado_Contenedor_Postal_Mensajeria ECPM ON
	DDCP.EMPR_Codigo = ECPM.EMPR_Codigo
	AND DDCP.ECPM_Numero = ECPM.Numero

	INNER JOIN Encabezado_Despacho_Contenedor_Postal EDCP ON
	DDCP.EMPR_Codigo = EDCP.EMPR_Codigo
	AND DDCP.EDCP_Numero = EDCP.Numero

	INNER JOIN Terceros PROV ON
	EDCP.EMPR_Codigo = PROV.EMPR_Codigo
	AND EDCP.TERC_Codigo_Proveedor = PROV.Codigo

	INNER JOIN Rutas RUTA ON
	EDCP.EMPR_Codigo = RUTA.EMPR_Codigo
	AND EDCP.RUTA_Codigo = RUTA.Codigo

	INNER JOIN Valor_Catalogos FPVE ON
	EDCP.EMPR_Codigo = FPVE.EMPR_Codigo
	AND EDCP.CATA_FPVE_Codigo = FPVE.Codigo

	INNER JOIN Vehiculos VEHI ON
	EDCP.EMPR_Codigo = VEHI.EMPR_Codigo
	AND EDCP.VEHI_Codigo = VEHI.Codigo

	LEFT JOIN Ciudades CIOR
	ON ECPM.EMPR_Codigo = CIOR.EMPR_Codigo
	AND ECPM.CIUD_Codigo_Origen = CIOR.Codigo

	LEFT JOIN Ciudades CIDE
	ON ECPM.EMPR_Codigo = CIDE.EMPR_Codigo
	AND ECPM.CIUD_Codigo_Destino = CIDE.Codigo

	INNER JOIN Oficinas OFIC
	ON EDCP.EMPR_Codigo = OFIC.EMPR_Codigo
	AND EDCP.OFIC_Codigo = OFIC.Codigo

	WHERE EDCP.EMPR_Codigo = @par_EMPR_Codigo              
    AND (EDCP.Fecha >= @par_Fecha_Inicial OR @par_Fecha_Inicial IS NULL)              
    AND (EDCP.Fecha <= @par_Fecha_Final OR @par_Fecha_Final IS NULL)
	AND (EDCP.Numero_Documento >= @par_Numero_Inicial OR @par_Numero_Inicial IS NULL)
	AND (EDCP.Numero_Documento <= @par_Numero_Final OR @par_Numero_Final IS NULL)
	AND (EDCP.TERC_Codigo_Proveedor = @par_TERC_Codigo_Proveedor OR @par_TERC_Codigo_Proveedor IS NULL)
	AND (EDCP.RUTA_Codigo = @par_Ruta_Codigo OR @par_Ruta_Codigo IS NULL)
	AND (EDCP.CATA_FPVE_Codigo = @par_CATA_FPVE_Codigo OR @par_CATA_FPVE_Codigo IS NULL)
	AND (EDCP.VEHI_Codigo = @par_VEHI_Codigo OR @par_VEHI_Codigo IS NULL)
	AND (EDCP.OFIC_Codigo = @par_Oficina_Codigo OR @par_Oficina_Codigo IS NULL)
	AND (EDCP.Estado = @par_Estado OR @par_Estado IS NULL)
	AND (EDCP.Anulado = @par_Anulado OR @par_Anulado IS NULL)
END
GO
---------------------------------------------------
PRINT 'gsp_listado_guias_mensajeria'
GO
DROP PROCEDURE gsp_listado_guias_mensajeria
GO
CREATE PROCEDURE gsp_listado_guias_mensajeria
(                        
	@par_EMPR_Codigo SMALLINT,
	@par_Fecha_Inicial date = NULL,              
	@par_Fecha_Final date = NULL,
	@par_Numero_Inicial NUMERIC = NULL,
	@par_Numero_Final NUMERIC = NULL,
	@par_TERC_Codigo_Cliente NUMERIC = NULL,
	@par_CATA_FPVE_Codigo NUMERIC = NULL,
	@par_Pendientes_Cumplir NUMERIC = NULL,                        
	@par_Pendientes_Facturar NUMERIC = NULL,                        
	@par_Oficina_Codigo NUMERIC = NULL,
	@par_Estado NUMERIC = NULL               
)                                     
AS                                   
BEGIN
	SELECT                                   
	EMPR.Nombre_Razon_Social,      
	ENRE.Numero,      
	ENRE.Numero_Documento,   
	ISNULL(ENFA.Numero_Documento, 0) AS FACTURA,  
	ENRE.Fecha,                        
	ISNULL(VEHI.Placa, '') AS Placa,                        
	IIF(ENRE.TERC_Codigo_Cliente > 0,                
	TRIM(ISNULL(CLIE.Razon_Social,'')+' '+ISNULL(CLIE.Nombre,'') +' '+ISNULL(CLIE.Apellido1,'')+' '+ISNULL(CLIE.Apellido2,'')),                
	TRIM(ISNULL(REMI.Razon_Social,'')+' '+ISNULL(REMI.Nombre,'') +' '+ISNULL(REMI.Apellido1,'')+' '+ISNULL(REMI.Apellido2,''))                
	)  AS NombreCliente,   
	IIF(ENRE.TERC_Codigo_Cliente > 0,  
	ISNULL(CLIE.Numero_Identificacion, ''),  
	ISNULL(REMI.Numero_Identificacion, '')) AS IdentificacionCliente,
	CIOR.Nombre AS CiudadOrigen,                        
	CIDE.Nombre AS CiudadDestino,                    
	ENRE.CATA_FOPR_Codigo AS FOPR_Codigo,                      
	FOPR.Campo1 AS FOPR_Nombre,                        
	ENRE.Valor_Flete_Cliente,                    
	ENRE.Total_Flete_Cliente,                    
	ENRE.Numeracion,              
	ENRE.Valor_Seguro_Cliente As Seguro,              
	ENRE.Valor_Flete_Transportador,                
	TRIM(CONCAT(ISNULL(REMI.Razon_Social,''),' ',ISNULL(REMI.Nombre,''),' ',ISNULL(REMI.Apellido1,''),' ',ISNULL(REMI.Apellido2,''))) AS NombreRemitente,                          
	TRIM(CONCAT(ISNULL(TECC.Razon_Social,''),' ',ISNULL(TECC.Nombre,''),' ',ISNULL(TECC.Apellido1,''),' ',ISNULL(TECC.Apellido2,''))) AS NombreRepresentante,
	ISNULL(EDCP.Numero_Documento, 0) AS EDCP_NumeroDocumento,                      
	ENRE.Peso_Cliente,                        
	ENRE.Cantidad_Cliente,         
	ENRE.OFIC_Codigo,                       
	OFIC.Nombre NombreOficina,                        
	ISNULL(ENRE.Valor_Comision_Oficina, 0) Valor_Comision_Oficina ,                  
	ISNULL(ENRE.Valor_Comision_Agencista, 0) Valor_Comision_Agencista,               
	ISNULL(ENRE.Valor_Reexpedicion, 0) Valor_Reexpedicion,      
	OFAC.Nombre As NombreOficinaActual,
	CASE ENRE.Anulado WHEN 1 THEN 'A' ELSE                        
	CASE ENRE.ESTADO WHEN 1 THEN 'D' ELSE 'B'                        
	END                                   
	END AS Estado,    
	CASE    
	WHEN CLIE.CATA_TIID_Codigo = 101 OR REMI.CATA_TIID_Codigo = 101 THEN 'CC'    
	WHEN CLIE.CATA_TIID_Codigo = 102 OR REMI.CATA_TIID_Codigo = 102 THEN 'NIT'    
	WHEN CLIE.CATA_TIID_Codigo = 103 OR REMI.CATA_TIID_Codigo = 103 THEN 'CE'    
	ELSE 'PASAPORTE' END AS Tipo_Documento,    
	CLIE.Emails,    
	ENRE.Documento_Cliente,    
	ENRE.Valor_Comercial_Cliente,    
	ENRE.Valor_Flete_Cliente AS Flete_Cliente
	
	FROM Encabezado_Remesas ENRE                                  
	INNER JOIN Empresas EMPR ON                                   
	ENRE.EMPR_Codigo = EMPR.Codigo

	LEFT JOIN Remesas_Paqueteria REPA ON                        
	ENRE.EMPR_Codigo = REPA.EMPR_Codigo                                   
	AND ENRE.Numero = REPA.ENRE_Numero
                                  
	LEFT JOIN Vehiculos VEHI ON                                   
	ENRE.EMPR_Codigo = VEHI.EMPR_Codigo                                  
	AND  ENRE.VEHI_Codigo = VEHI.Codigo             
                                  
	LEFT JOIN Terceros CLIE ON                                   
	ENRE.EMPR_Codigo = CLIE.EMPR_Codigo                                   
	AND ENRE.TERC_Codigo_Cliente = CLIE.Codigo                
                
	LEFT JOIN Terceros REMI ON                                   
	ENRE.EMPR_Codigo = REMI.EMPR_Codigo                                   
	AND ENRE.TERC_Codigo_Remitente = REMI.Codigo                                   
                        
	LEFT JOIN Ciudades CIOR ON                                
	ENRE.EMPR_Codigo = CIOR.EMPR_Codigo                                   
	AND ENRE.CIUD_Codigo_Remitente = CIOR.Codigo                        
                        
	LEFT JOIN Ciudades CIDE ON                                
	ENRE.EMPR_Codigo = CIDE.EMPR_Codigo                                   
	AND ENRE.CIUD_Codigo_Destinatario = CIDE.Codigo                             
                         
	LEFT JOIN Valor_Catalogos FOPR ON                                   
	ENRE.EMPR_Codigo = FOPR.EMPR_Codigo                                   
	AND ENRE.CATA_FOPR_Codigo = FOPR.Codigo                                         
                                  
	LEFT JOIN Oficinas OFIC ON                                   
	ENRE.EMPR_Codigo = OFIC.EMPR_Codigo                                   
	AND ENRE.OFIC_Codigo = OFIC.Codigo                        
                  
	LEFT JOIN Terceros TECC ON                  
	ENRE.EMPR_Codigo = TECC.EMPR_Codigo AND                  
	OFIC.TERC_Codigo_Comision = TECC.Codigo 
	
	LEFT JOIN Encabezado_Contenedor_Postal_Mensajeria ECPM ON                        
	REPA.EMPR_Codigo = ECPM.EMPR_Codigo                                   
	AND REPA.ECPM_Numero = ECPM.Numero
                        
	LEFT JOIN Encabezado_Despacho_Contenedor_Postal EDCP ON                        
	ECPM.EMPR_Codigo = EDCP.EMPR_Codigo                                   
	AND ECPM.EDCP_Numero = EDCP.Numero
	
	LEFT JOIN Oficinas OFAC ON            
	ENRE.EMPR_Codigo = OFAC.EMPR_Codigo AND            
	REPA.ENRE_Numero = ENRE.Numero AND            
	REPA.OFIC_Codigo_Actual = OFAC.Codigo       
   
	-- SE AGREGA CAMPO PARA CONSULTAR FACTURAS  //14-FEB-2022 / SARBOLEDA  
	LEFT JOIN Encabezado_Facturas AS ENFA ON                                   
	ENRE.EMPR_Codigo = ENFA.EMPR_Codigo                                  
	AND  ENRE.ENFA_Numero = ENFA.Numero  
  
	--INNER JOIN Encabezado_Facturas AS ENFA ON  
	--ENRE.ENFA_Numero = ENFA.Numero  
   
	WHERE ENRE.EMPR_Codigo = @par_EMPR_Codigo                      
	AND ENRE.TIDO_Codigo = 111                               
	AND (ENRE.Fecha >= @par_Fecha_Inicial OR @par_Fecha_Inicial IS NULL)              
    AND (ENRE.Fecha <= @par_Fecha_Final OR @par_Fecha_Final IS NULL)
	AND (ENRE.Numero_Documento >= @par_Numero_Inicial OR @par_Numero_Inicial IS NULL)
	AND (ENRE.Numero_Documento <= @par_Numero_Final OR @par_Numero_Final IS NULL)               
	AND (ENRE.OFIC_Codigo = @par_Oficina_Codigo OR @par_Oficina_Codigo IS NULL)
	AND (ENRE.TERC_Codigo_Cliente = @par_TERC_Codigo_Cliente OR @par_TERC_Codigo_Cliente IS NULL)
	AND ENRE.Estado = (IIF(@par_Estado is null, ENRE.Estado ,IIF(@par_Estado = 1,1,IIF(@par_Estado = 0, 0,ENRE.Estado))))          
	AND ENRE.Anulado = (IIF(@par_Estado = 2,1,IIF(@par_Estado is null,ENRE.Anulado,0)))                                              
	AND (ENRE.CATA_FOPR_Codigo = @par_CATA_FPVE_Codigo OR @par_CATA_FPVE_Codigo IS NULL)
	AND (ENRE.Cumplido =  @par_Pendientes_Cumplir OR @par_Pendientes_Cumplir IS NULL)
	AND (IIF(ENRE.ENFA_Numero = 0 OR ENRE.ENFA_Numero IS NULL, 0, 1) =  @par_Pendientes_Facturar OR @par_Pendientes_Facturar IS NULL)
	AND (ENRE.OFIC_Codigo = @par_Oficina_Codigo OR @par_Oficina_Codigo IS NULL)   
	ORDER BY CIDE.Nombre, ISNULL(NULLIF(ENRE.Numeracion,''),'z') asc, ENRE.Numero ASC                
END
GO
---------------------------------------------------
PRINT 'gsp_Reporte_Encabezado_factura'
GO
DROP PROCEDURE gsp_Reporte_Encabezado_factura
GO
CREATE PROCEDURE gsp_Reporte_Encabezado_factura
(                                      
	@par_Empr_Codigo NUMERIC,                                    
	@par_Numero_Factura  NUMERIC                                          
)                                          
AS                                     
BEGIN    
	--Oficina    
	Declare @TipoNumercion NUMERIC = 1101    
	Declare @OficinaFactura NUMERIC = NULL    
	Declare @Oficina NUMERIC = NULL    
	Declare @TIDO_Codigo NUMERIC = 170    
	--Validacion Numeracion por Oficinas (Oficina Principal en Oficinas)    
	SELECT @TipoNumercion = CATA_TIGN_Codigo FROM Tipo_Documentos WHERE EMPR_Codigo = @par_EMPR_Codigo and Codigo = @TIDO_Codigo    
	--Valida Oficina    
	SELECT @Oficina = OFIC_Factura FROM Encabezado_Facturas WHERE EMPR_Codigo = @par_EMPR_Codigo and Numero = @par_Numero_Factura    
	IF @TipoNumercion = 1102--Numeracion Por Oficina    
	BEGIN    
	IF(EXISTS(SELECT OFIC_Codigo_Factura FROM Oficinas WHERE EMPR_Codigo = @par_EMPR_Codigo and Codigo = @Oficina))    
	BEGIN    
	SELECT @OficinaFactura = OFIC_Codigo_Factura FROM Oficinas WHERE EMPR_Codigo = @par_EMPR_Codigo and Codigo = @Oficina    
	END    
	END    
                               
	SELECT DISTINCT                                    
	ENFA.Numero                                         
	, ENFA.Numero_Documento                                        
	, EMPR.Nombre_Razon_Social                                          
	, CONCAT(EMPR.Numero_Identificacion,'-',EMPR.Digito_Chequeo) IdentificacionEmpresa                                          
	, EMPR.Direccion                        
	, EMPR.Telefonos                      
	, EMPR.Actividad_Economica                      
	,EMFE.Firma_Digital                      
	,CASE WHEN TIDO.CATA_TIGN_Codigo = 1102 THEN OFFA.Prefijo_Factura        
	ELSE EMFE.Prefijo_Factura END AS Prefijo_Factura         
	, CIOF.Nombre CiudadOficina                                
	,SUBSTRING(OFIC.Codigo_Alterno,1,2) as Codigo_Alterno_Oficina                          
	,OFFA.Resolucion_Facturacion                          
	, ENFA.Fecha                                   
	, convert(datetime,DATEADD(DAY, ENFA.Dias_Plazo,ENFA.Fecha),113 ) FechaVence                          
	, FPVE.Campo1 FormaPago                 
	--Destinatario              
	, IIF(TECL.Codigo <> TFAA.Codigo AND TFAA.Codigo IS NOT NULL,                 
	ISNULL(TFAA.Razon_Social,'')+' '+ISNULL(TFAA.Nombre,'') + ' '+ISNULL(TFAA.Apellido1,'')+' '+ISNULL(TFAA.Apellido2,''), --Facturar A                                    
	ISNULL(TECL.Razon_Social,'')+' '+ISNULL(TECL.Nombre,'') + ' '+ISNULL(TECL.Apellido1,'')+' '+ISNULL(TECL.Apellido2,'')              
	) AS Cliente                                          
	, IIF(TECL.Codigo <> TFAA.Codigo AND TFAA.Codigo IS NOT NULL,                                    
	ISNULL(TFAA.Direccion, ''),                                    
	ISNULL(TECL.Direccion, '')                                    
	) AS DireccionCliente                     
	, IIF(TECL.Codigo <> TFAA.Codigo AND TFAA.Codigo IS NOT NULL,                                    
	CONCAT(ISNULL(TFAA.Numero_Identificacion, ''),IIF(TFAA.Digito_Chequeo IS NULL, '', '-'),ISNULL(TFAA.Digito_Chequeo, '0')),
	CONCAT(ISNULL(TECL.Numero_Identificacion, ''),IIF(TECL.Digito_Chequeo IS NULL, '', '-'),ISNULL(TECL.Digito_Chequeo, '0'))
	) AS IdentificacionCliente                      
	, IIF(TECL.Codigo <> TFAA.Codigo AND TFAA.Codigo IS NOT NULL,                                    
	ISNULL(TFAA.Telefonos, ''),                                    
	ISNULL(TECL.Telefonos, '')                                    
	) AS TelefonosCliente              
	, IIF(TECL.Codigo <> TFAA.Codigo AND TFAA.Codigo IS NOT NULL,                                    
	ISNULL(TFAA_CIUD.Nombre, ''),                                    
	ISNULL(CLIE_CIUD.Nombre, '')                                    
	) AS CiudadCliente              
	--Destinatario                          
                 
	, dbo.funcCantidadConLetra(ENFA.Valor_Factura) valorLetra                                          
	, ENFA.Observaciones ObservacionesFactura                                          
	, ENFA.Subtotal                                           
	, ENFA.Valor_Otros_Conceptos                                          
	, ENFA.Valor_Descuentos                                          
	, ENFA.Valor_Impuestos                                          
	, ENFA.Valor_Factura                          
	, FAEL.CUFE                          
	, FAEL.QR_code                          
	,USCR.nombre UsuarioCrea                          
	,ENFA.VALOR_TRM                          
	, ISNULL(TEVE.Razon_Social,'')+' '+ISNULL(TEVE.Nombre,'') +' '+ISNULL(TEVE.Apellido1,'')+' '+ISNULL(TEVE.Apellido2,'') AS Comercial  ,                                      
	TEVE.Codigo                                    
	,ENFA.Estado AS EstadoFactura                                  
	,ENFA.Anulado AS AnulacionFactura                                  
	,TEEM.Numero_Cuenta_Bancaria                                    
	,BANC.Nombre BANC_Nombre                                    
	,TICB.Campo1 As TICB_Nombre                  
	,EMPR.Emails                  
	,FAEL.Fecha_Envio AS Fecha_valiacion                  
	,ENFA.Fecha_Crea                  
	,ENFA.Dias_Plazo as Dias_Plazo               
	,CASE WHEN TIDO.CATA_TIGN_Codigo = 1102 THEN CODO.Prefijo_Documento -- CONSECUTIVO POR OFICINA          
	ELSE EMFE.Prefijo_Factura -- CONSECUTIVO POR EMPRESA          
	END AS Codigo_Contable,              
       
	CASE       
	WHEN ENFA.Anulado = 1 THEN 'ANULADO'      
	WHEN ENFA.Estado  = 1 THEN 'DEFINITIVO'      
	WHEN ENFA.Estado  = 0 THEN 'BORRADOR'END AS Estado    ,  
	ENFA.Numero_Orden_Compra     
      
	FROM Encabezado_Facturas ENFA            
	LEFT JOIN Empresas EMPR   on                                       
	ENFA.EMPR_Codigo = EMPR.Codigo                                      
                         
	LEFT JOIN Empresa_Factura_Electronica AS EMFE ON                   
	ENFA.EMPR_Codigo = EMFE.EMPR_Codigo                          
                          
	LEFT JOIN Factura_Electronica AS FAEL ON                                        
	ENFA.EMPR_Codigo = FAEL.EMPR_Codigo                                        
	AND ENFA.Numero = FAEL.ENFA_Numero                                        
                                     
	LEFT JOIN Terceros TECL on                                       
	ENFA.EMPR_Codigo = TECL.EMPR_Codigo                                           
	AND ENFA.TERC_Cliente = TECL.Codigo               
               
	LEFT JOIN  Ciudades CLIE_CIUD on                                       
	CLIE_CIUD.EMPR_Codigo = TECL.EMPR_Codigo                                          
	AND CLIE_CIUD.Codigo = TECL.CIUD_Codigo                                          
                                    
	LEFT JOIN Terceros TEEM on                               
	TEEM.EMPR_Codigo = EMPR.Codigo                                    
	AND TEEM.Codigo = 1                                    
                                    
	LEFT JOIN Bancos BANC on                                       
	TEEM.EMPR_Codigo = BANC.EMPR_Codigo                                    
	AND TEEM.BANC_Codigo = BANC.Codigo                                    
                                    
	LEFT JOIN Valor_Catalogos TICB on                                       
	TEEM.EMPR_Codigo = TICB.EMPR_Codigo                                    
	AND TEEM.CATA_TICB_Codigo = TICB.Codigo                                    
                                    
	LEFT JOIN Terceros TFAA on                              
	ENFA.EMPR_Codigo = TFAA.EMPR_Codigo                                           
	AND ENFA.TERC_Facturar = TFAA.Codigo              
               
	LEFT JOIN  Ciudades TFAA_CIUD on                                       
	TFAA_CIUD.EMPR_Codigo = TFAA.EMPR_Codigo                                          
	AND TFAA_CIUD.Codigo = TFAA.CIUD_Codigo                                       
                                      
	LEFT JOIN  Oficinas OFIC on                     
	ENFA.EMPR_Codigo = OFIC.EMPR_Codigo                                        
	AND ENFA.OFIC_Factura = OFIC.Codigo                                        
                                      
	LEFT JOIN  Ciudades CIOF on                                       
	OFIC.EMPR_Codigo = CIOF.EMPR_Codigo                                          
	AND OFIC.CIUD_Codigo = CIOF.Codigo    
     
	LEFT JOIN  Oficinas OFFA ON    
	ENFA.EMPR_Codigo = OFFA.EMPR_Codigo    
	AND (    
	ISNULL(@OficinaFactura, ENFA.OFIC_Factura) = OFFA.Codigo OR IIF(@OficinaFactura = 0, ENFA.OFIC_Factura, @OficinaFactura) = OFFA.Codigo     
	)                                        
                                      
	LEFT JOIN  Valor_Catalogos FPVE on                                       
	ENFA.EMPR_Codigo = FPVE.EMPR_Codigo                                          
	AND ENFA.CATA_FPVE_Codigo = FPVE.Codigo                                         
                                       
	LEFT JOIN  Usuarios USCR on                                       
	ENFA.EMPR_Codigo = USCR.EMPR_Codigo                                      
	AND ENFA.USUA_Codigo_Crea = USCR.Codigo                                      
                                      
	LEFT JOIN  Detalle_Remesas_Facturas DRFA on                                       
	ENFA.EMPR_Codigo = DRFA.EMPR_Codigo                                         
	AND ENFA.Numero = DRFA.ENFA_Numero                                      
                                      
	LEFT JOIN Encabezado_Remesas ENRE  on                                       
	DRFA.EMPR_Codigo = ENRE.EMPR_Codigo                                         
	AND DRFA.ENRE_Numero = ENRE.Numero                                        
                                     
	LEFT JOIN Encabezado_Solicitud_Orden_Servicios ESOS on                                       
	ENRE.EMPR_Codigo = ESOS.EMPR_Codigo                                       
	AND ENRE.ESOS_Numero = ESOS.Numero                                       
                                    
	LEFT JOIN  Terceros TEVE on                                       
	ESOS.EMPR_Codigo = TEVE.EMPR_Codigo                                       
	AND ESOS.TERC_Codigo_Comercial = TEVE.Codigo            
           
	INNER JOIN Tipo_Documentos TIDO           
	ON TIDO.EMPR_Codigo = ENFA.EMPR_Codigo           
	AND TIDO.Codigo = ENFA.TIDO_Codigo          
           
	LEFT JOIN Consecutivo_Documento_Oficinas CODO           
	ON CODO.EMPR_Codigo = ENFA.EMPR_Codigo           
	AND CODO.TIDO_Codigo = ENFA.TIDO_Codigo          
	AND CODO.OFIC_Codigo = ENFA.OFIC_Factura          
                            
	WHERE                                          
	ENFA.EMPR_Codigo = @par_Empr_Codigo                                          
	AND ENFA.Numero = @par_Numero_Factura                                      
END
GO
---------------------------------------------------
PRINT 'gsp_Reporte_Encabezado_Nota_Credito'
GO
DROP PROCEDURE gsp_Reporte_Encabezado_Nota_Credito
GO
CREATE PROCEDURE gsp_Reporte_Encabezado_Nota_Credito
(                               
	@par_Empr_Codigo NUMERIC,                                 
	@par_Numero_Nota  NUMERIC                                   
)                              
AS               
BEGIN                                   
	SELECT                       
	ENNF.EMPR_Codigo,                    
	ENNF.TIDO_Codigo,                    
	ENNF.Numero_Documento,                      
	ENNF.Fecha,                      
	ENNF.Observaciones,                      
	ENNF.Valor_Nota,                    
	ENNF.CUDE,                        
	ENFA.Numero_Documento AS ENFA_Numero_Documento,                      
	CASE WHEN TIFA.CATA_TIGN_Codigo = 1102 THEN OFFA.Prefijo_Factura  
	ELSE EMFE.Prefijo_Factura END AS Prefijo_Factura,  
	ENFA.Valor_Factura AS ENFA_Valor_Factura,                      
	dbo.funcCantidadConLetra(Valor_Nota) AS valorLetra,              
	CONF.Nombre AS CONF_Nombre,      
	--Informacion Destinatario      
	IIF(CLIE.Codigo <> TFAA.Codigo AND TFAA.Codigo IS NOT NULL,         
	ISNULL(TFAA.Razon_Social,'')+' '+ISNULL(TFAA.Nombre,'') + ' '+ISNULL(TFAA.Apellido1,'')+' '+ISNULL(TFAA.Apellido2,''), --Facturar A                            
	ISNULL(CLIE.Razon_Social,'')+' '+ISNULL(CLIE.Nombre,'') + ' '+ISNULL(CLIE.Apellido1,'')+' '+ISNULL(CLIE.Apellido2,'')      
	) AS NombreCliente,      
	IIF(CLIE.Codigo <> TFAA.Codigo AND TFAA.Codigo IS NOT NULL,                            
	ISNULL(TFAA.Direccion, ''),                            
	ISNULL(CLIE.Direccion, '')                            
	) AS CLIE_Direccion,      
	IIF(CLIE.Codigo <> TFAA.Codigo AND TFAA.Codigo IS NOT NULL,                            
	CONCAT(ISNULL(TFAA.Numero_Identificacion, ''),IIF(TFAA.Digito_Chequeo IS NULL, '', '-'),ISNULL(TFAA.Digito_Chequeo, '0')),
	CONCAT(ISNULL(CLIE.Numero_Identificacion, ''),IIF(CLIE.Digito_Chequeo IS NULL, '', '-'),ISNULL(CLIE.Digito_Chequeo, '0'))
	) AS CLIE_Numero_Identificacion,      
	IIF(CLIE.Codigo <> TFAA.Codigo AND TFAA.Codigo IS NOT NULL,                            
	ISNULL(TFAA.Telefonos, ''),                            
	ISNULL(CLIE.Telefonos, '')                            
	) AS CLIE_Telefonos,       
	IIF(CLIE.Codigo <> TFAA.Codigo AND TFAA.Codigo IS NOT NULL,                            
	ISNULL(TFAA_CIUD.Nombre, ''),                            
	ISNULL(CLIE_CIUD.Nombre, '')                            
	) AS CLIE_Ciudad,                     
	--Informacion Destinatario      
	EMPR.Nombre_Razon_Social,              
	CONCAT(EMPR.Numero_Identificacion,'-',EMPR.Digito_Chequeo) IdentificacionEmpresa,              
	EMPR.Direccion,              
	EMPR.Telefonos,              
	EMPR.Actividad_Economica,              
	EMFE.Firma_Digital,              
	iif(ENNF.TIDO_Codigo = 190, EMFE.Prefijo_Nota_Credito, EMFE.Prefijo_Nota_Debito) AS Prefijo,              
	CIOF.Nombre CiudadOficina,              
	OFRE.Resolucion_Facturacion,              
              
	USUA.Nombre AS USUA_Nombre,                  
	ENNF.Estado,                  
	ENNF.Anulado,                    
	ENFA.Dias_Plazo,          
	FAEL.Fecha_Envio AS Fecha_Envio,           
	FAEL.QR_Code,  
	FAEL.CUFE,  
	ENFA.Fecha_Crea AS Fecha_Generacion,          
	EMPR.Emails,        
	USAC.Nombre AS UsuarioCrea        
	,CASE WHEN TIDO.CATA_TIGN_Codigo = 1102 THEN CODO.Prefijo_Documento -- CONSECUTIVO POR OFICINA  
	ELSE iif(ENNF.TIDO_Codigo = 190, EMFE.Prefijo_Nota_Credito, EMFE.Prefijo_Nota_Debito) -- CONSECUTIVO POR EMPRESA  
	END AS Codigo_Contable   
       
	FROM Encabezado_Notas_Facturas AS ENNF                      
                      
	INNER JOIN Encabezado_Facturas AS ENFA ON                      
	ENNF.EMPR_Codigo = ENFA.EMPR_Codigo                      
	AND ENNF.ENFA_Numero = ENFA.Numero               
               
	LEFT JOIN Empresa_Factura_Electronica AS EMFE ON                                  
	ENFA.EMPR_Codigo = EMFE.EMPR_Codigo                     
                      
	LEFT JOIN Terceros AS CLIE ON                      
	ENNF.EMPR_Codigo = CLIE.EMPR_Codigo                      
	AND ENNF.TERC_Cliente = CLIE.Codigo      
      
	LEFT JOIN Ciudades AS CLIE_CIUD ON                      
	CLIE.EMPR_Codigo = CLIE_CIUD.EMPR_Codigo                      
	AND CLIE.CIUD_Codigo = CLIE_CIUD.Codigo      
       
	LEFT JOIN Terceros TFAA on                      
	ENFA.EMPR_Codigo = TFAA.EMPR_Codigo                                   
	AND ENFA.TERC_Facturar = TFAA.Codigo      
       
	LEFT JOIN Ciudades AS TFAA_CIUD ON                      
	TFAA.EMPR_Codigo = TFAA_CIUD.EMPR_Codigo                      
	AND TFAA.CIUD_Codigo = TFAA_CIUD.Codigo                 
           
	LEFT JOIN Conceptos_Notas_Facturas AS CONF ON              
	ENNF.EMPR_Codigo = CONF.EMPR_Codigo                      
	AND ENNF.CONF_Codigo = CONF.Codigo                      
                      
	INNER JOIN Empresas AS EMPR ON                      
	ENNF.EMPR_Codigo = EMPR.Codigo                      
              
	LEFT JOIN Oficinas OFRE on              
	ENFA.EMPR_Codigo = OFRE.EMPR_Codigo              
	AND ENFA.OFIC_Factura = OFRE.Codigo              
              
	LEFT JOIN  Oficinas OFIC on              
	ENNF.EMPR_Codigo = OFIC.EMPR_Codigo              
	AND ENNF.OFIC_Nota = OFIC.Codigo              
                                
	LEFT JOIN  Ciudades CIOF on                                 
	OFIC.EMPR_Codigo = CIOF.EMPR_Codigo                                    
	AND OFIC.CIUD_Codigo = CIOF.Codigo                      
                      
	INNER JOIN Usuarios AS USUA ON                      
	ENNF.EMPR_Codigo = USUA.EMPR_Codigo                      
	AND ENNF.USUA_Codigo_Crea = USUA.Codigo             
           
	LEFT JOIN Factura_Electronica AS FAEL ON                                
	ENFA.EMPR_Codigo = FAEL.EMPR_Codigo                                
	AND ENFA.Numero = FAEL.ENFA_Numero                    
          
	INNER JOIN Usuarios USAC ON        
	ENNF.EMPR_Codigo = USAC.EMPR_Codigo        
	AND ENNF.USUA_Codigo_Crea = USAC.Codigo   
   
	INNER JOIN Tipo_Documentos TIDO   
	ON TIDO.EMPR_Codigo = ENNF.EMPR_Codigo   
	AND TIDO.Codigo = ENNF.TIDO_Codigo  
   
	LEFT JOIN Consecutivo_Documento_Oficinas CODO   
	ON CODO.EMPR_Codigo = ENNF.EMPR_Codigo   
	AND CODO.TIDO_Codigo = ENNF.TIDO_Codigo  
	AND CODO.OFIC_Codigo = ENNF.OFIC_Nota  
  
   
	INNER JOIN Tipo_Documentos TIFA  
	ON TIFA.EMPR_Codigo = ENFA.EMPR_Codigo   
	AND TIFA.Codigo = ENFA.TIDO_Codigo  
  
	INNER JOIN Oficinas OFFA ON  
	ENFA.EMPR_Codigo = OFFA.EMPR_Codigo   
	AND ENFA.OFIC_Factura = OFFA.Codigo  
                      
	WHERE ENNF.EMPR_Codigo = @par_Empr_Codigo                      
	AND ENNF.Numero = @par_Numero_Nota                

END
GO
---------------------------------------------------
PRINT 'gsp_consultar_remesas_pendientes_facturar'
GO
DROP PROCEDURE gsp_consultar_remesas_pendientes_facturar
GO
CREATE PROCEDURE gsp_consultar_remesas_pendientes_facturar
(                                                                  
	@par_EMPR_Codigo SMALLINT,                          
	@par_Numero_Documento NUMERIC = NULL,            
	@par_TIDO_Codigo NUMERIC = NULL,            
	@par_Fecha_Inicial DATETIME = NULL,                          
	@par_Fecha_Final DATETIME = NULL,                          
	@par_CLIE_Codigo NUMERIC = NULL,                          
	@par_Documento_Cliente VARCHAR(30) = NULL,                  
	@par_ENPD_Numero_Documento NUMERIC = NULL,                          
	@par_ESOS_Numero_Documento NUMERIC = NULL,                  
	@par_TEDI_Codigo   INT =  NULL,                          
	@par_NumeroPagina INT = NULL,                          
	@par_RegistrosPagina INT = NULL ,              
	@par_Facturar_A NUMERIC =NULL,          
	@par_CIUD_Origen NUMERIC = NULL,          
	@par_CIUD_Destino NUMERIC = NULL,          
	@par_PRTR_Codigo NUMERIC = NULL          
)                                                                  
AS                                                                  
BEGIN            
	Declare @Remesa Numeric = 100;            
	Declare @RemesaPaqueteria Numeric = 110;            
	Declare @RemesaMensajeria Numeric = 111;
	Declare @RemesaOtrasEmpresas Numeric = 118;            
	Declare @RemesaProveedores Numeric = 112;            
	DECLARE @TableTipoRemesas TABLE (Codigo NUMERIC)            
            
	IF (@par_TIDO_Codigo IS NULL)  BEGIN    INSERT @TableTipoRemesas (Codigo) values (@Remesa), (@RemesaPaqueteria), (@RemesaMensajeria), (@RemesaOtrasEmpresas), (@RemesaProveedores)  END   ELSE   BEGIN   INSERT @TableTipoRemesas (Codigo) values (@par_TIDO_Codigo)   END
              
	IF @par_TIDO_Codigo = @Remesa OR @par_TIDO_Codigo = @RemesaOtrasEmpresas OR @par_TIDO_Codigo = @RemesaProveedores
	BEGIN          
	SELECT            
	ENRE.EMPR_Codigo,                          
	ENRE.Numero,                          
	ENRE.Numero_Documento,                  
	ENRE.TIDO_Codigo,                  
	ENRE.TERC_Codigo_Cliente,                          
	ISNULL(ENRE.Documento_Cliente,'') AS Documento_Cliente,                
	ISNULL(CLIE.Razon_Social,'') + ISNULL(CLIE.Nombre,'') + ' ' + ISNULL(CLIE.Apellido1,'') + ' ' + ISNULL(CLIE.Apellido2,'') As NombreCliente,                      
	ENRE.Fecha,                          
	ENRE.RUTA_Codigo,                          
	RUTA.Nombre AS NombreRuta,                          
	ENRE.PRTR_Codigo,                          
	PRTR.Nombre AS NombreProducto,                          
	ENRE.CATA_FOPR_Codigo,                          
	ENRE.TERC_Codigo_Remitente,                          
	ENRE.Observaciones,                          
	ENRE.Cantidad_Cliente,                          
	ENRE.Peso_Cliente,                          
	ENRE.Peso_Volumetrico_Cliente,                          
	ENRE.Valor_Flete_Cliente,                          
	ENRE.Valor_Manejo_Cliente,                          
	ENRE.Valor_Seguro_Cliente,                          
	ENRE.Valor_Descuento_Cliente,                          
	ENRE.Total_Flete_Cliente,                          
	ENRE.Valor_Comercial_Cliente,                          
	ENRE.Cantidad_Transportador,                          
	ENRE.Peso_Transportador,                          
	ENRE.Valor_Flete_Transportador,                          
	ENRE.Total_Flete_Transportador,            
	ENRE.ETCC_Numero,                          
	ENRE.ETCV_Numero,                          
	ENRE.ESOS_Numero,                          
	ESOS.Numero_Documento AS OrdenServicio,                          
	ISNULL(ESOS.Facturar_Despachar, 0) AS Facturar_Despachar,                          
	ISNULL(ESOS.Facturar_Cantidad_Peso_Cumplido, 0) AS Facturar_Cantidad_Peso_Cumplido,        
	ISNULL(CURE.Peso_Descargue, 0) AS Peso_Descargue,        
	ENRE.ENPD_Numero AS NumeroPlanilla,                          
	ISNULL(ENPD.Numero_Documento,0) AS NumeroDocumentoPlanilla,                          
	ENRE.ENMC_Numero AS NumeroManifiesto,                          
	ISNULL(ENMC.Numero_Documento,0) AS NumeroDocumentoManifiesto,      
	ISNULL(ENRE.ECPD_Numero,0) AS ECPD_Numero,                          
	ISNULL(ECPD.Numero_Documento,0) AS NumeroCumplido,            
	ENRE.VEHI_Codigo,                          
	ISNULL(PRTR.UEPT_Codigo, 0) AS Unidad_Empaque,                          
	ISNULL(ENRE.Distribucion,0) AS Distribucion,                        
	ISNULL(TEDI.Nombre, '') As NombreSede,                              
	VEHI.Placa,                
	IIF(ENRE.TIDO_Codigo = @RemesaPaqueteria, CIOP.Nombre , CIOR.Nombre) as CiudadRemitente,                            
	IIF(ENRE.TIDO_Codigo = @RemesaPaqueteria, CIDP.Nombre , CIDE.Nombre) as CiudadDestinatario,      
	ENRE.DT_SAP,    
	ENRE.Entrega_SAP,    
	ENRE.TERC_Codigo_Facturara,    
	RTRIM(LTRIM(CONCAT(FACA.Razon_Social,' ',FACA.Nombre,' ',FACA.Apellido1,' ',FACA.Apellido2))) AS NombreFacturarA,    
	CASE ENRE.TIDO_Codigo                  
	When @Remesa Then TIDE.Campo1               
	When @RemesaPaqueteria Then 'Paquetería'                  
	When @RemesaMensajeria Then 'Mensajería'
	When @RemesaOtrasEmpresas Then 'Manifiesto Otras Empresas'            
	When @RemesaProveedores Then 'Planilla Proveedores'            
	END AS TipoDespacho,            
	ESOS.CATA_TDOS_Codigo          
            
	FROM                                                                  
	Encabezado_Remesas ENRE                          
                          
	LEFT JOIN Rutas RUTA                          
	ON ENRE.EMPR_Codigo = RUTA.EMPR_Codigo                          
	AND ENRE.RUTA_Codigo = RUTA.Codigo                          
                  
	LEFT JOIN Producto_Transportados PRTR                          
	ON ENRE.EMPR_Codigo = PRTR.EMPR_Codigo                          
	AND ENRE.PRTR_Codigo = PRTR.Codigo                          
                          
	LEFT JOIN Terceros CLIE                          
	ON ENRE.EMPR_Codigo = CLIE.EMPR_Codigo                          
	AND ENRE.TERC_Codigo_Cliente = CLIE.Codigo      
     
	LEFT JOIN Terceros FACA      
	ON ENRE.EMPR_Codigo = FACA.EMPR_Codigo      
	AND ENRE.TERC_Codigo_Facturara = FACA.Codigo     
                          
	LEFT JOIN Encabezado_Solicitud_Orden_Servicios ESOS                          
	ON ENRE.EMPR_Codigo = ESOS.EMPR_Codigo                          
	AND ENRE.ESOS_Numero = ESOS.Numero                          
                          
	LEFT JOIN Encabezado_Facturas ENFA                          
	ON ENRE.EMPR_Codigo = ENFA.EMPR_Codigo                          
	AND ENRE.ENFA_Numero = ENFA.Numero                          
                                                                    
	LEFT JOIN Encabezado_Planilla_Despachos ENPD                          
	ON ENRE.EMPR_Codigo = ENPD.EMPR_Codigo                          
	AND ENRE.ENPD_Numero = ENPD.Numero                          
                          
	LEFT JOIN Encabezado_Manifiesto_Carga ENMC                          
	ON ENRE.EMPR_Codigo = ENMC.EMPR_Codigo                          
	AND ENRE.ENMC_Numero = ENMC.Numero                          
                          
	LEFT JOIN Encabezado_Cumplido_Planilla_Despachos ECPD                          
	ON ENRE.EMPR_Codigo = ECPD.EMPR_Codigo                       
	AND ENRE.ECPD_Numero = ECPD.Numero        
          
	LEFT JOIN Cumplido_Remesas CURE         
	ON ENRE.EMPR_Codigo = CURE.EMPR_Codigo                
	AND ENRE.Numero = CURE.ENRE_Numero                      
                          
	LEFT JOIN Detalle_Despacho_Orden_Servicios AS DDOS                          
	ON ENRE.EMPR_Codigo = DDOS.EMPR_Codigo                          
	AND ENRE.Numero = DDOS.ENRE_Numero                          
                          
	LEFT JOIN Tercero_Direcciones As TEDI                          
	ON ENRE.EMPR_Codigo = TEDI.EMPR_Codigo                          
	AND ENRE.TEDI_Codigo = TEDI.Codigo                          
                        
	LEFT JOIN Vehiculos AS VEHI                          
	ON ENRE.EMPR_Codigo = VEHI.EMPR_Codigo                          
	AND ENRE.VEHI_Codigo = VEHI.Codigo                          
           
	LEFT JOIN Ciudades as CIOR                        
	ON CIOR.EMPR_Codigo = RUTA.EMPR_Codigo                        
	AND CIOR.Codigo = RUTA.CIUD_Codigo_Origen                        
                        
	LEFT JOIN Ciudades as CIDE                        
	ON CIDE.EMPR_Codigo = RUTA.EMPR_Codigo                        
	AND CIDE.Codigo = RUTA.CIUD_Codigo_Destino          
           
	LEFT JOIN Ciudades as CIOP                       
	ON CIOP.EMPR_Codigo = ENRE.EMPR_Codigo                        
	AND CIOP.Codigo = ENRE.CIUD_Codigo_Remitente          
                        
	LEFT JOIN Ciudades as CIDP                        
	ON CIDP.EMPR_Codigo = ENRE.EMPR_Codigo                        
	AND CIDP.Codigo = ENRE.CIUD_Codigo_Destinatario          
                        
	LEFT JOIN Valor_Catalogos AS TIDE                        
	ON ESOS.EMPR_Codigo = TIDE.EMPR_Codigo                        
	AND ESOS.CATA_TDOS_Codigo = TIDE.Codigo            
             
	INNER JOIN (SELECT Codigo FROM @TableTipoRemesas) TDRE ON            
	TDRE.Codigo = ENRE.TIDO_Codigo               
                        
	WHERE                               
	ENRE.EMPR_Codigo = @par_EMPR_Codigo            
	AND ENRE.Estado = 1            
	AND ENRE.Anulado = 0            
	AND ENRE.Numero_Documento = ISNULL(@par_Numero_Documento, ENRE.Numero_Documento)                          
	AND ENRE.Fecha BETWEEN ISNULL(@par_Fecha_Inicial, ENRE.Fecha) AND ISNULL(@par_Fecha_Final, ENRE.Fecha)                          
	AND (ESOS.Numero_Documento = @par_ESOS_Numero_Documento OR @par_ESOS_Numero_Documento IS NULL)                
	-- AND (ESOS.TERC_Codigo_Facturar = @par_Facturar_A OR @par_Facturar_A IS NULL)            
	AND (ENRE.TERC_Codigo_Facturara = @par_Facturar_A OR @par_Facturar_A IS NULL)    
	AND (ENPD.Numero_Documento = @par_ENPD_Numero_Documento OR @par_ENPD_Numero_Documento IS NULL)                          
	AND ((ISNULL(ENRE.Cumplido, 0) = 1) OR (ESOS.Facturar_Despachar = 1 ))                       
	AND ENRE.TERC_Codigo_Cliente = ISNULL(@par_CLIE_Codigo, ENRE.TERC_Codigo_Cliente)                          
	AND (ENRE.Documento_Cliente  LIKE'%'+@par_Documento_Cliente+'%' OR @par_Documento_Cliente IS NULL)                          
	AND (ENRE.ENFA_Numero = 0 OR ENRE.ENFA_Numero IS NULL)                  
	AND  CLIE.Numero_Identificacion = ISNULL(@par_Documento_Cliente,CLIE.Numero_Identificacion)                          
	AND (ENRE.TEDI_Codigo = @par_TEDI_Codigo OR @par_TEDI_Codigo IS NULL)                     
	AND (ENRE.Remesa_Cortesia <> 1 or ENRE.Remesa_Cortesia IS NULL)          
	AND (CIOR.Codigo = @par_CIUD_Origen OR @par_CIUD_Origen IS NULL) --Filtro Origen Para Masivo (tido <> 110)          
	AND (CIDE.Codigo = @par_CIUD_Destino OR @par_CIUD_Destino IS NULL) --Filtro Destino Para Masivo (tido <> 110)          
	AND (ENRE.PRTR_Codigo = @par_PRTR_Codigo OR @par_PRTR_Codigo IS NULL)          
	ORDER BY ENRE.Numero            
          
	END          
	ELSE          
	BEGIN          
	SELECT            
	ENRE.EMPR_Codigo,                          
	ENRE.Numero,                          
	ENRE.Numero_Documento,                  
	ENRE.TIDO_Codigo,                  
	ENRE.TERC_Codigo_Cliente,                          
	ISNULL(ENRE.Documento_Cliente,'') AS Documento_Cliente,                
	ISNULL(CLIE.Razon_Social,'') + ISNULL(CLIE.Nombre,'') + ' ' + ISNULL(CLIE.Apellido1,'') + ' ' + ISNULL(CLIE.Apellido2,'') As NombreCliente,                      
	ENRE.Fecha,                          
	ENRE.RUTA_Codigo,                          
	RUTA.Nombre AS NombreRuta,                          
	ENRE.PRTR_Codigo,                          
	PRTR.Nombre AS NombreProducto,                          
	ENRE.CATA_FOPR_Codigo,                          
	ENRE.TERC_Codigo_Remitente,                          
	ENRE.Observaciones,                          
	ENRE.Cantidad_Cliente,                          
	ENRE.Peso_Cliente,                          
	ENRE.Peso_Volumetrico_Cliente,                          
	ENRE.Valor_Flete_Cliente,                          
	ENRE.Valor_Manejo_Cliente,                          
	ENRE.Valor_Seguro_Cliente,                          
	ENRE.Valor_Descuento_Cliente,                          
	ENRE.Total_Flete_Cliente,                          
	ENRE.Valor_Comercial_Cliente,                          
	ENRE.Cantidad_Transportador,                          
	ENRE.Peso_Transportador,                          
	ENRE.Valor_Flete_Transportador,                          
	ENRE.Total_Flete_Transportador,            
	ENRE.ETCC_Numero,                          
	ENRE.ETCV_Numero,                          
	ENRE.ESOS_Numero,                          
	ESOS.Numero_Documento AS OrdenServicio,                          
	ISNULL(ESOS.Facturar_Despachar, 0) AS Facturar_Despachar,                      
	ISNULL(ESOS.Facturar_Cantidad_Peso_Cumplido, 0) AS Facturar_Cantidad_Peso_Cumplido,        
	ISNULL(CURE.Peso_Descargue, 0) AS Peso_Descargue,        
	ENRE.ENPD_Numero AS NumeroPlanilla,                          
	ISNULL(ENPD.Numero_Documento,0) AS NumeroDocumentoPlanilla,                          
	ENRE.ENMC_Numero AS NumeroManifiesto,                          
	ISNULL(ENMC.Numero_Documento,0) AS NumeroDocumentoManifiesto,                          
	ISNULL(ENRE.ECPD_Numero,0) AS ECPD_Numero,                          
	ISNULL(ECPD.Numero_Documento,0) AS NumeroCumplido,            
	ENRE.VEHI_Codigo,                          
	ISNULL(PRTR.UEPT_Codigo, 0) AS Unidad_Empaque,                          
	ISNULL(ENRE.Distribucion,0) AS Distribucion,         
	ISNULL(TEDI.Nombre, '') As NombreSede,                              
	VEHI.Placa,                        
	IIF(ENRE.TIDO_Codigo = @RemesaPaqueteria, CIOP.Nombre , CIOR.Nombre) as CiudadRemitente,                            
	IIF(ENRE.TIDO_Codigo = @RemesaPaqueteria, CIDP.Nombre , CIDE.Nombre) as CiudadDestinatario,           
	ENRE.DT_SAP,    
	ENRE.Entrega_SAP,    
	ENRE.TERC_Codigo_Facturara,    
	RTRIM(LTRIM(CONCAT(FACA.Razon_Social,' ',FACA.Nombre,' ',FACA.Apellido1,' ',FACA.Apellido2))) AS NombreFacturarA,    
	CASE ENRE.TIDO_Codigo                  
	When @Remesa Then TIDE.Campo1                  
	When @RemesaPaqueteria Then 'Paquetería'
	When @RemesaMensajeria Then 'Mensajería'
	When @RemesaOtrasEmpresas Then 'Manifiesto Otras Empresas'            
	When @RemesaProveedores Then 'Planilla Proveedores'            
	END AS TipoDespacho,            
	ESOS.CATA_TDOS_Codigo          
            
	FROM                                                                  
	Encabezado_Remesas ENRE                          
                          
	LEFT JOIN Rutas RUTA                          
	ON ENRE.EMPR_Codigo = RUTA.EMPR_Codigo                          
	AND ENRE.RUTA_Codigo = RUTA.Codigo                          
                  
	LEFT JOIN Producto_Transportados PRTR                          
	ON ENRE.EMPR_Codigo = PRTR.EMPR_Codigo                          
	AND ENRE.PRTR_Codigo = PRTR.Codigo                          
                          
	LEFT JOIN Terceros CLIE                          
	ON ENRE.EMPR_Codigo = CLIE.EMPR_Codigo                          
	AND ENRE.TERC_Codigo_Cliente = CLIE.Codigo           
     
	LEFT JOIN Terceros FACA      
	ON ENRE.EMPR_Codigo = FACA.EMPR_Codigo      
	AND ENRE.TERC_Codigo_Facturara = FACA.Codigo     
                          
	LEFT JOIN Encabezado_Solicitud_Orden_Servicios ESOS                          
	ON ENRE.EMPR_Codigo = ESOS.EMPR_Codigo                          
	AND ENRE.ESOS_Numero = ESOS.Numero                          
                          
	LEFT JOIN Encabezado_Facturas ENFA                          
	ON ENRE.EMPR_Codigo = ENFA.EMPR_Codigo                          
	AND ENRE.ENFA_Numero = ENFA.Numero                          
                                                                    
	LEFT JOIN Encabezado_Planilla_Despachos ENPD                          
	ON ENRE.EMPR_Codigo = ENPD.EMPR_Codigo                          
	AND ENRE.ENPD_Numero = ENPD.Numero                          
                
	LEFT JOIN Encabezado_Manifiesto_Carga ENMC                          
	ON ENRE.EMPR_Codigo = ENMC.EMPR_Codigo                          
	AND ENRE.ENMC_Numero = ENMC.Numero                          
                          
	LEFT JOIN Encabezado_Cumplido_Planilla_Despachos ECPD                          
	ON ENRE.EMPR_Codigo = ECPD.EMPR_Codigo                       
	AND ENRE.ECPD_Numero = ECPD.Numero        
        
	LEFT JOIN Cumplido_Remesas CURE         
	ON ENRE.EMPR_Codigo = CURE.EMPR_Codigo                
	AND ENRE.Numero = CURE.ENRE_Numero           
                          
	LEFT JOIN Detalle_Despacho_Orden_Servicios AS DDOS                          
	ON ENRE.EMPR_Codigo = DDOS.EMPR_Codigo                          
	AND ENRE.Numero = DDOS.ENRE_Numero                          
                          
	LEFT JOIN Tercero_Direcciones As TEDI                          
	ON ENRE.EMPR_Codigo = TEDI.EMPR_Codigo                          
	AND ENRE.TEDI_Codigo = TEDI.Codigo                          
                        
	LEFT JOIN Vehiculos AS VEHI                          
	ON ENRE.EMPR_Codigo = VEHI.EMPR_Codigo                          
	AND ENRE.VEHI_Codigo = VEHI.Codigo                          
                        
	LEFT JOIN Ciudades as CIOR                        
	ON CIOR.EMPR_Codigo = RUTA.EMPR_Codigo                        
	AND CIOR.Codigo = RUTA.CIUD_Codigo_Origen                        
                        
	LEFT JOIN Ciudades as CIDE                        
	ON CIDE.EMPR_Codigo = RUTA.EMPR_Codigo                        
	AND CIDE.Codigo = RUTA.CIUD_Codigo_Destino          
           
	LEFT JOIN Ciudades as CIOP                       
	ON CIOP.EMPR_Codigo = ENRE.EMPR_Codigo                        
	AND CIOP.Codigo = ENRE.CIUD_Codigo_Remitente          
                        
	LEFT JOIN Ciudades as CIDP                        
	ON CIDP.EMPR_Codigo = ENRE.EMPR_Codigo                        
	AND CIDP.Codigo = ENRE.CIUD_Codigo_Destinatario          
                        
	LEFT JOIN Valor_Catalogos AS TIDE                        
	ON ESOS.EMPR_Codigo = TIDE.EMPR_Codigo                        
	AND ESOS.CATA_TDOS_Codigo = TIDE.Codigo            
             
	INNER JOIN (SELECT Codigo FROM @TableTipoRemesas) TDRE ON            
	TDRE.Codigo = ENRE.TIDO_Codigo               
                        
	WHERE                               
	ENRE.EMPR_Codigo = @par_EMPR_Codigo            
	AND ENRE.Estado = 1            
	AND ENRE.Anulado = 0            
	AND ENRE.Numero_Documento = ISNULL(@par_Numero_Documento, ENRE.Numero_Documento)                          
	AND ENRE.Fecha BETWEEN ISNULL(@par_Fecha_Inicial, ENRE.Fecha) AND ISNULL(@par_Fecha_Final, ENRE.Fecha)                          
	AND (ESOS.Numero_Documento = @par_ESOS_Numero_Documento OR @par_ESOS_Numero_Documento IS NULL)                
	--AND (ESOS.TERC_Codigo_Facturar = @par_Facturar_A OR @par_Facturar_A IS NULL)                           
	AND (ENRE.TERC_Codigo_Facturara = @par_Facturar_A OR @par_Facturar_A IS NULL)    
	AND (ENPD.Numero_Documento = @par_ENPD_Numero_Documento OR @par_ENPD_Numero_Documento IS NULL)                          
	AND ((ISNULL(ENRE.Cumplido, 0) = 1) OR (ESOS.Facturar_Despachar = 1 ))                       
	AND ENRE.TERC_Codigo_Cliente = ISNULL(@par_CLIE_Codigo, ENRE.TERC_Codigo_Cliente)                          
	AND (ENRE.Documento_Cliente  LIKE'%'+@par_Documento_Cliente+'%' OR @par_Documento_Cliente IS NULL)                          
	AND (ENRE.ENFA_Numero = 0 OR ENRE.ENFA_Numero IS NULL)                  
	AND  CLIE.Numero_Identificacion = ISNULL(@par_Documento_Cliente,CLIE.Numero_Identificacion)                          
	AND (ENRE.TEDI_Codigo = @par_TEDI_Codigo OR @par_TEDI_Codigo IS NULL)                     
	AND (ENRE.Remesa_Cortesia <> 1 or ENRE.Remesa_Cortesia IS NULL)          
	AND (ENRE.CIUD_Codigo_Remitente = @par_CIUD_Origen OR @par_CIUD_Origen IS NULL) --Filtro Origen Para Masivo (tido = 110)          
	AND (ENRE.CIUD_Codigo_Destinatario = @par_CIUD_Destino OR @par_CIUD_Destino IS NULL) --Filtro Destino Para Masivo (tido = 110)          
	AND (ENRE.PRTR_Codigo = @par_PRTR_Codigo OR @par_PRTR_Codigo IS NULL)          
	ORDER BY ENRE.Numero            
          
	END          
END
GO
---------------------------------------------------