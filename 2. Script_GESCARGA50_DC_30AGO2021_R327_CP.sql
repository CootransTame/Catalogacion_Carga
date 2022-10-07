PRINT 'Insertar VALOR Cuentas por cobrar'

insert into Valor_Catalogos (EMPR_Codigo,Codigo,CATA_Codigo	,Campo1,Estado,USUA_Codigo_Crea,Fecha_Crea)
select Codigo,14511,145,'Cuentas X Cobrar',1,	1	,Getdate() from Empresas

PRINT 'V_Comprobantes_Cuentas_Cobro_CONTAI'
/****** Object:  View [dbo].[V_Comprobantes_Cuentas_Cobro_CONTAI]    Script Date: 30/08/2021 3:15:40 p. m. ******/
DROP VIEW [dbo].[V_Comprobantes_Cuentas_Cobro_CONTAI]
GO

/****** Object:  View [dbo].[V_Comprobantes_Cuentas_Cobro_CONTAI]    Script Date: 30/08/2021 3:15:40 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[V_Comprobantes_Cuentas_Cobro_CONTAI]                                 
AS 
 
select       
  ENDC.EMPR_Codigo      
 ,ENDC.Codigo      
 ,ENDC.Numero      
 ,ENDC.TIDO_Codigo      
 ,ENDC.Codigo_Alterno       
 ,PLUC.Codigo as Cod_PUC          
 ,PLUC.Codigo_Cuenta       
 ,OFIC.Codigo_Alterno AS Codigo_Alterno_Oficina               
 ,OFIC.Codigo  AS Codigo_Oficina      
 ,TERC.Numero_Identificacion      
 ,CONVERT(VARCHAR, ENDC.Fecha, 101) AS Fecha        
 ,2 Tipo     
 ,ENDC.TERC_Codigo       
 ,ENDC.CATA_DOOR_Codigo      
 ,ENDC.Codigo_Concepto      
 ,ENDC.Codigo_Documento_Origen      
 ,ENDC.Documento_Origen      
 ,ENDC.Observaciones       
 ,ENDC.PLUC_Codigo  
 ,ENDC.Valor_Total    as Valor_Credito  
 ,0   as Valor_Debito  
 ,0 as Valor_Base   
 ,ENDC.Abono       
 ,ENDC.Saldo      
 ,ENDC.Estado      
 ,ENDC.Anulado      
 from Encabezado_Documento_Cuentas  ENDC      
      
 left JOIN Plan_Unico_Cuentas  PLUC                        
 ON PLUC.EMPR_Codigo = ENDC.EMPR_Codigo                       
 and  PLUC.Codigo = ENDC.PLUC_Codigo                            
                       
 INNER JOIN  Oficinas  OFIC                          
 ON OFIC.EMPR_Codigo = ENDC.EMPR_Codigo                           
 AND OFIC.Codigo =  ENDC.OFIC_Codigo         
               
 INNER JOIN  Terceros TERC                          
 ON TERC.EMPR_Codigo = ENDC.EMPR_Codigo                         
 AND TERC.Codigo =   ENDC.TERC_Codigo  
 
  UNION all    
  select       
  ENDC.EMPR_Codigo      
 ,ENDC.Codigo      
 ,ENDC.Numero      
 ,ENDC.TIDO_Codigo      
 ,ENDC.Codigo_Alterno       
 ,PLUC.Codigo as Cod_PUC          
 ,PLUC.Codigo_Cuenta       
 ,OFIC.Codigo_Alterno AS Codigo_Alterno_Oficina               
 ,OFIC.Codigo  AS Codigo_Oficina      
 ,TERC.Numero_Identificacion      
 ,CONVERT(VARCHAR, ENDC.Fecha, 101) AS Fecha        
 ,1 Tipo     
 ,ENDC.TERC_Codigo       
 ,ENDC.CATA_DOOR_Codigo      
 ,ENDC.Codigo_Concepto      
 ,ENDC.Codigo_Documento_Origen      
 ,ENDC.Documento_Origen      
 ,ENDC.Observaciones       
 ,ENDC.PLUC_Codigo      
 ,0 as Valor_Credito  
 ,ENDC.Valor_Total    as Valor_Debito  
 ,0 as Valor_Base  
 ,ENDC.Abono       
 ,ENDC.Saldo      
 ,ENDC.Estado      
 ,ENDC.Anulado      
 from Encabezado_Documento_Cuentas  ENDC      
      
 left JOIN Plan_Unico_Cuentas  PLUC                        
 ON PLUC.EMPR_Codigo = ENDC.EMPR_Codigo                       
 and  PLUC.Codigo = ENDC.PLUC_Codigo                            
                       
 INNER JOIN  Oficinas  OFIC                          
 ON OFIC.EMPR_Codigo = ENDC.EMPR_Codigo                           
 AND OFIC.Codigo =  ENDC.OFIC_Codigo         
               
 INNER JOIN  Terceros TERC                          
 ON TERC.EMPR_Codigo = ENDC.EMPR_Codigo                         
 AND TERC.Codigo =   ENDC.TERC_Codigo 
 
 
GO

print 'gsp_Cambiar_estados_Trazabilidad_Guias'
 
/****** Object:  StoredProcedure [dbo].[gsp_Cambiar_estados_Trazabilidad_Guias]    Script Date: 30/08/2021 5:40:35 p. m. ******/
DROP PROCEDURE [dbo].[gsp_Cambiar_estados_Trazabilidad_Guias]
GO

/****** Object:  StoredProcedure [dbo].[gsp_Cambiar_estados_Trazabilidad_Guias]    Script Date: 30/08/2021 5:40:35 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[gsp_Cambiar_estados_Trazabilidad_Guias] (      
@par_EMPR_Codigo           SMALLINT,--EMPRESA                                         
@par_CATA_ESRP_Codigo      NUMERIC (18, 0),      
@par_ENRE_Numero           NUMERIC (18, 0) = NULL,      
@par_ENPD_Numero           NUMERIC (18, 0) = NULL,      
@par_Numero_Documento      NUMERIC (18, 0) = NULL,      
@par_VEHI_Codigo           NUMERIC (18, 0) = NULL,      
@par_TERC_Codigo_Conductor NUMERIC (18, 0) = NULL,      
@par_Usuario_modifica      NUMERIC,      
@par_ModificarLegalizarGuias       NUMERIC,      
@par_OFIC_Codigo_Actual    NUMERIC = NULL)      
AS      
  BEGIN      
   
 IF @par_ModificarLegalizarGuias  = 1  
   BEGIN   
 UPDATE Remesas_Paqueteria  set  Legalizo_Guia=NULL    
 WHERE  EMPR_Codigo = @par_EMPR_Codigo      
     AND ENRE_Numero = @par_ENRE_Numero  
     
 UPDATE Detalle_Legalizacion_Guias  set   
 Legalizo=0 , Entrega_recaudo=0  
 WHERE  EMPR_Codigo = @par_EMPR_Codigo      
           AND ENRE_Numero  = @par_ENRE_Numero   
 END   
   
    

		 
  delete  Detalle_Estados_Remesas_Paqueteria  
where  ID = (
  select MAX(id) 
from Detalle_Estados_Remesas_Paqueteria 
	Where  EMPR_Codigo = @par_EMPR_Codigo
		AND ENRE_Numero = @par_ENRE_Numero
		AND CATA_ESPR_Codigo = 6030 
)

		
  DELETE   FROM Cumplido_Remesas where   ENRE_Numero = @par_ENRE_Numero  
  
   IF @par_CATA_ESRP_Codigo = 6010      
        BEGIN      
            ---UPDATE PLANILLA        
            INSERT INTO detalle_planilla_despachos      
                        (EMPR_Codigo,      
                         ENPD_Numero,      
                         TIDO_Codigo,      
                         ENRE_Numero,      
                         Numero_Documento_Remesa)      
            VALUES      ( @par_EMPR_Codigo,      
                          @par_ENPD_Numero,      
                          135,      
                          @par_ENRE_Numero,      
                          @par_Numero_Documento);      
      
            UPDATE Encabezado_Remesas      
            SET    ENPD_Numero = @par_ENPD_Numero,      
                   VEHI_Codigo = @par_VEHI_Codigo,      
                   TERC_Codigo_Conductor = @par_TERC_Codigo_Conductor,      
                   USUA_Codigo_Modifica = @par_Usuario_modifica      
            WHERE  EMPR_Codigo = @par_EMPR_Codigo      
                   AND Numero = @par_ENRE_Numero      
      
            UPDATE Remesas_Paqueteria      
            SET    CATA_ESRP_Codigo = 6010,      
                   ENPD_Numero_Ultima_Planilla = @par_ENPD_Numero      
            WHERE  EMPR_Codigo = @par_EMPR_Codigo      
                   AND ENRE_Numero = @par_ENRE_Numero      
      
            SELECT @@ROWCOUNT AS Numero      
        END      
   ELSE      
        BEGIN      
      
            UPDATE Encabezado_Remesas      
            SET    ENPD_Numero = 0,      
                   VEHI_Codigo = 0,      
                   USUA_Codigo_Modifica = @par_Usuario_modifica      
            WHERE  EMPR_Codigo = @par_EMPR_Codigo      
                   AND numero = @par_ENRE_Numero       
      
            UPDATE Remesas_Paqueteria      
            SET    OFIC_Codigo_Actual = @par_OFIC_Codigo_Actual,      
                   ENPD_Numero_Ultima_Planilla = 0,      
                   CATA_ESRP_Codigo = 6005            
            WHERE  EMPR_Codigo = @par_EMPR_Codigo      
                   AND ENRE_Numero = @par_ENRE_Numero      
      
                 
      
            SELECT @@ROWCOUNT AS Numero      
        END      
  END 
GO


print 'gsp_insertar_detalle_remesas_planilla_paqueteria'

 

/****** Object:  StoredProcedure [dbo].[gsp_insertar_detalle_remesas_planilla_paqueteria]    Script Date: 30/08/2021 5:43:08 p. m. ******/
DROP PROCEDURE [dbo].[gsp_insertar_detalle_remesas_planilla_paqueteria]
GO

/****** Object:  StoredProcedure [dbo].[gsp_insertar_detalle_remesas_planilla_paqueteria]    Script Date: 30/08/2021 5:43:08 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[gsp_insertar_detalle_remesas_planilla_paqueteria]      
(                          
 @par_EMPR_Codigo smallint                    
 ,@par_ENPD_Numero NUMERIC                    
 ,@par_TIDO_Codigo_Planilla NUMERIC                    
 ,@par_ENRE_Numero NUMERIC                  
 ,@par_ENRE_Valor_Reexpedicion MONEY = NULL                 
 ,@par_Numero_Documento_Remesa NUMERIC                    
 ,@par_USUA_Codigo_Crea NUMERIC                    
 ,@par_ENRE_Numero_Documento_Masivo  NUMERIC = null                    
 ,@par_ENRE_Numero_Masivo NUMERIC = null                    
 ,@par_VEHI_Codigo NUMERIC = NULL                    
 ,@par_TERC_Codigo_Conductor NUMERIC = NULL  
 ,@par_Estado_Planilla NUMERIC = NULL  
)                          
AS                          
BEGIN      
 DECLARE @CATA_TPGP_ENTREGA NUMERIC = 23701    
DECLARE @OFIC_Codigo NUMERIC   
 --Inserta el seguimiento de la planilla despachos                        
 INSERT INTO Detalle_Planilla_Despachos                    
 (EMPR_Codigo                          
 ,ENPD_Numero                          
 ,ENRE_Numero                          
 ,Numero_Documento_Remesa                      
 ,TIDO_Codigo      
 ,CATA_TPGP_Codigo      
 )                          
 VALUES                          
 (@par_EMPR_Codigo                           
 ,@par_ENPD_Numero                           
 ,@par_ENRE_Numero                           
 ,@par_Numero_Documento_Remesa                      
 ,@par_TIDO_Codigo_Planilla      
 ,@CATA_TPGP_ENTREGA      
 )               
              
 UPDATE Encabezado_Remesas SET ENPD_Numero = @par_ENPD_Numero,         
 VEHI_Codigo = @par_VEHI_Codigo,                    
 TERC_Codigo_Conductor = @par_TERC_Codigo_Conductor,                  
 Valor_Reexpedicion = ISNULL(@par_ENRE_Valor_Reexpedicion, Valor_Reexpedicion) ,    
 USUA_Codigo_Modifica =  @par_USUA_Codigo_Crea    
 WHERE EMPR_Codigo = @par_EMPR_Codigo AND Numero = @par_ENRE_Numero AND TIDO_Codigo = 110;            
            
 UPDATE Remesas_Paqueteria SET CATA_ESRP_Codigo = 6010,                    
 ENRE_Numero_Masivo = ISNULL(@par_ENRE_Numero_Masivo, ENRE_Numero_Masivo),             
 ENRE_Numero_Documento_Masivo = ISNULL(@par_ENRE_Numero_Documento_Masivo, ENRE_Numero_Documento_Masivo),        
 ENPD_Numero_Ultima_Planilla =  @par_ENPD_Numero,        
 TERC_Codigo_Ultimo_Conductor =  @par_TERC_Codigo_Conductor        
 WHERE EMPR_Codigo = @par_EMPR_Codigo AND ENRE_Numero = @par_ENRE_Numero;            
  
  select @OFIC_Codigo =( select OFIC_Codigo  from Encabezado_Planilla_Despachos  
 where Numero =@par_ENPD_Numero)  
  
  
     IF (@par_Estado_Planilla = 1)--Validar estado planilla           
 BEGIN  
 exec gsp_insertar_estado_remesa_paqueteria @par_EMPR_Codigo,@par_ENRE_Numero,6010,@par_USUA_Codigo_Crea,@par_ENPD_Numero, @OFIC_Codigo,@par_TERC_Codigo_Conductor  
END                     
 UPDATE Detalle_Novedades_Despacho set ENPD_Numero = @par_ENPD_Numero where EMPR_Codigo = @par_EMPR_Codigo AND ENRE_Numero = @par_ENRE_Numero;                    
 --EXEC gsp_actualizar_totales_fletes_cliente @par_EMPR_Codigo, @par_ENPD_Numero              
              
 SELECT @par_ENPD_Numero AS Numero        
END 
GO




