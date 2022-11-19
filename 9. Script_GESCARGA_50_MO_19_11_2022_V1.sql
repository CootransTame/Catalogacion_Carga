PRINT 'gsp_anular_encabezado_factura_ventas'
GO
DROP PROCEDURE gsp_anular_encabezado_factura_ventas
GO
CREATE PROCEDURE gsp_anular_encabezado_factura_ventas
(              
	@par_EMPR_Codigo       smallint,              
	@par_ENFA_Numero       NUMERIC,              
	@par_USUA_Codigo_Anula smallint,              
	@par_Causa_Anula    VARCHAR(150)              
)              
AS              
BEGIN              
	Declare @EstadoAnulado int = 1; -- Valor Anulacion              
	Declare @SinFacturaAsociada int = 0; --  quitar asociación factura - remesas              
	Declare @CATA_DOOR_Codigo_factura int = 2601; -- Cata Documento factura en Encabezado_Documento_Cuentas            
	Declare @AbonoCuentaCobro money = 0;              
	Declare @FechaAnulacion Date = Getdate();      
	Declare @TIDO_Codigo_GuiaPaqueteria int = 110; -- TIDO_Codigo Guia Paqueteria
	Declare @TIDO_Codigo_GuiaMensajeria int = 111; -- TIDO_Codigo Guia Mensajeria
       
	--Verifica si es una factura creada desde Paqueteria o Mensajeria
	if exists(      
		Select Numero, ENFA_Numero from Encabezado_Remesas where  ENFA_Numero = @par_ENFA_Numero AND TIDO_Codigo in(@TIDO_Codigo_GuiaPaqueteria, @TIDO_Codigo_GuiaMensajeria)
	)      
	BEGIN

		Declare @CATA_FOPR_Codigo INT = 0
		Select @CATA_FOPR_Codigo = CATA_FOPR_Codigo from Encabezado_Remesas where  ENFA_Numero = @par_ENFA_Numero AND TIDO_Codigo in(@TIDO_Codigo_GuiaPaqueteria, @TIDO_Codigo_GuiaMensajeria)

		--Caso para Anulacion factura creada desde Paqueteria      
		-- Anula Factura
		UPDATE  Encabezado_Facturas  SET                
		Anulado = @EstadoAnulado,                
		USUA_Codigo_Anula = @par_USUA_Codigo_Anula,                 
		Causa_Anula = @par_Causa_Anula              
		WHERE EMPR_Codigo = @par_EMPR_Codigo               
		AND Numero = @par_ENFA_Numero      
      
		-- Anula Remesa
		IF @CATA_FOPR_Codigo = 4902 OR @CATA_FOPR_Codigo = 4903
		BEGIN
			Update Encabezado_Remesas SET      
			Anulado = @EstadoAnulado,      
			USUA_Codigo_Anula = @par_USUA_Codigo_Anula,                 
			Causa_Anula = 'Anulación Factura',    
			Fecha_Anula = GETDATE()      
			WHERE EMPR_Codigo = @par_EMPR_Codigo       
			AND ENFA_Numero = @par_ENFA_Numero      
			AND TIDO_Codigo IN(@TIDO_Codigo_GuiaPaqueteria, @TIDO_Codigo_GuiaMensajeria)
		END
		ELSE
		BEGIN
			-- Quita Asociacion Factura - remesa              
			UPDATE Encabezado_Remesas SET              
			ENFA_Numero = @SinFacturaAsociada              
			WHERE EMPR_Codigo = @par_EMPR_Codigo              
			AND ENFA_Numero = @par_ENFA_Numero 
		END
  
		--Quita asocociacion de precintos  
		UPDATE Detalle_Asignacion_Precintos_Oficina SET ENRE_Numero = 0  
		FROM Detalle_Asignacion_Precintos_Oficina DAPO  
		LEFT JOIN Encabezado_Remesas ENRE ON  
		DAPO.EMPR_Codigo = ENRE.EMPR_Codigo  
		AND DAPO.ENRE_Numero = ENRE.Numero  
  
		WHERE ENRE.EMPR_Codigo = @par_EMPR_Codigo       
		AND ENRE.ENFA_Numero = @par_ENFA_Numero  
		AND ENRE.TIDO_Codigo IN(@TIDO_Codigo_GuiaPaqueteria, @TIDO_Codigo_GuiaMensajeria) 
		--Quita asocociacion de precintos  
  
		--Quita asocociacion de Preimpresos  
		UPDATE Detalle_Asignacion_Guias_Preimpresas SET ENRE_Numero = 0  
		FROM Detalle_Asignacion_Guias_Preimpresas DAGP  
		LEFT JOIN Encabezado_Remesas ENRE ON  
		DAGP.EMPR_Codigo = ENRE.EMPR_Codigo  
		AND DAGP.ENRE_Numero = ENRE.Numero  
  
		WHERE ENRE.EMPR_Codigo = @par_EMPR_Codigo       
		AND ENRE.ENFA_Numero = @par_ENFA_Numero  
		AND ENRE.TIDO_Codigo IN(@TIDO_Codigo_GuiaPaqueteria, @TIDO_Codigo_GuiaMensajeria)
		--Quita asocociacion de Preimpresos    
  
		SELECT Numero from Encabezado_Facturas              
		WHERE EMPR_Codigo = @par_EMPR_Codigo              
		AND Numero = @par_ENFA_Numero        
      
	END      
	ELSE      
	BEGIN
		-- Caso para Anulacion factura      
		-- Verifica si la Cuenta por cobrar tiene pagos              
		SELECT @AbonoCuentaCobro = Abono FROM encabezado_documento_cuentas              
		WHERE EMPR_Codigo = @par_EMPR_Codigo                
		AND Codigo_Documento_Origen = @par_ENFA_Numero                
		AND CATA_DOOR_Codigo = @CATA_DOOR_Codigo_factura            
            
		IF ISNULL(@AbonoCuentaCobro, 0) = 0
		BEGIN
			-- Anula Factura            
			UPDATE  Encabezado_Facturas  SET                
			Anulado = @EstadoAnulado,                
			USUA_Codigo_Anula = @par_USUA_Codigo_Anula,                 
			Causa_Anula = @par_Causa_Anula,    
			Fecha_Anula = GETDATE()           
			WHERE EMPR_Codigo = @par_EMPR_Codigo               
			AND Numero = @par_ENFA_Numero              
            
			-- Quita Asociacion Factura - remesa              
			UPDATE Encabezado_Remesas SET              
			ENFA_Numero = @SinFacturaAsociada              
			WHERE EMPR_Codigo = @par_EMPR_Codigo              
			AND ENFA_Numero = @par_ENFA_Numero              
            
			-- Anula Cuenta por cobrar de la factura          
			UPDATE Encabezado_Documento_Cuentas SET              
			Anulado = @EstadoAnulado,    
			USUA_Codigo_Anula = @par_USUA_Codigo_Anula,                 
			Causa_Anulacion = 'Anulación Factura',    
			Fecha_Anula = GETDATE()            
			WHERE EMPR_Codigo = @par_EMPR_Codigo              
			AND Codigo_Documento_Origen = @par_ENFA_Numero              
			AND CATA_DOOR_Codigo = @CATA_DOOR_Codigo_factura              
            
			SELECT Numero from Encabezado_Facturas              
			WHERE EMPR_Codigo = @par_EMPR_Codigo              
			AND Numero = @par_ENFA_Numero              
        
			EXEC gsp_anular_movimiento_contable @par_EMPR_Codigo,170,@par_ENFA_Numero
		END            
		ELSE
		BEGIN            
			SELECT 0 AS Numero              
		END            
	END      
END
GO
--------------------------------------------------------
PRINT 'gsp_consultar_detalle_remesa_facturas'
GO
DROP PROCEDURE gsp_consultar_detalle_remesa_facturas
GO
CREATE PROCEDURE gsp_consultar_detalle_remesa_facturas
(        
 @par_EMPR_Codigo smallint,                
 @par_ENFA_Numero   numeric                
)                
AS                
BEGIN        
 Declare @Remesa Numeric = 100;        
 Declare @RemesaPaqueteria Numeric = 110;
 Declare @RemesaMensajeria Numeric = 111;
 Declare @RemesaOtrasEmpresas Numeric = 118;       
        
 SELECT DERF.EMPR_Codigo,                  
 DERF.ENFA_Numero,                  
 DERF.ENRE_Numero,                  
 ISNULL(ENOS.Numero_Documento, 0) AS ENOS_Numero_Documento,              
 ISNULL(ENPD.Numero_Documento, 0) AS ENPD_Numero_Documento,              
 ISNULL(ENMC.Numero_Documento, 0) AS ENMC_Numero_Documento,              
 ENRE.Fecha,                  
 ENRE.Numero_Documento As ENRE_Numero_Documento,                
 ISNULL(ENRE.MBL_Contenedor, 'MBL') AS MBL_Contenedor,                  
 ISNULL(RUTA.Nombre, '') As NombreRuta,                  
 ENRE.Documento_Cliente As Numero_Documento_Cliente,                  
 ISNULL(DERF.Valor_Flete_Cliente,ENRE.Valor_Flete_Cliente) Valor_Flete_Cliente,    
 PROD.Nombre As NombreProducto,                  
 ENRE.TIDO_Codigo AS ENRE_TIDO_Codigo,          
 ENRE.Cantidad_Cliente,                 
 ISNULL(DERF.Peso_Cliente ,ENRE.Peso_Cliente) Peso_Cliente,    
 ISNULL(DERF.Total_Flete_Cliente, ENRE.Total_Flete_Cliente) Total_Flete_Cliente,    
 VEHI.Placa,            
 IIF(ENRE.TIDO_Codigo = @RemesaPaqueteria, CIORPAQU.Nombre, CIOR.Nombre) as CiudadRemitente,                
 IIF(ENRE.TIDO_Codigo = @RemesaPaqueteria, CIDEPAQU.Nombre, CIDE.Nombre)  as CiudadDestinatario,                
 CASE ENRE.TIDO_Codigo      
 When 100 Then TIDE.Campo1      
 When @RemesaPaqueteria Then 'Paquetería'      
 When @RemesaMensajeria Then 'Mensajería'      
 When @RemesaOtrasEmpresas Then 'Manifiesto Otras Empresas'      
 END AS TipoDespacho,      
 ISNULL(ENOS.CATA_TDOS_Codigo, 0) AS CATA_TDOS_Codigo,        
 ISNULL(ENRE.Observaciones,'') As Observaciones                  
                  
 FROM Detalle_Remesas_Facturas DERF                  
                  
 INNER JOIN                  
 Encabezado_Remesas AS ENRE ON                  
 DERF.EMPR_Codigo = ENRE.EMPR_Codigo                  
 AND DERF.ENRE_Numero = ENRE.Numero                  
                  
 INNER JOIN                  
 Rutas AS RUTA ON                  
 ENRE.EMPR_Codigo = RUTA.EMPR_Codigo                  
 AND ENRE.RUTA_Codigo = RUTA.Codigo                  
                  
 INNER JOIN                  
 Producto_Transportados AS PROD ON                  
 ENRE.EMPR_Codigo = PROD.EMPR_Codigo                  
 AND ENRE.PRTR_Codigo = PROD.Codigo              
               
 LEFT JOIN                  
 Encabezado_Planilla_Despachos AS ENPD ON                  
 ENRE.EMPR_Codigo = ENPD.EMPR_Codigo                  
 AND ENRE.ENPD_Numero = ENPD.Numero                  
              
 LEFT JOIN                  
 Encabezado_Solicitud_Orden_Servicios AS ENOS ON                  
 ENRE.EMPR_Codigo = ENOS.EMPR_Codigo                  
 AND ENRE.ESOS_Numero = ENOS.Numero              
              
 LEFT JOIN                  
 Encabezado_Manifiesto_Carga AS ENMC ON                  
 ENRE.EMPR_Codigo = ENMC.EMPR_Codigo                  
 AND ENRE.ENMC_Numero = ENMC.Numero              
            
 LEFT JOIN Vehiculos AS VEHI              
 ON ENRE.EMPR_Codigo = VEHI.EMPR_Codigo              
 AND ENRE.VEHI_Codigo = VEHI.Codigo              
            
 LEFT JOIN Ciudades as CIOR            
 ON CIOR.EMPR_Codigo = RUTA.EMPR_Codigo            
 AND CIOR.Codigo = RUTA.CIUD_Codigo_Origen        
         
 --CiudadPaqueteria        
 LEFT JOIN Ciudades as CIORPAQU            
 ON ENRE.EMPR_Codigo = CIORPAQU.EMPR_Codigo            
 AND ENRE.CIUD_Codigo_Remitente = CIORPAQU.Codigo          
            
 LEFT JOIN Ciudades as CIDE            
 ON CIDE.EMPR_Codigo = RUTA.EMPR_Codigo            
 AND CIDE.Codigo = RUTA.CIUD_Codigo_Destino           
         
 --CiudadPaqueteria        
 LEFT JOIN Ciudades as CIDEPAQU        
 ON ENRE.EMPR_Codigo = CIDEPAQU.EMPR_Codigo            
 AND ENRE.CIUD_Codigo_Destinatario = CIDEPAQU.Codigo           
            
 LEFT JOIN Valor_Catalogos AS TIDE            
 ON ENOS.EMPR_Codigo = TIDE.EMPR_Codigo            
 AND ENOS.CATA_TDOS_Codigo = TIDE.Codigo            
                  
 WHERE DERF.EMPR_Codigo = @par_EMPR_Codigo                  
 AND DERF.ENFA_Numero = @par_ENFA_Numero                  
                  
END
GO
--------------------------------------------------------
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
              
	IF (@par_TIDO_Codigo IS NULL)  BEGIN   
		INSERT INTO @TableTipoRemesas (Codigo) values (@Remesa), (@RemesaPaqueteria), (@RemesaMensajeria), (@RemesaOtrasEmpresas), (@RemesaProveedores)  
	END   
	ELSE   
	BEGIN
		INSERT INTO @TableTipoRemesas (Codigo) values (@par_TIDO_Codigo)
	END  
                
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
