DROP  PROCEDURE gsp_registrar_entrega_remesa_paqueteria    
GO
CREATE  PROCEDURE gsp_registrar_entrega_remesa_paqueteria    
(                      
 @par_EMPR_Codigo SMALLINT ,                      
 @par_ENRE_Numero NUMERIC,                      
 @par_Cantidad_Recibe MONEY = NULL,                        
 @par_Peso_Recibe MONEY = NULL,                      
 --@par_Fecha_Recibe DATE = NULL,                      
 @par_CATA_TIID_Codigo_Recibe NUMERIC,                      
 @par_Numero_Identificacion_Recibe VARCHAR(30),                      
 @par_Nombre_Recibe VARCHAR(50) = NULL,                                        
 @par_Telefonos_Recibe VARCHAR(100) = NULL,                     
 @par_Firma IMAGE = NULL,                             
 @par_Observaciones_Recibe VARCHAR(500) = NULL,                         
 @par_USUA_Codigo_Modifica SMALLINT,              
 @par_CATA_NERP_Codigo numeric = null   ,          
 @par_OFIC_Codigo numeric = null  ,        
 @par_ENPD_Numero numeric = null         
)                      
AS                       
BEGIN                    
 DECLARE @OFIC_Codigo numeric  
 DECLARE @FECHA_ENTREGA DATETIME
 --Actualiza Remesa    
 SELECT @FECHA_ENTREGA = Fecha_Entrega FROM  Remesas_Paqueteria                      
 WHERE                       
 EMPR_Codigo =  @par_EMPR_Codigo                      
 AND ENRE_Numero =  @par_ENRE_Numero   

 SELECT @OFIC_Codigo = OFIC_Codigo_Actual FROM Remesas_Paqueteria WHERE ENRE_Numero = @par_ENRE_Numero  
 if @par_OFIC_Codigo is null  
 begin  
 set @par_OFIC_Codigo = @OFIC_Codigo  
 end  
 --Genera Documento Cumplido    
 INSERT INTO Cumplido_Remesas (                
 EMPR_Codigo,                
 ENRE_Numero,                
 Fecha_Recibe,                
 Nombre_Recibe,                
 Numero_Identificacion_Recibe,                
 Telefonos_Recibe,                
 Observaciones_Recibe,                
 Cantidad_Recibe,                
 Peso_Recibe,                
 Firma_Recibe,                
 Fecha_Crea,                
 USUA_Codigo_Crea,                
 OFIC_Codigo  ,              
 CATA_NERP_Codigo,        
 --Mofigicacion DC: 16/06/2021         
 ENPD_Numero,        
 TERC_Codigo_Entrega        
 --Fin modificacion        
 )                
 VALUES (                
 @par_EMPR_Codigo,                
 @par_ENRE_Numero,                
 @FECHA_ENTREGA,                
 @par_Nombre_Recibe,                
 @par_Numero_Identificacion_Recibe,                
 @par_Telefonos_Recibe,                
 @par_Observaciones_Recibe,                
 ISNULL(@par_Cantidad_Recibe,0),                
 ISNULL(@par_Peso_Recibe,0),                
 @par_Firma,                
 GETDATE(),                
 @par_USUA_Codigo_Modifica,                
 @par_OFIC_Codigo ,              
 @par_CATA_NERP_Codigo,        
 --Mofigicacion DC: 16/06/2021         
 @par_ENPD_Numero,        
 @par_USUA_Codigo_Modifica        
 --Fin modificacion        
 )    
 --Genera Documento Cumplido    
     
 --Actualiza Remesa    
 UPDATE Remesas_Paqueteria                      
 SET                       
 Cantidad_Recibe = @par_Cantidad_Recibe,                      
 Peso_Recibe = @par_Peso_Recibe,                      
 Fecha_Recibe = GETDATE(),                      
 CATA_TIID_Codigo_Recibe = @par_CATA_TIID_Codigo_Recibe,                      
 Numero_Identificacion_Recibe = @par_Numero_Identificacion_Recibe,                     
 Nombre_Recibe = @par_Nombre_Recibe,                      
 Telefonos_Recibe = @par_Telefonos_Recibe,                    
 Firma_Recibe = @par_Firma,                    
 Observaciones_Recibe = @par_Observaciones_Recibe,                
 CATA_ESRP_Codigo = 6030,              
 CATA_NERP_Codigo = @par_CATA_NERP_Codigo  ,            
 OFIC_Codigo_Entrega =@par_OFIC_Codigo,          
 USUA_Codigo_Entrega = @par_USUA_Codigo_Modifica          
 --Fecha_Entrega = GETDATE()          
                      
 WHERE                       
 EMPR_Codigo =  @par_EMPR_Codigo                      
 AND ENRE_Numero =  @par_ENRE_Numero    
 --Actualiza Remesa    
 --Actualiza Remesa Paqueteria    
 update Encabezado_Remesas set Entregado = 1,                  
 Cumplido = 1,                
 USUA_Codigo_Modifica =  @par_USUA_Codigo_Modifica,                      
 Fecha_Modifica = GETDATE()                    
                   
 WHERE                       
 EMPR_Codigo =  @par_EMPR_Codigo           
 AND Numero =  @par_ENRE_Numero       
 --Actualiza Remesa Paqueteria    
    
 exec gsp_insertar_estado_remesa_paqueteria @par_EMPR_Codigo, @par_ENRE_Numero,6030,@par_USUA_Codigo_Modifica,@par_ENPD_Numero,@par_OFIC_Codigo, @par_USUA_Codigo_Modifica    
                    
 SELECT @par_ENRE_Numero As Codigo                      
END    
GO