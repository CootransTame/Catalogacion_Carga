 

/****** Object:  StoredProcedure [dbo].[gsp_obtener_remesa_paqueteria_control_entregas_PAGINA_ASP]    Script Date: 20/09/2021 3:13:08 p. m. ******/
DROP PROCEDURE [dbo].[gsp_obtener_remesa_paqueteria_control_entregas_PAGINA_ASP]
GO

/****** Object:  StoredProcedure [dbo].[gsp_obtener_remesa_paqueteria_control_entregas_PAGINA_ASP]    Script Date: 20/09/2021 3:13:08 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[gsp_obtener_remesa_paqueteria_control_entregas_PAGINA_ASP]          
(                                  
 @par_EMPR_Codigo smallint,                                  
 @par_Numero Numeric,  
 @par_NumeroPreimpreso   varchar (max)  = NULL     
)                                  
AS                                   
BEGIN            
select distinct                        
 ENRE.EMPR_Codigo,                                
 ENRE.Fecha,                                
 ENRE.Numero,                                
 ENRE.Numero_Documento,  
 ENRE.Numeracion  as Numero_preimpreso,
  case ENPR.CATA_ESRP_Codigo      
 when 6001 then 'RECOGIDA     '    
 when 6005 then 'OFICINA ORIGEN    '    
 when 6010 then 'DESPACHADA     '    
 when 6015 then 'TRANSITO      '    
 when 6017 then 'RECIBIDA OFICINA INTERMEDIA'    
 when 6020 then 'RECIBIDA OFICINA DESTINO '    
 when 6025 then 'REPARTO OFICINA DESTINO  '    
 when 6030 then 'ENTREGADA (CUMPLIDA)    '    
 when 6035 then 'DEVUELTA OFICINA DESTINO '    
 when 6040 then 'DEVUELTA OFICINA ORIGEN  '     
 end  as ESTADOGUIA,     
ENPR.CATA_ESRP_Codigo,    
 ENRE.Anulado,    
  ISNULL(CLIE.Razon_Social, '') + ' ' + ISNULL(CLIE.Nombre, '') + ' ' + ISNULL(CLIE.Apellido1, '') + ' ' + ISNULL(CLIE.Apellido2, '') AS NombreCliente,    
  ISNULL(REMI.Razon_Social, '') + ' ' + ISNULL(REMI.Nombre, '') + ' ' + ISNULL(REMI.Apellido1, '') + ' ' + ISNULL(REMI.Apellido2, '') AS NombreRemitente,                                                                            
  CONVERT(varchar,ENPR.Fecha_Recibe,5) as Fecha_Recibe,    
 --ENPR.Fecha_Recibe,     
 CIDO.Nombre AS  Ciudad_Origen,
 CIDD.Nombre AS Ciudad_Destino,
 ENPR.Numero_Identificacion_Recibe,            
 ENPR.Nombre_Recibe,            
 ENPR.Telefonos_Recibe,            
 ENPR.Cantidad_Recibe,            
 ENPR.Peso_Recibe,            
 ENPR.CATA_NERP_Codigo,          
 NERP.Campo1 NovedadRecibe,          
 ENPR.Observaciones_Recibe,            
 ENPR.Firma_Recibe    ,        
 ENPR.Latitud,        
 ENPR.Longitud,      
 /*modificacion 26/03/2021*/      
 USUA.Nombre as Usuario_Entrega,      
ENPR.OFIC_Codigo_Entrega as  OFIC_Codigo_Entrega,      
 OFICIN.Nombre as OFIC_Nombre_Entrega      
       /*Fin modificacion 26/03/2021*/      
 FROM                                 
 Remesas_Paqueteria as ENPR                       
 INNER JOIN Encabezado_Remesas AS ENRE                                
 ON ENPR.EMPR_Codigo = ENRE.EMPR_Codigo                          
 AND ENPR.ENRE_Numero = ENRE.Numero          
           
 LEFT JOIN Valor_Catalogos AS NERP                                
 ON ENPR.EMPR_Codigo = ENRE.EMPR_Codigo                          
 AND ENPR.CATA_NERP_Codigo = NERP.Codigo         
      
  /*modificacion 26/03/2021*/      
  LEFT JOIN  Usuarios AS USUA      
  ON ENPR.EMPR_Codigo = USUA.EMPR_Codigo      
  and  ENPR.USUA_Codigo_Entrega = USUA.Codigo      
      
    LEFT JOIN  Oficinas AS OFICIN      
  ON ENPR.EMPR_Codigo = OFICIN.EMPR_Codigo      
  and  ENPR.OFIC_Codigo_Entrega = OFICIN.Codigo      
       /*Fin modificacion 26/03/2021*/       
         LEFT JOIN Terceros AS CLIE                                 
 ON ENRE.EMPR_Codigo = CLIE.EMPR_Codigo                                                                
 AND ENRE.TERC_Codigo_Cliente = CLIE.Codigo   
 
  LEFT JOIN Terceros AS REMI                                                                            
 ON ENRE.EMPR_Codigo = REMI.EMPR_Codigo                                                                            
 AND ENRE.TERC_Codigo_Remitente = REMI.Codigo   

 INNER JOIN Ciudades AS CIDO 
 ON ENPR.EMPR_Codigo = CIDO.EMPR_Codigo 
 AND   ENPR.CIUD_Codigo_Origen = CIDO.Codigo

  INNER JOIN Ciudades AS CIDD
 ON ENPR.EMPR_Codigo = CIDD.EMPR_Codigo 
 AND  ENPR.CIUD_Codigo_Destino = CIDD.Codigo

            
 WHERE            
 ENRE.EMPR_Codigo = @par_EMPR_Codigo                              
 AND ENRE.Numero_Documento = @par_Numero   
 OR ENRE.Numeracion = @par_NumeroPreimpreso  
 AND ENRE.TIDO_Codigo = 110 --> Guía       
END          
GO


