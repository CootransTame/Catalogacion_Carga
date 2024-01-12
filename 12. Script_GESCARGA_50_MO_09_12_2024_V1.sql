ALTER TABLE Terceros ADD Firma VARCHAR(Max) NULL;
GO
ALTER TABLE Terceros DROP column Firma
----------------------------------------------------------
PRINT 'gsp_insertar_terceros'
GO
DROP PROCEDURE gsp_insertar_terceros
GO
CREATE PROCEDURE gsp_insertar_terceros
(                                                          
	@par_EMPR_Codigo SMALLINT,                                                          
	@par_Codigo_Alterno VARCHAR(20) = NULL,                                                          
	@par_Codigo_Contable VARCHAR(20) = NULL,                    
	@par_PAIS_Codigo NUMERIC = NULL,                                                     
	@par_CATA_TINT_Codigo NUMERIC = NULL,                                                          
	@par_CATA_TIID_Codigo NUMERIC = NULL,                                                          
	@par_Numero_Identificacion VARCHAR(30) = NULL,                                                          
	@par_Digito_Chequeo SMALLINT = NULL,                                                          
	@par_Razon_Social VARCHAR(100) = NULL,                                                          
	@par_Representante_Legal VARCHAR(100) = NULL,                                                          
	@par_Nombre VARCHAR(100) = NULL,                                                          
	@par_Apellido1 VARCHAR(50) = NULL,                                                          
	@par_Apellido2 VARCHAR(50) = NULL,                                                          
	@par_CATA_SETE_Codigo NUMERIC = NULL,                                                          
	@par_CIUD_Codigo_Identificacion NUMERIC = NULL,                                                          
	@par_CIUD_Codigo_Nacimiento NUMERIC = NULL,                                                          
	@par_CIUD_Codigo_Direccion NUMERIC = NULL,                                                         
	@par_Barrio VARCHAR(150) = NULL,                                                          
	@par_Direccion VARCHAR(150) = NULL,                                                          
	@par_Codigo_Postal VARCHAR(50) = NULL,                                                          
	@par_Telefonos VARCHAR(100) = NULL,                                                          
	@par_Celulares VARCHAR(100) = NULL,                                                          
	@par_Emails VARCHAR(250) = NULL,                                                          
	@par_BANC_Codigo NUMERIC = NULL,                                                          
	@par_CATA_TICB_Codigo NUMERIC = NULL,                                                          
	@par_Numero_Cuenta_Bancaria VARCHAR(50) = NULL,                                                          
	@par_Titular_Cuenta_Bancaria VARCHAR(100) = NULL,                                                          
	@par_TERC_Codigo_Beneficiario NUMERIC = NULL,                                                          
	@par_Foto IMAGE = NULL,                                                          
	@par_Observaciones VARCHAR(500) = NULL,                                                          
                                                          
	@par_Justificacion_Bloqueo VARCHAR(150) = NULL,                                                          
	@par_Reporto_Contabilidad SMALLINT = NULL,                                                          
	@par_Codigo_Retorno_Contabilidad VARCHAR(50) = NULL,                                                          
	@par_Mensaje_Retorno_Contabilidad VARCHAR(200) = NULL,                                                          
	@par_Estado SMALLINT = null,                                                          
	@par_USUA_Codigo_Crea SMALLINT,                                                          
	@par_Perfiles  VARCHAR(1000),                                                          
	@Codigo NUMERIC = 0,
	@par_Firma VARCHAR(MAX) = NULL,
	--Datos Conductor                                                          
	@par_CATA_TICO_Codigo NUMERIC = NULL,                                                          
	@par_CATA_TISA_Codigo NUMERIC = NULL,                                                          
	@par_CATA_CALC_Codigo NUMERIC = NULL,                 
	@par_CATA_CCCV_Codigo NUMERIC = NULL,             
	@par_Numero_Licencia VARCHAR(20) = NULL,                          
	@par_Fecha_Vencimiento_Licencia DATETIME = NULL,                             
	@par_Conductor_Propio SMALLINT = NULL,       
	@par_Conductor_Afiliado SMALLINT = NULL,                    
	@par_BloqueadoAltoRiesgo SMALLINT = NULL,                    
	@par_Fecha_Ultimo_Viaje DATETIME = NULL,                                                          
	@par_Referencias_Personales VARCHAR(500) = NULL,                                                          
	--Datos Empleado                                                          
	@par_Fecha_Vinculacion DATE = NULL,                                                          
	@par_Fecha_Finalizacion DATE = NULL,                                           
	@par_CATA_TICE_Codigo NUMERIC = NULL,                                                          
	@par_CATA_CARG_Codigo NUMERIC = NULL,                                                          
	@par_Salario MONEY = NULL,                                              
	@par_Valor_Auxilio_Transporte MONEY = NULL,                                                          
	@par_Valor_Seguridad_Social MONEY = NULL,                                                          
	@par_Valor_Aporte_Parafiscales MONEY = NULL,                             
	@par_Porcentaje_Comision NUMERIC = NULL,                                                          
	@par_Valor_Seguro_Vida MONEY = NULL,                                                 
	@par_Valor_Provision_Prestaciones_Sociales MONEY = NULL,                                                          
	@par_Empleado_Externo SMALLINT = NULL,                                                          
	@par_CATA_DEEM_Codigo NUMERIC = NULL ,                                                        
	--Datos Cliente                                                          
	@par_CATA_FPCL_Codigo NUMERIC = NULL,                                                          
	@par_TERC_Codigo_Comercial NUMERIC = NULL,                                                         
	@par_Dias_Plazo_Pago NUMERIC = NULL,                                                          
	@par_ETCV_Numero NUMERIC = NULL,                                                          
	@par_CATA_TIVC_Codigo NUMERIC = NULL,                                                          
	@par_Cupo NUMERIC = NULL,                                
	@par_Saldo NUMERIC = NULL,                          
	@par_Correo_Factura_Electronica VARCHAR(100) = NULL,                    
	@par_BloquearDespachos NUMERIC = NULL,                   
	--Datos Proveedor                                                          
	@par_ETCC_Numero NUMERIC = NULL,                                                        
	@par_CATA_FOCO_Codigo NUMERIC = NULL ,                                                        
	@par_Dias_Plazo_Cobro NUMERIC = NULL ,                                                      
	@par_CATA_TIAN_Codigo NUMERIC = NULL,                                  
                                  
	@par_Margen_Utilidad  NUMERIC (18, 2) = NULL,                                  
	@par_Maneja_Condiciones_Peso_Cumplido SMALLINT = NULL,                           
	@par_Maneja_Condiciones_Comerciales_Tarifas SMALLINT = NULL,                              
	@par_Dia_Cierre_Facturacion  INT = NULL,                                  
	@par_CATA_MFPC_Codigo           INT = NULL            ,                      
	@par_Maneja_Gestion_Documentos_Cliente SMALLINT = NULL,                      
	@par_TERC_Codigo_Analista_Cartera NUMERIC = NULL,
	@par_CATA_LISE_Codigo NUMERIC = NULL                      
                      
)                                                          
AS                                                          
BEGIN                      
 EXEC gsp_generar_consecutivo  @par_EMPR_Codigo, 10, 0, @Codigo OUTPUT                                                 
 INSERT INTO Terceros                                                          
 (EMPR_Codigo                                                   
 ,Codigo                                                          
 ,Codigo_Alterno                                                          
 ,Codigo_Contable                     
 ,CATA_TINT_Codigo                                                          
 ,CATA_TIID_Codigo                                                          
 ,Numero_Identificacion                         
 ,Digito_Chequeo                                                          
 ,CIUD_Codigo_Identificacion                                                          
 ,CIUD_Codigo_Nacimiento                                                          
 ,Razon_Social                                                          
 ,Nombre             
 ,Apellido1                                                          
 ,Apellido2                                                          
 ,CATA_SETE_Codigo                                                          
 ,CIUD_Codigo                                     
 ,Barrio                                                        
 ,Direccion                                                          
 ,Codigo_Postal                                                          
 ,Telefonos                                     
 ,Celulares                                                          
 ,Emails                          
 ,Correo_Facturacion                        
 ,Observaciones                                                          
 ,Foto                                                          
                                                         
 ,Justificacion_Bloqueo                                                          
 ,Reporto_Contabilidad                                                          
 ,Codigo_Retorno_Contabilidad                                 
 ,Mensaje_Retorno_Contabilidad                                                          
 ,BANC_Codigo                                                          
 ,CATA_TICB_Codigo                                                          
 ,Numero_Cuenta_Bancaria                              
 ,TERC_Codigo_Beneficiario                                                          
 ,USUA_Codigo_Crea                                                         
 ,Fecha_Crea                                                          
 ,Representante_Legal                                                          
 ,Titular_Cuenta_Bancaria                                                     
 ,PAIS_Codigo                                                       
                                                        
 ,Estado                                        
 ,CATA_TIAN_Codigo                                      
 ,CATA_TIVC_Codigo                                      
 ,Cupo                                      
 ,Saldo                                    
 ,Reportar_RNDC   
 ,CATA_LISE_Codigo
 ,Firma
 )                                                          
 VALUES                                                          
 (                                  
 @par_EMPR_Codigo                                        
 ,@Codigo                                                          
 ,@par_Codigo_Alterno                                                          
 ,@par_Codigo_Contable                                                     
 ,ISNULL(@par_CATA_TINT_Codigo ,500)                                                          
 ,ISNULL(@par_CATA_TIID_Codigo ,100)                                                          
 ,ISNULL(@par_Numero_Identificacion ,'')                                                          
 ,ISNULL(@par_Digito_Chequeo,0)                                      
 ,ISNULL(@par_CIUD_Codigo_Identificacion,0)                                                          
 ,ISNULL(@par_CIUD_Codigo_Nacimiento,0)                                                          
 ,@par_Razon_Social                                                          
 ,@par_Nombre                                                          
 ,ISNULL(@par_Apellido1 ,'')                    
 ,ISNULL(@par_Apellido2 ,'')                                                          
 ,ISNULL(@par_CATA_SETE_Codigo,600)                                                          
 ,ISNULL(@par_CIUD_Codigo_Direccion, 0)                                                          
 ,ISNULL(@par_Barrio,'')                                        
 ,ISNULL(@par_Direccion,'')                                                          
 ,ISNULL(@par_Codigo_Postal,0)                                          
 ,ISNULL(@par_Telefonos,'')                                          
 ,@par_Celulares              
 ,@par_Emails                               
 ,ISNULL(@par_Correo_Factura_Electronica,'')                          
 ,ISNULL(@par_Observaciones,'')                                                          
 ,@par_Foto                                                          
             
 ,@par_Justificacion_Bloqueo                                                          
 ,ISNULL(@par_Reporto_Contabilidad,0)                                         
 ,@par_Codigo_Retorno_Contabilidad                                                          
 ,@par_Mensaje_Retorno_Contabilidad                                                          
 ,@par_BANC_Codigo                                                          
 ,ISNULL(@par_CATA_TICB_Codigo,0)                                                          
 ,@par_Numero_Cuenta_Bancaria                                                          
 ,@par_TERC_Codigo_Beneficiario                                  
 ,@par_USUA_Codigo_Crea                                                          
 ,GETDATE()                                                     
 ,@par_Representante_Legal                                                          
 ,@par_Titular_Cuenta_Bancaria                                                          
 ,ISNULL(@par_PAIS_Codigo,0)                           
 ,ISNULL(@par_Estado,0)                                        
 ,@par_CATA_TIAN_Codigo                                      
 ,@par_CATA_TIVC_Codigo                                      
 ,@par_Cupo                                      
 ,@par_Saldo                                
 ,1          
 ,@par_CATA_LISE_Codigo
 ,@par_Firma
 )                                                          
                                                             
 IF ISNULL(@par_Perfiles,'') <> '' BEGIN                                               
                                                             
 --Creación de tabla para almacenar los perfiles                                                            
 CREATE TABLE #Perfiles (perfil numeric)                                                            
 SET NOCOUNT ON                                                            
 --El separador de los perfiles es una comma ','                                                            
 DECLARE @intPosicion int, @strPerfil as varchar (5) , @lonPerfil numeric                                                            
 --@Posicion es la posicion de cada uno de nuestros separadores                                                            
                                                               
 --bucle para identificar pergiles                                                
 WHILE patindex('%,%' , @par_Perfiles )<> 0                                                            
 --patindex busca un patron en una cadena y devuelve su posicion                                                            
 BEGIN                                                            
 --Buscamos la posicion de la primera comma                                             
 SELECT @intPosicion =  patindex('%,%' , @par_Perfiles)                                                            
 -- se asigna el código del perfil a la variable @lonPerfil                                                            
 SELECT @strPerfil = left(@par_Perfiles, @intPosicion - 1)                                                            
 --Inserta cliente si el perfil coincide                                               
 IF( CONVERT(NUMERIC,@strPerfil) = 1401)                                                          
 BEGIN                                                          
 INSERT INTO dbo.Tercero_Clientes                                                          
 (EMPR_Codigo                              
 ,TERC_Codigo                                                          
 ,ETCV_Numero                                       
 ,CATA_FPCL_Codigo                                                          
 ,TERC_Codigo_Comercial                                                          
 ,Dias_Plazo_Pago                                  
 ,Margen_Utilidad                                  
 ,Maneja_Condiciones_Peso_Cumplido                        
 ,Maneja_Condiciones_Comerciales_Tarifas                            
 ,Dia_Cierre_Facturacion                                  
 ,CATA_MFPC_Codigo                          
 ,Correo_Facturacion                             
 ,Gestion_Documentos                      
 ,TERC_Codigo_Analista_Cartera                
 ,Bloquear_Despachos                
 )                                                          
 VALUES                                                          
 (@par_EMPR_Codigo                                                       
 ,@Codigo                                                          
 ,ISNULL(@par_ETCV_Numero,0)                                                          
 ,ISNULL(@par_CATA_FPCL_Codigo,1500)                                                          
 ,@par_TERC_Codigo_Comercial                                                          
 ,@par_Dias_Plazo_Pago                                    
 ,ISNULL(@par_Margen_Utilidad,0)                                  
 ,ISNULL(@par_Maneja_Condiciones_Peso_Cumplido,0)                            
 ,ISNULL(@par_Maneja_Condiciones_Comerciales_Tarifas,0)                               
 ,ISNULL(@par_Dia_Cierre_Facturacion,0)                                  
 ,ISNULL(@par_CATA_MFPC_Codigo,0)                          
 ,ISNULL(@par_Correo_Factura_Electronica,'')                             
 ,@par_Maneja_Gestion_Documentos_Cliente                      
 ,@par_TERC_Codigo_Analista_Cartera                
 ,@par_BloquearDespachos                
 )                                                          
                                                           
                                                          
 END                                                          
 --Inserta Condutor si el perfil coincide                                                          
 IF( CONVERT(NUMERIC,@strPerfil) = 1403)                                                          
 BEGIN          
        
 INSERT INTO dbo.Tercero_Conductores                                                          
 (EMPR_Codigo                                                       
 ,TERC_Codigo                                                          
 ,CATA_TCCO_Codigo                                                          
 ,CATA_TISA_Codigo                                                          
 ,CATA_CALC_Codigo                                                          
 ,Numero_Licencia                                                          
 ,Fecha_Vencimiento_Licencia                             
 ,Conductor_Propio                                                          
 ,Fecha_Ultimo_Viaje          
 ,CATA_CCCV_Codigo          
 ,Referencias_Personales      
 ,Conductor_Afiliado    
 ,Bloqueo_Alto_Riesgo    
 )                                                         
 VALUES                                                          
 (@par_EMPR_Codigo                                                          
 ,@Codigo                                                          
 ,ISNULL(@par_CATA_TICO_Codigo,1700)                                                          
 ,ISNULL(@par_CATA_TISA_Codigo,1900)                                                
 ,ISNULL(@par_CATA_CALC_Codigo,1800)                                                          
 ,ISNULL(@par_Numero_Licencia,'')                                                          
 ,ISNULL(@par_Fecha_Vencimiento_Licencia,'')                                                          
 ,ISNULL(@par_Conductor_Propio,0)                
 ,ISNULL(@par_Fecha_Ultimo_Viaje,'')                                    
 ,ISNULL(@par_CATA_CCCV_Codigo,23500)             
 ,@par_Referencias_Personales      
 ,ISNULL(@par_Conductor_Afiliado,0)          
 ,ISNULL(@par_BloqueadoAltoRiesgo,0)       
 )                                                          
 END                                         
 --Inserta Empleado si el perfil coincide                                      
 IF( CONVERT(NUMERIC,@strPerfil) = 1405)                                                          
 BEGIN                                                          
                                                          
 INSERT INTO dbo.Tercero_Empleados                                                          
 (EMPR_Codigo                                                          
 ,TERC_Codigo                                                          
 ,CATA_CARG_Codigo                                                          
 ,Fecha_Vinculacion                                                          
 ,Salario                                                  
 ,Valor_Auxilio_Transporte                                                          
 ,Valor_Seguridad_Social                                                          
 ,Valor_Aporte_Parafiscales                         
 ,Valor_Provision_Prestaciones_Sociales                                                          
 ,Empleado_Externo                                                        
 ,Fecha_Finalizacion                                                          
 ,CATA_TICE_Codigo                                                          
 ,Porcentaje_Comision                                                          
 ,Valor_Seguro_Vida                                                        
 ,CATA_DEEM_Codigo)                                                          
 VALUES                                                          
 (@par_EMPR_Codigo                   
 ,@Codigo                                                          
 ,isnull(@par_CATA_CARG_Codigo,2000)                                                          
 ,ISNULL(@par_Fecha_Vinculacion,'')                                                
 ,@par_Salario                                                          
 ,@par_Valor_Auxilio_Transporte                                                          
 ,@par_Valor_Seguridad_Social                                                          
 ,@par_Valor_Aporte_Parafiscales                                                          
 ,@par_Valor_Provision_Prestaciones_Sociales                                                         
 ,@par_Empleado_Externo                                                          
 ,ISNULL(@par_Fecha_Finalizacion,'')                                      
 ,isnull(@par_CATA_TICE_Codigo,1200)                                                          
 ,@par_Porcentaje_Comision                                                          
 ,@par_Valor_Seguro_Vida                                                        
 ,ISNULL(@par_CATA_DEEM_Codigo,8700))                                                          
     
 END                                                          
IF( CONVERT(NUMERIC,@strPerfil) = 1409 or CONVERT(NUMERIC,@strPerfil) = 1412)                                                          
 BEGIN                                                          
 if exists(select * from Tercero_Proveedores where EMPR_Codigo = @par_EMPR_Codigo and TERC_Codigo = @Codigo)                                                          
 UPDATE Tercero_Proveedores                                                          
 SET CATA_FOCO_Codigo = ISNULL(@par_CATA_FOCO_Codigo,8800)                                                        
 , Dias_Plazo_Cobro = isnull(@par_Dias_Plazo_Cobro,0)                                                          
 , ETCC_Numero = ISNULL(@par_ETCC_Numero,0)                                                           
 WHERE EMPR_Codigo = @par_EMPR_Codigo and TERC_Codigo = @Codigo                                              
 ELSE                                                          
 INSERT INTO dbo.Tercero_Proveedores                                                          
 (EMPR_Codigo                                  
 ,TERC_Codigo                                  
 ,ETCC_Numero                                         
 ,CATA_FOCO_Codigo                                  
 ,Dias_Plazo_Cobro                                  
 )                                  
 VALUES                                                          
 (@par_EMPR_Codigo                                                          
 ,@Codigo                                                        
 ,ISNULL(@par_ETCC_Numero,0)                                                          
 ,ISNULL(@par_CATA_FOCO_Codigo,8800)                                                        
 ,ISNULL(@par_Dias_Plazo_Cobro,8800)                                                        
 )                                                          
 END                        
 SET @lonPerfil = convert (numeric, @strPerfil)                                                            
 -- Se inserta el perfil a la tabla                                                            
 INSERT INTO #Perfiles values (@lonPerfil)                                                            
 --y ese parámetro lo guardamos en la tabla temporal                                                            
 --Reemplazamos lo procesado con nada con la funcion stuff                                                            
 SELECT @par_Perfiles = stuff(@par_Perfiles, 1, @intPosicion, '')                                          
 END                                                            
 INSERT INTO Perfil_Terceros                                                            
 SELECT @par_EMPR_Codigo, @Codigo, perfil FROM #Perfiles                                                            
                                                            
 DROP TABLE #Perfiles                                                            
 END                    
 INSERT INTO Tercero_Novedades (                  
 EMPR_Codigo,                  
 TERC_Codigo,                  
 CATA_NOTE_Codigo,                  
 Estado,                  
 Observaciones,                  
 USUA_Codigo_Crea,                  
 Fecha_Crea                  
 )                  
 VALUES(                  
 @par_EMPR_Codigo,                  
 @Codigo,                  
 22212,--Creación Registro                  
 1,                  
 'Creación Tercero',                  
@par_USUA_Codigo_Crea,                  
GETDATE()                  
 )                  
                    
 EXEC gsp_insertar_digito_chequeo_tercero @par_EMPR_Codigo, @Codigo                   
                   
                   
 select @Codigo as Codigo                                                          
END
GO
----------------------------------------------------------
PRINT 'gsp_modificar_terceros'
GO
DROP PROCEDURE gsp_modificar_terceros
GO
CREATE PROCEDURE gsp_modificar_terceros
(                                                                
	@par_EMPR_Codigo SMALLINT,                                                                
	@par_Codigo_Alterno VARCHAR(20) = NULL,                                                                
	@par_Codigo_Contable VARCHAR(20) = NULL,                                                                
	@par_CATA_TINT_Codigo NUMERIC = NULL,                                                                
	@par_CATA_TIID_Codigo NUMERIC = NULL,                                                                
	@par_Numero_Identificacion VARCHAR(30) = NULL,                                                                
	@par_Digito_Chequeo SMALLINT = NULL,                                                                
	@par_Razon_Social VARCHAR(100) = NULL,                                                                
	@par_Representante_Legal VARCHAR(100) = NULL,                                                                
	@par_Nombre VARCHAR(100) = NULL,                                                                
	@par_Apellido1 VARCHAR(50) = NULL,                                                                
	@par_PAIS_Codigo NUMERIC= NULL,                                                        
	@par_Apellido2 VARCHAR(50) = NULL,                                                                
	@par_CATA_SETE_Codigo NUMERIC = NULL,                                                                
	@par_CIUD_Codigo_Identificacion NUMERIC = NULL,                                                                
	@par_CIUD_Codigo_Nacimiento NUMERIC = NULL,                                                                
	@par_CIUD_Codigo_Direccion NUMERIC = NULL,                                                                
	@par_Direccion VARCHAR(150) = NULL,                                                             
	@par_Barrio VARCHAR(150)    = NULL,                                                            
	@par_Codigo_Postal VARCHAR(50) = NULL,                                                                
	@par_Telefonos VARCHAR(100) = NULL,                                                                
	@par_Celulares VARCHAR(100) = NULL,                                                                
	@par_Emails VARCHAR(250) = NULL,                                                                
	@par_BANC_Codigo NUMERIC = NULL,                                                                
	@par_CATA_TICB_Codigo NUMERIC = NULL,                                                                
	@par_Numero_Cuenta_Bancaria VARCHAR(50) = NULL,                                                                
	@par_Titular_Cuenta_Bancaria VARCHAR(100) = NULL,                                                                
	@par_TERC_Codigo_Beneficiario NUMERIC = NULL,                                                                
	@par_Foto IMAGE = NULL,                                                                
	@par_Observaciones VARCHAR(500) = NULL,                                                                
                                                                
	@par_Justificacion_Bloqueo VARCHAR(150) = NULL,                                                                
	@par_Reporto_Contabilidad SMALLINT = NULL,                                                                
	@par_Codigo_Retorno_Contabilidad VARCHAR(50) = NULL,                                                                
	@par_Mensaje_Retorno_Contabilidad VARCHAR(200) = NULL,                                                                
	@par_Estado SMALLINT = null,                                                                
	@par_USUA_Codigo_Crea SMALLINT,                                                                
	@par_Perfiles  VARCHAR(1000),     
	@Codigo NUMERIC = 0,
	@par_Firma VARCHAR(MAX) = NULL,
	--Datos Conductor                  
	@par_CATA_TICO_Codigo NUMERIC = NULL,                         
	@par_CATA_TISA_Codigo NUMERIC = NULL,                                           
	@par_CATA_CALC_Codigo NUMERIC = NULL,              
	@par_CATA_CCCV_Codigo  NUMERIC = NULL,              
	@par_Numero_Licencia VARCHAR(20) = NULL,                                            
	@par_Fecha_Vencimiento_Licencia DATE = NULL,                                               
	@par_Conductor_Propio SMALLINT = NULL,             
	@par_Conductor_Afiliado SMALLINT = NULL,             
	@par_BloqueadoAltoRiesgo SMALLINT = NULL,             
	@par_Fecha_Ultimo_Viaje DATE = NULL,                                                                
	@par_Referencias_Personales VARCHAR(500) = NULL,                                                          
	--Datos Empleado                                                                
	@par_Fecha_Vinculacion DATE = NULL,                                                 
	@par_Fecha_Finalizacion DATE = NULL,                                                                
	@par_CATA_TICE_Codigo NUMERIC = NULL,                                                                
	@par_CATA_CARG_Codigo NUMERIC = NULL,                                                                
	@par_Salario MONEY = NULL,                                                                
	@par_Valor_Auxilio_Transporte MONEY = NULL,                                                               
	@par_Valor_Seguridad_Social MONEY = NULL,                                                                
	@par_Valor_Aporte_Parafiscales MONEY = NULL,                                                                
	@par_Porcentaje_Comision NUMERIC = NULL,                                                            
	@par_Valor_Seguro_Vida MONEY = NULL,                                                                
	@par_Valor_Provision_Prestaciones_Sociales MONEY = NULL,                                                                
	@par_Empleado_Externo SMALLINT = NULL,                                                                
	@par_CATA_DEEM_Codigo NUMERIC = NULL ,                                                              
	--Datos Cliente                                                                
	@par_CATA_FPCL_Codigo NUMERIC = NULL,                    
	@par_BloquearDespachos NUMERIC = NULL,                    
	@par_TERC_Codigo_Comercial NUMERIC = NULL,                                                                
	@par_Dias_Plazo_Pago NUMERIC = NULL,                                                                
	@par_ETCV_Numero NUMERIC = NULL,                                             
	@par_CATA_TIVC_Codigo NUMERIC = NULL,                                                            
	@par_Cupo NUMERIC = NULL,                                
	@par_Saldo  NUMERIC = NULL,                            
	@par_Correo_Factura_Electronica VARCHAR(100) = NULL,

	--Datos Proveedor                                                                
	@par_ETCC_Numero NUMERIC = NULL ,                                                              
	@par_CATA_FOCO_Codigo NUMERIC = NULL ,                                                              
	@par_Dias_Plazo_Cobro NUMERIC = NULL ,                                          
	@par_CATA_TIAN_Codigo NUMERIC = NULL,                                  
                                  
	@par_Margen_Utilidad NUMERIC (18, 2) = NULL,                                  
	@par_Maneja_Condiciones_Peso_Cumplido SMALLINT = NULL,                           
	@par_Maneja_Condiciones_Comerciales_Tarifas SMALLINT = NULL,                                 
	@par_Dia_Cierre_Facturacion INT = NULL,                                  
	@par_CATA_MFPC_Codigo  INT = NULL ,                        
	@par_Maneja_Gestion_Documentos_Cliente SMALLINT = NULL,                        
	@par_TERC_Codigo_Analista_Cartera NUMERIC = NULL  ,                           
	@par_CATA_LISE_Codigo NUMERIC = NULL                      
)                                               
AS                                                         
BEGIN

UPDATE Terceros                                                                
        SET                         
         Codigo_Alterno = @par_Codigo_Alterno                                                                
        ,Codigo_Contable = @par_Codigo_Contable                                                            
        ,CATA_TINT_Codigo = ISNULL(@par_CATA_TINT_Codigo ,500)                                                                
        ,CATA_TIID_Codigo = ISNULL(@par_CATA_TIID_Codigo ,100)                                               
        ,Numero_Identificacion = ISNULL(@par_Numero_Identificacion ,'')                    
        ,Digito_Chequeo = ISNULL(@par_Digito_Chequeo,0)                                                                
        ,CIUD_Codigo_Identificacion = ISNULL(@par_CIUD_Codigo_Identificacion,0)                                                                
        ,CIUD_Codigo_Nacimiento = ISNULL(@par_CIUD_Codigo_Nacimiento,0)                                                                
 ,Razon_Social = @par_Razon_Social                                                                
        ,Nombre = @par_Nombre                                                                
        ,Apellido1 = ISNULL(@par_Apellido1 ,'')                                                           
        ,Apellido2 = ISNULL(@par_Apellido2 ,'')                                                                
        ,CATA_SETE_Codigo = ISNULL(@par_CATA_SETE_Codigo,600)                                                   
        ,CIUD_Codigo = ISNULL(@par_CIUD_Codigo_Direccion, 0)                                                                
        ,Direccion = ISNULL(@par_Direccion,'')                                        
  ,PAIS_Codigo = ISNULL(@par_PAIS_Codigo,0)                                                        
        ,Codigo_Postal = ISNULL(@par_Codigo_Postal,0)                                            
        ,Telefonos = ISNULL(@par_Telefonos,'')                                                                
        ,Celulares = @par_Celulares                                    
        ,Emails = @par_Emails                                      
  ,Correo_Facturacion = ISNULL(@par_Correo_Factura_Electronica,'')                           
        ,Observaciones = ISNULL(@par_Observaciones,'')                                                                
        ,Foto = @par_Foto                                                                
        ,Barrio = ISNULL(@par_Barrio,'')                                                       
        ,Justificacion_Bloqueo = @par_Justificacion_Bloqueo                                                                
        ,Reporto_Contabilidad = ISNULL(@par_Reporto_Contabilidad,0)                                                                
        ,Codigo_Retorno_Contabilidad = @par_Codigo_Retorno_Contabilidad                                                                
 ,Mensaje_Retorno_Contabilidad = @par_Mensaje_Retorno_Contabilidad                                                                
        ,BANC_Codigo = @par_BANC_Codigo                                                                 
        ,CATA_TICB_Codigo=ISNULL(@par_CATA_TICB_Codigo,0)                                                                
        ,Numero_Cuenta_Bancaria = @par_Numero_Cuenta_Bancaria                                                                
        ,TERC_Codigo_Beneficiario = @par_TERC_Codigo_Beneficiario      
        ,USUA_Modifica = @par_USUA_Codigo_Crea                                                                
        ,Fecha_Modifica = GETDATE()                                                                
        ,Representante_Legal = @par_Representante_Legal                                                                
        ,Titular_Cuenta_Bancaria = @par_Titular_Cuenta_Bancaria                                                                
        ,Estado=ISNULL(@par_Estado,0)                                      
  ,CATA_TIAN_Codigo = @par_CATA_TIAN_Codigo                                         
  ,CATA_TIVC_Codigo = @par_CATA_TIVC_Codigo                                        
  ,Cupo = @par_Cupo                                        
  --,Saldo = CASE WHEN Saldo IS NULL THEN @par_Cupo ELSE Saldo END                                        
  ,Saldo = @par_Saldo                                
  ,Reportar_RNDC = 1     
  ,CATA_LISE_Codigo= @par_CATA_LISE_Codigo
  ,Firma = @par_Firma
                                                         
  WHERE                                                                 
  EMPR_Codigo = @par_EMPR_Codigo                                                                 
  AND Codigo = @Codigo                                                                
          
        
  DELETE Perfil_Terceros WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = @Codigo                                                                
  --DELETE Tercero_Clientes WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = @Codigo                                      
  DELETE Tercero_Conductores WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = @Codigo                                                                
  DELETE Tercero_Empleados WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = @Codigo                                                                
  DELETE Clientes_Lineas_Servicios  WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo_Cliente = @Codigo                                            
  IF ISNULL(@par_Perfiles,'')<> '' BEGIN                                                        
                                                                   
  --Creación de tabla para almacenar los perfiles                                                             
  CREATE TABLE #Perfiles (perfil numeric)                                                                  
  SET NOCOUNT ON                                                         
  --El separador de los perfiles es una comma ','                                                                  
  DECLARE @intPosicion int, @strPerfil as varchar (5) , @lonPerfil numeric                                                                  
  --@Posicion es la posicion de cada uno de nuestros separadores                                                                  
                                                                     
  --bucle para identificar pergiles                                                                  
  WHILE patindex('%,%' , @par_Perfiles ) <> 0                                       
  --patindex busca un patron en una cadena y devuelve su posicion                                                                  
  BEGIN                                                                  
  --Buscamos la posicion de la primera comma                                                                  
  SELECT @intPosicion =  patindex('%,%' , @par_Perfiles)                                                                  
  -- se asigna el código del perfil a la variable @lonPerfil                                                                  
  SELECT @strPerfil = left(@par_Perfiles, @intPosicion - 1)                                                                  
      --Inserta o modifica si cliente si el perfil coincide                                      
  DECLARE @existTerc_Clie int = 0;     
  SELECT @existTerc_Clie = count(*) FROM Tercero_Clientes WHERE EMPR_Codigo = @par_EMPR_Codigo AND TERC_Codigo = @Codigo                                                
         
 IF( CONVERT(NUMERIC,@strPerfil) = 1401)                                                             
  BEGIN                                      
                   
            
 IF @existTerc_Clie = 1                                       
   BEGIN                                      
   UPDATE Tercero_Clientes SET                                      
   ETCV_Numero = ISNULL(@par_ETCV_Numero,0),                                      
   CATA_FPCL_Codigo = ISNULL(@par_CATA_FPCL_Codigo,1500),                     
   Bloquear_Despachos = @par_BloquearDespachos,                     
   TERC_Codigo_Comercial = @par_TERC_Codigo_Comercial,                                      
   Dias_Plazo_Pago = @par_Dias_Plazo_Pago,                                  
   Margen_Utilidad = ISNULL(@par_Margen_Utilidad, 0),                                  
   Maneja_Condiciones_Peso_Cumplido = ISNULL(@par_Maneja_Condiciones_Peso_Cumplido, 0),                            
   Maneja_Condiciones_Comerciales_Tarifas = ISNULL(@par_Maneja_Condiciones_Comerciales_Tarifas,0),                                
   Dia_Cierre_Facturacion = ISNULL(@par_Dia_Cierre_Facturacion,0),                               
   CATA_MFPC_Codigo = ISNULL(@par_CATA_MFPC_Codigo,0),                            
   Correo_Facturacion = ISNULL(@par_Correo_Factura_Electronica,'')    ,                        
   Gestion_Documentos = @par_Maneja_Gestion_Documentos_Cliente,                        
   TERC_Codigo_Analista_Cartera = @par_TERC_Codigo_Analista_Cartera                        
                           
                                
  WHERE EMPR_Codigo = @par_EMPR_Codigo                                      
  AND TERC_Codigo = @Codigo                                      
   END                                      
   ELSE                                      
   BEGIN                                      
    INSERT INTO Tercero_Clientes                     
    (EMPR_Codigo                                      
    ,TERC_Codigo                                      
    ,ETCV_Numero                                      
    ,CATA_FPCL_Codigo                                      
    ,TERC_Codigo_Comercial                                      
    ,Dias_Plazo_Pago                            
 ,Correo_Facturacion                          
 ,Bloquear_Despachos                  
    )                                      
   VALUES                                      
    (@par_EMPR_Codigo                                      
    ,@Codigo                                      
    ,ISNULL(@par_ETCV_Numero,0)                                      
    ,ISNULL(@par_CATA_FPCL_Codigo,1500)                                      
    ,@par_TERC_Codigo_Comercial                                      
    ,@par_Dias_Plazo_Pago                            
 ,ISNULL(@par_Correo_Factura_Electronica,''),                  
 @par_BloquearDespachos                  
    )                          
   END                                         
  END                                                                
  --Inserta Condutor si el perfil coincide                                                                
IF( CONVERT(NUMERIC,@strPerfil) = 1403)                                                                
  BEGIN                    
             
   INSERT INTO dbo.Tercero_Conductores                                                                
      (EMPR_Codigo                                                                
      ,TERC_Codigo                                                      
      ,CATA_TCCO_Codigo                                                        
      ,CATA_TISA_Codigo                                                                
      ,CATA_CALC_Codigo                                                                
 ,Numero_Licencia                                                                
      ,Fecha_Vencimiento_Licencia                                                                
   ,Conductor_Propio            
   ,CATA_CCCV_Codigo            
  ,Fecha_Ultimo_Viaje                                    
   ,Referencias_Personales          
   ,Conductor_Afiliado    
   ,Bloqueo_Alto_Riesgo    
   )                                                                
     VALUES                                              
      (@par_EMPR_Codigo                                                                
      ,@Codigo                                                                
      ,ISNULL(@par_CATA_TICO_Codigo,1700)                                
      ,ISNULL(@par_CATA_TISA_Codigo,1900)                                                                
      ,ISNULL(@par_CATA_CALC_Codigo,1800)             
      ,ISNULL(@par_Numero_Licencia,'')                                                  
      ,ISNULL(@par_Fecha_Vencimiento_Licencia, '')                                                              
      ,ISNULL(@par_Conductor_Propio,0)                                                       
    ,ISNULL(@par_CATA_CCCV_Codigo,23500)                
   ,ISNULL(@par_Fecha_Ultimo_Viaje, '')                                    
   ,@par_Referencias_PersonaleS          
   ,ISNULL(@par_Conductor_Afiliado,0)         
      ,ISNULL(@par_BloqueadoAltoRiesgo,0)        
   )                                                                 
                                                            
  END                                                                
  --Inserta Empleado si el perfil coincide                                                                
  IF( CONVERT(NUMERIC,@strPerfil) = 1405)                                                                
  BEGIN                                 
                                                        
  INSERT INTO dbo.Tercero_Empleados                                                                
   (EMPR_Codigo                                                                
   ,TERC_Codigo                                                                
   ,CATA_CARG_Codigo                                                                
   ,Fecha_Vinculacion                                                                
   ,Salario                                                      
   ,Valor_Auxilio_Transporte                                                                
   ,Valor_Seguridad_Social                                       
   ,Valor_Aporte_Parafiscales                                                                
   ,Valor_Provision_Prestaciones_Sociales                                                                
   ,Empleado_Externo                                         
   ,Fecha_Finalizacion                                                                
,CATA_TICE_Codigo                                                                
   ,Porcentaje_Comision                                                                
   ,Valor_Seguro_Vida                                                              
   ,CATA_DEEM_Codigo)                                                               
  VALUES                                                                
   (@par_EMPR_Codigo                 
   ,@Codigo                                                                
   ,isnull(@par_CATA_CARG_Codigo,2000)                                         
   ,@par_Fecha_Vinculacion                                                                
   ,@par_Salario                                                                
   ,@par_Valor_Auxilio_Transporte                                               
   ,@par_Valor_Seguridad_Social                                                                
   ,@par_Valor_Aporte_Parafiscales                     
   ,@par_Valor_Provision_Prestaciones_Sociales                                                                
   ,@par_Empleado_Externo                                                                
   ,@par_Fecha_Finalizacion                                                                
   ,isnull(@par_CATA_TICE_Codigo,1200)                                                                
   ,@par_Porcentaje_Comision                                                                
   ,@par_Valor_Seguro_Vida                                               
   ,ISNULL(@par_CATA_DEEM_Codigo,8700))                                                       
                                                                
  END                                                     
  --Inserta PROVEEDOR si el perfil coincide                                                                
  IF( CONVERT(NUMERIC,@strPerfil) = 1409 or CONVERT(NUMERIC,@strPerfil) = 1412)                                                                
  BEGIN                                                                
   if exists(select * from Tercero_Proveedores where EMPR_Codigo = @par_EMPR_Codigo and TERC_Codigo = @Codigo)                                                  
   UPDATE Tercero_Proveedores                            
  SET CATA_FOCO_Codigo = ISNULL(@par_CATA_FOCO_Codigo,8800)                                                            
    , Dias_Plazo_Cobro = isnull(@par_Dias_Plazo_Cobro,0)                                                              
    , ETCC_Numero = ISNULL(@par_ETCC_Numero,0)                                                           
 where EMPR_Codigo = @par_EMPR_Codigo and TERC_Codigo = @Codigo                                                
   ELSE                                                                
   INSERT INTO dbo.Tercero_Proveedores                                                            
        (EMPR_Codigo                                                                
        ,TERC_Codigo                                                                
        ,ETCC_Numero                                                                
  ,CATA_FOCO_Codigo                                                              
  ,Dias_Plazo_Cobro                                                    
        )                                                                
       VALUES                                                                
        (@par_EMPR_Codigo                                                                
        ,@Codigo                                                               
        ,ISNULL(@par_ETCC_Numero,0)                                                                
  ,ISNULL(@par_CATA_FOCO_Codigo,8800)                                                              
  ,ISNULL(@par_Dias_Plazo_Cobro,8800)                                       
   )                                                                 
  END                                                                
  SET @lonPerfil = convert (numeric, @strPerfil)                                                                  
  -- Se inserta el perfil a la tabla                                                                  
  INSERT INTO #Perfiles values (@lonPerfil)                                                                  
  --y ese parámetro lo guardamos en la tabla temporal                                                                  
  --Reemplazamos lo procesado con nada con la funcion stuff                                                                  
 SELECT @par_Perfiles = stuff(@par_Perfiles, 1, @intPosicion, '')                                                                  
  END                                                                  
  INSERT INTO Perfil_Terceros                                                                  
  SELECT @par_EMPR_Codigo, @Codigo, perfil FROM #Perfiles                       
                                            
  DROP TABLE #Perfiles                                                                  
  END                                             
                        
   --EXEC gsp_insertar_digito_chequeo_tercero @par_EMPR_Codigo, @Codigo                         
select @Codigo as Codigo                                                                
END
GO
----------------------------------------------------------
PRINT 'gsp_obtener_terceros'
GO
DROP PROCEDURE gsp_obtener_terceros
GO
CREATE PROCEDURE gsp_obtener_terceros
(                      
	@par_EMPR_Codigo smallint,                      
	@par_Codigo Numeric  = null,                    
	@par_Identificacion VARCHAR(20) = NULL                    
)                      
AS                       
BEGIN                      
SELECT                       
	1 as Obtener,                      
	TERC.EMPR_Codigo,--                      
	TERC.Codigo,--                      
	ISNULL(TERC.Codigo_Alterno,'') AS  Codigo_Alterno,--                      
	ISNULL(TERC.Codigo_Contable,0) AS  Codigo_Contable,                      
	TERC.CATA_TINT_Codigo,                      
	TERC.CATA_TIID_Codigo,                      
	TERC.Numero_Identificacion,                      
	TERC.Digito_Chequeo,                      
	ISNULL(TERC.Razon_Social,'') AS Razon_Social ,                      
	ISNULL(TERC.Representante_Legal,'') AS  Representante_Legal,                      
	ISNULL(TERC.Nombre,'') AS  Nombre,                      
	TERC.Apellido1,                      
	ISNULL(TERC.Apellido2,'')Apellido2,                      
	TERC.CATA_SETE_Codigo,                      
	TERC.CIUD_Codigo_Identificacion,                      
	TERC.CIUD_Codigo_Nacimiento,                      
	TERC.CIUD_Codigo AS CIUD_Codigo_Direccion,                      
	--0 as CIUD_Codigo_Direccion,                      
	TERC.Direccion,                      
	ISNULL(TERC.Barrio,'') AS Barrio,                  
	ISNULL(TERC.Codigo_Postal,0) AS Codigo_Postal ,                      
	TERC.Telefonos,                      
	ISNULL(TERC.Celulares,'') AS Celulares ,                      
	ISNULL(TERC.Emails,'') AS Emails ,         
	ISNULL(TERC.Correo_Facturacion,'') As Correo_Facturacion,    
	TERC.BANC_Codigo,                      
	TERC.CATA_TICB_Codigo,                      
	ISNULL(TERC.Numero_Cuenta_Bancaria,0) AS Numero_Cuenta_Bancaria ,                      
	ISNULL(TERC.TERC_Codigo_Beneficiario,0) AS TERC_Codigo_Beneficiario,                      
	ISNULL(TERC.Titular_Cuenta_Bancaria,'') AS  Titular_Cuenta_Bancaria,                      
	TERC.Observaciones,                      
	TERC.Foto,                   
	TERC.PAIS_Codigo,                   
	ISNULL(TERC.Justificacion_Bloqueo,'') AS Justificacion_Bloqueo ,                      
	TERC.CATA_TIAN_Codigo,        
	TERC.Estado   ,      
	TERC.CATA_TIVC_Codigo   ,      
	TERC.Cupo   ,      
	TERC.Saldo ,        
	TERC.CATA_LISE_Codigo,
	TERC.Firma
	FROM Terceros AS TERC                      
	WHERE TERC.EMPR_Codigo = @par_EMPR_Codigo                      
	AND TERC.Codigo = isnull(@par_Codigo  ,TERC.Codigo)                    
	AND TERC.Numero_Identificacion =  isnull(@par_Identificacion  ,TERC.Numero_Identificacion)                      
END
GO
----------------------------------------------------------