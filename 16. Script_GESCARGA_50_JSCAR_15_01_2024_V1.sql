DROP PROCEDURE gsp_consultar_remesas_por_contenedor_postal      
GO
CREATE PROCEDURE gsp_consultar_remesas_por_contenedor_postal      
(                                                                              
 @par_EMPR_Codigo SMALLINT,      
 @par_NumeroInicial NUMERIC = NULL,      
 @par_TIDO_Codigo NUMERIC = NULL,      
 @par_FechaInicial DATE = NULL,      
 @par_FechaFinal DATE = NULL,      
 @par_Ciudad_Origen NUMERIC = NULL,      
 @par_Ciudad_Destino NUMERIC = NULL,    
 @par_OFIC_Codigo_Actual NUMERIC    
)                                                                              
AS                                                                                       
BEGIN                                                                              
 IF @par_FechaInicial <> NULL BEGIN      
  SET @par_FechaInicial = CONVERT(DATE, @par_FechaInicial, 101)      
 END      
      
 IF @par_FechaFinal <> NULL BEGIN      
  SET @par_FechaFinal = CONVERT(DATE, @par_FechaFinal, 101)      
 END      
      
 SELECT       
 ENRE.EMPR_Codigo,                
 ENRE.Numero,                    
 ENRE.Numero_Documento,      
 ENRE.Numeracion,      
 ENRE.TIDO_Codigo,      
 ENRE.Fecha,      
 REPA.CIUD_Codigo_Origen,      
 CIOR.Nombre AS CiudadOrigen,      
 REPA.CIUD_Codigo_Destino,      
 CIDE.Nombre AS CiudadDestino,      
 ENRE.Cantidad_Cliente,      
 REPA.Peso_A_Cobrar,      
 ENRE.Observaciones,  
 ENRE.Valor_Flete_Cliente,  
 ENRE.Total_Flete_Cliente,  
 ENRE.CATA_FOPR_Codigo  
 FROM Remesas_Paqueteria REPA      
      
 INNER JOIN Encabezado_Remesas AS ENRE                                                                              
 ON REPA.EMPR_Codigo = ENRE.EMPR_Codigo                                                                              
 AND REPA.ENRE_Numero = ENRE.Numero      
      
 LEFT JOIN Ciudades CIOR ON      
 REPA.EMPR_Codigo = CIOR.EMPR_Codigo      
 AND REPA.CIUD_Codigo_Origen = CIOR.Codigo      
      
 LEFT JOIN Ciudades CIDE ON      
 REPA.EMPR_Codigo = CIDE.EMPR_Codigo      
 AND REPA.CIUD_Codigo_Destino = CIDE.Codigo      
      
 WHERE ENRE.EMPR_Codigo = @par_EMPR_Codigo                      
 AND ENRE.TIDO_Codigo = ISNULL(@par_TIDO_Codigo, ENRE.TIDO_Codigo)      
 AND ENRE.Numero_Documento = ISNULL(@par_NumeroInicial, ENRE.Numero_Documento)       
 AND ENRE.Fecha >= ISNULL(@par_FechaInicial, ENRE.Fecha)                                          
 AND ENRE.Fecha <= ISNULL(@par_FechaFinal, ENRE.Fecha)      
 AND REPA.CIUD_Codigo_Origen = ISNULL(@par_Ciudad_Origen, REPA.CIUD_Codigo_Origen)      
 AND REPA.CIUD_Codigo_Destino = ISNULL(@par_Ciudad_Destino, REPA.CIUD_Codigo_Destino)      
 AND REPA.OFIC_Codigo_Actual = @par_OFIC_Codigo_Actual    
 AND ISNULL(REPA.ECPM_Numero, 0) = 0      
 AND ISNULL(REPA.EDCP_Numero, 0) = 0      
 AND ENRE.Anulado = 0                                                                            
 AND ENRE.Estado = 1                      
 ORDER BY Numero ASC       
END    
GO
DROP PROCEDURE gsp_consultar_detalle_remesas_despacho_contenedor_postal_mensajeria      
GO
CREATE PROCEDURE gsp_consultar_detalle_remesas_despacho_contenedor_postal_mensajeria      
(                  
 @par_EMPR_Codigo smallint,                  
 @par_EDCP_Numero NUMERIC                  
)                  
AS                  
BEGIN                
 SELECT                 
 DRDC.EDCP_Numero,      
 DRDC.ENRE_Numero AS Numero,      
 ENRE.Numero_Documento AS Numero_Documento,      
 ENRE.Numeracion,      
 ENRE.Fecha,      
 REPA.CIUD_Codigo_Origen,      
 CIOR.Nombre AS CIUD_Nombre_Origen,      
 REPA.CIUD_Codigo_Destino,      
 CIDE.Nombre AS CIUD_Nombre_Destino,      
 ENRE.Cantidad_Cliente AS Cantidad,      
 REPA.Peso_A_Cobrar AS Peso,      
 ENRE.Observaciones,      
 ENRE.Valor_Flete_Cliente,  
 ENRE.Total_Flete_Cliente,  
 DRDC.Calcular_Contra_Entrega,  
 ENRE.CATA_FOPR_Codigo  
      
 FROM Detalle_Remesas_Despacho_Contenedor_Postal DRDC                
                
 INNER JOIN Encabezado_Remesas ENRE ON                
 DRDC.EMPR_Codigo = ENRE.EMPR_Codigo                
 AND DRDC.ENRE_Numero = ENRE.Numero        
      
 INNER JOIN Remesas_Paqueteria REPA ON                
 ENRE.EMPR_Codigo = REPA.EMPR_Codigo                
 AND ENRE.Numero = REPA.ENRE_Numero      
      
 LEFT JOIN Ciudades CIOR ON      
 REPA.EMPR_Codigo = CIOR.EMPR_Codigo      
 AND REPA.CIUD_Codigo_Origen = CIOR.Codigo      
      
 LEFT JOIN Ciudades CIDE ON      
 REPA.EMPR_Codigo = CIDE.EMPR_Codigo      
 AND REPA.CIUD_Codigo_Destino = CIDE.Codigo      
      
 WHERE DRDC.EMPR_Codigo = @par_EMPR_Codigo            
 AND DRDC.EDCP_Numero = @par_EDCP_Numero            
END      
GO