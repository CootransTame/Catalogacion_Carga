ALTER TABLE Encabezado_Despacho_Contenedor_Postal ADD
Valor_Remesas_No_Contenidas NUMERIC (19,4)
GO
ALTER TABLE remesas_paqueteria ADD EDCP_Numero NUMERIC NULL
GO
CREATE TABLE [dbo].[Detalle_Remesas_Despacho_Contenedor_Postal](
	[EMPR_Codigo] [smallint] NOT NULL,
	[EDCP_Numero] [numeric](18, 0) NOT NULL,
	[ENRE_Numero] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_Detalle_Remesas_Despacho_Contenedor_Postal] PRIMARY KEY CLUSTERED 
(
	[EMPR_Codigo] ASC,
	[EDCP_Numero] ASC,
	[ENRE_Numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE Marca_Motores
(
EMPR_Codigo	smallint,
Codigo numeric identity(1,1),
Nombre NVARCHAR(500),
Estado	smallint,
USUA_Codigo_Crea	smallint,
Fecha_Crea	datetime,
USUA_Codigo_Modifica	smallint null,
Fecha_Modifica	datetime null,
CONSTRAINT [PK_Marca_Motores] PRIMARY KEY CLUSTERED 
(
	EMPR_Codigo ASC,
	Codigo ASC
)
)ON [PRIMARY]
GO
CREATE TABLE Linea_Motores
(
EMPR_Codigo	smallint ,
Codigo  numeric identity(1,1),
MAMO_Codigo numeric,
Nombre NVARCHAR(500),
Estado	smallint,
USUA_Codigo_Crea	smallint,
Fecha_Crea	datetime,
USUA_Codigo_Modifica	smallint null,
Fecha_Modifica	datetime null,
CONSTRAINT [PK_Linea_Motores] PRIMARY KEY CLUSTERED 
(
	EMPR_Codigo ASC,
	Codigo ASC,
	MAMO_Codigo ASC
)
)ON [PRIMARY]

GO
CREATE TABLE Norma_Emisiones
(
EMPR_Codigo	smallint,
Codigo numeric identity(1,1),
Nombre NVARCHAR(500),
Estado	smallint,
USUA_Codigo_Crea	smallint,
Fecha_Crea	datetime,
USUA_Codigo_Modifica	smallint null,
Fecha_Modifica	datetime null,
CONSTRAINT [PK_Norma_Emisiones] PRIMARY KEY CLUSTERED 
(
	EMPR_Codigo ASC,
	Codigo ASC
)
)ON [PRIMARY]
GO
ALTER TABLE Vehiculos ADD
MAMO_Codigo NUMERIC NULL,
LIMO_Codigo NUMERIC NULL,
NOEM_Codigo NUMERIC NULL
GO
ALTER TABLE Semirremolques ADD
CATA_LISE_Codigo NUMERIC NULL
GO
set  identity_insert Marca_Motores on
insert into Marca_Motores
(
EMPR_Codigo,
Codigo,
Nombre,
Estado,
USUA_Codigo_Crea,
Fecha_Crea,
USUA_Codigo_Modifica,
Fecha_Modifica
)
values (1,0,'(NO APLICA)',0,1,NULL,NULL,NULL)
set  identity_insert Marca_Motores oFF
GO

set  identity_insert Norma_Emisiones on
insert into Norma_Emisiones
(
EMPR_Codigo,
Codigo,
Nombre,
Estado,
USUA_Codigo_Crea,
Fecha_Crea,
USUA_Codigo_Modifica,
Fecha_Modifica
)
values (1,0,'(NO APLICA)',0,1,NULL,NULL,NULL)
set  identity_insert Norma_Emisiones oFF
GO

set  identity_insert LINEA_Motores on
insert into LINEA_Motores
(
EMPR_Codigo,
Codigo,
MAMO_Codigo,
Nombre,
Estado,
USUA_Codigo_Crea,
Fecha_Crea,
USUA_Codigo_Modifica,
Fecha_Modifica
)
values (1,0,0,'(NO APLICA)',0,1,NULL,NULL,NULL)
set  identity_insert LINEA_Motores oFF
GO

DELETE Permiso_Grupo_Usuarios WHERE MEAP_Codigo = 100913
GO
DELETE Menu_Aplicaciones WHERE Codigo = 100913
GO
INSERT INTO Menu_Aplicaciones( 
EMPR_Codigo,
Codigo,
MOAP_Codigo,
Nombre,
Padre_Menu,
Orden_Menu,
Mostrar_Menu,
Aplica_Habilitar,
Aplica_Consultar,
Aplica_Actualizar,
Aplica_Eliminar_Anular,
Aplica_Imprimir,
Aplica_Contabilidad,
Opcion_Permiso,
Opcion_Listado,
Aplica_Ayuda,
Url_Pagina,
Url_Ayuda) 
VALUES(
1
,100913
,10
,'Marca Motores'
,1009
,112
,1
,1
,1
,1
,1
,1
,1
,0
,0
,0
,'#!ConsultarMarcaMotores'
,'#!'
)
GO
INSERT INTO Permiso_Grupo_Usuarios(
EMPR_Codigo,
MEAP_Codigo,
GRUS_Codigo,
Habilitar,
Consultar,
Actualizar,
Eliminar_Anular,
Imprimir,
Permiso,
Contabilidad
) 
VALUES (
1,
100913,
1,
1,
1,
1,
1,
1,
0,
0
) 
GO
DELETE Permiso_Grupo_Usuarios WHERE MEAP_Codigo = 100914
GO
DELETE Menu_Aplicaciones WHERE Codigo = 100914
GO
INSERT INTO Menu_Aplicaciones( 
EMPR_Codigo,
Codigo,
MOAP_Codigo,
Nombre,
Padre_Menu,
Orden_Menu,
Mostrar_Menu,
Aplica_Habilitar,
Aplica_Consultar,
Aplica_Actualizar,
Aplica_Eliminar_Anular,
Aplica_Imprimir,
Aplica_Contabilidad,
Opcion_Permiso,
Opcion_Listado,
Aplica_Ayuda,
Url_Pagina,
Url_Ayuda) 
VALUES(
1
,100914
,10
,'Linea Motores'
,1009
,113
,1
,1
,1
,1
,1
,1
,1
,0
,0
,0
,'#!ConsultarLineaMotores'
,'#!'
)
GO
INSERT INTO Permiso_Grupo_Usuarios(
EMPR_Codigo,
MEAP_Codigo,
GRUS_Codigo,
Habilitar,
Consultar,
Actualizar,
Eliminar_Anular,
Imprimir,
Permiso,
Contabilidad
) 
VALUES (
1,
100914,
1,
1,
1,
1,
1,
1,
0,
0
) 
GO
DELETE Permiso_Grupo_Usuarios WHERE MEAP_Codigo = 100915
GO
DELETE Menu_Aplicaciones WHERE Codigo = 100915
GO
INSERT INTO Menu_Aplicaciones( 
EMPR_Codigo,
Codigo,
MOAP_Codigo,
Nombre,
Padre_Menu,
Orden_Menu,
Mostrar_Menu,
Aplica_Habilitar,
Aplica_Consultar,
Aplica_Actualizar,
Aplica_Eliminar_Anular,
Aplica_Imprimir,
Aplica_Contabilidad,
Opcion_Permiso,
Opcion_Listado,
Aplica_Ayuda,
Url_Pagina,
Url_Ayuda) 
VALUES(
1
,100915
,10
,'Norma Emisiones'
,1009
,114
,1
,1
,1
,1
,1
,1
,1
,0
,0
,0
,'#!ConsultarNormaEmisiones'
,'#!'
)
GO
INSERT INTO Permiso_Grupo_Usuarios(
EMPR_Codigo,
MEAP_Codigo,
GRUS_Codigo,
Habilitar,
Consultar,
Actualizar,
Eliminar_Anular,
Imprimir,
Permiso,
Contabilidad
) 
VALUES (
1,
100915,
1,
1,
1,
1,
1,
1,
0,
0
) 
GO
DROP PROCEDURE gsp_insertar_Detalle_Remesas_Despacho_Contenedor_Postal  
GO
CREATE PROCEDURE gsp_insertar_Detalle_Remesas_Despacho_Contenedor_Postal  
(    
 @par_EMPR_Codigo smallint,                
 @par_EDCP_Numero NUMERIC,              
 @par_ENRE_Numero NUMERIC,  
 @par_OFIC_Codigo NUMERIC,    
 @par_USUA_Codigo_Crea NUMERIC,    
 @par_Estado_Despacho NUMERIC,
 @par_Calcular_Contra_Entrega SMALLINT = NULL
)                
AS                
BEGIN    
     
 IF(NOT EXISTS(SELECT EDCP_Numero FROM Detalle_Remesas_Despacho_Contenedor_Postal           
 WHERE EMPR_Codigo = @par_EMPR_Codigo AND EDCP_Numero = @par_EDCP_Numero AND ENRE_Numero = @par_ENRE_Numero)          
 )    
 BEGIN    
  INSERT INTO Detalle_Remesas_Despacho_Contenedor_Postal(                
  EMPR_Codigo    
  ,EDCP_Numero    
  ,ENRE_Numero 
  ,Calcular_Contra_Entrega
  )                
  VALUES(                
  @par_EMPR_Codigo    
  ,@par_EDCP_Numero    
  ,@par_ENRE_Numero   
  ,@par_Calcular_Contra_Entrega
  )          
    
  UPDATE remesas_paqueteria SET EDCP_Numero = @par_EDCP_Numero,CATA_ESRP_Codigo = 6010  WHERE EMPR_Codigo = @par_EMPR_Codigo AND ENRE_Numero = @par_ENRE_Numero    
   IF (@par_Estado_Despacho = 1)--Validar estado documento              
   BEGIN    
    EXEC gsp_insertar_estado_remesa_paqueteria @par_EMPR_Codigo,@par_ENRE_Numero,6010,@par_USUA_Codigo_Crea,@par_EDCP_Numero,@par_OFIC_Codigo,0    
   END    
  SELECT @par_EDCP_Numero AS Numero   
 END    
 ELSE    
 BEGIN    
  SELECT -1 AS Numero    
 END    
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
 REPA.CIUD_Codigo_Origen,    
 CIOR.Nombre AS CIUD_Nombre_Origen,    
 REPA.CIUD_Codigo_Destino,    
 CIDE.Nombre AS CIUD_Nombre_Destino,    
 ENRE.Cantidad_Cliente AS Cantidad,    
 REPA.Peso_A_Cobrar AS Peso,    
 ENRE.Observaciones,    
 ENRE.Valor_Flete_Cliente,
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
DROP PROCEDURE gsp_anular_despacho_contenedor_postal      
GO
CREATE PROCEDURE gsp_anular_despacho_contenedor_postal      
(                  
 @par_EMPR_Codigo smallint,                  
 @par_Numero NUMERIC,                  
 @par_USUA_Codigo_Anula smallint,                  
 @par_Causa_Anula VARCHAR(150)                  
)                  
AS                  
BEGIN   
 --Actualiza estado de la guia  
 UPDATE REPA SET REPA.CATA_ESRP_Codigo = 6005                       
 FROM Remesas_Paqueteria AS REPA                       
 INNER JOIN  Encabezado_Contenedor_Postal_Mensajeria AS ECPM                       
 ON REPA.EMPR_Codigo = ECPM.EMPR_Codigo                       
 AND REPA.ECPM_Numero = ECPM.Numero                      
 WHERE ECPM.EMPR_Codigo = @par_EMPR_Codigo AND ECPM.EDCP_Numero = @par_Numero    

 UPDATE Remesas_Paqueteria SET CATA_ESRP_Codigo = 6005, EDCP_Numero = 0                       
 FROM Remesas_Paqueteria                      
 WHERE EMPR_Codigo = @par_EMPR_Codigo AND EDCP_Numero = @par_Numero    
  
 UPDATE Encabezado_Despacho_Contenedor_Postal SET Anulado = 1, USUA_Codigo_Anula = @par_USUA_Codigo_Anula, Causa_Anula = @par_Causa_Anula, Fecha_Anula = GETDATE()    
 WHERE EMPR_Codigo = @par_EMPR_Codigo AND Numero = @par_Numero    
    
 UPDATE Encabezado_Contenedor_Postal_Mensajeria  SET EDCP_Numero = 0        
 WHERE EMPR_Codigo = @par_EMPR_Codigo        
 AND EDCP_Numero = @par_Numero    
    
 SELECT @par_Numero AS Numero    
END  
GO
DROP PROCEDURE gsp_eliminar_detalle_remesa_Despacho_contenedor_postal    
GO
CREATE PROCEDURE gsp_eliminar_detalle_remesa_Despacho_contenedor_postal    
(        
 @par_EMPR_Codigo smallint,  
 @par_ENRE_Numero NUMERIC,  
 @par_EDCP_Numero NUMERIC  
)        
AS        
BEGIN        
 DELETE Detalle_Remesas_Despacho_Contenedor_Postal        
 WHERE EMPR_Codigo = @par_EMPR_Codigo        
 AND ENRE_Numero = @par_ENRE_Numero        
 AND EDCP_Numero = @par_EDCP_Numero        
        
 UPDATE Remesas_Paqueteria  SET CATA_ESRP_Codigo = 6005, EDCP_Numero = 0  
 WHERE EMPR_Codigo = @par_EMPR_Codigo        
 AND ENRE_Numero = @par_ENRE_Numero    
 
END  
GO
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
 @par_USUA_Codigo_Crea NUMERIC    
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
 )      
 SET @NumeroInterno = @@IDENTITY          
 SELECT @NumeroInterno AS Numero, @Numero AS Numero_Documento         
END  
GO
DROP PROCEDURE gsp_modificar_despacho_contenedor_postal  
GO
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
 @par_USUA_Codigo_Crea NUMERIC      
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
 USUA_Codigo_Modifica = @par_USUA_Codigo_Crea    
        
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
 OFIC.Nombre OFIC_Nombre  
        
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
DROP PROCEDURE gsp_consultar_vehiculos_Autocomplete                            
GO
CREATE PROCEDURE gsp_consultar_vehiculos_Autocomplete                            
(                                            
@par_EMPR_Codigo SMALLINT,                                            
@par_Filtro VARCHAR(100) = NULL,                                                              
@par_Codigo NUMERIC = null       ,                                  
@par_Estado NUMERIC = null ,                                        
@par_Conductor NUMERIC = null,    
@par_Fecha_Vigencia datetime = null,    
@par_Consulta_Cierres_Mantimiento NUMERIC = null 
)                                            
AS                                            
BEGIN                 
    
    
IF @par_Codigo > 0                        
BEGIN                        
SELECT TOP(20)                                           
 COND.EMPR_Codigo,                                            
 VEHI.Placa,                                            
 VEHI.Codigo,                                            
 VEHI.Codigo_Alterno,          
 VEHI.Modelo,          
 VEHI.Numero_Motor,           
 VEHI.TERC_Codigo_Propietario,                                           
 ISNULL(COND.Razon_Social,'') + ' ' + ISNULL(COND.Nombre,'') + ' ' + ISNULL(COND.Apellido1,'') + ' ' + ISNULL(COND.Apellido2,'') As NombreConductor,                                            
 COND.Numero_Identificacion As IdentificacionConductor,                                            
 VEHI.TERC_Codigo_Conductor,                                            
 ISNULL(TENE.Razon_Social,'') + ' ' + ISNULL(TENE.Nombre,'') + ' ' + ISNULL(TENE.Apellido1,'') + ' ' + ISNULL(TENE.Apellido2,'') As NombreTenedor,                                            
 TENE.Numero_Identificacion As IdentificacionTenedor,                                            
 VEHI.TERC_Codigo_Tenedor,                                            
 VEHI.Estado,                                            
 VEHI.Capacidad_Kilos AS Capacidad,                                            
 CASE WHEN VEHI.Estado = 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS EstadoVehiculo,                                            
 VEHI.CATA_TIVE_Codigo,                                            
 TIVE.Campo1 as TipoVehiculo,                                
 ISNULL(TIVE.Campo3,0) as AplicaSemirremolque,                                          
 SEMI.Placa as PlacaSemirremolque,                                            
 SEMI.Codigo as CodigoSemirremolque,                                    
 VEHI.Justificacion_Bloqueo,                    
 VEHI.CATA_TIDV_Codigo,                
 VEHI.SEMI_Codigo,              
 (SELECT SUM(Total_Puntos) FROM Plan_Puntos_Vehiculos where EMPR_Codigo = VEHI.EMPR_Codigo and VEHI_Codigo = VEHI.Codigo) as Puntos,                          
 ROW_NUMBER() OVER(ORDER BY VEHI.Codigo) AS RowNumber                                            
FROM                                            
 Vehiculos AS VEHI                                           
 LEFT JOIN Semirremolques SEMI ON                                          
 VEHI.EMPR_Codigo = SEMI.EMPR_Codigo                                            
 AND VEHI.SEMI_Codigo = SEMI.Codigo                   
                   
LEFT JOIN Terceros COND ON                      
COND.EMPR_Codigo = VEHI.EMPR_Codigo                                          
AND COND.Codigo = VEHI.TERC_Codigo_Conductor                  
                                       
LEFT JOIN Terceros TENE ON                  
TENE.EMPR_Codigo = VEHI.EMPR_Codigo                                          
AND TENE.Codigo = VEHI.TERC_Codigo_Tenedor                  
                                          
LEFT JOIN Valor_Catalogos TIVE ON                  
VEHI.EMPR_Codigo = TIVE.EMPR_Codigo                                          
AND VEHI.CATA_TIVE_Codigo = TIVE.Codigo         
    
                                          
WHERE                                            
VEHI.Codigo != 0                                            
 AND (VEHI.Codigo = @par_Codigo OR @par_Codigo IS NULL)          
 AND VEHI.EMPR_Codigo = @par_EMPR_Codigo                                            
 AND ((VEHI.Placa LIKE '%' + @par_Filtro + '%') OR  (VEHI.Codigo_Alterno LIKE '%' + @par_Filtro + '%') OR (@par_Filtro IS NULL))                                            
 AND (VEHI.TERC_Codigo_Conductor = @par_Conductor OR @par_Conductor IS NULL)                            
 --AND VEHI.TERC_Codigo_Conductor NOT IN (select Codigo from Terceros where Estado = 0)                
END                            
ELSE IF @par_Consulta_Cierres_Mantimiento > 0
BEGIN
SELECT DISTINCT TOP(20)                                           
 COND.EMPR_Codigo,                                            
 VEHI.Placa,                               
 VEHI.Codigo,                                            
 VEHI.Codigo_Alterno,          
 VEHI.Modelo,          
 VEHI.Numero_Motor,          
 VEHI.TERC_Codigo_Propietario,                                             
 ISNULL(COND.Razon_Social,'') + ' ' + ISNULL(COND.Nombre,'') + ' ' + ISNULL(COND.Apellido1,'') + ' ' + ISNULL(COND.Apellido2,'') As NombreConductor,                     
 COND.Numero_Identificacion As IdentificacionConductor,                                            
 VEHI.TERC_Codigo_Conductor,                                            
 ISNULL(TENE.Razon_Social,'') + ' ' + ISNULL(TENE.Nombre,'') + ' ' + ISNULL(TENE.Apellido1,'') + ' ' + ISNULL(TENE.Apellido2,'') As NombreTenedor,                                            
 TENE.Numero_Identificacion As IdentificacionTenedor,                                            
 VEHI.TERC_Codigo_Tenedor,                                            
 VEHI.Estado AS Estado,                                            
 VEHI.Capacidad_Kilos AS Capacidad,                                            
 CASE WHEN VEHI.Estado = 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS EstadoVehiculo,                                            
 VEHI.CATA_TIVE_Codigo,                                            
 TIVE.Campo1 as TipoVehiculo,                                
 ISNULL(TIVE.Campo3,0) as AplicaSemirremolque,                                          
 SEMI.Placa as PlacaSemirremolque,                                            
 SEMI.Codigo as CodigoSemirremolque,               
 VEHI.SEMI_Codigo,                                   
 VEHI.Justificacion_Bloqueo,                  
 VEHI.CATA_TIDV_Codigo,                
 (SELECT SUM(Total_Puntos) FROM Plan_Puntos_Vehiculos where EMPR_Codigo = VEHI.EMPR_Codigo and VEHI_Codigo = VEHI.Codigo) as Puntos                      
 --ROW_NUMBER() OVER(ORDER BY VEHI.Codigo) AS RowNumber                                            
FROM                                            
 Vehiculos AS VEHI                                           
 LEFT JOIN Semirremolques SEMI ON                                          
 VEHI.EMPR_Codigo = SEMI.EMPR_Codigo                                            
 AND VEHI.SEMI_Codigo = SEMI.Codigo                   
                   
LEFT JOIN Terceros COND ON                      
COND.EMPR_Codigo = VEHI.EMPR_Codigo                                          
AND COND.Codigo = VEHI.TERC_Codigo_Conductor                  
                                       
LEFT JOIN Terceros TENE ON                  
TENE.EMPR_Codigo = VEHI.EMPR_Codigo                                          
AND TENE.Codigo = VEHI.TERC_Codigo_Tenedor                  
                                          
LEFT JOIN Valor_Catalogos TIVE ON                  
VEHI.EMPR_Codigo = TIVE.EMPR_Codigo                                          
AND VEHI.CATA_TIVE_Codigo = TIVE.Codigo                  
   
                                          
WHERE            
(    
VEHI.Codigo != 0                                            
 AND (VEHI.Codigo = @par_Codigo OR @par_Codigo IS NULL)                                      
 AND VEHI.EMPR_Codigo = @par_EMPR_Codigo                                            
 AND ((VEHI.Placa LIKE '%' + @par_Filtro + '%') OR  (VEHI.Codigo_Alterno LIKE '%' + @par_Filtro + '%') OR (@par_Filtro IS NULL))                                            
 AND (VEHI.TERC_Codigo_Conductor = @par_Conductor OR @par_Conductor IS NULL)                            
 AND VEHI.TERC_Codigo_Conductor NOT IN (select Codigo from Terceros where Estado = 0)                      
 )    
 OR (    
  VEHI.Codigo != 0      
  AND (VEHI.Codigo = @par_Codigo OR @par_Codigo IS NULL)                                      
  AND VEHI.EMPR_Codigo = @par_EMPR_Codigo                                            
  AND ((VEHI.Placa LIKE '%' + @par_Filtro + '%') OR  (VEHI.Codigo_Alterno LIKE '%' + @par_Filtro + '%') OR (@par_Filtro IS NULL))                                            
  AND (VEHI.TERC_Codigo_Conductor = @par_Conductor OR @par_Conductor IS NULL)                            
  
 )   
END
ELSE                 
BEGIN                        
SELECT DISTINCT TOP(20)                                           
 COND.EMPR_Codigo,                                            
 VEHI.Placa,                               
 VEHI.Codigo,                                            
 VEHI.Codigo_Alterno,          
 VEHI.Modelo,          
 VEHI.Numero_Motor,          
 VEHI.TERC_Codigo_Propietario,                                             
 ISNULL(COND.Razon_Social,'') + ' ' + ISNULL(COND.Nombre,'') + ' ' + ISNULL(COND.Apellido1,'') + ' ' + ISNULL(COND.Apellido2,'') As NombreConductor,                     
 COND.Numero_Identificacion As IdentificacionConductor,                                            
 VEHI.TERC_Codigo_Conductor,                                            
 ISNULL(TENE.Razon_Social,'') + ' ' + ISNULL(TENE.Nombre,'') + ' ' + ISNULL(TENE.Apellido1,'') + ' ' + ISNULL(TENE.Apellido2,'') As NombreTenedor,                                            
 TENE.Numero_Identificacion As IdentificacionTenedor,                                            
 VEHI.TERC_Codigo_Tenedor,                                            
 CASE WHEN (@par_Fecha_Vigencia BETWEEN AUMA.Fecha AND AUMA.Fecha_vigencia) THEN 1 ELSE VEHI.Estado END AS Estado,                                            
 VEHI.Capacidad_Kilos AS Capacidad,                                            
 CASE WHEN VEHI.Estado = 1 THEN 'ACTIVO' ELSE 'INACTIVO' END AS EstadoVehiculo,                                            
 VEHI.CATA_TIVE_Codigo,                                            
 TIVE.Campo1 as TipoVehiculo,                                
 ISNULL(TIVE.Campo3,0) as AplicaSemirremolque,                                          
 SEMI.Placa as PlacaSemirremolque,                                            
 SEMI.Codigo as CodigoSemirremolque,               
 VEHI.SEMI_Codigo,                                   
 VEHI.Justificacion_Bloqueo,                  
 VEHI.CATA_TIDV_Codigo,                
 (SELECT SUM(Total_Puntos) FROM Plan_Puntos_Vehiculos where EMPR_Codigo = VEHI.EMPR_Codigo and VEHI_Codigo = VEHI.Codigo) as Puntos                      
 --ROW_NUMBER() OVER(ORDER BY VEHI.Codigo) AS RowNumber                                            
FROM                                            
 Vehiculos AS VEHI                                           
 LEFT JOIN Semirremolques SEMI ON                                          
 VEHI.EMPR_Codigo = SEMI.EMPR_Codigo                                            
 AND VEHI.SEMI_Codigo = SEMI.Codigo                   
                   
LEFT JOIN Terceros COND ON                      
COND.EMPR_Codigo = VEHI.EMPR_Codigo                                          
AND COND.Codigo = VEHI.TERC_Codigo_Conductor                  
                                       
LEFT JOIN Terceros TENE ON                  
TENE.EMPR_Codigo = VEHI.EMPR_Codigo                                          
AND TENE.Codigo = VEHI.TERC_Codigo_Tenedor                  
                                          
LEFT JOIN Valor_Catalogos TIVE ON                  
VEHI.EMPR_Codigo = TIVE.EMPR_Codigo                                          
AND VEHI.CATA_TIVE_Codigo = TIVE.Codigo                  
    
LEFT JOIN Autorizaciones_Mantenimiento AUMA ON    
AUMA.EMPR_Codigo = VEHI.EMPR_Codigo                                          
AND AUMA.VEHI_Codigo = VEHI.Codigo      
AND AUMA.Estado = 1    
AND AUMA.Anulado = 0    
                                          
WHERE            
(    
VEHI.Codigo != 0                                            
 AND (VEHI.Codigo = @par_Codigo OR @par_Codigo IS NULL)                                      
 AND VEHI.EMPR_Codigo = @par_EMPR_Codigo                                            
 AND ((VEHI.Placa LIKE '%' + @par_Filtro + '%') OR  (VEHI.Codigo_Alterno LIKE '%' + @par_Filtro + '%') OR (@par_Filtro IS NULL))                                            
 AND (VEHI.TERC_Codigo_Conductor = @par_Conductor OR @par_Conductor IS NULL)                            
 AND (VEHI.Estado = @par_Estado OR @par_Estado IS NULL)    
 AND VEHI.TERC_Codigo_Conductor NOT IN (select Codigo from Terceros where Estado = 0)                      
 )    
 OR (    
  VEHI.Codigo != 0      
  AND (VEHI.Codigo = @par_Codigo OR @par_Codigo IS NULL)                                      
  AND VEHI.EMPR_Codigo = @par_EMPR_Codigo                                            
  AND ((VEHI.Placa LIKE '%' + @par_Filtro + '%') OR  (VEHI.Codigo_Alterno LIKE '%' + @par_Filtro + '%') OR (@par_Filtro IS NULL))                                            
  AND (VEHI.TERC_Codigo_Conductor = @par_Conductor OR @par_Conductor IS NULL)                            
  AND ((@par_Fecha_Vigencia BETWEEN AUMA.Fecha AND AUMA.Fecha_vigencia))    
 )    
END       
END    
GO
DROP PROCEDURE gsp_insertar_vehiculos                                  
GO
CREATE PROCEDURE gsp_insertar_vehiculos                                  
(                                  
@par_EMPR_Codigo SMALLINT,                                  
@Codigo NUMERIC = 0,                                  
@par_Placa varchar(20),                                  
@par_Codigo_Alterno varchar(20) = null,                                  
@par_Emergencias SMALLINT = null,                                  
@par_SEMI_Codigo numeric = null,                                  
@par_TERC_Codigo_Propietario numeric = null,                                  
@par_TERC_Codigo_Tenedor numeric = null,                                  
@par_TERC_Codigo_Conductor numeric = null,                                  
@par_TERC_Codigo_Afiliador numeric = null,                                  
@par_COVE_Codigo numeric = null,                                  
@par_MAVE_Codigo numeric = null,                                  
@par_LIVE_Codigo numeric = null,  

@par_MAMO_Codigo numeric = null,                                  
@par_LIMO_Codigo numeric = null,                                  
@par_NOEM_Codigo numeric = null,                                  


@par_Modelo smallint = null,                                  
@par_Modelo_Repotenciado smallint = null,                                  
@par_CATA_TIVE_Codigo numeric = null,                                  
@par_Cilindraje numeric = null,                                  
@par_CATA_TICA_Codigo numeric = null,                                  
@par_Numero_Ejes smallint = null,                                  
@par_Numero_Motor varchar(50) = null,                                  
@par_Numero_Serie varchar(50) = null,                                  
@par_Peso_Bruto numeric = null,                                  
@par_Kilometraje numeric = null,                                  
@par_Fecha_Actuliza_Kilometraje datetime = null,                                  
@par_ESSE_Numero numeric = null,                                  
@par_Fecha_Ultimo_Cargue datetime = null,                                  
@par_Estado smallint = null,                                  
                              
@par_USUA_Codigo_Crea smallint = null,                                  
@par_CATA_TIDV_Codigo numeric = null,                                  
@par_Tarjeta_Propiedad varchar(50) = null,                                  
@par_Capacidad numeric(18,2) = null,                                  
@par_Capacidad_Galones numeric(18,2) = null,                                  
@par_Peso_Tara numeric = null,                                  
@par_TERC_Codigo_Proveedor_GPS numeric = null,                                  
@par_Usuario_GPS varchar(50) = null,                                  
@par_Clave_GPS varchar(50) = null,                                  
@par_TelefonoGPS numeric = null,                                  
@par_CATA_CAIV_Codigo numeric = null,                                  
@par_Justificacion_Bloqueo varchar (150) = null   ,                               
@par_TERC_Codigo_Aseguradora_SOAT numeric = null   ,                               
@par_Referencia_SOAT varchar (50) = null   ,                               
@par_Fecha_Vencimiento_SOAT DATE = null        ,                          
@par_URL_GPS varchar (200) = null,                                  
@par_Identificador_GPS varchar (50) = null,            
@par_CapacidadVolumen numeric (18,0) = null  ,          
@par_Fecha_Vinculacion datetime = null,          
@par_Fecha_Inactivacion datetime = null,    
@par_CATA_TICO_Codigo numeric(18,0) = null ,   
 @par_CATA_LISE_Codigo NUMERIC = NULL                      
)                                  
AS                                  
BEGIN                                  
IF EXISTS(SELECT * FROM dbo.Vehiculos where placa = @par_Placa AND EMPR_Codigo = @par_EMPR_Codigo)                                  
BEGIN                                  
 select 1 as Codigo                                  
END                                  
ELSE                                  
BEGIN                                  
 EXEC gsp_generar_consecutivo  @par_EMPR_Codigo, 20, 0, @Codigo OUTPUT                   
 INSERT INTO Vehiculos                                  
      (EMPR_Codigo                                  
      ,Codigo                                  
      ,Placa                                
      ,Codigo_Alterno                                  
                              
      ,SEMI_Codigo                                  
      ,TERC_Codigo_Propietario                                  
      ,TERC_Codigo_Tenedor                                  
      ,TERC_Codigo_Conductor                
      ,TERC_Codigo_Afiliador                                  
      ,COVE_Codigo                                  
      ,MAVE_Codigo                    
      ,LIVE_Codigo                                  
      ,MAMO_Codigo                                  
      ,LIMO_Codigo                                  
      ,NOEM_Codigo                                  
      ,Modelo                                  
      ,Modelo_Repotenciado                                  
      ,CATA_TIVE_Codigo                                  
      ,Cilindraje                                  
      ,CATA_TICA_Codigo                                  
      ,Numero_Ejes                                  
      ,Numero_Motor                                  
      ,Numero_Serie                                  
  ,Peso_Bruto                                  
      ,Kilometraje                                  
      ,Fecha_Actuliza_Kilometraje                                  
      ,ESSE_Numero                   
      ,Fecha_Ultimo_Cargue                                  
      ,Estado                                  
                                        
      ,USUA_Codigo_Crea                                  
      ,Fecha_Crea                
   ,Fecha_Modifica                        
      ,CATA_TIDV_Codigo                                  
      ,Tarjeta_Propiedad                                  
      ,Capacidad_Kilos                                  
      ,Capacidad_Galones                                  
,Peso_Tara                                  
      ,TERC_Codigo_Proveedor_GPS                                  
      ,Usuario_GPS                                  
      ,Clave_GPS                                  
      ,CATA_CAIV_Codigo                                  
      ,Justificacion_Bloqueo                                  
      ,Telefono_GPS                                  
  ,TERC_Codigo_Aseguradora_SOAT                             
 ,Referencia_SOAT                              
 ,Fecha_Vencimiento_SOAT                             
 , URL_GPS                          
 ,Identificador_GPS                  
 ,Reportar_RNDC  ,            
 Capacidad_Volumen      ,    
 CATA_TICO_Codigo ,  
 CATA_LISE_Codigo  
      )                                  
   VALUES                                  
      (@par_EMPR_Codigo                                  
      ,@Codigo                                  
      ,@par_Placa                                  
      ,ISNULL(@par_Codigo_Alterno,'')                                  
                              
      ,ISNULL(@par_SEMI_Codigo,0)                                  
      ,ISNULL(@par_TERC_Codigo_Propietario,0)                                  
      ,ISNULL(@par_TERC_Codigo_Tenedor,0)                                  
    ,ISNULL(@par_TERC_Codigo_Conductor,0)                                  
      ,ISNULL(@par_TERC_Codigo_Afiliador,0)                                  
      ,ISNULL(@par_COVE_Codigo,0)                                  
      ,ISNULL(@par_MAVE_Codigo,0)                                  
      ,ISNULL(@par_LIVE_Codigo,0)                                  
      ,ISNULL(@par_MAMO_Codigo,0)                                  
      ,ISNULL(@par_LIMO_Codigo,0)                                  
      ,ISNULL(@par_NOEM_Codigo,0)                                  
      ,ISNULL(@par_Modelo,0)                                  
      ,@par_Modelo_Repotenciado                                  
      ,ISNULL(@par_CATA_TIVE_Codigo,2200)                                  
      ,ISNULL(@par_Cilindraje,0)                                  
      ,ISNULL(@par_CATA_TICA_Codigo,2300)                                  
      ,ISNULL(@par_Numero_Ejes,0)                                  
      ,ISNULL(@par_Numero_Motor,'')                                  
      ,ISNULL(@par_Numero_Serie,0)                                  
      ,ISNULL(@par_Peso_Bruto,0)                                  
      ,ISNULL(@par_Kilometraje,0)                                  
      ,ISNULL(@par_Fecha_Actuliza_Kilometraje,'01/01/1900')                                  
      ,ISNULL(@par_ESSE_Numero,0)            ,ISNULL(@par_Fecha_Ultimo_Cargue,'01/01/1900')                                  
      ,ISNULL(@par_Estado,0)                                  
                                        
      ,ISNULL(@par_USUA_Codigo_Crea,0)                                  
      ,ISNULL(@par_Fecha_Vinculacion,GETDATE())          
   ,@par_Fecha_Inactivacion          
      ,ISNULL(@par_CATA_TIDV_Codigo,2100)                                  
      ,isnull(@par_Tarjeta_Propiedad,'')                                  
      ,isnull(@par_Capacidad,0)                                  
      ,@par_Capacidad_Galones                                  
      ,@par_Peso_Tara                                  
      ,ISNULL(@par_TERC_Codigo_Proveedor_GPS,0)                                  
      ,@par_Usuario_GPS                                  
      ,@par_Clave_GPS                                  
      ,ISNULL(@par_CATA_CAIV_Codigo,2400)                                  
      ,@par_Justificacion_Bloqueo                                  
   ,@par_TelefonoGPS                                  
        , @par_TERC_Codigo_Aseguradora_SOAT                            
  ,@par_Referencia_SOAT                            
  ,@par_Fecha_Vencimiento_SOAT                            
  ,@par_URL_GPS                          
  ,@par_Identificador_GPS                 
  ,1  ,            
  ISNULL(@par_CapacidadVolumen,0)        
  ,@par_CATA_TICO_Codigo,  
  @par_CATA_LISE_Codigo  
      )                        
                        
INSERT INTO Plan_Puntos_Vehiculos                        
(                        
EMPR_Codigo,                      
VEHI_Codigo,                        
Fecha,                        
CATA_CFTR_Codigo,                        
Total_Puntos,                        
Fecha_Actualiza_Puntos,--NULL                        
Estado,                        
USUA_Codigo_Crea,                        
Fecha_Crea,                        
USUA_Codigo_Modifica,--NULL                        
Fecha_Modifica--NULL                        
)                        
VALUES (                        
@par_EMPR_Codigo,                        
@Codigo,                        
GETDATE(),                        
18801,                        
0,                        
NULL,--NULL                        
1,                        
@par_USUA_Codigo_Crea,                        
GETDATE(),                        
NULL,--NULL                        
NULL--NULL                        
)                        
                    
IF NOT EXISTS(SELECT * FROM Usuarios WHERE TERC_Codigo_Conductor =@par_TERC_Codigo_Conductor AND EMPR_Codigo = @par_EMPR_Codigo ) AND EXISTS(SELECT * FROM Validacion_Procesos WHERE EMPR_Codigo = @par_EMPR_Codigo and PROC_Codigo = 35 AND Estado = 1)      
  
    
      
        
          
            
              
BEGIN                    
 INSERT INTO Usuarios                    
 (                    
 EMPR_Codigo,                    
 Codigo_Usuario,                    
 Codigo_Alterno,                    
 Nombre,                    
 Descripcion,                    
 Habilitado,                    
 Clave,                    
 Dias_Cambio_Clave,                    
 Manager,                    
 Login,                    
 CATA_APLI_Codigo,                    
 TERC_Codigo_Empleado,                    
 TERC_Codigo_Cliente,                    
 TERC_Codigo_Conductor,                    
 TERC_Codigo_Proveedor,                    
 TERC_Codigo_Transportador,                    
 Fecha_Ultimo_Ingreso,                    
 Intentos_Ingreso,                    
 Fecha_Ultimo_Cambio_Clave,                    
 Mensaje_Banner,                    
 Fecha_Ultima_Actividad                    
 )      
 SELECT  EMPR_Codigo,                    
 Numero_Identificacion,                    
 Numero_Identificacion,                    
 Nombre +' '+ Apellido1+' '+ Apellido2,                    
 'CONDUCTOR',                    
 1,                    
 Numero_Identificacion,                    
 360,                    
 0,                    
 0,                    
 203,                    
 0,                    
 0,                    
 Codigo,                    
 0,                    
 NULL,                    
 NULL,                    
 0,                    
 NULL,                    
 '',                    
 NULL                    
 FROM Terceros WHERE Codigo =@par_TERC_Codigo_Conductor AND EMPR_Codigo = @par_EMPR_Codigo                    
END                   
INSERT INTO Vehiculo_Novedades (        
 EMPR_Codigo,        
 VEHI_Codigo,        
 CATA_NOVE_Codigo,        
 Estado,        
 Observaciones,        
 USUA_Codigo_Crea,        
 Fecha_Crea        
 )        
 VALUES(        
 @par_EMPR_Codigo,        
 @Codigo,        
 22307,--Creación Registro        
 1,        
 'Creación Vehículo',        
@par_USUA_Codigo_Crea,        
GETDATE()        
 )        
                    
 select @Codigo as Codigo                                  
 END                               
END                                  
GO
DROP PROCEDURE gsp_modificar_vehiculos                            
GO
CREATE PROCEDURE gsp_modificar_vehiculos                            
(                            
@par_EMPR_Codigo SMALLINT,                            
@Codigo NUMERIC ,                            
@par_Codigo_Alterno varchar(20) = null,                            
@par_SEMI_Codigo numeric = null,                            
@par_TERC_Codigo_Propietario numeric = null,                            
@par_TERC_Codigo_Tenedor numeric = null,                            
@par_TERC_Codigo_Conductor numeric = null,                            
@par_TERC_Codigo_Afiliador numeric = null,                            
@par_COVE_Codigo numeric = null,                            
@par_MAVE_Codigo numeric = null,                            
@par_LIVE_Codigo numeric = null, 
@par_MAMO_Codigo numeric = null,                                  
@par_LIMO_Codigo numeric = null,                                  
@par_NOEM_Codigo numeric = null, 
@par_Modelo smallint = null,                            
@par_Modelo_Repotenciado smallint = null,                            
@par_CATA_TIVE_Codigo numeric = null,                            
@par_Cilindraje numeric(18,2) = null,                            
@par_CATA_TICA_Codigo numeric = null,                            
@par_Numero_Ejes smallint = null,                            
@par_Numero_Motor varchar(50) = null,                            
@par_Numero_Serie varchar(50) = null,                            
@par_Peso_Bruto numeric(18,2) = null,                            
@par_Kilometraje numeric = null,                            
@par_Fecha_Actuliza_Kilometraje datetime = null,                            
@par_ESSE_Numero numeric = null,                            
@par_Fecha_Ultimo_Cargue datetime = null,                            
@par_Estado smallint = null,                            
@par_CATA_ESVE_Codigo numeric = null,                            
@par_USUA_Codigo_Crea smallint = null,                            
@par_CATA_TIDV_Codigo numeric = null,                            
@par_Tarjeta_Propiedad varchar(50) = null,                            
@par_Capacidad numeric(18,2) = null,                            
@par_Capacidad_Galones numeric(18,2) = null,                            
@par_Peso_Tara numeric(18,2) = null,                            
@par_TERC_Codigo_Proveedor_GPS numeric = null,                            
@par_Usuario_GPS varchar(50) = null,                            
@par_Clave_GPS varchar(50) = null,                            
@par_TelefonoGPS numeric = null,                            
@par_CATA_CAIV_Codigo numeric = null,                            
@par_Justificacion_Bloqueo varchar (150) = null,                            
@par_Foto image = null   ,                        
@par_TERC_Codigo_Aseguradora_SOAT numeric = null   ,                           
@par_Referencia_SOAT varchar (50) = null   ,                           
@par_Fecha_Vencimiento_SOAT DATE = null  ,                            
@par_URL_GPS varchar (200) = null,                              
@par_Identificador_GPS varchar (50) = null    ,          
@par_CapacidadVolumen numeric(18,0) = null   ,                         
@par_CATA_TICO_Codigo numeric(18,0) = null,    
@par_CATA_LISE_Codigo NUMERIC = NULL                        
    
)                            
AS                            
BEGIN                            
                            
                            
update Vehiculos set                            
           Codigo_Alterno = ISNULL(@par_Codigo_Alterno,'')                            
           ,SEMI_Codigo = ISNULL(@par_SEMI_Codigo,0)                            
           ,TERC_Codigo_Propietario = ISNULL(@par_TERC_Codigo_Propietario,0)                            
           ,TERC_Codigo_Tenedor =ISNULL(@par_TERC_Codigo_Tenedor,0)                            
           ,TERC_Codigo_Conductor = ISNULL(@par_TERC_Codigo_Conductor,0)                            
           ,TERC_Codigo_Afiliador = ISNULL(@par_TERC_Codigo_Afiliador,0)                            
           ,COVE_Codigo = ISNULL(@par_COVE_Codigo,0)                            
           ,MAVE_Codigo = ISNULL(@par_MAVE_Codigo,0)                            
           ,LIVE_Codigo = ISNULL(@par_LIVE_Codigo,0)   
           ,MAMO_Codigo = ISNULL(@par_MAMO_Codigo,0)   
           ,LIMO_Codigo = ISNULL(@par_LIMO_Codigo,0)   
           ,NOEM_Codigo = ISNULL(@par_NOEM_Codigo,0)   
		   ,Modelo = ISNULL(@par_Modelo,0)                            
           ,Modelo_Repotenciado = @par_Modelo_Repotenciado                            
           ,CATA_TIVE_Codigo = ISNULL(@par_CATA_TIVE_Codigo,2200)                            
           ,Cilindraje = ISNULL(@par_Cilindraje,0)                            
           ,CATA_TICA_Codigo = ISNULL(@par_CATA_TICA_Codigo,2300)                            
           ,Numero_Ejes = ISNULL(@par_Numero_Ejes,0)                            
           ,Numero_Motor = ISNULL(@par_Numero_Motor,'')                            
           ,Numero_Serie = ISNULL(@par_Numero_Serie,0)                            
           ,Peso_Bruto = ISNULL(@par_Peso_Bruto,0)                            
           ,Kilometraje = ISNULL(@par_Kilometraje,0)                            
           ,Fecha_Actuliza_Kilometraje = ISNULL(@par_Fecha_Actuliza_Kilometraje,'01/01/1900')                            
           ,ESSE_Numero = ISNULL(@par_ESSE_Numero,0)                            
           ,Fecha_Ultimo_Cargue =   ISNULL(@par_Fecha_Ultimo_Cargue,'01/01/1900')                            
           ,Estado = ISNULL(@par_Estado,0)                            
                                      
           ,USUA_Codigo_Modifica = ISNULL(@par_USUA_Codigo_Crea,0)                            
           ,Fecha_Modifica = GETDATE()                            
           ,CATA_TIDV_Codigo = ISNULL(@par_CATA_TIDV_Codigo,2100)                         
           ,Tarjeta_Propiedad = Isnull(@par_Tarjeta_Propiedad,'')                            
           ,Capacidad_Kilos = Isnull(@par_Capacidad,0)                            
     ,Capacidad_Galones = @par_Capacidad_Galones                            
           ,Peso_Tara = @par_Peso_Tara                            
           ,TERC_Codigo_Proveedor_GPS = ISNULL(@par_TERC_Codigo_Proveedor_GPS,0)                            
           ,Usuario_GPS = @par_Usuario_GPS                            
           ,Clave_GPS = @par_Clave_GPS                            
         ,CATA_CAIV_Codigo = isnull(@par_CATA_CAIV_Codigo,2400)                            
           ,Justificacion_Bloqueo = @par_Justificacion_Bloqueo                            
           ,Telefono_GPS = @par_TelefonoGPS                            
           ,TERC_Codigo_Aseguradora_SOAT = @par_TERC_Codigo_Aseguradora_SOAT                            
           ,Referencia_SOAT = @par_Referencia_SOAT                            
           ,Fecha_Vencimiento_SOAT = @par_Fecha_Vencimiento_SOAT                           
     ,URL_GPS = @par_URL_GPS                      
   ,Identificador_GPS = @par_Identificador_GPS               
   ,Reportar_RNDC = 1  ,          
   Capacidad_Volumen = ISNULL(@par_CapacidadVolumen,0)  ,        
CATA_TICO_Codigo = @par_CATA_TICO_Codigo ,    
CATA_LISE_Codigo = @par_CATA_LISE_Codigo    
     where EMPR_Codigo = @par_EMPR_Codigo                            
     AND Codigo = @Codigo                      
                  
IF NOT EXISTS(SELECT * FROM Usuarios WHERE TERC_Codigo_Conductor =@par_TERC_Codigo_Conductor AND EMPR_Codigo = @par_EMPR_Codigo ) AND EXISTS(SELECT * FROM Validacion_Procesos WHERE EMPR_Codigo = @par_EMPR_Codigo and PROC_Codigo = 35 AND Estado = 1)       
  
    
      
        
          
           
BEGIN                  
 INSERT INTO Usuarios                  
 (                  
 EMPR_Codigo,                  
 Codigo_Usuario,                  
 Codigo_Alterno,                  
 Nombre,                  
 Descripcion,                  
 Habilitado,                  
 Clave,                  
 Dias_Cambio_Clave,                  
 Manager,                  
 Login,                  
 CATA_APLI_Codigo,                  
 TERC_Codigo_Empleado,                  
 TERC_Codigo_Cliente,                  
 TERC_Codigo_Conductor,                  
 TERC_Codigo_Proveedor,                  
 TERC_Codigo_Transportador,                  
 Fecha_Ultimo_Ingreso,                  
 Intentos_Ingreso,                  
 Fecha_Ultimo_Cambio_Clave,                  
 Mensaje_Banner,                  
 Fecha_Ultima_Actividad                  
 )                  
 SELECT  EMPR_Codigo,                  
 Numero_Identificacion,                  
 Numero_Identificacion,                  
 Nombre +' '+ Apellido1+' '+ Apellido2,                  
 'CONDUCTOR',                  
 1,                  
 Numero_Identificacion,                  
 360,                  
 0,                  
 0,                  
 203,                  
 0,                  
 0,                  
 Codigo,       
 0,                  
 NULL,                  
 NULL,                  
 0,                  
 NULL,                  
 '',                  
 NULL                  
 FROM Terceros WHERE Codigo =@par_TERC_Codigo_Conductor AND EMPR_Codigo = @par_EMPR_Codigo                  
END      
DELETE Vehiculo_Actividades WHERE  EMPR_Codigo = @par_EMPR_Codigo   AND VEHI_Codigo = @Codigo  
select @Codigo as Codigo                            
END                            
GO
DROP PROCEDURE gsp_obtener_vehiculo               
GO
CREATE PROCEDURE gsp_obtener_vehiculo               
(                      
@par_EMPR_Codigo SMALLINT,                      
@par_Codigo NUMERIC = null,                      
@par_Placa VARCHAR(20) = null,                    
@par_Emergencias SMALLINT = 0                    
)                      
AS                       
BEGIN                      
                      
SELECT                       
1 AS Obtener,                      
VEHI.EMPR_Codigo,                      
VEHI.Codigo,                      
VEHI.Placa,                      
VEHI.Codigo_Alterno,                      
VEHI.SEMI_Codigo,                
SEMI.Placa as PlacaSemirremolque,                     
VEHI.TERC_Codigo_Propietario,                      
VEHI.TERC_Codigo_Tenedor,                
ISNULL(TENE.Razon_Social,'') + ' ' + ISNULL(TENE.Nombre,'') + ' ' + ISNULL(TENE.Apellido1,'') + ' ' + ISNULL(TENE.Apellido2,'') As NombreTenedor,                     
VEHI.TERC_Codigo_Conductor,                 
ISNULL(COND.Razon_Social,'') + ' ' + ISNULL(COND.Nombre,'') + ' ' + ISNULL(COND.Apellido1,'') + ' ' + ISNULL(COND.Apellido2,'') As NombreConductor,                 
COND.Numero_Identificacion As IdentificacionConductor,                
ISNULL(COND.Celulares, '') AS Celulares,                  
VEHI.TERC_Codigo_Afiliador,                      
VEHI.COVE_Codigo,                      
VEHI.MAVE_Codigo,                      
VEHI.LIVE_Codigo,                      
VEHI.Modelo,                      
ISNULL(VEHI.Modelo_Repotenciado,0) AS Modelo_Repotenciado,                      
VEHI.CATA_TIVE_Codigo,                      
TIVE.Campo1 AS TipoVehiculo,                      
VEHI.Cilindraje,                      
VEHI.CATA_TICA_Codigo,                      
VEHI.Numero_Ejes,                      
VEHI.Numero_Motor,                      
VEHI.Numero_Serie,                      
VEHI.Peso_Bruto,                      
VEHI.Kilometraje,                      
VEHI.Fecha_Actuliza_Kilometraje,                      
VEHI.ESSE_Numero,                      
Fecha_Ultimo_Cargue,                      
VEHI.Estado,                      
'' AS EstadoVehiculo,                      
ISNULL(VEHI.Tarjeta_Propiedad,0) AS Tarjeta_Propiedad,                      
ISNULL(VEHI.Capacidad_Kilos,0) AS Capacidad,                      
ISNULL(VEHI.Capacidad_Galones,0) AS CapacidadGalones,                      
ISNULL(VEHI.Peso_Tara,0) AS Peso_Tara,                      
ISNULL(VEHI.TERC_Codigo_Proveedor_GPS,0) AS TERC_Codigo_Proveedor_GPS,                      
ISNULL(VEHI.Usuario_GPS,'') AS Usuario_GPS,                      
ISNULL(VEHI.Clave_GPS,'') AS Clave_GPS,                      
ISNULL(VEHI.CATA_CAIV_Codigo,2400) AS CATA_CAIV_Codigo,                      
ISNULL(VEHI.Justificacion_Bloqueo,'') AS Justificacion_Bloqueo,                      
ISNULL(VEHI.Telefono_GPS,0) AS TelefonoGPS,                      
ISNULL(VEHI.CATA_TIDV_Codigo,2100) AS CATA_TIDV_Codigo,                 
VEHI.TERC_Codigo_Aseguradora_SOAT,                
VEHI.Referencia_SOAT,                
VEHI.Fecha_Vencimiento_SOAT,            
VEHI.URL_GPS  ,          
VEHI.Identificador_GPS  ,        
ISNULL(VEHI.Capacidad_Volumen,0) As Capacidad_Volumen ,    
VEHI.CATA_TICO_Codigo,    
VEHI.CATA_LISE_Codigo,
VEHI.MAMO_Codigo,
VEHI.LIMO_Codigo,
VEHI.NOEM_Codigo
FROM                       
Vehiculos AS VEHI              
              
LEFT JOIN Semirremolques SEMI ON                        
VEHI.EMPR_Codigo = SEMI.EMPR_Codigo                          
AND VEHI.SEMI_Codigo = SEMI.Codigo                      
              
LEFT JOIN Valor_Catalogos TIVE ON                        
VEHI.EMPR_Codigo = TIVE.EMPR_Codigo                          
AND VEHI.CATA_TIVE_Codigo = TIVE.Codigo                
              
LEFT JOIN Terceros TENE ON                        
VEHI.EMPR_Codigo = TENE.EMPR_Codigo                          
AND VEHI.TERC_Codigo_Tenedor = TENE.Codigo                
              
LEFT JOIN Terceros COND ON                        
VEHI.EMPR_Codigo = COND.EMPR_Codigo                          
AND VEHI.TERC_Codigo_Conductor = COND.Codigo             
                      
WHERE VEHI.EMPR_Codigo = @par_EMPR_Codigo                      
AND VEHI.Codigo = ISNULL(@par_Codigo,VEHI.Codigo)                      
AND VEHI.Placa = ISNULL (@par_Placa,VEHI.Placa)                      
                          
END          
GO
DROP PROCEDURE gsp_consultar_marca_motores  
GO
CREATE PROCEDURE gsp_consultar_marca_motores  
(  
 @par_EMPR_Codigo SMALLINT,  
 @par_Codigo NUMERIC = NULL,  
 @par_Nombre VARCHAR(50) = NULL,  
 @par_Estado INT = NULL,  
 @par_NumeroPagina INT = NULL,  
 @par_RegistrosPagina INT = NULL  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  DECLARE  
   @CantidadRegistros INT  
  SELECT @CantidadRegistros = (  
    SELECT DISTINCT   
     COUNT(1)   
    FROM  
     Marca_Motores   
    WHERE  
     Codigo <> 0  
     AND EMPR_Codigo = @par_EMPR_Codigo  
     AND Estado = ISNULL(@par_Estado, Estado)  
     AND Codigo = ISNULL(@par_Codigo, Codigo)  
     AND ((Nombre LIKE '%' + @par_Nombre + '%') OR (@par_Nombre IS NULL))  
     );  
              
    WITH Pagina AS  
    (  
  
    SELECT  
     0 AS Obtener,  
     EMPR_Codigo,  
     Codigo, 
     Nombre,  
     Estado,  
     ROW_NUMBER() OVER(ORDER BY Nombre) AS RowNumber  
    FROM  
     Marca_Motores   
    WHERE  
     Codigo <> 0  
     AND EMPR_Codigo = @par_EMPR_Codigo  
     AND Estado = ISNULL(@par_Estado, Estado)  
     AND Codigo = ISNULL(@par_Codigo, Codigo)  
     AND ((Nombre LIKE '%' + @par_Nombre + '%') OR (@par_Nombre IS NULL))  
  )  
  SELECT DISTINCT  
  0 AS Obtener,  
  EMPR_Codigo,  
  Codigo,  
  Nombre,  
  Estado,  
  @CantidadRegistros AS TotalRegistros,  
  @par_NumeroPagina AS PaginaObtener,  
  @par_RegistrosPagina AS RegistrosPagina  
  FROM  
   Pagina  
  WHERE  
   RowNumber > (ISNULL(@par_NumeroPagina, 1) -1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)  
   AND RowNumber <= ISNULL(@par_NumeroPagina, 1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)  
  order by Nombre  
END  
GO
DROP PROCEDURE gsp_insertar_marca_motores   
GO
CREATE PROCEDURE gsp_insertar_marca_motores    
(    
@par_EMPR_Codigo SMALLINT ,    
@par_Nombre VARCHAR (50),    
@par_Estado SMALLINT,    
@par_USUA_Codigo_Crea SMALLINT    
)    
AS     
BEGIN    
INSERT INTO Marca_Motores   
(    
EMPR_Codigo,    
Nombre,    
Estado,    
USUA_Codigo_Crea,    
Fecha_Crea    
)    
VALUES    
(    
@par_EMPR_Codigo,    
@par_Nombre,    
@par_Estado,    
@par_USUA_Codigo_Crea,    
GETDATE()    
)    
SELECT Codigo = @@identity    
END    
GO
DROP PROCEDURE gsp_modificar_marca_motores   
GO
CREATE PROCEDURE gsp_modificar_marca_motores   
(    
@par_EMPR_Codigo SMALLINT ,    
@par_Codigo NUMERIC,    
@par_Nombre VARCHAR (50),    
@par_Estado SMALLINT,    
@par_USUA_Codigo_Modifica SMALLINT    
)    
AS     
BEGIN    
UPDATE Marca_Motores  
SET     
Nombre = @par_Nombre,    
Estado =  @par_Estado,    
USUA_Codigo_Modifica =  @par_USUA_Codigo_Modifica,    
Fecha_Modifica = GETDATE()    
    
WHERE     
EMPR_Codigo =  @par_EMPR_Codigo    
AND Codigo =  @par_Codigo    
    
SELECT @par_Codigo As Codigo    
END    
GO
DROP PROCEDURE gsp_obtener_marca_motores  
GO
CREATE PROCEDURE gsp_obtener_marca_motores  
(  
@par_EMPR_Codigo SMALLINT,  
@par_Codigo NUMERIC  
)  
AS   
BEGIN  
 SELECT  
  1 AS Obtener,  
  EMPR_Codigo,  
  Codigo,  
  Nombre,  
  Estado,  
  ROW_NUMBER() OVER(ORDER BY Nombre) AS RowNumber  
 FROM  
  Marca_Motores   
 WHERE  
  
  EMPR_Codigo = @par_EMPR_Codigo  
  AND Codigo = @par_Codigo  
END  
GO
DROP PROCEDURE gsp_eliminar_marca_motores
GO
CREATE PROCEDURE gsp_eliminar_marca_motores
(  
  @par_EMPR_Codigo SMALLINT,  
  @par_Codigo NUMERIC  
  )  
AS  
BEGIN  
    
  DELETE Marca_Motores   
  WHERE EMPR_Codigo = @par_EMPR_Codigo   
    AND Codigo = @par_Codigo  
  
    SELECT @@ROWCOUNT AS Numero  
  
END  
GO
DROP PROCEDURE gsp_consultar_norma_emisiones  
GO
CREATE PROCEDURE gsp_consultar_norma_emisiones  
(  
 @par_EMPR_Codigo SMALLINT,  
 @par_Codigo NUMERIC = NULL,  
 @par_Nombre VARCHAR(50) = NULL,  
 @par_Estado INT = NULL,  
 @par_NumeroPagina INT = NULL,  
 @par_RegistrosPagina INT = NULL  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  DECLARE  
   @CantidadRegistros INT  
  SELECT @CantidadRegistros = (  
    SELECT DISTINCT   
     COUNT(1)   
    FROM  
     Norma_Emisiones   
    WHERE  
     Codigo <> 0  
     AND EMPR_Codigo = @par_EMPR_Codigo  
     AND Estado = ISNULL(@par_Estado, Estado)  
     AND Codigo = ISNULL(@par_Codigo, Codigo)  
     AND ((Nombre LIKE '%' + @par_Nombre + '%') OR (@par_Nombre IS NULL))  
     );  
              
    WITH Pagina AS  
    (  
  
    SELECT  
     0 AS Obtener,  
     EMPR_Codigo,  
     Codigo,  
     Nombre,  
     Estado,  
     ROW_NUMBER() OVER(ORDER BY Nombre) AS RowNumber  
    FROM  
     Norma_Emisiones   
    WHERE  
     Codigo <> 0  
     AND EMPR_Codigo = @par_EMPR_Codigo  
     AND Estado = ISNULL(@par_Estado, Estado)  
     AND Codigo = ISNULL(@par_Codigo, Codigo)  
     AND ((Nombre LIKE '%' + @par_Nombre + '%') OR (@par_Nombre IS NULL))  
  )  
  SELECT DISTINCT  
  0 AS Obtener,  
  EMPR_Codigo,  
  Codigo,  
  Nombre,  
  Estado,  
  @CantidadRegistros AS TotalRegistros,  
  @par_NumeroPagina AS PaginaObtener,  
  @par_RegistrosPagina AS RegistrosPagina  
  FROM  
   Pagina  
  WHERE  
   RowNumber > (ISNULL(@par_NumeroPagina, 1) -1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)  
   AND RowNumber <= ISNULL(@par_NumeroPagina, 1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)  
  order by Nombre  
END  
GO
DROP PROCEDURE gsp_insertar_norma_emisiones   
GO
CREATE PROCEDURE gsp_insertar_norma_emisiones    
(    
@par_EMPR_Codigo SMALLINT ,    
@par_Nombre VARCHAR (50),    
@par_Estado SMALLINT,    
@par_USUA_Codigo_Crea SMALLINT    
)    
AS     
BEGIN    
INSERT INTO Norma_Emisiones   
(    
EMPR_Codigo,    
Nombre,    
Estado,    
USUA_Codigo_Crea,    
Fecha_Crea    
)    
VALUES    
(    
@par_EMPR_Codigo,    
@par_Nombre,    
@par_Estado,    
@par_USUA_Codigo_Crea,    
GETDATE()    
)    
SELECT Codigo = @@identity    
END    
GO
DROP PROCEDURE gsp_modificar_norma_emisiones   
GO
CREATE PROCEDURE gsp_modificar_norma_emisiones   
(    
@par_EMPR_Codigo SMALLINT ,    
@par_Codigo NUMERIC,    
@par_Nombre VARCHAR (50),    
@par_Estado SMALLINT,    
@par_USUA_Codigo_Modifica SMALLINT    
)    
AS     
BEGIN    
UPDATE Norma_Emisiones  
SET     
Nombre = @par_Nombre,    
Estado =  @par_Estado,    
USUA_Codigo_Modifica =  @par_USUA_Codigo_Modifica,    
Fecha_Modifica = GETDATE()    
    
WHERE     
EMPR_Codigo =  @par_EMPR_Codigo    
AND Codigo =  @par_Codigo    
    
SELECT @par_Codigo As Codigo    
END    
GO
DROP PROCEDURE gsp_obtener_norma_emisiones  
GO
CREATE PROCEDURE gsp_obtener_norma_emisiones  
(  
@par_EMPR_Codigo SMALLINT,  
@par_Codigo NUMERIC  
)  
AS   
BEGIN  
 SELECT  
  1 AS Obtener,  
  EMPR_Codigo,  
  Codigo,  
  Nombre,  
  Estado,  
  ROW_NUMBER() OVER(ORDER BY Nombre) AS RowNumber  
 FROM  
  Norma_Emisiones   
 WHERE  
  
  EMPR_Codigo = @par_EMPR_Codigo  
  AND Codigo = @par_Codigo  
END  
GO
DROP PROCEDURE gsp_eliminar_norma_emisiones
GO
CREATE PROCEDURE gsp_eliminar_Norma_Emisiones
(  
  @par_EMPR_Codigo SMALLINT,  
  @par_Codigo NUMERIC  
  )  
AS  
BEGIN  
    
  DELETE Norma_Emisiones   
  WHERE EMPR_Codigo = @par_EMPR_Codigo   
    AND Codigo = @par_Codigo  
  
    SELECT @@ROWCOUNT AS Numero  
  
END  
GO
DROP PROCEDURE gsp_consultar_linea_motores 
GO
CREATE PROCEDURE gsp_consultar_linea_motores   
(    
 @par_EMPR_Codigo SMALLINT,    
 @par_Codigo NUMERIC = NULL,    
 @par_Nombre VARCHAR(50) = NULL,    
 @par_Nombre_Marca VARCHAR(50) = NULL,    
 @par_MAMO_Codigo NUMERIC = NULL,    
 @par_Estado SMALLINT = NULL,    
 @par_NumeroPagina INT = NULL,    
 @par_RegistrosPagina INT = NULL    
)    
AS    
BEGIN    
 SET NOCOUNT ON;    
  DECLARE    
   @CantidadRegistros INT    
  SELECT @CantidadRegistros = (    
    SELECT DISTINCT     
     COUNT(1)     
    FROM    
     Linea_Motores LIMO,    
     Marca_Motores MAMO    
    WHERE    
     LIMO.Codigo <> 0    
     AND LIMO.Codigo <> 18263    
     AND LIMO.EMPR_Codigo = MAMO.EMPR_Codigo     
     AND LIMO.MAMO_Codigo = MAMO.Codigo    
    
     AND LIMO.EMPR_Codigo = @par_EMPR_Codigo    
     AND LIMO.Estado = ISNULL(@par_Estado, LIMO.Estado)    
     AND LIMO.Codigo = ISNULL(@par_Codigo, LIMO.Codigo)    
     AND ((LIMO.Nombre LIKE '%' + @par_Nombre + '%') OR (@par_Nombre IS NULL))    
     AND ((MAMO.Nombre LIKE '%' + @par_Nombre_Marca + '%') OR (@par_Nombre_Marca IS NULL))    
     AND LIMO.MAMO_Codigo = ISNULL(@par_MAMO_Codigo,LIMO.MAMO_Codigo)    
     );    
                
    WITH Pagina AS    
    (    
    
    SELECT    
     0 AS Obtener,    
     LIMO.EMPR_Codigo,    
     LIMO.Codigo,    
     LIMO.Nombre,    
     LIMO.Estado,    
     LIMO.MAMO_Codigo,    
     MAMO.Nombre AS NombreMarca,    
     ROW_NUMBER() OVER(ORDER BY LIMO.Nombre) AS RowNumber    
    FROM    
     Linea_Motores LIMO,    
     Marca_Motores MAMO    
    WHERE    
     LIMO.Codigo <> 0    
     AND LIMO.Codigo <> 18263   
     AND LIMO.EMPR_Codigo = MAMO.EMPR_Codigo     
     AND LIMO.MAMO_Codigo = MAMO.Codigo    
    
     AND LIMO.EMPR_Codigo = @par_EMPR_Codigo    
     AND LIMO.Estado = ISNULL(@par_Estado, LIMO.Estado)    
     AND LIMO.Codigo = ISNULL(@par_Codigo, LIMO.Codigo)    
     AND ((LIMO.Nombre LIKE '%' + @par_Nombre + '%') OR (@par_Nombre IS NULL))    
     AND ((MAMO.Nombre LIKE '%' + @par_Nombre_Marca + '%') OR (@par_Nombre_Marca IS NULL))    
     AND LIMO.MAMO_Codigo = ISNULL(@par_MAMO_Codigo,LIMO.MAMO_Codigo)    
  )    
  SELECT DISTINCT    
  0 AS Obtener,    
  EMPR_Codigo,    
  Codigo,    
  Nombre,    
  Estado,    
  MAMO_Codigo,    
  NombreMarca,    
  @CantidadRegistros AS TotalRegistros,    
  @par_NumeroPagina AS PaginaObtener,    
  @par_RegistrosPagina AS RegistrosPagina    
  FROM    
   Pagina    
  WHERE    
   RowNumber > (ISNULL(@par_NumeroPagina, 1) -1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)    
   AND RowNumber<= ISNULL(@par_NumeroPagina, 1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)    
  order by Nombre    
END    
GO
DROP PROCEDURE gsp_insertar_linea_motores    
GO
CREATE PROCEDURE gsp_insertar_linea_motores    
(    
@par_EMPR_Codigo SMALLINT ,    
@par_MAMO_Codigo NUMERIC,    
@par_Nombre VARCHAR (50),    
@par_Estado SMALLINT,    
@par_USUA_Codigo_Crea SMALLINT    
)    
AS     
BEGIN    
 INSERT INTO Linea_Motores   
 (    
 EMPR_Codigo,    
 MAMO_Codigo,    
 Nombre,    
 Estado,    
 USUA_Codigo_Crea,    
 Fecha_Crea    
 )    
 VALUES    
 (    
 @par_EMPR_Codigo,    
 @par_MAMO_Codigo,    
 @par_Nombre,    
 @par_Estado,    
 @par_USUA_Codigo_Crea,    
 GETDATE()    
 )    
 SELECT Codigo = @@identity    
    
END    
GO
DROP PROCEDURE gsp_modificar_linea_motores    
GO
CREATE PROCEDURE gsp_modificar_linea_motores    
(    
@par_EMPR_Codigo SMALLINT ,    
@par_Codigo NUMERIC,    
@par_MAMO_Codigo NUMERIC,    
@par_Nombre VARCHAR (50),    
@par_Estado SMALLINT,    
@par_USUA_Codigo_Modifica SMALLINT    
)    
AS     
BEGIN    
UPDATE Linea_Motores 
SET     
Nombre = @par_Nombre,    
MAMO_Codigo = @par_MAMO_Codigo,    
Estado =  @par_Estado,    
USUA_Codigo_Modifica =  @par_USUA_Codigo_Modifica,    
Fecha_Modifica = GETDATE()    
    
WHERE     
EMPR_Codigo =  @par_EMPR_Codigo    
AND Codigo =  @par_Codigo    
    
SELECT @par_Codigo As Codigo    
END    
GO
DROP PROCEDURE gsp_obtener_linea_motores
GO
CREATE PROCEDURE gsp_obtener_linea_motores  
(  
 @par_EMPR_Codigo SMALLINT,  
 @par_Codigo NUMERIC  
)  
AS   
BEGIN  
  SELECT  
   1 AS Obtener,  
   LIMO.EMPR_Codigo,  
   LIMO.Codigo,  
   LIMO.Nombre,  
   LIMO.MAMO_Codigo,  
   LIMO.Estado,  
   MAMO.Nombre AS NombreMarca,  
   ROW_NUMBER() OVER(ORDER BY LIMO.Nombre) AS RowNumber  
  FROM  
   Linea_Motores LIMO,  
   Marca_Motores MAMO  
  WHERE  
   LIMO.EMPR_Codigo = MAMO.EMPR_Codigo   
   AND LIMO.MAMO_Codigo = MAMO.Codigo  
  
   AND LIMO.EMPR_Codigo = @par_EMPR_Codigo  
   AND LIMO.Codigo = @par_Codigo  
  
END  
GO
DROP PROCEDURE gsp_eliminar_linea_motores
GO
CREATE PROCEDURE gsp_eliminar_linea_motores
(  
  @par_EMPR_Codigo SMALLINT,  
  @par_Codigo NUMERIC  
  )  
AS  
BEGIN  
    
  DELETE Linea_Motores   
  WHERE EMPR_Codigo = @par_EMPR_Codigo   
    AND Codigo = @par_Codigo  
  
    SELECT @@ROWCOUNT AS Numero  
  
END  
GO
DROP PROCEDURE gsp_insertar_semirremolques              
GO
CREATE PROCEDURE gsp_insertar_semirremolques              
(              
@par_EMPR_Codigo SMALLINT              
,@Codigo NUMERIC = 0              
,@par_Placa varchar(20)              
,@par_Codigo_AlternO varchar(20) = null              
,@par_TERC_Codigo_Propietario NUMERIC = NULL              
,@par_TERC_Codigo_Afiliador NUMERIC = NULL              
,@par_Equipo_Propio SMALLINT = NULL              
,@par_MASE_Codigo NUMERIC = NULL              
,@par_CATA_TISE_Codigo NUMERIC = NULL              
,@par_CATA_TICA_Codigo NUMERIC = NULL              
            
,@par_Modelo NUMERIC = NULL              
,@par_Numero_Ejes SMALLINT = NULL              
,@par_Levanta_Ejes SMALLINT = NULL              
,@par_Ancho NUMERIC(18,2) = NULL              
,@par_Alto NUMERIC(18,2)  = NULL              
,@par_Largo NUMERIC(18,2)  = NULL              
,@par_Peso_Vacio NUMERIC(18,2)  = NULL              
,@par_Capacidad_Galones NUMERIC(18,2)  = NULL              
,@par_Capacidad_Kilos NUMERIC(18,2)  = NULL              
              
,@par_Justificacion_Bloqueo varchar(150) = NULL              
,@par_Estado SMALLINT = NULL              
,@par_USUA_Codigo_Crea SMALLINT = NULL  ,    
@par_Fecha_Vinculacion datetime = null,            
 @par_CATA_LISE_Codigo NUMERIC = NULL                      
              
)              
AS              
BEGIN              
              
IF( @Codigo = 0)              
BEGIN              
 EXEC gsp_generar_consecutivo  @par_EMPR_Codigo, 50, 0, @Codigo OUTPUT                
END              
INSERT INTO Semirremolques              
           (EMPR_Codigo                
           ,Codigo              
           ,Placa              
            ,Codigo_Alterno              
           ,TERC_Codigo_Propietario              
     --5            
                      
           ,Equipo_Propio              
           ,MASE_Codigo              
           ,CATA_TISE_Codigo              
           ,CATA_TICA_Codigo             
     --10             
                      
           ,Modelo              
           ,Numero_Ejes              
           ,Levanta_Ejes              
           ,Ancho              
           ,Alto              
           ,Largo              
           ,Peso_Vacio              
           ,Capacidad_Galones              
           ,Capacidad_Kilos              
                      
           ,Justificacion_Bloqueo              
           ,Estado              
           ,USUA_Codigo_Crea              
           ,Fecha_Crea             
     ,CATA_TIEQ_Codigo        
  ,Reportar_RNDC      
  ,CATA_LISE_Codigo
           )              
     VALUES              
           (@par_EMPR_Codigo              
           ,@Codigo              
           ,@par_Placa              
           ,@par_Codigo_Alterno              
           ,ISNULL(@par_TERC_Codigo_Propietario,0)              
     --5            
                      
           ,ISNULL(@par_Equipo_Propio,0)              
           ,ISNULL(@par_MASE_Codigo,0)              
           ,ISNULL(@par_CATA_TISE_Codigo,3400)              
           ,ISNULL(@par_CATA_TICA_Codigo,2300)              
     --10            
                       
           ,@par_Modelo              
           ,@par_Numero_Ejes              
           ,@par_Levanta_Ejes              
           ,@par_Ancho              
           ,@par_Alto              
           ,@par_Largo              
           ,@par_Peso_Vacio              
           ,@par_Capacidad_Galones              
           ,@par_Capacidad_Kilos              
                        
           ,ISNULL(@par_Justificacion_Bloqueo      ,'')        
           ,ISNULL(@par_Estado,0)              
           ,@par_USUA_Codigo_Crea              
           ,ISNULL(@par_Fecha_Vinculacion,GETDATE())              
			 ,0          
		  ,1      
		  ,@par_CATA_LISE_Codigo
           )              
  
INSERT INTO Semirremolque_Novedades(  
 EMPR_Codigo,  
 SEMI_Codigo,  
 CATA_NOSE_Codigo,  
 Estado,  
 Observaciones,  
 USUA_Codigo_Crea,  
 Fecha_Crea  
 )  
 VALUES(  
 @par_EMPR_Codigo,  
 @Codigo,  
 22404,--Creación Registro  
 1,  
 'Creación Semirremolque',  
@par_USUA_Codigo_Crea,  
GETDATE()  
 )  
                   
select @Codigo as Codigo              
END              
GO
DROP PROCEDURE gsp_modificar_semirremolques        
GO
CREATE PROCEDURE gsp_modificar_semirremolques        
(        
@par_EMPR_Codigo SMALLINT        
,@Codigo NUMERIC        
,@par_Codigo_AlternO varchar(20) = null        
,@par_TERC_Codigo_Propietario NUMERIC = NULL        
,@par_TERC_Codigo_Afiliador NUMERIC = NULL        
,@par_Equipo_Propio SMALLINT = NULL        
,@par_MASE_Codigo NUMERIC = NULL        
,@par_CATA_TISE_Codigo NUMERIC = NULL        
,@par_CATA_TICA_Codigo NUMERIC = NULL        
      
,@par_Modelo NUMERIC = NULL        
,@par_Numero_Ejes SMALLINT = NULL        
,@par_Levanta_Ejes SMALLINT = NULL        
,@par_Ancho NUMERIC(18,2) = NULL        
,@par_Alto NUMERIC(18,2)  = NULL        
,@par_Largo NUMERIC(18,2)  = NULL        
,@par_Peso_Vacio NUMERIC(18,2)  = NULL        
,@par_Capacidad_Galones NUMERIC(18,2)  = NULL        
,@par_Capacidad_Kilos NUMERIC(18,2)  = NULL        
        
,@par_Justificacion_Bloqueo varchar(150) = NULL        
,@par_Estado SMALLINT = NULL        
,@par_USUA_Codigo_Modifica SMALLINT = NULL        
 ,@par_CATA_LISE_Codigo NUMERIC = NULL                      
        
)        
AS        
BEGIN        
        
update Semirremolques        
           set         
     Codigo_Alterno = @par_Codigo_Alterno        
           ,TERC_Codigo_Propietario = ISNULL(@par_TERC_Codigo_Propietario,0)        
      
           ,Equipo_Propio = ISNULL(@par_Equipo_Propio,0)        
           ,MASE_Codigo = ISNULL(@par_MASE_Codigo,0)        
           ,CATA_TISE_Codigo =ISNULL(@par_CATA_TISE_Codigo,3400)        
           ,CATA_TICA_Codigo = ISNULL(@par_CATA_TICA_Codigo,2300)        
                  
           ,Modelo = @par_Modelo        
           ,Numero_Ejes = @par_Numero_Ejes        
           ,Levanta_Ejes = @par_Levanta_Ejes        
           ,Ancho = @par_Ancho        
           ,Alto = @par_Alto        
           ,Largo = @par_Largo        
           ,Peso_Vacio = @par_Peso_Vacio        
           ,Capacidad_Galones = @par_Capacidad_Galones        
           ,Capacidad_Kilos = @par_Capacidad_Kilos        
                 
           ,Justificacion_Bloqueo = ISNULL(@par_Justificacion_Bloqueo,'')    
           ,Estado = ISNULL(@par_Estado,0)        
           ,USUA_Codigo_Modifica = @par_USUA_Codigo_Modifica        
           ,Fecha_Modifica = GETDATE()        
     ,Reportar_RNDC = 1  
	 ,CATA_LISE_Codigo = @par_CATA_LISE_Codigo
     where EMPR_Codigo = @par_EMPR_Codigo        
     and Codigo = @Codigo        
select @Codigo as Codigo        
END        
GO
DROP PROCEDURE gsp_obtener_semirremolque      
GO
CREATE PROCEDURE gsp_obtener_semirremolque      
(      
@par_EMPR_Codigo smallint,      
@par_Codigo numeric = null,      
@par_Placa varchar(20) = null      
)      
as       
begin      
      
select       
1 AS Obtener,      
SEMI.EMPR_Codigo,      
SEMI.Codigo,      
SEMI.Placa,      
ISNULL(SEMI.Codigo_Alterno,'') AS Codigo_Alterno,      
ISNULL(SEMI.Modelo,0) AS Modelo,      
'' AS EstadoSemirremolque,      
SEMI.TERC_Codigo_Propietario,      
    
SEMI.Equipo_Propio,      
SEMI.MASE_Codigo,      
SEMI.CATA_TISE_Codigo,      
SEMI.CATA_TICA_Codigo,      
ISNULL(SEMI.Numero_Ejes,0) AS Numero_Ejes,      
ISNULL(SEMI.Levanta_Ejes,0) AS Levanta_Ejes,      
ISNULL(SEMI.Ancho,0) AS Ancho,      
ISNULL(SEMI.Alto,0) AS Alto,      
ISNULL(Largo,0) AS Largo,      
ISNULL(SEMI.Peso_Vacio,0) AS Peso_Vacio,      
ISNULL(SEMI.Capacidad_Kilos,0) AS Capacidad_Kilos,      
ISNULL(SEMI.Capacidad_Galones,0) AS Capacidad_Galones,      
ISNULL(SEMI.Justificacion_Bloqueo,'') AS Justificacion_Bloqueo,      
SEMI.Estado    ,  
TISE.Campo1 AS TipoSemirremolque, 
SEMI.CATA_LISE_Codigo
      
from       
Semirremolques     SEMI  
  
LEFT JOIN Valor_Catalogos TISE ON  
SEMI.EMPR_Codigo = TISE.EMPR_Codigo AND  
SEMI.CATA_TISE_Codigo = TISE.Codigo  
      
where   
SEMI.EMPR_Codigo = @par_EMPR_Codigo      
and SEMI.Codigo = ISNULL(@par_Codigo,SEMI.Codigo)      
and SEMI.Placa = ISNULL (@par_Placa,SEMI.Placa)      
      
      
end      
GO