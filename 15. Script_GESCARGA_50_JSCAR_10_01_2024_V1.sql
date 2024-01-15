
alter table oficinas add 
Porcentaje_Manejo_Mensajeria NUMERIC(18,2),
Porcentaje_Empresa_Mensajeria NUMERIC(18,2),
Porcentaje_Comision_Mensajeria NUMERIC(18,2),
TERC_Codigo_Comision_Mensajeria NUMERIC(18,0),
OFIC_Codigo_Principal_Mensajeria NUMERIC(18,0),
TERC_Codigo_Agencista_Mensajeria NUMERIC(18,0),
Porcentaje_Comision_Agencista_Mensajeria NUMERIC(18,2)
go

ALTER TABLE Encabezado_Despacho_Contenedor_Postal ADD 
Cantidad_Guias numeric (18,2) null,
Peso_Guias numeric (18,2) null,
Valor_Contra_Entregas_Guias numeric (18,2) null
go
ALTER TABLE Detalle_Remesas_Despacho_Contenedor_Postal
ADD Calcular_Contra_Entrega smallint null
go
DROP PROCEDURE gsp_insertar_despacho_contenedor_postal    
GO
CREATE PROCEDURE gsp_insertar_despacho_contenedor_postal    
(    
 @par_EMPR_Codigo SMALLINT,      
 @par_TIDO_Codigo NUMERIC,      
 @par_Fecha DATE = NULL,    
 @par_RUTA_Codigo NUMERIC = NULL,    
 @par_TERC_PROV_Codigo NUMERIC = NULL,    
 @par_CATA_FPVE_Codigo NUMERIC = NULL,    
 @par_VEHI_Codigo NUMERIC = NULL,    
 @par_Cantidad MONEY = NULL,    
 @par_Peso MONEY = NULL,    
 @par_ValorFlete MONEY = NULL,    
 @par_ValorAnticipo MONEY = NULL,    
 @par_ValorTotal MONEY = NULL,    
 @par_ValorRemesasNoContenidas MONEY = NULL,    
 @par_Observaciones VARCHAR(200) = NULL,      
 @par_Estado NUMERIC = NULL,    
 @par_OFIC_Codigo NUMERIC = NULL,  
 @par_USUA_Codigo_Crea NUMERIC,

 @par_Cantidad_Guias numeric (18,2) null,
 @par_Peso_Guias numeric (18,2) null,
 @par_Valor_Contra_Entregas_Guias numeric (18,2) null
 
)            
AS    
BEGIN      
 DECLARE @Numero NUMERIC    
 DECLARE @NumeroInterno NUMERIC    
 EXEC gsp_generar_consecutivo @par_EMPR_Codigo, @par_TIDO_Codigo, @par_OFIC_Codigo, @Numero OUTPUT    
    
 INSERT INTO Encabezado_Despacho_Contenedor_Postal(      
 EMPR_Codigo    
 ,TIDO_Codigo    
 ,Numero_Documento    
 ,Fecha    
 ,RUTA_Codigo    
 ,VEHI_Codigo    
 ,CATA_FPVE_Codigo    
 ,TERC_Codigo_Proveedor    
 ,Cantidad    
 ,Peso    
 ,Valor_Flete    
 ,Valor_Anticipo    
 ,Valor_Total    
 ,Valor_Remesas_No_Contenidas  
 ,Observaciones    
 ,Anulado    
 ,Estado    
 ,Fecha_Crea    
 ,USUA_Codigo_Crea    
 ,OFIC_Codigo    
 ,Cantidad_Guias
 ,Peso_Guias
 ,Valor_Contra_Entregas_Guias
 )    
 Values(            
 @par_EMPR_Codigo    
 ,@par_TIDO_Codigo    
 ,@Numero    
 ,@par_Fecha    
 ,@par_RUTA_Codigo    
 ,@par_VEHI_Codigo    
 ,@par_CATA_FPVE_Codigo    
 ,@par_TERC_PROV_Codigo    
 ,@par_Cantidad    
 ,@par_Peso    
 ,@par_ValorFlete    
 ,@par_ValorAnticipo    
 ,@par_ValorTotal    
 ,@par_ValorRemesasNoContenidas  
 ,@par_Observaciones    
 ,0    
 ,@par_Estado    
 ,GETDATE()    
 ,@par_USUA_Codigo_Crea    
 ,@par_OFIC_Codigo
 ,@par_Cantidad_Guias
 ,@par_Peso_Guias
 ,@par_Valor_Contra_Entregas_Guias
 )        
 SET @NumeroInterno = @@IDENTITY            
 SELECT @NumeroInterno AS Numero, @Numero AS Numero_Documento           
END    
GO
DROP PROCEDURE gsp_obtener_despacho_contenedor_postal    
GO
CREATE PROCEDURE gsp_obtener_despacho_contenedor_postal    
(          
 @par_EMPR_Codigo smallint,          
 @par_Numero NUMERIC          
)          
AS          
BEGIN          
 SELECT           
 EDCP.Numero,        
 EDCP.Numero_Documento,        
 EDCP.Fecha,    
 EDCP.RUTA_Codigo,    
 RUTA.Nombre AS RUTA_Nombre,    
 EDCP.VEHI_Codigo,    
 VEHI.Placa AS VEHI_Placa,    
 EDCP.CATA_FPVE_Codigo,    
 FPVE.Campo1 AS CATA_FPVE_Nombre,    
 EDCP.TERC_Codigo_Proveedor,    
 EDCP.Cantidad,    
 EDCP.Peso,    
 EDCP.Valor_Flete,    
 EDCP.Valor_Anticipo,    
 EDCP.Valor_Total,    
 EDCP.Valor_Remesas_No_Contenidas,    
 EDCP.Observaciones,          
 EDCP.Estado,    
 EDCP.Anulado,    
 EDCP.OFIC_Codigo,          
 OFIC.Nombre OFIC_Nombre,    
 EDCP.Cantidad_Guias,
 EDCP.Peso_Guias,
 EDCP.Valor_Contra_Entregas_Guias
 FROM Encabezado_Despacho_Contenedor_Postal EDCP          
        
 LEFT JOIN Rutas RUTA ON    
 EDCP.EMPR_Codigo = RUTA.EMPR_Codigo    
 AND EDCP.RUTA_Codigo = RUTA.Codigo    
    
 LEFT JOIN Vehiculos VEHI ON    
 EDCP.EMPR_Codigo = VEHI.EMPR_Codigo    
 AND EDCP.VEHI_Codigo = VEHI.Codigo    
    
 LEFT JOIN Valor_Catalogos FPVE ON    
 EDCP.EMPR_Codigo = FPVE.EMPR_Codigo    
 AND EDCP.CATA_FPVE_Codigo = FPVE.Codigo    
    
 LEFT JOIN Oficinas OFIC          
 ON EDCP.EMPR_Codigo = OFIC.EMPR_Codigo          
 AND EDCP.OFIC_Codigo = OFIC.Codigo    
    
 WHERE EDCP.EMPR_Codigo = @par_EMPR_Codigo          
 AND EDCP.Numero = @par_Numero          
END    
GO
drop PROCEDURE gsp_modificar_despacho_contenedor_postal    
go
CREATE PROCEDURE gsp_modificar_despacho_contenedor_postal    
(          
 @par_EMPR_Codigo SMALLINT,      
 @par_Numero NUMERIC,      
 @par_Fecha DATE = NULL,    
 @par_RUTA_Codigo NUMERIC = NULL,    
 @par_TERC_PROV_Codigo NUMERIC = NULL,    
 @par_CATA_FPVE_Codigo NUMERIC = NULL,    
 @par_VEHI_Codigo NUMERIC = NULL,    
 @par_Cantidad MONEY = NULL,    
 @par_Peso MONEY = NULL,    
 @par_ValorFlete MONEY = NULL,    
 @par_ValorAnticipo MONEY = NULL,    
 @par_ValorTotal MONEY = NULL,    
 @par_ValorRemesasNoContenidas MONEY = NULL,    
 @par_Observaciones VARCHAR(200) = NULL,      
 @par_Estado NUMERIC = NULL,    
 @par_OFIC_Codigo NUMERIC = NULL,    
 @par_USUA_Codigo_Crea NUMERIC,
 @par_Cantidad_Guias numeric (18,2) null,
 @par_Peso_Guias numeric (18,2) null,
 @par_Valor_Contra_Entregas_Guias numeric (18,2) null
)          
AS          
BEGIN      
 --Libera documetos y elimina detalle      
 UPDATE Encabezado_Contenedor_Postal_Mensajeria SET EDCP_Numero = 0 WHERE EMPR_Codigo = @par_EMPR_Codigo AND EDCP_Numero = @par_Numero      
 UPDATE Remesas_Paqueteria SET EDCP_Numero = 0 WHERE EMPR_Codigo = @par_EMPR_Codigo AND EDCP_Numero = @par_Numero      
 DELETE Detalle_Despacho_Contenedor_Postal WHERE EMPR_Codigo = @par_EMPR_Codigo AND EDCP_Numero = @par_Numero      
 DELETE Detalle_Remesas_Despacho_Contenedor_Postal WHERE EMPR_Codigo = @par_EMPR_Codigo AND EDCP_Numero = @par_Numero      
      
 UPDATE Encabezado_Despacho_Contenedor_Postal SET          
 Fecha = ISNULL(@par_Fecha, Fecha),      
 RUTA_Codigo = ISNULL(@par_RUTA_Codigo, RUTA_Codigo),    
 TERC_Codigo_Proveedor = ISNULL(@par_CATA_FPVE_Codigo, TERC_Codigo_Proveedor),    
 CATA_FPVE_Codigo = ISNULL(@par_CATA_FPVE_Codigo, CATA_FPVE_Codigo),    
 VEHI_Codigo = ISNULL(@par_VEHI_Codigo, VEHI_Codigo),    
 Cantidad = ISNULL(@par_Cantidad, Cantidad),    
 Peso = ISNULL(@par_Peso, Peso),    
 Valor_Flete = ISNULL(@par_ValorFlete, Valor_Flete),    
 Valor_Anticipo = ISNULL(@par_ValorAnticipo, Valor_Anticipo),    
 Valor_Total = ISNULL(@par_ValorTotal, Valor_Total),    
 Valor_Remesas_No_Contenidas = ISNULL(@par_ValorRemesasNoContenidas ,Valor_Remesas_No_Contenidas),    
 Observaciones = ISNULL(@par_Observaciones, Observaciones),      
 Estado = @par_Estado,      
 Fecha_Modifica = GETDATE(),      
 USUA_Codigo_Modifica = @par_USUA_Codigo_Crea,
 Cantidad_Guias = @par_Cantidad_Guias,
 Peso_Guias = @par_Peso_Guias,
 Valor_Contra_Entregas_Guias = @par_Valor_Contra_Entregas_Guias
          
 WHERE          
 EMPR_Codigo = @par_EMPR_Codigo          
 AND Numero = @par_Numero          
          
 SELECT Numero, Numero_Documento         
 FROM Encabezado_Despacho_Contenedor_Postal        
 WHERE          
 EMPR_Codigo = @par_EMPR_Codigo          
 AND Numero = @par_Numero    
END    
GO
DROP PROCEDURE gsp_modificar_oficinas      
GO
CREATE PROCEDURE gsp_modificar_oficinas      
(                            
 @par_EMPR_Codigo SMALLINT,                            
 @par_Codigo SMALLINT,                            
 @par_Codigo_Alterno VARCHAR(20),                            
 @par_Nombre VARCHAR(50),                            
 @par_CIUD_Codigo NUMERIC,                            
 @par_Direccion VARCHAR(150),                            
 @par_Telefono VARCHAR(20),                            
 @par_Email VARCHAR(150),                            
 @par_CATA_TIOF_Codigo NUMERIC = NULL,                    
 @par_REPA_Codigo  NUMERIC = NULL,                             
 @par_Resolucion_Facturacion VARCHAR(500) = NULL,                  
 @par_Aplica_Enturnamiento NUMERIC,                  
 @par_Estado SMALLINT,                            
 @par_USUA_Modifica SMALLINT,                        
 @par_ZOCI_Codigo NUMERIC       ,              
 @par_Porcentaje_Comision numeric(18,2) = null,              
 @par_Tercero_Comision numeric  = null,              
 @par_Tercero_Agencista_Comision numeric = null,              
 @par_Oficina_Principal numeric = null,              
 @par_Porcentaje_Agencista_Comision numeric(18,2) = null,            
 @par_Porcentaje_Seguro_Paq numeric(18,2) = null,        
 @par_Prefijo_Factura VARCHAR(20) = null,        
 @par_Clave_Tecnica_Factura VARCHAR(250) = null,        
 @par_Clave_Externa_Factura VARCHAR(250) = null,      
 @par_OFIC_Codigo_Factura NUMERIC = NULL    ,    
 @par_Porcentaje_Comision_Empresa NUMERIC(18,2) = NULL  ,    
 @par_Cuenta_PUC_ICA NUMERIC(18,0) = NULL,

 @par_Porcentaje_Manejo_Mensajeria NUMERIC(18,2) = null ,   
 @par_Porcentaje_Empresa_Mensajeria NUMERIC(18,2) = null  ,  
 @par_Porcentaje_Comision_Mensajeria NUMERIC(18,2) = null   , 
 @par_TERC_Codigo_Comision_Mensajeria NUMERIC(18,0) = null   , 
 @par_OFIC_Codigo_Principal_Mensajeria NUMERIC(18,0) = null   , 
 @par_TERC_Codigo_Agencista_Mensajeria NUMERIC(18,0) = null   , 
 @par_Porcentaje_Comision_Agencista_Mensajeria NUMERIC(18,2) = null 
)                            
AS                             
BEGIN                             
 UPDATE Oficinas                            
 SET                            
 EMPR_Codigo = @par_EMPR_Codigo,                            
 Codigo_Alterno = @par_Codigo_Alterno,                            
 Nombre = @par_Nombre,                            
 CIUD_Codigo = @par_CIUD_Codigo ,                            
 Direccion = @par_Direccion,                            
 Telefono = @par_Telefono,                            
 Email = @par_Email,                            
 CATA_TIOF_Codigo = @par_CATA_TIOF_Codigo,                      
 REPA_Codigo = @par_REPA_Codigo,                           
 Resolucion_Facturacion = ISNULL(@par_Resolucion_Facturacion,''),                  
 Aplica_Enturnamiento = @par_Aplica_Enturnamiento,                         
 Estado = @par_Estado,                            
 ZOCI_Codigo= @par_ZOCI_Codigo,                        
 USUA_Modifica = @par_USUA_Modifica,                            
 Fecha_Modifica = GETDATE()   ,              
 Porcentaje_Comision = @par_Porcentaje_Comision,              
 Porcentaje_Comision_Agencista = @par_Porcentaje_Agencista_Comision,              
 TERC_Codigo_Comision = @par_Tercero_Comision,              
 TERC_Codigo_Agencista = @par_Tercero_Agencista_Comision,              
 OFIC_Codigo_Principal = @par_Oficina_Principal ,          
 Porcentaje_Seguro_Paqueteria = @par_Porcentaje_Seguro_Paq,        
 Prefijo_Factura = @par_Prefijo_Factura,        
 Clave_Tecnica_Factura = @par_Clave_Tecnica_Factura,        
 Clave_Externa_Factura = @par_Clave_Externa_Factura,      
 OFIC_Codigo_Factura = ISNULL(@par_OFIC_Codigo_Factura, OFIC_Codigo_Factura)  ,    
 PLUC_Codigo_ICA = ISNULL(@par_Cuenta_PUC_ICA,0),  
 Porcentaje_Comision_Empresa = @par_Porcentaje_Comision_Empresa,
 Porcentaje_Manejo_Mensajeria = @par_Porcentaje_Manejo_Mensajeria,   
 Porcentaje_Empresa_Mensajeria = @par_Porcentaje_Empresa_Mensajeria,  
 Porcentaje_Comision_Mensajeria = @par_Porcentaje_Comision_Mensajeria, 
 TERC_Codigo_Comision_Mensajeria = @par_TERC_Codigo_Comision_Mensajeria, 
 OFIC_Codigo_Principal_Mensajeria = @par_OFIC_Codigo_Principal_Mensajeria, 
 TERC_Codigo_Agencista_Mensajeria = @par_TERC_Codigo_Agencista_Mensajeria, 
 Porcentaje_Comision_Agencista_Mensajeria = @par_Porcentaje_Comision_Agencista_Mensajeria
 WHERE                             
 EMPR_Codigo = @par_EMPR_Codigo                            
 AND Codigo = @par_Codigo                            
                            
 SELECT @par_Codigo AS Codigo                            
END      
GO
DROP PROCEDURE gsp_obtener_oficinas      
GO
CREATE PROCEDURE gsp_obtener_oficinas      
(                        
 @par_EMPR_Codigo SMALLINT,                        
 @par_Codigo NUMERIC                      
)                        
AS                         
BEGIN                         
 SELECT                         
 1 AS Obtener,                        
 OFIC.EMPR_Codigo,                        
 OFIC.Codigo,                        
 OFIC.Codigo_Alterno,                        
 OFIC.Nombre,                        
 OFIC.CIUD_Codigo,                        
 OFIC.Direccion,                        
 OFIC.Telefono,                        
 OFIC.Email,                        
 OFIC.Resolucion_Facturacion,              
 OFIC.Aplica_Enturnamiento,              
 OFIC.Estado,                       
 OFIC.CATA_TIOF_Codigo,                     
 OFIC.REPA_Codigo,            
 OFIC.Porcentaje_Seguro_Paqueteria,               
 CIUD.Nombre AS Ciudad,                  
 ISNULL(ZONA.Codigo,0) AS Codigo_Zona,                      
 ISNULL(ZONA.Nombre,'') AS Nombre_Zona ,            
 LTRIM(CONCAT(ISNULL(TERC.Razon_Social,''),' ',ISNULL(TERC.Nombre,''),' ',ISNULL(TERC.Apellido1,''),ISNULL(TERC.Apellido2,'')))  AS TerceroComision,            
 LTRIM(CONCAT(ISNULL(TEAG.Razon_Social,''),' ',ISNULL(TEAG.Nombre,''),' ',ISNULL(TEAG.Apellido1,''),ISNULL(TEAG.Apellido2,'')))  AS TerceroAgencista,            
 OFPR.Nombre AS NombreOficinaPrincipal,            
 OFIC.TERC_Codigo_Comision,            
 OFIC.TERC_Codigo_Agencista,            
 OFIC.OFIC_Codigo_Principal,            
 OFIC.Porcentaje_Comision,            
 OFIC.Porcentaje_Comision_Agencista,        
 OFIC.Prefijo_Factura,        
 OFIC.Clave_Tecnica_Factura,        
 OFIC.Clave_Externa_Factura,      
 ISNULL(OFIC.OFIC_Codigo_Factura, 0) AS OFIC_Codigo_Factura ,    
 OFIC.PLUC_Codigo_ICA As Cuenta_PUC_ICA  ,  
 OFIC.Porcentaje_Comision_Empresa ,
 OFIC.Porcentaje_Manejo_Mensajeria ,
 OFIC.Porcentaje_Empresa_Mensajeria,
 OFIC.Porcentaje_Comision_Mensajeria,
 OFIC.TERC_Codigo_Comision_Mensajeria,
 OFIC.OFIC_Codigo_Principal_Mensajeria,
 OFIC.TERC_Codigo_Agencista_Mensajeria,
 OFIC.Porcentaje_Comision_Agencista_Mensajeria
 FROM                        
 Oficinas OFIC                  
 LEFT JOIN                      
 Zona_Ciudades ZONA    ON                     
 OFIC.EMPR_Codigo = ZONA.EMPR_Codigo                      
 AND OFIC.ZOCI_Codigo = ZONA.Codigo            
              
 LEFT JOIN Terceros TERC ON            
 OFIC.EMPR_Codigo = TERC.EMPR_Codigo AND            
 OFIC.TERC_Codigo_Comision = TERC.Codigo            
            
 LEFT JOIN Terceros TEAG ON            
 OFIC.EMPR_Codigo = TEAG.EMPR_Codigo AND            
 OFIC.TERC_Codigo_Agencista = TEAG.Codigo            
            
            
 LEFT JOIN Oficinas OFPR ON            
 OFIC.EMPR_Codigo = OFPR.EMPR_Codigo AND            
 OFIC.OFIC_Codigo_Principal = OFPR.Codigo ,                     
                   
 Ciudades CIUD            
            
              
 WHERE                        
 OFIC.EMPR_Codigo = CIUD.EMPR_Codigo                        
 AND OFIC.CIUD_Codigo = CIUD.Codigo                        
 AND OFIC.Codigo <> 0                        
 AND OFIC.EMPR_Codigo = @par_EMPR_Codigo                        
 AND OFIC.Codigo = @par_Codigo                        
END      
GO
DROP PROCEDURE gsp_insertar_oficinas      
GO
CREATE PROCEDURE gsp_insertar_oficinas      
(                              
 @par_EMPR_Codigo SMALLINT,                              
 @par_Codigo_Alterno VARCHAR(20),                              
 @par_Nombre VARCHAR(50),                              
 @par_CIUD_Codigo NUMERIC,                              
 @par_Direccion VARCHAR(150),                              
 @par_Telefono VARCHAR(20),                              
 @par_Email VARCHAR(150),                             
 @par_CATA_TIOF_Codigo NUMERIC = NULL,                        
 @par_REPA_Codigo  NUMERIC = NULL,                             
 @par_Resolucion_Facturacion VARCHAR(500) = NULL,                    
 @par_Aplica_Enturnamiento NUMERIC,                         
 @par_Estado SMALLINT,                              
 @par_USUA_Codigo_Crea SMALLINT,                          
 @par_ZOCI_Codigo NUMERIC       ,              
 @par_Porcentaje_Comision numeric(18,2) = null,              
 @par_Tercero_Comision numeric = null,              
 @par_Tercero_Agencista_Comision numeric = null,              
 @par_Oficina_Principal numeric = null,              
 @par_Porcentaje_Agencista_Comision numeric(18,2) = null,          
 @par_Porcentaje_Seguro_Paq numeric(18,2) = null,        
 @par_Prefijo_Factura VARCHAR(20) = null,        
 @par_Clave_Tecnica_Factura VARCHAR(250) = null,        
 @par_Clave_Externa_Factura VARCHAR(250) = null,      
 @par_OFIC_Codigo_Factura NUMERIC = NULL  ,    
 @par_Porcentaje_Comision_Empresa NUMERIC(18,2) = NULL  ,    
 @par_Cuenta_PUC_ICA NUMERIC(18,0) = null,    

 @par_Porcentaje_Manejo_Mensajeria NUMERIC(18,2) = null ,   
 @par_Porcentaje_Empresa_Mensajeria NUMERIC(18,2) = null  ,  
 @par_Porcentaje_Comision_Mensajeria NUMERIC(18,2) = null   , 
 @par_TERC_Codigo_Comision_Mensajeria NUMERIC(18,0) = null   , 
 @par_OFIC_Codigo_Principal_Mensajeria NUMERIC(18,0) = null   , 
 @par_TERC_Codigo_Agencista_Mensajeria NUMERIC(18,0) = null   , 
 @par_Porcentaje_Comision_Agencista_Mensajeria NUMERIC(18,2) = null 

 )                              
AS                               
BEGIN                               
                              
 DECLARE @Codigo NUMERIC                               
 SELECT @Codigo = ISNULL(MAX(Codigo),0)+1 from Oficinas WHERE EMPR_Codigo = @par_EMPR_Codigo                               
                              
 INSERT INTO Oficinas                              
 (                              
 EMPR_Codigo,                              
 Codigo,                              
 Codigo_Alterno,                              
 Nombre,                              
 CIUD_Codigo,                              
 Direccion,                              
 Telefono,                              
 Email,                              
 Resolucion_Facturacion,                              
 CATA_TIOF_Codigo,                          
 REPA_Codigo,                       
 Aplica_Enturnamiento,                  
 Estado,                    
 USUA_Codigo_Crea,                              
 Fecha_Crea,                          
 ZOCI_Codigo,              
 Porcentaje_Comision,              
 TERC_Codigo_Comision,              
 TERC_Codigo_Agencista,              
 OFIC_Codigo_Principal,              
 Porcentaje_Comision_Agencista,          
 Porcentaje_Seguro_Paqueteria,        
 Prefijo_Factura,        
 Clave_Tecnica_Factura,        
 Clave_Externa_Factura,      
 OFIC_Codigo_Factura  ,    
 PLUC_Codigo_ICA ,  
 Porcentaje_Comision_Empresa,
 Porcentaje_Manejo_Mensajeria ,   
 Porcentaje_Empresa_Mensajeria  ,  
 Porcentaje_Comision_Mensajeria , 
 TERC_Codigo_Comision_Mensajeria, 
 OFIC_Codigo_Principal_Mensajeria , 
 TERC_Codigo_Agencista_Mensajeria , 
 Porcentaje_Comision_Agencista_Mensajeria 
 )                              
 VALUES                              
 (                              
 @par_EMPR_Codigo,                              
 @Codigo,                              
 @par_Codigo_Alterno,                              
 @par_Nombre,                              
 @par_CIUD_Codigo,                              
 @par_Direccion,                              
 @par_Telefono,                              
 @par_Email,                              
 ISNULL(@par_Resolucion_Facturacion,''),                        
 @par_CATA_TIOF_Codigo,                       
 ISNULL(@par_REPA_Codigo, 0),                  
 @par_Aplica_Enturnamiento,                  
 @par_Estado,                  
 @par_USUA_Codigo_Crea,                              
 GETDATE(),                          
 @par_ZOCI_Codigo,              
 @par_Porcentaje_Comision,              
 @par_Tercero_Comision,              
 @par_Tercero_Agencista_Comision,              
 @par_Oficina_Principal,              
 @par_Porcentaje_Agencista_Comision,          
 @par_Porcentaje_Seguro_Paq,        
 @par_Prefijo_Factura,        
 @par_Clave_Tecnica_Factura,        
 @par_Clave_Externa_Factura,      
 ISNULL(@par_OFIC_Codigo_Factura, @Codigo)  ,    
 ISNULL(@par_Cuenta_PUC_ICA,0)  ,  
 @par_Porcentaje_Comision_Empresa ,
 @par_Porcentaje_Manejo_Mensajeria ,   
 @par_Porcentaje_Empresa_Mensajeria  ,  
 @par_Porcentaje_Comision_Mensajeria , 
 @par_TERC_Codigo_Comision_Mensajeria, 
 @par_OFIC_Codigo_Principal_Mensajeria , 
 @par_TERC_Codigo_Agencista_Mensajeria , 
 @par_Porcentaje_Comision_Agencista_Mensajeria 
 )                              
 SELECT Codigo = @Codigo                            
END      
GO
DROP PROCEDURE gsp_anular_contenedor_postal_mensajeria    
GO
CREATE PROCEDURE gsp_anular_contenedor_postal_mensajeria    
(                
 @par_EMPR_Codigo smallint,                
 @par_ECPM_Numero NUMERIC,                
 @par_USUA_Codigo_Anula smallint,                
 @par_Causa_Anula VARCHAR(150)                
)                
AS                
BEGIN  
IF (
select COUNT(*) from Detalle_Despacho_Contenedor_Postal as DDCP INNER JOIN Encabezado_Despacho_Contenedor_Postal AS EDCP
ON DDCP.EMPR_Codigo = EDCP.EMPR_Codigo
AND DDCP.EDCP_Numero = EDCP.Numero
where DDCP.EMPR_Codigo = @par_EMPR_Codigo AND DDCP.ECPM_Numero = @par_ECPM_Numero AND EDCP.Anulado = 0
) > 0
BEGIN
SELECT 0 AS Numero
END
ELSE		
BEGIN
 UPDATE Encabezado_Contenedor_Postal_Mensajeria SET Anulado = 1, USUA_Codigo_Anula = @par_USUA_Codigo_Anula, Causa_Anula = @par_Causa_Anula, Fecha_Anula = GETDATE()  
 WHERE EMPR_Codigo = @par_EMPR_Codigo AND Numero = @par_ECPM_Numero  
  
 UPDATE Remesas_Paqueteria  SET ECPM_Numero = 0      
 WHERE EMPR_Codigo = @par_EMPR_Codigo      
 AND ECPM_Numero = @par_ECPM_Numero  
  
 SELECT @par_ECPM_Numero AS Numero  
END
END  
GO
update menu_aplicaciones set padre_menu = 4801, moap_codigo = 48 where codigo = 470501

DROP PROCEDURE gsp_consultar_manifiestos  
GO
CREATE PROCEDURE gsp_consultar_manifiestos  
(                                          
 @par_EMPR_Codigo SMALLINT,     
 @par_TIDO_Codigo_Planilla NUMERIC,                                         
 @par_Numero NUMERIC = NULL,    
 @par_Fecha_Inicial DATE = NULL,                                          
 @par_Fecha_Final DATE = NULL,                         
 @par_Placa VARCHAR(20) = NULL,                            
 @par_Codigo_Conductor NUMERIC = NULL,                            
 @par_Conductor VARCHAR(50)  = NULL,                                           
 @par_Estado INT = NULL,                                          
 @par_Anulado SMALLINT = NULL ,                                                  
 @par_OFIC_Codigo INT = NULL,                                          
 @par_CATA_TIMA_Codigo NUMERIC = NULL,                            
 @par_NumeroPagina INT = NULL,                                          
 @par_RegistrosPagina INT = NULL,                      
 @par_Usuario_Consulta INT = 0                                        
)                                          
AS                                          
BEGIN                        
 SET @par_OFIC_Codigo = CASE @par_OFIC_Codigo WHEN -1 THEN NULL ELSE @par_OFIC_Codigo END        
 SET NOCOUNT ON;                                           
 DECLARE @CantidadRegistros INT                                          
 SELECT @CantidadRegistros =                                          
 (                                          
  SELECT DISTINCT                                          
  COUNT(1)                                          
  FROM        
        
  Encabezado_Manifiesto_Carga ENMC                                          
  LEFT JOIN Empresas EMPR ON                                     
  ENMC.EMPR_Codigo = EMPR.Codigo              
             
  LEFT JOIN Encabezado_Cumplido_Planilla_Despachos AS ECPD          
  ON ENMC.EMPR_Codigo = ECPD.EMPR_Codigo          
  AND ENMC.Numero = ECPD.ENMC_Numero  
  AND ECPD.Estado = 1  
  AND ECPD.Anulado = 0  
                                    
  LEFT JOIN Vehiculos VEHI                                             
  ON ENMC.EMPR_Codigo = VEHI.EMPR_Codigo                                         
  AND ENMC.VEHI_Codigo = VEHI.Codigo                                          
                                          
  LEFT JOIN Terceros PROP ON                                          
  ENMC.EMPR_Codigo = PROP.EMPR_Codigo AND ENMC.TERC_Codigo_Propietario = PROP.Codigo                                          
                                          
  LEFT JOIN Terceros TENE ON                                          
  ENMC.EMPR_Codigo = TENE.EMPR_Codigo AND ENMC.TERC_Codigo_Tenedor = TENE.Codigo                                          
                                          
  LEFT JOIN Terceros COND ON                                          
  ENMC.EMPR_Codigo = COND.EMPR_Codigo AND ENMC.TERC_Codigo_Conductor = COND.Codigo                                          
                                          
  LEFT JOIN Terceros SECO ON                                          
  ENMC.EMPR_Codigo = SECO.EMPR_Codigo                                          
  AND ENMC.TERC_Codigo_Segundo_Conductor = SECO.Codigo                                          
                                          
  LEFT JOIN Terceros AFIL ON                                          
  ENMC.EMPR_Codigo = AFIL.EMPR_Codigo                                          
  AND ENMC.TERC_Codigo_Afiliador = AFIL.Codigo                                          
                                          
  LEFT JOIN Semirremolques SEMI ON                                          
  ENMC.EMPR_Codigo = SEMI.EMPR_Codigo                                          
  AND ENMC.SEMI_Codigo = SEMI.Codigo                                          
                                          
  LEFT JOIN V_Tipo_vehiculos TIVE ON                                          
  ENMC.EMPR_Codigo = TIVE.EMPR_Codigo                                          
  AND ENMC.TIVE_Codigo = TIVE.Codigo                                          
                                          LEFT JOIN Rutas RUTA ON                                          
  ENMC.EMPR_Codigo = RUTA.EMPR_Codigo                 
  AND ENMC.RUTA_Codigo = RUTA.Codigo                                          
                     
  LEFT JOIN Ciudades CIOR ON                                      
  RUTA.EMPR_Codigo = CIOR.EMPR_Codigo                                          
  AND RUTA.CIUD_Codigo_Origen = CIOR.Codigo                                          
                                    
  LEFT JOIN Ciudades CIDE ON                                          
  RUTA.EMPR_Codigo = CIDE.EMPR_Codigo                                          
  AND RUTA.CIUD_Codigo_Destino = CIDE.Codigo                                          
     
  LEFT JOIN Terceros ASEG ON                                          
  ENMC.EMPR_Codigo = ASEG.EMPR_Codigo                                          
  AND ENMC.TERC_Codigo_Aseguradora = ASEG.Codigo                                          
                                          
  LEFT JOIN Tipo_Documentos TIDO ON                                          
  ENMC.EMPR_Codigo = TIDO.EMPR_Codigo                                          
  AND ENMC.TIDO_Codigo = TIDO.Codigo                                          
                                          
  LEFT JOIN Oficinas OFIC ON                                          
  ENMC.EMPR_Codigo = OFIC.EMPR_Codigo                                          
  AND ENMC.OFIC_Codigo = OFIC.Codigo                                          
                                          
  LEFT JOIN V_Tipo_Manifiesto TIMA ON                                          
  ENMC.EMPR_Codigo = TIMA.EMPR_Codigo                                          
  AND ENMC.CATA_TIMA_Codigo = TIMA.Codigo                                          
                                          
  LEFT JOIN Detalle_Integraciones_Planilla_Despachos DIPD                                          
  ON ENMC.EMPR_Codigo = DIPD.EMPR_Codigo AND ENMC.ENPD_Numero = DIPD.ENPD_Numero                                          
                                             
  LEFT JOIN V_Motivo_Anulacion_Manifiesto MAMA ON                                          
  ENMC.EMPR_Codigo = MAMA.EMPR_Codigo                                          
  AND ENMC.CATA_MAMC_Codigo = MAMA.Codigo                                       
                                     
  LEFT JOIN Encabezado_Planilla_Despachos ENPD ON        
  ENMC.EMPR_Codigo = ENPD.EMPR_Codigo        
  AND ENMC.ENPD_Numero = ENPD.Numero         
                                          
  WHERE                                          
  ENMC.EMPR_Codigo = @par_EMPR_Codigo    
  AND ENPD.TIDO_Codigo = @par_TIDO_Codigo_Planilla                                         
  AND ENMC.Numero_Documento = ISNULL(@par_Numero,ENMC.Numero_Documento)                                          
  AND (CONVERT (DATE, ENMC.Fecha) >= @par_Fecha_Inicial OR @par_Fecha_Inicial IS NULL)        
  AND (CONVERT (DATE, ENMC.Fecha) <= @par_Fecha_Final OR @par_Fecha_Final IS NULL)        
  AND (ENMC.OFIC_Codigo = @par_OFIC_Codigo OR @par_OFIC_Codigo IS NULL)                        
  AND ENMC.TERC_Codigo_Conductor = ISNULL(@par_Codigo_Conductor,ENMC.TERC_Codigo_Conductor)                            
  AND ((COND.Nombre + ' ' + COND.Apellido1 + ' ' + COND.Apellido2 LIKE '%' + RTRIM(LTRIM(@par_Conductor)) + '%' OR COND.Razon_Social LIKE '%' + RTRIM(LTRIM(@par_Conductor)) + '%') OR (@par_Conductor IS NULL))                            
  AND ENMC.Estado = ISNULL(@par_Estado, ENMC.Estado)           
  AND VEHI.Placa = ISNULL(@par_Placa, VEHI.Placa)                      
  AND ENMC.Anulado = ISNULL (@par_Anulado,ENMC.Anulado )              
  --AND (ENMC.CATA_TIMA_Codigo = @par_CATA_TIMA_Codigo OR @par_CATA_TIMA_Codigo IS NULL)              
  AND (ENMC.OFIC_Codigo IN (                      
  SELECT USOF.OFIC_Codigo FROM Usuario_Oficinas USOF WHERE USOF.USUA_Codigo = @par_Usuario_Consulta                      
  ) OR @par_Usuario_Consulta IS NULL OR @par_Usuario_Consulta = 0)                                      
 );                     
 WITH Pagina                                          
 AS              
 (        
  SELECT DISTINCT        
  EMPR.Nombre_Razon_Social Empresa,                                    
  ENMC.EMPR_Codigo,                                          
  ENMC.Numero,                                          
  ENMC.Numero_Documento,                                          
  ENMC.Fecha,                  
  ENMC.VEHI_Codigo,                                          
  VEHI.Placa AS PlacaVehiculo,                                          
  ENMC.TERC_Codigo_Propietario,                                          
  PROP.Numero_Identificacion AS IdentificacionPropietario,                                          
  CONCAT(PROP.Nombre,' ',PROP.Apellido1,' ',PROP.Apellido2) AS NombrePropietario,                                          
  ENMC.TERC_Codigo_Tenedor,                                          
  TENE.Numero_Identificacion AS IdentificacionTenedor,                                          
  CONCAT(TENE.Nombre,' ',TENE.Apellido1,' ',TENE.Apellido2) AS NombreTenedor,                                          
  ENMC.TERC_Codigo_Conductor,                                  
  COND.Numero_Identificacion AS IdentificacionConductor,                                          
  CONCAT(COND.Nombre,' ',COND.Apellido1,' ',COND.Apellido2) AS NombreConductor,                                          
  COND.Telefonos AS TelefonoConductor,                                          
  ISNULL(ENMC.TERC_Codigo_Segundo_Conductor,0) AS TERC_Codigo_Segundo_Conductor,                                          
  SECO.Numero_Identificacion AS IdentificacionSegundoConductor,                                          
  CONCAT(SECO.Nombre,' ',SECO.Apellido1,' ',SECO.Apellido2) AS NombreSegundoConductor,                                          
  ENMC.TERC_Codigo_Afiliador,                                          
  AFIL.Numero_Identificacion AS IdentificacionAfiliador,                                          
  CONCAT(AFIL.Nombre,' ',AFIL.Apellido1,' ',AFIL.Apellido2) AS NombreAfiliador,                                          
  ENMC.SEMI_Codigo,                                          
  ISNULL(SEMI.Placa, '') AS PlacaSemirremolque,                                          
  ENMC.TIVE_Codigo,                                          
  TIVE.Nombre AS TipoVehiculo,                                          
  ENMC.RUTA_Codigo,                                          
  RUTA.Nombre AS NombreRuta,                                          
  ENMC.Observaciones,                                          
  ENMC.Fecha_Cumplimiento,                                          
  ENMC.Cantidad_Total,                           
  ENMC.Peso_Total,                                          
  ENMC.Valor_Flete,                                          
  ENMC.Valor_Retencion_Fuente,                                          
  ENMC.Valor_ICA,                                          
  ENMC.Valor_Otros_Descuentos,                                          
  ENMC.Valor_Flete_Neto,                                          
  ENMC.Valor_Anticipo,                                          
  ENMC.Valor_Pagar,                                
  ENMC.TERC_Codigo_Aseguradora,                                          
  ASEG.Numero_Identificacion AS IdentificacionAseguradora,                                          
  CONCAT(ASEG.Nombre,' ',ASEG.Apellido1,' ',ASEG.Apellido2) AS NombreAseguradora,                                          
  ENMC.Numero_Poliza,                                          
  ENMC.Fecha_Vigencia_Poliza,                                  
  ENMC.ELPD_Numero,                         
  ISNULL(ECPD.Numero_Documento, 0) AS ECPD_Numero,                                          
  ENMC.Finalizo_Viaje,                                          
  ENMC.Anulado,                                          
  ENMC.Siniestro,                                          
  ENMC.Estado,                                          
  CASE ENMC.Estado WHEN 1 THEN 'Definitivo' ELSE 'Borrador' END AS NombreEstado,                                   
  ISNULL(ENMC.Numeracion,'') AS Numeracion,                                          
  ENMC.TIDO_Codigo,                                          
  TIDO.Nombre AS TipoDocumento,                                          
  ENMC.USUA_Codigo_Crea,                                          
  ENMC.Fecha_Crea,                                          
  ISNULL(ENMC.USUA_Codigo_Modifica,0) AS USUA_Codigo_Modifica,                                          
  ISNULL(ENMC.Fecha_Modifica,'') AS Fecha_Modifica,                                          
  ISNULL(ENMC.Fecha_Anula,'') AS Fecha_Anula,                                          
  ISNULL(ENMC.USUA_Codigo_Anula,0) AS USUA_Codigo_Anula,                                          
  ISNULL(ENMC.Causa_Anula,'') AS Causa_Anula,                                          
  ENMC.OFIC_Codigo,                                          
  OFIC.Nombre AS Oficina,                    
  ENMC.CATA_TIMA_Codigo,                                          
  ISNULL(TIMA.Nombre,'') AS TipoManifiesto,                                          
  ISNULL(ENMC.Numero_Manifiesto_Electronico,0) AS Numero_Manifiesto_Electronico,                                          
  ISNULL(ENMC.Fecha_Reporte_Manifiesto_Electronico,'') AS Fecha_Reporte_Manifiesto_Electronico,                                          
  ISNULL(ENMC.Mensaje_Manifiesto_Electronico,'') AS Mensaje_Manifiesto_Electronico,                                          
  ISNULL(ENMC.CATA_MAMC_Codigo,0) AS CATA_MAMC_Codigo,                                          
  ISNULL(MAMA.Nombre,'') AS MotivoAnulacion,                                          
  ROW_NUMBER() OVER (ORDER BY ENMC.Numero DESC) AS RowNumber                                          
  ,CIOR.Nombre CiudadOrigen                        
  ,CIOR.DEPA_Codigo As CIOR_DEPA_Codigo                                    
  ,CIDE.DEPA_Codigo As CIDE_DEPA_Codigo                        
  ,CIDE.Nombre CiudadDestino    
  ,ISNULL(ENPD.Numero_Documento, 0) as NumeroDocumentoPlanilla                              
  ,ISNULL(ENPD.Numero, 0) as NumeroPlanilla                              
  FROM                                          
  Encabezado_Manifiesto_Carga ENMC                                          
  LEFT JOIN Empresas EMPR ON                                     
  ENMC.EMPR_Codigo = EMPR.Codigo              
             
                
  LEFT JOIN Encabezado_Cumplido_Planilla_Despachos AS ECPD          
  ON ENMC.EMPR_Codigo = ECPD.EMPR_Codigo          
  AND ENMC.Numero = ECPD.ENMC_Numero  
  AND ECPD.Estado = 1  
  AND ECPD.Anulado = 0         
                                    
                                    
  LEFT JOIN Vehiculos VEHI                                             
  ON ENMC.EMPR_Codigo = VEHI.EMPR_Codigo                                         
  AND ENMC.VEHI_Codigo = VEHI.Codigo                                          
                                          
  LEFT JOIN Terceros PROP ON                                          
  ENMC.EMPR_Codigo = PROP.EMPR_Codigo AND ENMC.TERC_Codigo_Propietario = PROP.Codigo                                          
                                          
  LEFT JOIN Terceros TENE ON                                          
  ENMC.EMPR_Codigo = TENE.EMPR_Codigo AND ENMC.TERC_Codigo_Tenedor = TENE.Codigo                                          
                                          
  LEFT JOIN Terceros COND ON                           
  ENMC.EMPR_Codigo = COND.EMPR_Codigo AND ENMC.TERC_Codigo_Conductor = COND.Codigo                                          
                               
  LEFT JOIN Terceros SECO ON                                          
  ENMC.EMPR_Codigo = SECO.EMPR_Codigo                                          
  AND ENMC.TERC_Codigo_Segundo_Conductor = SECO.Codigo                                          
                                          
  LEFT JOIN Terceros AFIL ON                                          
  ENMC.EMPR_Codigo = AFIL.EMPR_Codigo                                          
  AND ENMC.TERC_Codigo_Afiliador = AFIL.Codigo                                   
                                          
  LEFT JOIN Semirremolques SEMI ON                            
  ENMC.EMPR_Codigo = SEMI.EMPR_Codigo                                          
  AND ENMC.SEMI_Codigo = SEMI.Codigo                                          
                                          
  LEFT JOIN V_Tipo_vehiculos TIVE ON                                          
  ENMC.EMPR_Codigo = TIVE.EMPR_Codigo                                          
  AND ENMC.TIVE_Codigo = TIVE.Codigo                                          
                                          
  LEFT JOIN Rutas RUTA ON                                          
  ENMC.EMPR_Codigo = RUTA.EMPR_Codigo                                          
  AND ENMC.RUTA_Codigo = RUTA.Codigo                                          
                                    
  LEFT JOIN Ciudades CIOR ON                                          
  RUTA.EMPR_Codigo = CIOR.EMPR_Codigo                                          
  AND RUTA.CIUD_Codigo_Origen = CIOR.Codigo                                   
                                    
  LEFT JOIN Ciudades CIDE ON                                          
  RUTA.EMPR_Codigo = CIDE.EMPR_Codigo                                          
  AND RUTA.CIUD_Codigo_Destino = CIDE.Codigo                                                                  
                                    
  LEFT JOIN Terceros ASEG ON                                          
  ENMC.EMPR_Codigo = ASEG.EMPR_Codigo                                          
  AND ENMC.TERC_Codigo_Aseguradora = ASEG.Codigo                                          
                                     
  LEFT JOIN Tipo_Documentos TIDO ON                                          
  ENMC.EMPR_Codigo = TIDO.EMPR_Codigo                                          
  AND ENMC.TIDO_Codigo = TIDO.Codigo                                          
                                          
  LEFT JOIN Oficinas OFIC ON                                          
  ENMC.EMPR_Codigo = OFIC.EMPR_Codigo                                          
  AND ENMC.OFIC_Codigo = OFIC.Codigo                                          
                                          
  LEFT JOIN V_Tipo_Manifiesto TIMA ON                                          
  ENMC.EMPR_Codigo = TIMA.EMPR_Codigo                                          
  AND ENMC.CATA_TIMA_Codigo = TIMA.Codigo                                          
                                          
  LEFT JOIN Detalle_Integraciones_Planilla_Despachos DIPD                                          
  ON ENMC.EMPR_Codigo = DIPD.EMPR_Codigo AND ENMC.ENPD_Numero = DIPD.ENPD_Numero                                          
                                             
  LEFT JOIN V_Motivo_Anulacion_Manifiesto MAMA ON                                          
  ENMC.EMPR_Codigo = MAMA.EMPR_Codigo                                          
  AND ENMC.CATA_MAMC_Codigo = MAMA.Codigo                                      
                      
  LEFT JOIN Encabezado_Planilla_Despachos ENPD ON        
  ENMC.EMPR_Codigo = ENPD.EMPR_Codigo        
  AND ENMC.ENPD_Numero = ENPD.Numero                                        
                                         
  WHERE                                          
  ENMC.EMPR_Codigo = @par_EMPR_Codigo    
  AND ENPD.TIDO_Codigo = @par_TIDO_Codigo_Planilla    
  AND ENMC.Numero_Documento = ISNULL(@par_Numero,ENMC.Numero_Documento)                                          
  AND (CONVERT (DATE, ENMC.Fecha) >= @par_Fecha_Inicial OR @par_Fecha_Inicial IS NULL)        
  AND (CONVERT (DATE, ENMC.Fecha) <= @par_Fecha_Final OR @par_Fecha_Final IS NULL)         
  AND (ENMC.OFIC_Codigo = @par_OFIC_Codigo OR @par_OFIC_Codigo IS NULL)                        
  AND ENMC.TERC_Codigo_Conductor = ISNULL(@par_Codigo_Conductor,ENMC.TERC_Codigo_Conductor)                            
  AND ((COND.Nombre + ' ' + COND.Apellido1 + ' ' + COND.Apellido2 LIKE '%' + RTRIM(LTRIM(@par_Conductor)) + '%' OR COND.Razon_Social LIKE '%' + RTRIM(LTRIM(@par_Conductor)) + '%') OR (@par_Conductor IS NULL))                                         
  AND ENMC.Estado = ISNULL(@par_Estado, ENMC.Estado)                                          
  AND ENMC.Anulado = ISNULL (@par_Anulado,ENMC.Anulado )                                                  
  AND VEHI.Placa = ISNULL(@par_Placa, VEHI.Placa)                       
  --AND (ENMC.CATA_TIMA_Codigo = @par_CATA_TIMA_Codigo OR @par_CATA_TIMA_Codigo IS NULL)              
  AND (ENMC.OFIC_Codigo IN (                      
   SELECT USOF.OFIC_Codigo FROM Usuario_Oficinas USOF WHERE USOF.USUA_Codigo = @par_Usuario_Consulta                      
  ) OR @par_Usuario_Consulta IS NULL OR @par_Usuario_Consulta = 0)    
 )                                          
 SELECT DISTINCT                                          
 0 AS Obtener,                                          
 Empresa ,                                   
 EMPR_Codigo,                                          
 Numero,                                          
 Numero_Documento,                                          
 Fecha,                                          
 VEHI_Codigo,                                          
 PlacaVehiculo,                                          
 TERC_Codigo_Propietario,                                          
 IdentificacionPropietario,                                          
 NombrePropietario,                                          
 TERC_Codigo_Tenedor,                                          
 IdentificacionTenedor,                                          
 NombreTenedor,                                          
 TERC_Codigo_Conductor,                                          
 IdentificacionConductor,                                          
 NombreConductor,                                          
 TelefonoConductor,                                          
 TERC_Codigo_Segundo_Conductor,                                          
 IdentificacionSegundoConductor,                                          
 NombreSegundoConductor,                                          
 TERC_Codigo_Afiliador,                                          
 IdentificacionAfiliador,                                          
 NombreAfiliador,                                          
 SEMI_Codigo,                                          
 PlacaSemirremolque,                                          
 TIVE_Codigo,                                          
 TipoVehiculo,                               
 RUTA_Codigo,                                          
 NombreRuta,                                          
 Observaciones,                                          
 Fecha_Cumplimiento,                                          
 Cantidad_Total,                                          
 Peso_Total,                                          
 Valor_Flete,                                          
 Valor_Retencion_Fuente,                                          
 Valor_ICA,                                          
 Valor_Otros_Descuentos,                                          
 Valor_Flete_Neto,                                          
 Valor_Anticipo,                                          
 Valor_Pagar,                 
 TERC_Codigo_Aseguradora,                                          
 IdentificacionAseguradora,                              
 NombreAseguradora,                       
 Numero_Poliza,                                          
 Fecha_Vigencia_Poliza,                                          
 ELPD_Numero,                                          
 ECPD_Numero,                                          
 Finalizo_Viaje,                                          
 Anulado,                                          
 Siniestro,                                          
 Estado,                                          
 NombreEstado,                                          
 Numeracion,                                          
 TIDO_Codigo,                     
 TipoDocumento,                                          
 USUA_Codigo_Crea,                                          
 Fecha_Crea,                    
 USUA_Codigo_Modifica,                                          
 Fecha_Modifica,                                          
 Fecha_Anula,                                          
 USUA_Codigo_Anula,                                          
 Causa_Anula,                                          
 OFIC_Codigo,                                          
 Oficina,                                          
 CATA_TIMA_Codigo,                                          
 TipoManifiesto,                                          
 Numero_Manifiesto_Electronico,                                          
 Fecha_Reporte_Manifiesto_Electronico,                                          
 Mensaje_Manifiesto_Electronico,                                          
 CATA_MAMC_Codigo,                                          
 MotivoAnulacion,                                          
 CiudadOrigen,                         
 CIOR_DEPA_Codigo,                        
 CIDE_DEPA_Codigo,                        
 CiudadDestino,    
 NumeroDocumentoPlanilla,                              
 NumeroPlanilla,        
 @CantidadRegistros AS TotalRegistros,                                          
 @par_NumeroPagina AS PaginaObtener,                                          
 @par_RegistrosPagina AS RegistrosPagina                                          
 FROM Pagina                                          
 WHERE RowNumber > (ISNULL(@par_NumeroPagina, 1) - 1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)                                      
 AND RowNumber <= ISNULL(@par_NumeroPagina, 1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)                                          
 ORDER BY Numero                                          
END  
GO
DROP PROCEDURE  gsp_obtener_manifiesto_rndc_masivo  
GO
CREATE PROCEDURE  gsp_obtener_manifiesto_rndc_masivo  
(            
 @par_EMPR_Codigo smallint,            
 @par_ENMC_Numero Numeric            
)            
AS                                            
BEGIN                                            
 -- Codigo RNDC Tipo Identificacion                                              
 DECLARE @TIID_RNDC_CED CHAR = 'C';--Codigo RNDC Tipo Identificacion Cedula                                              
 DECLARE @TIID_RNDC_NIT CHAR = 'N';--Codigo RNDC Tipo Identificacion NIT                                              
                                              
 SELECT DISTINCT TOP(1)                                           
 CONCAT (EMPR.Numero_Identificacion,  IIF(EMPR.Digito_Chequeo IS NULL OR  EMPR.Digito_Chequeo = 0, '', EMPR.Digito_Chequeo) ) AS NUMNITEMPRESATRANSPORTE,    
 --TENEDOR                                            
 CASE TENE.CATA_TIID_Codigo  WHEN 101 THEN @TIID_RNDC_CED   WHEN 102 THEN @TIID_RNDC_NIT   ELSE @TIID_RNDC_NIT END  As TENE_CODTIPOIDTERCERO,                                              
 CONCAT (TENE.Numero_Identificacion,  IIF(TENE.Digito_Chequeo IS NULL OR  TENE.Digito_Chequeo = 0, '', TENE.Digito_Chequeo) ) AS TENE_NUMIDTERCERO,                                              
 IIF(TENE.Razon_Social IS NULL OR TENE.Razon_Social = '', TENE.Nombre, TENE.Razon_Social ) AS TENE_NOMIDTERCERO,                                              
 ISNULL(TENE.Apellido1, '') AS TENE_PRIMERAPELLIDOIDTERCERO,                                              
 ISNULL(TENE.Apellido2, '') AS TENE_SEGUNDOAPELLIDOIDTERCERO,                                              
 CIUD_TENE.Codigo_Alterno AS TENE_CODSEDETERCERO,                                              
 CIUD_TENE.Nombre AS TENE_NOMSEDETERCERO,                                              
 ISNULL(TENE.Telefonos, '') AS TENE_NUMTELEFONOCONTACTO,                                              
 ISNULL(TENE.Celulares, '') AS TENE_NUMCELULARPERSONA,                                              
 TENE.Direccion AS TENE_NOMENCLATURADIRECCION,                       
 TENE.Reportar_RNDC AS TENE_Reportar_RNDC,                                            
 TENE.Codigo AS TENE_Codigo,    
 --PROPIETARIO                                            
 CASE PROP.CATA_TIID_Codigo  WHEN 101 THEN @TIID_RNDC_CED   WHEN 102 THEN @TIID_RNDC_NIT   ELSE @TIID_RNDC_NIT END  As PROP_CODTIPOIDTERCERO,                                              
 CONCAT (PROP.Numero_Identificacion,  IIF(PROP.Digito_Chequeo IS NULL OR  PROP.Digito_Chequeo = 0, '', PROP.Digito_Chequeo) ) AS PROP_NUMIDTERCERO,                                              
 IIF(PROP.Razon_Social IS NULL OR PROP.Razon_Social = '', PROP.Nombre, PROP.Razon_Social ) AS PROP_NOMIDTERCERO,                                              
 ISNULL(PROP.Apellido1, '') AS PROP_PRIMERAPELLIDOIDTERCERO,                                              
 ISNULL(PROP.Apellido2, '') AS PROP_SEGUNDOAPELLIDOIDTERCERO,                                              
 CIUD_PROP.Codigo_Alterno AS PROP_CODSEDETERCERO,                                              
 CIUD_PROP.Nombre AS PROP_NOMSEDETERCERO,                                              
 ISNULL(PROP.Telefonos, '') AS PROP_NUMTELEFONOCONTACTO,                                              
 ISNULL(PROP.Celulares, '') AS PROP_NUMCELULARPERSONA,                                              
 PROP.Direccion AS PROP_NOMENCLATURADIRECCION,                                            
 PROP.Reportar_RNDC AS PROP_Reportar_RNDC,                                            
 PROP.Codigo AS PROP_Codigo,                                            
                                            
 --CONDUCTOR                                            
 CASE COND.CATA_TIID_Codigo  WHEN 101 THEN @TIID_RNDC_CED   WHEN 102 THEN @TIID_RNDC_NIT   ELSE @TIID_RNDC_NIT END  As COND_CODTIPOIDTERCERO,                      
 COND.Numero_Identificacion AS COND_NUMIDTERCERO,         
 IIF(COND.Razon_Social IS NULL OR COND.Razon_Social = '', COND.Nombre, COND.Razon_Social ) AS COND_NOMIDTERCERO,                                          
 ISNULL(COND.Apellido1, '') AS COND_PRIMERAPELLIDOIDTERCERO,    
 ISNULL(COND.Apellido2, '') AS COND_SEGUNDOAPELLIDOIDTERCERO,                                              
 CIUD_COND.Codigo_Alterno AS COND_CODSEDETERCERO,                                              
 CIUD_COND.Nombre AS COND_NOMSEDETERCERO,                                              
 ISNULL(COND.Telefonos, '') AS COND_NUMTELEFONOCONTACTO,                                              
 ISNULL(COND.Celulares, '') AS COND_NUMCELULARPERSONA,                                              
 COND.Direccion AS COND_NOMENCLATURADIRECCION,                                            
 TCOND.Numero_Licencia AS   COND_NUMLICENCIACONDUCCION,                                            
 CALC.Campo2 AS COND_CODCATEGORIALICENCIACONDUCCION,                        
 TCOND.Fecha_Vencimiento_Licencia AS FECHAVENCIMIENTOLICENCIA,                       
 COND.Reportar_RNDC AS COND_Reportar_RNDC,                                            
 COND.Codigo AS COND_Codigo,            
 ISNULL(TECO2.Numero_Identificacion,'0') AS COND_NUMIDTERCERO2,         
 IIF(TECO2.Numero_Identificacion IS NULL, '0',                 
 CASE TECO2.CATA_TIID_Codigo WHEN 101 THEN @TIID_RNDC_CED   WHEN 102 THEN @TIID_RNDC_NIT   ELSE @TIID_RNDC_NIT END ) As COND_CODTIPOIDTERCERO2,    
 --VEHICULIO                                            
 VEHI.Placa AS NUMPLACA,                                 
 SEMI.Placa AS NUMPLACAREMOLQUE,                                
 1 AS UNIDADMEDIDACAPACIDAD,                                            
 TIVE.Campo4 AS CODCONFIGURACIONUNIDADCARGA,                                            
 MAVE.Codigo_Alterno as CODMARCAVEHICULOCARGA,                                            
 LIVE.Codigo_Alterno AS CODLINEAVEHICULOCARGA,                               
 VEHI.Modelo AS ANOFABRICACIONVEHICULOCARGA,                                            
 convert(int, VEHI.Peso_Tara) AS PESOVEHICULOVACIO,                                            
 convert(int, SEMI.Peso_Vacio) AS PESOSEMIRREMOLQUEVACIO,                                            
 COVE.Codigo_Alterno AS CODCOLORVEHICULOCARGA,                                            
 0 AS CODTIPOCARROCERIA,                                            
 VEHI.Numero_Serie AS NUMCHASIS,                                            
 convert(int, VEHI.Capacidad_Kilos) AS CAPACIDADUNIDADCARGA,                                    
 VEHI.Referencia_SOAT as NUMSEGUROSOAT,                                      
 VEHI.Fecha_Vencimiento_SOAT as FECHAVENCIMIENTOSOAT,                                    
 CONCAT (SOAT.Numero_Identificacion,  IIF(SOAT.Digito_Chequeo IS NULL OR  SOAT.Digito_Chequeo = 0, '', SOAT.Digito_Chequeo) ) AS NUMNITASEGURADORASOAT ,                                   
 VEHI.Reportar_RNDC AS VEHI_Reportar_RNDC,                                            
 VEHI.Codigo AS VEHI_Codigo,                    
 SEMI.Reportar_RNDC AS SEMI_Reportar_RNDC,                                            
 SEMI.Codigo AS SEMI_Codigo,    
 --MANIFIESTO                                            
 --CASE ENMA.CATA_TIMA_Codigo                                              
 -- WHEN 8807 THEN --Vacío                                              
 -- 'W'                                               
 -- ELSE                                              
 -- 'G'                                             
 --END AS CODOPERACIONTRANSPORTE ,                
 CASE WHEN TIMA.Campo2 = 'G' THEN 'G'                
 WHEN TIMA.Campo2 = 'D' THEN 'D'                
 ELSE 'G' END  AS CODOPERACIONTRANSPORTE ,                   
 ENMA.Cantidad_viajes_dia AS VIAJESDIA,            
 --TRANSBORDO            
 ISNULL(TICM.Campo2, 'C') AS TIPOCUMPLIDOMANIFIESTO,            
 ISNULL(MOSM.Campo2, '') AS MOTIVOSUSPENSIONMANIFIESTO,            
 ISNULL(COSM.Campo2, '') AS CONSECUENCIASUSPENSIONMANIFIESTO,    
 CASE WHEN VEHI.CATA_TIDV_Codigo = 2102 /*VEHICULO PROPIO*/ THEN 0 ELSE CONVERT(INTEGER,ENMA.Valor_Flete) END  AS VALORDESCUENTOFLETE,    
 IIF(ENCP.CATA_TICM_Codigo = 20802, 'V', '') AS MOTIVOVALORDESCUENTOMANIFIESTO,     
 ISNULL(CONVERT(VARCHAR(8),MATR.Numero_Documento), '') AS MANNROMANIFIESTOTRANSBORDO,    
 --TRANSBORDO            
 ENMA.Numero_Documento as NUMMANIFIESTOCARGA,                   
 ENMA.Fecha_Crea as FECHAEXPEDICIONMANIFIESTO,                                            
 CIOR.Codigo_Alterno+'000' AS CODMUNICIPIOORIGENMANIFIESTO,                                         
 CIDE.Codigo_Alterno+'000'  AS CODMUNICIPIODESTINOMANIFIESTO,        
 CASE      
 WHEN VEHI.CATA_TIDV_Codigo = 2102 /*VEHICULO PROPIO*/ THEN 0 ELSE CONVERT(INTEGER,ENMA.Valor_Flete) END  AS VALORFLETEPACTADOVIAJE,                                            
 CONVERT(money,ISNULL(DIPD.Valor_Tarifa,DECI.Valor_Tarifa)*1000) AS RETENCIONICAMANIFIESTOCARGA,                                            
 CONVERT(INTEGER, ENMA.Valor_Anticipo) AS VALORANTICIPOMANIFIESTO,                                            
 CONVERT(money,DIPD2.Valor_Tarifa*1000) AS RETENCIONFUENTEMANIFIESTO,                         
 CIDE.Codigo_Alterno+'000' AS CODMUNICIPIOPAGOSALDO,                                            
 'R' AS CODRESPONSABLEPAGOCARGUE,                                            
 'D' AS CODRESPONSABLEPAGODESCARGUE,                                            
 ENMA.Fecha_Cumplimiento AS FECHAPAGOSALDOMANIFIESTO,                                            
 ENMA.Observaciones AS OBSERVACIONES,                                      
 ENCP.Fecha as FECHAENTREGADOCUMENTOS,                                      
 0 as VALORADICIONALHORASCARGUE,                                      
 0 as VALORADICIONALHORASDESCARGUE,                  
 CASE WHEN ENMA.Aceptacion_Electronica IS NULL THEN 'NO'                  
 WHEN ENMA.Aceptacion_Electronica = 0 THEN 'NO'                  
 WHEN ENMA.Aceptacion_Electronica = 1 THEN 'SI'                  
 END AS ACEPTACIONELECTRONICA                  
                            
 FROM Encabezado_Manifiesto_Carga AS ENMA                                             
                                            
 LEFT JOIN Empresas AS EMPR                                            
 ON ENMA.EMPR_Codigo = EMPR.Codigo                                  
                                            
 LEFT JOIN Terceros AS TENE                                            
 ON ENMA.EMPR_Codigo = TENE.EMPR_Codigo                                            
 AND ENMA.TERC_Codigo_Tenedor = TENE.Codigo                                            
                                              
 LEFT JOIN Ciudades AS CIUD_TENE ON                                              
 TENE.EMPR_Codigo = CIUD_TENE.EMPR_Codigo                                              
 AND TENE.CIUD_Codigo = CIUD_TENE.Codigo            
            
 LEFT JOIN Terceros AS PROP                                            
 ON ENMA.EMPR_Codigo = PROP.EMPR_Codigo                                            
 AND ENMA.TERC_Codigo_Propietario = PROP.Codigo                                            
                                              
 LEFT JOIN Ciudades AS CIUD_PROP ON                                              
 PROP.EMPR_Codigo = CIUD_PROP.EMPR_Codigo                                              
 AND PROP.CIUD_Codigo = CIUD_PROP.Codigo                                              
                                            
 LEFT JOIN Terceros AS COND                                            
 ON ENMA.EMPR_Codigo = COND.EMPR_Codigo                                            
 AND ENMA.TERC_Codigo_Conductor = COND.Codigo                             
                                            
 LEFT JOIN Tercero_Conductores AS TCOND                                            
 ON ENMA.EMPR_Codigo = TCOND.EMPR_Codigo                                            
AND ENMA.TERC_Codigo_Conductor = TCOND.TERC_Codigo                                       
                        
 LEFT JOIN Valor_Catalogos AS CALC                                            
 ON TCOND.EMPR_Codigo = CALC.EMPR_Codigo      
 AND TCOND.CATA_CALC_Codigo = CALC.Codigo                                  
                
 LEFT JOIN Valor_Catalogos AS  TIMA ON                 
 ENMA.EMPR_Codigo = TIMA.EMPR_Codigo AND          
 ENMA.CATA_TIMA_Codigo = TIMA.Codigo                
                
                                              
 LEFT JOIN Ciudades AS CIUD_COND ON                                        
 COND.EMPR_Codigo = CIUD_COND.EMPR_Codigo                                              
 AND COND.CIUD_Codigo_Identificacion = CIUD_COND.Codigo               
                                            
 LEFT JOIN Vehiculos AS VEHI ON                                              
 ENMA.EMPR_Codigo = VEHI.EMPR_Codigo                                          
 AND ENMA.VEHI_Codigo = VEHI.Codigo                                      
                                
 LEFT JOIN Semirremolques AS SEMI ON                                              
 ENMA.EMPR_Codigo = SEMI.EMPR_Codigo                                              
 AND (ENMA.SEMI_Codigo = SEMI.Codigo OR VEHI.SEMI_Codigo = SEMI.Codigo)                              
                                    
 LEFT JOIN Terceros AS SOAT                     
 ON VEHI.EMPR_Codigo = SOAT.EMPR_Codigo                                            
 AND VEHI.TERC_Codigo_Aseguradora_SOAT = SOAT.Codigo                                      
                                    
 LEFT JOIN Marca_Vehiculos AS MAVE ON                                              
 VEHI.EMPR_Codigo = MAVE.EMPR_Codigo                                              
 AND VEHI.MAVE_Codigo = MAVE.Codigo                                              
                                            
 LEFT JOIN Linea_Vehiculos AS LIVE ON                                              
 VEHI.EMPR_Codigo = LIVE.EMPR_Codigo                                              
 AND VEHI.LIVE_Codigo = LIVE.Codigo                                             
 AND MAVE.Codigo = LIVE.MAVE_Codigo                                                                             
 LEFT JOIN Color_Vehiculos AS COVE ON                                              
 VEHI.EMPR_Codigo = COVE.EMPR_Codigo                                              
 AND VEHI.COVE_Codigo = COVE.Codigo                                             
                                            
 LEFT JOIN Valor_Catalogos AS TIVE ON                                              
 VEHI.EMPR_Codigo = TIVE.EMPR_Codigo                             
 AND VEHI.CATA_TIVE_Codigo = TIVE.Codigo                                              
                                            
 LEFT JOIN Rutas AS RUTA ON                                              
 ENMA.EMPR_Codigo = RUTA.EMPR_Codigo                                              
 AND ENMA.RUTA_Codigo = RUTA.Codigo                                            
                                            
 LEFT JOIN Ciudades AS CIOR ON                                              
 RUTA.EMPR_Codigo = CIOR.EMPR_Codigo                                              
 AND RUTA.CIUD_Codigo_Origen = CIOR.Codigo                                            
                                            
 LEFT JOIN Ciudades AS CIDE ON                                
 RUTA.EMPR_Codigo = CIDE.EMPR_Codigo                                              
 AND RUTA.CIUD_Codigo_Destino = CIDE.Codigo                                            
                                      
 LEFT JOIN Encabezado_Planilla_Despachos AS ENPD ON                                              
 ENPD.EMPR_Codigo = ENMA.EMPR_Codigo                                              
 AND ENPD.ENMC_Numero = ENMA.Numero                                      
                                      
 LEFT JOIN Detalle_Impuestos_Planilla_Despachos AS DIPD ON                                      
 DIPD.EMPR_Codigo = ENPD.EMPR_Codigo                                      
 AND DIPD.ENPD_Numero = ENPD.Numero                                      
 AND DIPD.ENIM_Codigo = 21                                      
                      
 LEFT JOIN Detalle_Ciudad_Impuestos AS DECI ON                                      
 DECI.EMPR_Codigo = RUTA.EMPR_Codigo                                      
 AND DECI.CIUD_Codigo = RUTA.CIUD_Codigo_Origen                                      
 AND DECI.ENIM_Codigo = 21                                
                          
 LEFT JOIN Detalle_Impuestos_Planilla_Despachos AS DIPD2 ON                                      
 DIPD2.EMPR_Codigo = ENPD.EMPR_Codigo                                      
 AND DIPD2.ENPD_Numero = ENPD.Numero                                      
 AND DIPD2.ENIM_Codigo = 20                                
             
 LEFT JOIN Encabezado_Cumplido_Planilla_Despachos AS ENCP on            
 ENMA.EMPR_Codigo = ENCP.EMPR_Codigo            
 AND ENMA.Numero = ENCP.ENMC_Numero            
            
 --LEFT JOIN Encabezado_Cumplido_Planilla_Despachos AS ENCP on            
 --ENCP.EMPR_Codigo = ENMA.EMPR_Codigo            
 --and ENCP.ENPD_Numero = ENMA.ENPD_Numero            
            
 --Tipo Cumplido Manifiesto            
 LEFT JOIN Valor_Catalogos AS TICM ON            
 ENCP.EMPR_Codigo = TICM.EMPR_Codigo            
 AND ENCP.CATA_TICM_Codigo = TICM.Codigo            
            
 --Motivo Suspension Manifiesto            
 LEFT JOIN Valor_Catalogos AS MOSM ON            
 ENCP.EMPR_Codigo = MOSM.EMPR_Codigo            
 AND ENCP.CATA_MOSM_Codigo = MOSM.Codigo            
            
 --Consecuencia Suspension Manifiesto            
 LEFT JOIN Valor_Catalogos AS COSM ON            
 ENCP.EMPR_Codigo = COSM.EMPR_Codigo            
 AND ENCP.CATA_COSM_Codigo = COSM.Codigo            
            
 --Manifiesto Transbordo Original            
            
 LEFT JOIN Encabezado_Manifiesto_Carga MATR ON            
 ENMA.EMPR_Codigo = MATR.EMPR_Codigo            
 AND ENMA.ENMC_Numero_Transbordo = MATR.Numero            
        
        
 LEFT JOIN Detalle_Conductores_Planilla_Despachos SECO ON        
 ENMA.EMPR_Codigo = SECO.EMPR_Codigo AND        
 ENMA.ENPD_Numero = SECO.ENPD_Numero AND        
 ENMA.TERC_Codigo_Conductor <> SECO.TERC_Codigo_Conductor              
        
 LEFT JOIN Terceros TECO2 ON        
 ENMA.EMPR_Codigo = TECO2.EMPR_Codigo AND        
 SECO.TERC_Codigo_Conductor = TECO2.Codigo                 
        
                             
 WHERE ENMA.EMPR_Codigo = @par_EMPR_Codigo                                            
 AND ENMA.Numero_Documento = @par_ENMC_Numero            
END  
GO