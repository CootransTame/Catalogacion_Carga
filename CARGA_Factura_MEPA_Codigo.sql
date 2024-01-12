PRINT 'gsp_insertar_encabezado_facturas'
GO
DROP PROCEDURE gsp_insertar_encabezado_facturas
GO
CREATE PROCEDURE gsp_insertar_encabezado_facturas
(          
	@par_EMPR_Codigo smallint,                
	@par_TIDO_Codigo numeric,                
	@par_Numero_Preimpreso varchar(20),                
	@par_CATA_TIFA_Codigo numeric,                
	@par_Fecha date,                
	@par_OFIC_Factura numeric,                
	@par_TERC_Cliente numeric,                
	@par_TERC_Facturar numeric,             
	@par_TEDI_Codigo numeric = NULL,           
	@par_CATA_FPVE_Codigo numeric,          
	@par_Dias_Plazo smallint,                
	@par_Observaciones varchar(500),                
	@par_Valor_Remesas money,                
	@par_Valor_Otros_Conceptos money,                
	@par_Valor_Descuentos money,                
	@par_Subtotal money,                
	@par_Valor_Impuestos money,                
	@par_Valor_Factura money,                
	@par_Valor_TRM money,                
	@par_MONE_Codigo_Alterna numeric,                
	@par_Valor_Moneda_Alterna money,                
	@par_Valor_Anticipo money,                
	@par_Resolucion_Facturacion varchar(500),                
	@par_Control_Impresion smallint,                
	@par_Estado smallint,                
	@par_USUA_Codigo_Crea smallint,                
	@par_Anulado smallint,    
	@par_Numero_Orden_Compra varchar(500)= NULL,
	@par_CATA_MEPA_Codigo numeric = NULL
)          
AS                
BEGIN          
	DECLARE @numNumeroFactura NUMERIC = 0 ,@numNumero numeric = 0        
	Declare @TipoNumercion NUMERIC = 1101        
	Declare @OficinaFactura NUMERIC = @par_OFIC_Factura        
	--Consumo Prefactura                
	IF ISNULL(@par_Estado,0) = 0 BEGIN                
	SET @par_TIDO_Codigo = 175 --> Prefactura             
	END          
	--Validacion Numeracion por Oficinas (Oficina Principal en Oficinas)        
	SELECT @TipoNumercion = CATA_TIGN_Codigo FROM Tipo_Documentos WHERE EMPR_Codigo = @par_EMPR_Codigo and Codigo = @par_TIDO_Codigo        
	IF @TipoNumercion = 1102--Numeracion Por Oficina        
	BEGIN        
	IF(EXISTS(SELECT OFIC_Codigo_Factura FROM Oficinas WHERE EMPR_Codigo = @par_EMPR_Codigo and Codigo = @par_OFIC_Factura))        
	BEGIN        
	SELECT @OficinaFactura = OFIC_Codigo_Factura FROM Oficinas WHERE EMPR_Codigo = @par_EMPR_Codigo and Codigo = @par_OFIC_Factura        
	END        
	END      
      
	EXEC gsp_generar_consecutivo @par_EMPR_Codigo, @par_TIDO_Codigo, @OficinaFactura, @numNumeroFactura OUTPUT

	IF @numNumeroFactura IS NOT NULL      
	BEGIN      
		INSERT INTO Encabezado_Facturas (      
		EMPR_Codigo,                
		TIDO_Codigo,                
		Numero_Documento,                
		Numero_Preimpreso,                
		CATA_TIFA_Codigo,               
		Fecha,                
		OFIC_Factura,                
		TERC_Cliente,                
		TERC_Facturar,             
		TEDI_Codigo,             
		CATA_FPVE_Codigo,          
		Dias_Plazo,                
		Observaciones,                
		Valor_Remesas,                
		Valor_Otros_Conceptos,                
		Valor_Descuentos,                
		Subtotal,                
		Valor_Impuestos,                
		Valor_Factura,                
		Valor_TRM,                
		MONE_Codigo_Alterna,                
		Valor_Moneda_Alterna,                
		Valor_Anticipo,                
		Resolucion_Facturacion,                
		Control_Impresion,                
		Estado,                
		Fecha_Crea,                
		USUA_Codigo_Crea,                
		Anulado,                
		Factura_Electronica,  
		Numero_Orden_Compra,
		CATA_MEPA_Codigo
		)          
		VALUES(                
		@par_EMPR_Codigo,                
		@par_TIDO_Codigo,                
		@numNumeroFactura,                
		@par_Numero_Preimpreso,               
		@par_CATA_TIFA_Codigo,              
		@par_Fecha,                
		@par_OFIC_Factura,                
		@par_TERC_Cliente,                
		@par_TERC_Facturar,          
		@par_TEDI_Codigo,             
		@par_CATA_FPVE_Codigo,              
		@par_Dias_Plazo,                
		@par_Observaciones,                
		@par_Valor_Remesas,                
		@par_Valor_Otros_Conceptos,                
		@par_Valor_Descuentos,                
		@par_Subtotal,                
		@par_Valor_Impuestos,                
		@par_Valor_Factura,                
		@par_Valor_TRM,         
		@par_MONE_Codigo_Alterna,                
		@par_Valor_Moneda_Alterna,                
		@par_Valor_Anticipo,                
		@par_Resolucion_Facturacion,                
		@par_Control_Impresion,                
		@par_Estado,                
		GETDATE(),                
		@par_USUA_Codigo_Crea,           
		@par_Anulado,                
		0 ,  
		@par_Numero_Orden_Compra,
		@par_CATA_MEPA_Codigo
		)      
		SELECT @@IDENTITY As Numero, @numNumeroFactura As Numero_Documento  
		--SELECT Numero, Numero_Documento FROM Encabezado_Facturas                 
		--WHERE EMPR_Codigo = @par_EMPR_Codigo                
		--AND Numero_Documento = @numNumeroFactura                
		--AND TIDO_Codigo = @par_TIDO_Codigo                
		--AND CATA_TIFA_Codigo = @par_CATA_TIFA_Codigo      
	END      
	ELSE      
	BEGIN      
		SELECT -1 AS Numero, -1 AS Numero_Documento--No consumer definitivo Oficina      
	END      
END
GO
---------------------------------------------------
PRINT 'gsp_modificar_encabezado_facturas'
GO
DROP PROCEDURE gsp_modificar_encabezado_facturas
GO
CREATE PROCEDURE gsp_modificar_encabezado_facturas
(          
	@par_EMPR_Codigo smallint,                
	@par_Numero numeric,                
	@par_Fecha datetime,                
	@par_OFIC_Factura smallint,                
	@par_TERC_Cliente numeric,                
	@par_TERC_Facturar numeric,        
	@par_TEDI_Codigo numeric = NULL,            
	@par_CATA_FPVE_Codigo numeric,                
	@par_Dias_Plazo int = NULL,                
	@par_Observaciones varchar(500) = NULL,                
	@par_Valor_Remesas money = NULL,                
	@par_Valor_Otros_Conceptos money = NULL,                
	@par_Valor_Descuentos money = NULL,                
	@par_Subtotal money = NULL,                
	@par_Valor_Impuestos   money = NULL,                
	@par_Valor_Factura    money = NULL,                
	@par_Valor_TRM     money =  NULL,                
	@par_MONE_Codigo_Alterna  money = NULL,                
	@par_Valor_Moneda_Alterna  money = NULL,                
	@par_Valor_Anticipo    money = NULL,          
	@par_Resolucion_Facturacion    varchar(500),                
	@par_Control_Impresion     smallint,          
	@par_USUA_Codigo_Modifica     smallint,               
	@par_Estado      money = NULL,  
	@par_Numero_Orden_Compra  varchar(500) = NULL,
	@par_CATA_MEPA_Codigo numeric = NULL
)                
                
AS                
BEGIN      
	--variables numeracion      
	Declare @TipoNumercion NUMERIC = 1101      
	Declare @OficinaFactura NUMERIC = @par_OFIC_Factura      
	--Variable Tipo Factura              
	Declare @par_FactDefinitivo numeric = NULL              
	set @par_FactDefinitivo = 170              
	-- Limpia el detalle                
	UPDATE Encabezado_Remesas SET ENFA_Numero = 0 WHERE EMPR_Codigo = @par_EMPR_Codigo AND ENFA_Numero = @par_Numero                
	DELETE Detalle_Remesas_Facturas WHERE EMPR_Codigo = @par_EMPR_Codigo AND ENFA_Numero = @par_Numero               
	DELETE Detalle_Impuestos_Conceptos_Facturas WHERE EMPR_Codigo = @par_EMPR_Codigo AND ENFA_Numero = @par_Numero               
	DELETE Detalle_Conceptos_Facturas WHERE EMPR_Codigo = @par_EMPR_Codigo AND ENFA_Numero = @par_Numero               
	DELETE Detalle_Impuestos_Facturas WHERE EMPR_Codigo = @par_EMPR_Codigo AND ENFA_Numero = @par_Numero    
    
	--Actuviliza el encabezado                
	UPDATE Encabezado_Facturas SET                
              
	Fecha = @par_Fecha,                
	OFIC_Factura = @par_OFIC_Factura,                
	TERC_Cliente = @par_TERC_Cliente,                
	TERC_Facturar = @par_TERC_Facturar,        
	TEDI_Codigo = @par_TEDI_Codigo,         
	CATA_FPVE_Codigo = @par_CATA_FPVE_Codigo,                
	Dias_Plazo  = ISNULL(@par_Dias_Plazo,0),                
	Observaciones  = ISNULL(@par_Observaciones,''),                
	Valor_Remesas = ISNULL(@par_Valor_Remesas,0),                
	Valor_Otros_Conceptos = ISNULL(@par_Valor_Otros_Conceptos,0),                
	Valor_Descuentos = ISNULL(@par_Valor_Descuentos,0),                
	Subtotal = ISNULL(@par_Subtotal,0),                
	Valor_Impuestos = ISNULL(@par_Valor_Impuestos,0),                
	Valor_Factura = ISNULL(@par_Valor_Factura,0),                
	Valor_TRM = ISNULL(@par_Valor_TRM,0),                
	MONE_Codigo_Alterna = ISNULL(@par_MONE_Codigo_Alterna,0),                
	Valor_Moneda_Alterna = ISNULL(@par_Valor_Moneda_Alterna,0),                
	Valor_Anticipo = ISNULL(@par_Valor_Anticipo,0),                
	Resolucion_Facturacion = ISNULL(@par_Resolucion_Facturacion,''),          
	Control_Impresion = ISNULL(@par_Control_Impresion,0),          
	USUA_Codigo_Modifica = ISNULL(@par_USUA_Codigo_Modifica, 0),          
	Fecha_Modifica = GETDATE(),          
	Estado = ISNULL(@par_Estado,0),  
	Numero_Orden_Compra = ISNULL(@par_Numero_Orden_Compra,0),
	CATA_MEPA_Codigo = @par_CATA_MEPA_Codigo
              
	FROM Encabezado_Facturas ENFA                
	WHERE ENFA.EMPR_Codigo = @par_EMPR_Codigo                
	AND ENFA.NUmero = @par_Numero                
              
	--- Consumo de factura definitiva    
	DECLARE @ConsumoDefinitivo NUMERIC = 1    
	IF ISNULL(@par_Estado,0) = 1 BEGIN                
		DECLARE @numNumeroFactura NUMERIC = 0      
		--Validacion Numeracion por Oficinas (Oficina Principal en Oficinas)      
		SELECT @TipoNumercion = CATA_TIGN_Codigo FROM Tipo_Documentos WHERE EMPR_Codigo = @par_EMPR_Codigo and Codigo = @par_FactDefinitivo      
		IF @TipoNumercion = 1102--Numeracion Por Oficina      
		BEGIN      
			IF(EXISTS(SELECT OFIC_Codigo_Factura FROM Oficinas WHERE EMPR_Codigo = @par_EMPR_Codigo and Codigo = @par_OFIC_Factura))      
			BEGIN      
				SELECT @OficinaFactura = OFIC_Codigo_Factura FROM Oficinas WHERE EMPR_Codigo = @par_EMPR_Codigo and Codigo = @par_OFIC_Factura      
			END      
		END    
    
		EXEC gsp_generar_consecutivo @par_EMPR_Codigo, @par_FactDefinitivo, @OficinaFactura, @numNumeroFactura OUTPUT                
    
		IF @numNumeroFactura IS NOT NULL    
		BEGIN     
			UPDATE Encabezado_Facturas SET Numero_Documento = @numNumeroFactura, TIDO_Codigo =  @par_FactDefinitivo                
			WHERE EMPR_Codigo = @par_EMPR_Codigo                
			AND Numero = @par_Numero    
		END    
		ELSE    
		BEGIN    
			SET @ConsumoDefinitivo = 0    
		END
	END    
    
	IF @ConsumoDefinitivo = 1    
	BEGIN    
		--- Retorna la modificación                
		SELECT Numero, Numero_Documento FROM Encabezado_Facturas ENFA                
		WHERE ENFA.EMPR_Codigo = @par_EMPR_Codigo                
		AND ENFA.Numero = @par_Numero                
	END    
	ELSE    
	BEGIN    
		SELECT -1 AS Numero, -1 AS Numero_Documento--No consumer definitivo Oficina    
	END    
END
GO
---------------------------------------------------
PRINT 'gsp_obtener_encabezado_facturas'
GO
DROP PROCEDURE gsp_obtener_encabezado_facturas
GO
CREATE PROCEDURE gsp_obtener_encabezado_facturas
(          
	@par_EMPR_Codigo SMALLINT,                
	@par_Numero NUMERIC = NULL,            
	@par_NumeroDocumento NUMERIC = NULL,            
	@par_TERC_Cliente NUMERIC = NULL,          
	@par_OFIC_Codigo NUMERIC = NULL,          
	@par_Estado NUMERIC = NULL,            
	@par_Anulado NUMERIC = NULL            
)                
AS                
BEGIN        
	SELECT          
	ENFA.EMPR_Codigo,                
	ENFA.Numero,                
	ENFA.TIDO_Codigo,                
	ENFA.Numero_Documento,                
	ENFA.Fecha,                
	ENFA.OFIC_Factura,                
	ENFA.TERC_Cliente,                
	ENFA.TERC_Facturar,        
	ENFA.TEDI_Codigo,        
	TEDI.Nombre AS TEDI_Codigo,        
	ENFA.CATA_TIFA_Codigo,
   
	ISNULL(ENFA.Numero_Orden_Compra,'')  as Numero_Orden_Compra,  
	ENFA.CATA_FPVE_Codigo,                
	ISNULL(ENFA.Dias_Plazo,0) As Dias_Plazo,                
	ISNULL(ENFA.Observaciones,'') As Observaciones,                
	ISNULL(ENFA.Valor_Remesas,0) As Valor_Remesas,                
	ISNULL(ENFA.Valor_Otros_Conceptos,0) As Valor_Otros_Conceptos,                
	ISNULL(ENFA.Valor_Descuentos,0) As Valor_Descuentos,                
	ISNULL(ENFA.Subtotal,0) As Subtotal,                
	ISNULL(ENFA.Valor_Impuestos,0) As Valor_Impuestos,                
	ISNULL(ENFA.Valor_Factura,0) As Valor_Factura,                
	ISNULL(ENFA.Valor_TRM,0) As Valor_TRM,                
	ISNULL(ENFA.MONE_Codigo_Alterna,0) As MONE_Codigo_Alterna,                
	ISNULL(ENFA.Valor_Moneda_Alterna,0) As Valor_Moneda_Alterna,                
	ISNULL(ENFA.Valor_Anticipo,0) As Valor_Anticipo,                
	ISNULL(ENFA.Factura_Electronica,0) As Estado_FAEL,                
	ISNULL(ENFA.Estado,0) As Estado,
	ISNULL(ENFA.CATA_MEPA_Codigo,0) AS CATA_MEPA_Codigo,
                
	ISNULL(ENFA.Anulado,0) As Anulado,                
	ISNULL(ENFA.Fecha_Anula,'01/01/1900') As Fecha_Anula,                
	ISNULL(ENFA.USUA_Codigo_Anula,0) As USUA_Codigo_Anula,                
	ISNULL(ENFA.Causa_Anula,'') As Causa_Anula
	
	FROM Encabezado_Facturas ENFA
        
	LEFT JOIN Tercero_Direcciones TEDI ON        
	ENFA.EMPR_Codigo = TEDI.EMPR_Codigo        
	AND ENFA.TEDI_Codigo = TEDI.Codigo        
        
	WHERE ENFA.EMPR_Codigo = @par_EMPR_Codigo                
	AND ENFA.Numero = ISNULL(@par_Numero, ENFA.Numero)             
	AND ENFA.Numero_Documento = ISNULL (@par_NumeroDocumento,ENFA.Numero_Documento)            
	AND ENFA.TERC_Cliente = ISNULL (@par_TERC_Cliente,ENFA.TERC_Cliente)            
	AND ENFA.Estado = ISNULL (@par_Estado,ENFA.Estado)            
	AND ENFA.Anulado = ISNULL (@par_Anulado,ENFA.Anulado)            
	AND (ENFA.OFIC_Factura = @par_OFIC_Codigo OR @par_OFIC_Codigo IS NULL)          
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
	WHEN ENFA.Estado  = 0 THEN 'BORRADOR'END AS Estado,    
	ENFA.Numero_Orden_Compra,
	MEPA.Campo1 AS CATA_MEPA_Nombre
        
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
	
	LEFT JOIN Valor_Catalogos MEPA ON
	MEPA.EMPR_Codigo = ENFA.EMPR_Codigo
	AND MEPA.Codigo = ENFA.CATA_MEPA_Codigo
                              
	WHERE                                            
	ENFA.EMPR_Codigo = @par_Empr_Codigo                                            
	AND ENFA.Numero = @par_Numero_Factura                                        
END
GO
---------------------------------------------------