ALTER TABLE ciudades ADD Permite_Producto_Al_Cobro smallint NULL;
GO
ALTER TABLE Remesas_Paqueteria ADD Producto_Al_Cobro smallint NULL;
GO
----------------------------------------------------------
PRINT 'gsp_insertar_ciudades'
GO
DROP PROCEDURE gsp_insertar_ciudades
GO
CREATE PROCEDURE gsp_insertar_ciudades
(    
	@par_EMPR_Codigo SMALLINT,    
	@par_DEPA_Codigo INT,    
	@par_Nombre VARCHAR(50),    
	@par_Codigo_Alterno VARCHAR(20),    
	@par_Codigo_Postal VARCHAR(50) = null,  
	@par_Calcular_ICA_Oficina smallint = null,  
	@par_Estado SMALLINT,
	@par_PermiteProductoAlcobro SMALLINT,
	@par_USUA_Codigo_Crea SMALLINT    
)    
AS
BEGIN
 INSERT INTO
  Ciudades    
  (    
   EMPR_Codigo,    
   DEPA_Codigo,    
   Nombre,    
   Codigo_Alterno,   
   Codigo_Postal,  
   Calcular_ICA_Oficina,
   Permite_Producto_Al_Cobro,
   Estado,    
   USUA_Codigo_Crea,    
   Fecha_Crea    
  )    
 VALUES    
 (    
  @par_EMPR_Codigo,    
  @par_DEPA_Codigo,    
  @par_Nombre,    
  @par_Codigo_Alterno,    
  @par_Codigo_Postal,  
  ISNULL(@par_Calcular_ICA_Oficina,0),
  @par_PermiteProductoAlcobro,
  @par_Estado,    
  @par_USUA_Codigo_Crea,    
  GETDATE()    
 )    
SELECT Codigo = @@identity    
END
GO
----------------------------------------------------------
PRINT 'gsp_modificar_ciudades'
GO
DROP PROCEDURE gsp_modificar_ciudades
GO
CREATE PROCEDURE gsp_modificar_ciudades
(      
	@par_EMPR_Codigo SMALLINT,      
	@par_Codigo INT,      
	@par_DEPA_Codigo INT,      
	@par_Nombre VARCHAR(50),      
	@par_Codigo_Alterno VARCHAR(20),      
	@par_Codigo_Postal VARCHAR(50) = null,  
	@par_Calcular_ICA_Oficina smallint = null,
	@par_PermiteProductoAlcobro smallint = null,
	@par_Estado SMALLINT,      
	@par_USUA_Codigo SMALLINT      
)      
AS      
BEGIN      
	UPDATE      
	Ciudades      
	SET      
	DEPA_Codigo = @par_DEPA_Codigo,      
	Nombre = @par_Nombre,      
	Codigo_Alterno = @par_Codigo_Alterno,      
	Codigo_Postal =    @par_Codigo_Postal,  
	Calcular_ICA_Oficina = ISNULL(@par_Calcular_ICA_Oficina,0),  
	Permite_Producto_Al_Cobro = @par_PermiteProductoAlcobro,
	Estado = @par_Estado,
	USUA_Codigo_Modifica = @par_USUA_Codigo,      
	Fecha_Modifica = GETDATE()      
	WHERE      
	EMPR_Codigo = @par_EMPR_codigo AND      
	Codigo = @par_Codigo      
      
	SELECT @par_Codigo AS Codigo
END
GO
----------------------------------------------------------
PRINT 'gsp_obtener_ciudades'
GO
DROP PROCEDURE gsp_obtener_ciudades
GO
CREATE PROCEDURE gsp_obtener_ciudades
(    
	@par_EMPR_Codigo SMALLINT,    
	@par_Codigo NUMERIC    
)    
AS    
BEGIN    
	SELECT    
	1 AS Obtener,    
	CIUD.EMPR_Codigo,    
	CIUD.Codigo,    
	CIUD.Nombre AS Ciudad,    
	CIUD.Codigo_Alterno,  
	CIUD.Codigo_Postal,  
	ISNULL(CIUD.Calcular_ICA_Oficina,0) as Calcular_ICA_Oficina,
	ISNULL(CIUD.Permite_Producto_Al_Cobro,0) as Permite_Producto_Al_Cobro,
	CIUD.Estado,    
	CIUD.DEPA_Codigo,    
	DEPA.Nombre AS Departamento,    
	DEPA.PAIS_Codigo,    
	PAIS.Nombre AS Pais,    
	CONCAT(CIUD.Nombre,' (',DEPA.Nombre,')') AS CiudadDepartamento    
    
	FROM    
	Ciudades CIUD,    
	Departamentos DEPA,    
	Paises PAIS    
	WHERE    
	CIUD.EMPR_Codigo = DEPA.EMPR_Codigo    
	AND CIUD.EMPR_Codigo = @par_EMPR_Codigo    
	AND CIUD.DEPA_Codigo = DEPA.Codigo    
	AND DEPA.EMPR_Codigo = PAIS.EMPR_Codigo    
	AND DEPA.PAIS_Codigo = PAIS.Codigo    
	AND CIUD.Codigo = @par_Codigo     
    
END
GO
----------------------------------------------------------
PRINT 'gsp_consultar_ciudades_Autocomplete'
GO
DROP PROCEDURE gsp_consultar_ciudades_Autocomplete
GO
CREATE PROCEDURE gsp_consultar_ciudades_Autocomplete
(                
	@par_EMPR_Codigo SMALLINT,                
	@par_Codigo INT = NULL,                
	@par_Filtro VARCHAR(40) = NULL,                
	@par_Estado SMALLINT = NULl,        
	@par_Ciudad_Oficinas SMALLINT = NULl ,      
	@par_Ciudad_Regiones SMALLINT = NULl,      
	@par_REPA_Codigo NUMERIC = NULL      
)                
AS                
BEGIN               
IF @par_Ciudad_Oficinas > 0        
BEGIN
 SELECT DISTINCT          
    0 AS Obtener,                
    CIUD.EMPR_Codigo,                
    CIUD.Codigo,                
    CIUD.Nombre AS Ciudad,                
    CIUD.Codigo_Alterno,                
 CIUD.Codigo_Postal,    
    --CIUD.Tarifa_Impuesto1,                
    --CIUD.Tarifa_Impuesto2,
	ISNULL(CIUD.Permite_Producto_Al_Cobro,0) as Permite_Producto_Al_Cobro,
    CIUD.Estado,                
    CIUD.DEPA_Codigo,                
    DEPA.Nombre AS Departamento,                
    DEPA.PAIS_Codigo,                
    PAIS.Nombre AS Pais,                
    CONCAT(CIUD.Nombre,' (',DEPA.Nombre,')') AS CiudadDepartamento        
   FROM            
    Ciudades_Oficina_Enturnamiento_Despachos AS COED        
    inner join Ciudades AS CIUD on        
 CIUD.EMPR_Codigo = COED.EMPR_Codigo        
 and COED.CIUD_Codigo = CIUD.Codigo        
              
  LEFT JOIN Departamentos AS DEPA ON                
     CIUD.EMPR_Codigo = DEPA.EMPR_Codigo                
     AND CIUD.DEPA_Codigo = DEPA.Codigo                
              
  LEFT JOIN Paises AS PAIS ON                
     DEPA.EMPR_Codigo = PAIS.EMPR_Codigo                
     AND DEPA.PAIS_Codigo = PAIS.Codigo                
                 
   WHERE                
    CIUD.EMPR_Codigo = DEPA.EMPR_Codigo                
    AND CIUD.DEPA_Codigo = DEPA.Codigo                
    AND DEPA.EMPR_Codigo = PAIS.EMPR_Codigo                
    AND DEPA.PAIS_Codigo = PAIS.Codigo                
    AND CIUD.Codigo <> 0                
    AND CIUD.Estado = ISNULL(@par_Estado, CIUD.Estado)                
    AND CIUD.Codigo = ISNULL(@par_Codigo, CIUD.Codigo)                
    AND CIUD.EMPR_Codigo = @par_EMPR_Codigo                
                   
    AND ((CIUD.Nombre LIKE '%' + @par_Filtro + '%') OR (@par_Filtro IS NULL))                
                
             
 ORDER BY CIUD.Nombre            
END        
ELSE IF @par_Ciudad_Regiones > 0        
BEGIN
 SELECT DISTINCT  top(20)              
    0 AS Obtener,                
    CIUD.EMPR_Codigo,                
    CIUD.Codigo,                
    CIUD.Nombre AS Ciudad,                
    CIUD.Codigo_Alterno,     
 CIUD.Codigo_Postal,               
    --CIUD.Tarifa_Impuesto1,                
    --CIUD.Tarifa_Impuesto2,
	ISNULL(CIUD.Permite_Producto_Al_Cobro,0) as Permite_Producto_Al_Cobro,
    CIUD.Estado,                
    CIUD.DEPA_Codigo,                
    DEPA.Nombre AS Departamento,                
    DEPA.PAIS_Codigo,                
    PAIS.Nombre AS Pais,                
    CONCAT(CIUD.Nombre,' (',DEPA.Nombre,')') AS CiudadDepartamento        
   FROM            
    Ciudades_Regiones_Paises AS CIRP        
    inner join Ciudades AS CIUD on        
 CIUD.EMPR_Codigo = CIRP.EMPR_Codigo        
 and CIRP.CIUD_Codigo = CIUD.Codigo        
              
  LEFT JOIN Departamentos AS DEPA ON                
     CIUD.EMPR_Codigo = DEPA.EMPR_Codigo                
     AND CIUD.DEPA_Codigo = DEPA.Codigo                
              
  LEFT JOIN Paises AS PAIS ON                
     DEPA.EMPR_Codigo = PAIS.EMPR_Codigo                
     AND DEPA.PAIS_Codigo = PAIS.Codigo                
                 
   WHERE                
    CIUD.EMPR_Codigo = DEPA.EMPR_Codigo                
    AND CIUD.DEPA_Codigo = DEPA.Codigo                
    AND DEPA.EMPR_Codigo = PAIS.EMPR_Codigo                
    AND DEPA.PAIS_Codigo = PAIS.Codigo                
    AND CIUD.Codigo <> 0                
    AND CIUD.Estado = ISNULL(@par_Estado, CIUD.Estado)                
    AND CIUD.Codigo = ISNULL(@par_Codigo, CIUD.Codigo)                
    AND CIUD.EMPR_Codigo = @par_EMPR_Codigo                
            
    AND ((CIUD.Nombre LIKE '%' + @par_Filtro + '%') OR (@par_Filtro IS NULL))                
                
             
 ORDER BY CIUD.Nombre            
END       
ELSE IF @par_REPA_Codigo > 0        
BEGIN
 SELECT DISTINCT             
    0 AS Obtener,                
    CIUD.EMPR_Codigo,                
    CIUD.Codigo,                
    CIUD.Nombre AS Ciudad,                
    CIUD.Codigo_Alterno,    
 CIUD.Codigo_Postal,    
    --CIUD.Tarifa_Impuesto1,                
    --CIUD.Tarifa_Impuesto2,
	ISNULL(CIUD.Permite_Producto_Al_Cobro,0) as Permite_Producto_Al_Cobro,
	CIUD.Estado,                
    CIUD.DEPA_Codigo,                
    DEPA.Nombre AS Departamento,                
    DEPA.PAIS_Codigo,                
    PAIS.Nombre AS Pais,                
    CONCAT(CIUD.Nombre,' (',DEPA.Nombre,')') AS CiudadDepartamento        
   FROM            
    Ciudades_Regiones_Paises AS CIRP        
    inner join Ciudades AS CIUD on        
 CIUD.EMPR_Codigo = CIRP.EMPR_Codigo        
 and CIRP.CIUD_Codigo = CIUD.Codigo        
              
  LEFT JOIN Departamentos AS DEPA ON                
     CIUD.EMPR_Codigo = DEPA.EMPR_Codigo                
     AND CIUD.DEPA_Codigo = DEPA.Codigo                
              
  LEFT JOIN Paises AS PAIS ON                
     DEPA.EMPR_Codigo = PAIS.EMPR_Codigo                
     AND DEPA.PAIS_Codigo = PAIS.Codigo                
                 
   WHERE                
    CIUD.EMPR_Codigo = DEPA.EMPR_Codigo                
    AND CIUD.DEPA_Codigo = DEPA.Codigo                
    AND DEPA.EMPR_Codigo = PAIS.EMPR_Codigo                
    AND DEPA.PAIS_Codigo = PAIS.Codigo                
    AND CIUD.Codigo <> 0                
    AND CIUD.Estado = ISNULL(@par_Estado, CIUD.Estado)                
    AND CIUD.Codigo = ISNULL(@par_Codigo, CIUD.Codigo)                
    AND CIUD.EMPR_Codigo = @par_EMPR_Codigo                
                   
    AND ((CIUD.Nombre LIKE '%' + @par_Filtro + '%') OR (@par_Filtro IS NULL))                
    AND CIRP.REPA_Codigo = @par_REPA_Codigo            
             
 ORDER BY CIUD.Nombre            
END       
ELSE        
BEGIN
  IF @par_Codigo > 0 AND @par_Codigo  IS NOT NULL          
  BEGIN          
  SELECT top(1)               
    0 AS Obtener,                
    CIUD.EMPR_Codigo,                
    CIUD.Codigo,                
    CIUD.Nombre AS Ciudad,                
    CIUD.Codigo_Alterno,    
 CIUD.Codigo_Postal,               
    --CIUD.Tarifa_Impuesto1,                
    --CIUD.Tarifa_Impuesto2,
	ISNULL(CIUD.Permite_Producto_Al_Cobro,0) as Permite_Producto_Al_Cobro,
    CIUD.Estado,                
    CIUD.DEPA_Codigo,                
    DEPA.Nombre AS Departamento,                
    DEPA.PAIS_Codigo,                
    PAIS.Nombre AS Pais,                
    CONCAT(CIUD.Nombre,' (',DEPA.Nombre,')') AS CiudadDepartamento,                
    ROW_NUMBER() OVER(ORDER BY CIUD.Nombre) AS RowNumber                
   FROM                
    Ciudades AS CIUD              
              
  LEFT JOIN Departamentos AS DEPA ON                
     CIUD.EMPR_Codigo = DEPA.EMPR_Codigo                
     AND CIUD.DEPA_Codigo = DEPA.Codigo                
              
  LEFT JOIN Paises AS PAIS ON                
     DEPA.EMPR_Codigo = PAIS.EMPR_Codigo                
     AND DEPA.PAIS_Codigo = PAIS.Codigo                
                 
   WHERE                
    CIUD.EMPR_Codigo = DEPA.EMPR_Codigo                
    AND CIUD.DEPA_Codigo = DEPA.Codigo                
    AND DEPA.EMPR_Codigo = PAIS.EMPR_Codigo                
    AND DEPA.PAIS_Codigo = PAIS.Codigo                
    AND CIUD.Codigo <> 0                
    AND CIUD.Codigo = @par_Codigo          
    AND CIUD.EMPR_Codigo = @par_EMPR_Codigo                
                
             
 ORDER BY CIUD.Nombre            
  END          
  ELSE          
  BEGIN          
   SELECT   top(20)              
    0 AS Obtener,                
    CIUD.EMPR_Codigo,                
    CIUD.Codigo,                
    CIUD.Nombre AS Ciudad,                
    CIUD.Codigo_Alterno,     
 CIUD.Codigo_Postal,       
    --CIUD.Tarifa_Impuesto1,                
    --CIUD.Tarifa_Impuesto2,
	ISNULL(CIUD.Permite_Producto_Al_Cobro,0) as Permite_Producto_Al_Cobro,
    CIUD.Estado,                
    CIUD.DEPA_Codigo,                
    DEPA.Nombre AS Departamento,                
    DEPA.PAIS_Codigo,                
    PAIS.Nombre AS Pais,                
    CONCAT(CIUD.Nombre,' (',DEPA.Nombre,')') AS CiudadDepartamento,                
    ROW_NUMBER() OVER(ORDER BY CIUD.Nombre) AS RowNumber                
   FROM                
    Ciudades AS CIUD              
              
  LEFT JOIN Departamentos AS DEPA ON                
     CIUD.EMPR_Codigo = DEPA.EMPR_Codigo              
     AND CIUD.DEPA_Codigo = DEPA.Codigo                
              
  LEFT JOIN Paises AS PAIS ON                
     DEPA.EMPR_Codigo = PAIS.EMPR_Codigo                
     AND DEPA.PAIS_Codigo = PAIS.Codigo                
                 
   WHERE                
    CIUD.EMPR_Codigo = DEPA.EMPR_Codigo                
    AND CIUD.DEPA_Codigo = DEPA.Codigo                
    AND DEPA.EMPR_Codigo = PAIS.EMPR_Codigo                
    AND DEPA.PAIS_Codigo = PAIS.Codigo                
    AND CIUD.Codigo <> 0                
    AND CIUD.Estado = ISNULL(@par_Estado, CIUD.Estado)                
    AND CIUD.Codigo = ISNULL(@par_Codigo, CIUD.Codigo)                
    AND CIUD.EMPR_Codigo = @par_EMPR_Codigo                
                   
    AND ((CIUD.Nombre LIKE '%' + @par_Filtro + '%') OR (@par_Filtro IS NULL))                
                
             
 ORDER BY CIUD.Nombre            
END                
END                
END
GO
----------------------------------------------------------
PRINT 'gsp_insertar_encabezado_remesa_paqueteria'
GO
DROP PROCEDURE gsp_insertar_encabezado_remesa_paqueteria
GO
CREATE PROCEDURE gsp_insertar_encabezado_remesa_paqueteria
(                    
	@par_EMPR_Codigo smallint,                    
	@par_ENRE_Numero numeric,                    
	@par_TERC_Codigo_Transportador_Externo numeric = NULL,                    
	@par_Numero_Guia_Externa varchar(50) = NULL,                    
	@par_CATA_TTRP_Codigo numeric = NULL,                    
	@par_CATA_TDRP_Codigo numeric = NULL,                    
	@par_CATA_TPRP_Codigo numeric = NULL,                    
	@par_CATA_TSRP_Codigo numeric = NULL,                    
	@par_CATA_TERP_Codigo numeric = NULL,                    
	@par_CATA_TIRP_Codigo numeric = NULL,                    
	@par_Fecha_Interfaz_Tracking datetime = NULL,                    
	@par_Fecha_Interfaz_WMS datetime  = NULL,                  
                    
	@par_CATA_ESRP_Codigo numeric = NULL,                  
	@par_Observaciones_Remitente varchar(500) = NULL,                  
	@par_Observaciones_Destinatario varchar(500) = NULL,                  
	@par_CIUD_Codigo_Origen numeric = NULL,                  
	@par_CIUD_Codigo_Destino numeric = NULL,                  
                  
	@par_OFIC_Codigo_Origen numeric = NULL,                  
	@par_OFIC_Codigo_Destino numeric = NULL,                  
	@par_OFIC_Codigo_Actual  numeric = NULL,                  
	@par_Descripcion_Mercancia varchar(500) = NULL,                  
	@par_Reexpedicion  smallint = NULL,                    
                     
	@par_Centro_Costo VARCHAR(20) = NULL,                    
	@par_CATA_LISC_Codigo NUMERIC = NULL,                    
	@par_SICD_Codigo_Cargue NUMERIC = NULL,                    
	@par_SICD_Codigo_Descargue NUMERIC = NULL,                    
	@par_Fecha_Entrega DATETIME = NULL,                  
	@par_Largo numeric(18,5) = NULL,                  
	@par_Alto numeric(18,5) = NULL,                  
	@par_Ancho numeric(18,5) = NULL,                  
	@par_Peso_Volumetrico numeric(18,5) = NULL,                  
	@par_Peso_A_Cobrar numeric(18,5) = NULL,                  
	@par_Flete_Pactado numeric = NULL,                  
	@par_Ajuste_Flete smallint= NULL   ,                    
	@par_Linea_Negocio_Paqueteria NUMERIC = NULL,                    
	@par_Maneja_Detalle_Unidades NUMERIC = NULL,                    
	@par_Recoger_Oficina_Destino NUMERIC = NULL,                  
	@par_OFIC_Codigo_Recibe NUMERIC = NULL,                  
	@par_ZONA_Codigo NUMERIC = NULL,                  
	@par_Latitud NUMERIC(18, 10) = NULL,                  
	@par_Longitud NUMERIC(18, 10) = NULL,                  
	@par_HERP_Codigo NUMERIC = NULL  ,                    
	@par_Liquidar_Unidad NUMERIC = NULL,                
	@par_TERC_Codigo_Aforador NUMERIC = NULL,                
	@par_OFIC_Codigo_Registro_Manual NUMERIC = NULL,                
	@par_Guia_Creada_Ruta_Conductor NUMERIC = NULL,             
	@par_Remesa_Urbana smallint= NULL   ,     
	@par_Numero_Invias NUMERIC = NULL,        
	@par_Producto_Al_Cobro NUMERIC = NULL,
	@par_USUA_Codigo_Crea NUMERIC = NULL
)                    
AS                    
BEGIN                
 INSERT INTO Remesas_Paqueteria (                
 EMPR_Codigo,                    
 ENRE_Numero,                    
 TERC_Codigo_Transportador_Externo,                    
 Numero_Guia_Externa,                    
 CATA_TTRP_Codigo,                    
 CATA_TDRP_Codigo,                    
 CATA_TPRP_Codigo,                    
 CATA_TSRP_Codigo,                    
 CATA_TERP_Codigo,                    
 CATA_TIRP_Codigo,                    
 Fecha_Interfaz_Cargue_Archivo,                    
 Fecha_Interfaz_Cargue_WMS,                    
 CATA_ESRP_Codigo,                    
 Observaciones_Remitente,                    
 Observaciones_Destinatario,                    
 CIUD_Codigo_Origen,                    
 CIUD_Codigo_Destino,                    
                    
 OFIC_Codigo_Origen,                    
 OFIC_Codigo_Destino,                    
 OFIC_Codigo_Actual,                    
 Descripcion_Mercancia,                    
 Reexpedicion,                
 ZOCI_Codigo_Entrega,                    
                    
 Centro_Costo,                    
 CATA_LISC_Codigo,                    
 SICD_Codigo_Cargue,                    
 SICD_Codigo_Descargue,                    
 Fecha_Entrega,                    
 Largo,                    
 Alto,                    
 Ancho,                    
 Peso_Volumetrico,                    
 Peso_A_Cobrar,                    
 Flete_Pactado,         
 Ajuste_Flete,                    
 CATA_LNPA_Codigo,                    
 Recoger_Oficina_Destino,                  
 OFIC_Codigo_Recibe,                  
 Maneja_Detalle_Unidades,                  
 Latitud,              
 Longitud,                  
 CATA_HERP_Codigo,                    
 Liquidar_Unidad,                
 TERC_Codigo_Aforador,                
 OFIC_Codigo_Registro_Manual,            
 Guia_Creada_Ruta_Conductor,    
 Remesa_Urbana,  
 Numero_Invias,
 Producto_Al_Cobro
 )                    
 VALUES (@par_EMPR_Codigo,                    
 ISNULL(@par_ENRE_Numero, 0),                     
 ISNULL(@par_TERC_Codigo_Transportador_Externo, 0),                     
 ISNULL(@par_Numero_Guia_Externa, ''),                     
 ISNULL(@par_CATA_TTRP_Codigo, 6200),                     
 ISNULL(@par_CATA_TDRP_Codigo, 6300),                   
 ISNULL(@par_CATA_TPRP_Codigo, 6400),                     
 ISNULL(@par_CATA_TSRP_Codigo, 6500),                     
 ISNULL(@par_CATA_TERP_Codigo, 6601),                     
 ISNULL(@par_CATA_TIRP_Codigo, 6700),                     
 ISNULL(@par_Fecha_Interfaz_Tracking, '01/01/1900'),                     
 ISNULL(@par_Fecha_Interfaz_WMS, '01/01/1900'),                     
 ISNULL(@par_CATA_ESRP_Codigo, 0),                     
 ISNULL(@par_Observaciones_Remitente, ''),                     
 ISNULL(@par_Observaciones_Destinatario, ''),                    
 @par_CIUD_Codigo_Origen, @par_CIUD_Codigo_Destino,                     
 ISNULL(@par_OFIC_Codigo_Origen, 0),                     
 ISNULL(@par_OFIC_Codigo_Destino, 0),                     
 ISNULL(@par_OFIC_Codigo_Actual, 0),                     
 ISNULL(@par_Descripcion_Mercancia, ''),                     
 ISNULL(@par_Reexpedicion, 0),                     
 ISNULL(@par_ZONA_Codigo, 0),                    
 @par_Centro_Costo,                     
 @par_CATA_LISC_Codigo,                     
 @par_SICD_Codigo_Cargue,                     
 @par_SICD_Codigo_Descargue,                     
 @par_Fecha_Entrega,                     
 @par_Largo, @par_Alto,                     
 @par_Ancho,                     
 @par_Peso_Volumetrico,                     
 @par_Peso_A_Cobrar,                     
 @par_Flete_Pactado,                     
 @par_Ajuste_Flete,                    
 @par_Linea_Negocio_Paqueteria,                    
 @par_Recoger_Oficina_Destino,                    
 @par_OFIC_Codigo_Recibe,                  
 @par_Maneja_Detalle_Unidades,                  
 @par_Latitud,                  
 @par_Longitud,                  
 @par_HERP_Codigo,                    
 @par_Liquidar_Unidad,                
 @par_TERC_Codigo_Aforador,                
 @par_OFIC_Codigo_Registro_Manual,            
 @par_Guia_Creada_Ruta_Conductor  ,    
 @par_Remesa_Urbana ,   
 @par_Numero_Invias,
 @par_Producto_Al_Cobro
 )                    
                    
        
                  
 SELECT                    
 ENRE_Numero AS Numero                    
 FROM Remesas_Paqueteria                    
 WHERE EMPR_Codigo = @par_EMPR_Codigo                    
 AND ENRE_Numero = @par_ENRE_Numero                    
END
GO
----------------------------------------------------------
PRINT 'gsp_modificar_encabezado_remesa_paqueteria'
GO
DROP PROCEDURE gsp_modificar_encabezado_remesa_paqueteria
GO
CREATE PROCEDURE gsp_modificar_encabezado_remesa_paqueteria
(                    
	@par_EMPR_Codigo smallint,                    
	@par_ENRE_Numero numeric,                    
	@par_TERC_Codigo_Transportador_Externo numeric = NULL,                    
	@par_Numero_Guia_Externa varchar(50) = NULL,                    
	@par_CATA_TTRP_Codigo numeric = NULL,                    
	@par_CATA_TDRP_Codigo numeric = NULL,                    
	@par_CATA_TPRP_Codigo numeric = NULL,                    
	@par_CATA_TSRP_Codigo numeric = NULL,                    
	@par_CATA_TERP_Codigo numeric = NULL,                    
	@par_CATA_TIRP_Codigo numeric = NULL,                    
	@par_Fecha_Interfaz_Tracking datetime = NULL,                    
	@par_Fecha_Interfaz_WMS datetime  = NULL,             
                  
	@par_CATA_ESRP_Codigo numeric = NULL,                  
	@par_Observaciones_Remitente varchar(500) = NULL,                  
	@par_Observaciones_Destinatario varchar(500) = NULL,            
	@par_CIUD_Codigo_Origen numeric = NULL,                  
	@par_CIUD_Codigo_Destino numeric = NULL,            
                     
	@par_OFIC_Codigo_Origen numeric = NULL,                  
	@par_OFIC_Codigo_Destino numeric = NULL,                  
	@par_OFIC_Codigo_Actual  numeric = NULL,                  
	@par_Descripcion_Mercancia varchar(500) = NULL,                  
	@par_Reexpedicion  smallint = NULL,                    
            
	@par_Centro_Costo VARCHAR(20) = NULL,                  
	@par_CATA_LISC_Codigo NUMERIC  =NULL,                  
	@par_SICD_Codigo_Cargue NUMERIC  =NULL,                  
	@par_SICD_Codigo_Descargue NUMERIC  =NULL,                  
	@par_Fecha_Entrega DATETIME = NULL,                  
	@par_Largo numeric(18,5) = NULL,                    
	@par_Alto numeric(18,5) = NULL,                    
	@par_Ancho numeric(18,5) = NULL,                    
	@par_Peso_Volumetrico numeric(18,5) = NULL,                    
	@par_Peso_A_Cobrar numeric(18,5) = NULL,                    
	@par_Flete_Pactado numeric = NULL,                    
	@par_Ajuste_Flete smallint= NULL,                  
                    
	@par_Linea_Negocio_Paqueteria NUMERIC = NULL,                  
	@par_Maneja_Detalle_Unidades NUMERIC = NULL,                  
	@par_Recoger_Oficina_Destino NUMERIC = NULL,                    
	@par_OFIC_Codigo_Recibe NUMERIC = NULL,                   
	@par_ZONA_Codigo NUMERIC = NULL,                    
	@par_Latitud NUMERIC(18, 10) = NULL,                    
	@par_Longitud NUMERIC(18, 10) = NULL,                    
	@par_HERP_Codigo NUMERIC = NULL  ,                  
	@par_Liquidar_Unidad NUMERIC = NULL,                
	@par_TERC_Codigo_Aforador NUMERIC = NULL,                
	@par_OFIC_Codigo_Registro_Manual NUMERIC = NULL,            
	@par_Guia_Creada_Ruta_Conductor NUMERIC = NULL,                
	@par_Remesa_Urbana smallint= NULL   ,                    
	@par_Numero_Invias NUMERIC = NULL, 
	@par_Producto_Al_Cobro NUMERIC = NULL,
	@par_USUA_Codigo_Crea NUMERIC = NULL            
)                    
AS                    
BEGIN                  
	DELETE Detalle_Reexpedicion_Remesas_Paqueteria            
	WHERE EMPR_Codigo = @par_EMPR_Codigo            
	AND ENRE_Numero = @par_ENRE_Numero            
            
	DELETE Remesa_Gestion_Documentos            
	WHERE EMPR_Codigo = @par_EMPR_Codigo            
	AND ENRE_Numero = @par_ENRE_Numero            
          
	DELETE Detalle_Etiquetas_Remesas_Paqueteria            
	WHERE EMPR_Codigo = @par_EMPR_Codigo            
	AND ENRE_Numero = @par_ENRE_Numero        
        
	--Libera Preimpresos        
	Update Detalle_Asignacion_Guias_Preimpresas SET         
	ENRE_Numero = 0, USUA_Codigo_Modifica = @par_USUA_Codigo_Crea, Fecha_Modifica = GETDATE()        
	WHERE EMPR_Codigo = @par_EMPR_Codigo        
	AND ENRE_Numero = @par_ENRE_Numero         
	--Libera Preimpresos        
                    
	UPDATE Remesas_Paqueteria            
	SET                  
	TERC_Codigo_Transportador_Externo = ISNULL(@par_TERC_Codigo_Transportador_Externo,0),                 
	Numero_Guia_Externa =  ISNULL(@par_Numero_Guia_Externa,''),                    
	CATA_TTRP_Codigo =  ISNULL(@par_CATA_TTRP_Codigo,0),                    
                    
	CATA_TDRP_Codigo =  ISNULL(@par_CATA_TDRP_Codigo,0),                    
	CATA_TPRP_Codigo =  ISNULL(@par_CATA_TPRP_Codigo,0),                    
	CATA_TSRP_Codigo  = ISNULL(@par_CATA_TSRP_Codigo,0),                    
	CATA_TERP_Codigo =  ISNULL(@par_CATA_TERP_Codigo,0),                    
	CATA_TIRP_Codigo =  ISNULL(@par_CATA_TIRP_Codigo,0),                    
                    
	Fecha_Interfaz_Cargue_Archivo =  ISNULL(@par_Fecha_Interfaz_Tracking,'01/01/1900'),                  
	Fecha_Interfaz_Cargue_WMS  = ISNULL(@par_Fecha_Interfaz_WMS,'01/01/1900'),                  
	CATA_ESRP_Codigo  = ISNULL(@par_CATA_ESRP_Codigo,0),                  
	Observaciones_Remitente =  ISNULL(@par_Observaciones_Remitente,''),                  
	Observaciones_Destinatario =  ISNULL(@par_Observaciones_Destinatario,''),                  
                    
	CIUD_Codigo_Origen =  @par_CIUD_Codigo_Origen,               
	CIUD_Codigo_Destino =  @par_CIUD_Codigo_Destino,                    
	OFIC_Codigo_Origen =  ISNULL(@par_OFIC_Codigo_Origen,0),                  
	OFIC_Codigo_Destino =   ISNULL(@par_OFIC_Codigo_Destino,0),                  
	OFIC_Codigo_Actual =  ISNULL(@par_OFIC_Codigo_Actual,0),                  
                    
	Descripcion_Mercancia  = ISNULL(@par_Descripcion_Mercancia,''),                  
	Reexpedicion  =  ISNULL(@par_Reexpedicion,0),                  
	Centro_Costo = @par_Centro_Costo,                  
	CATA_LISC_Codigo = @par_CATA_LISC_Codigo,                  
	SICD_Codigo_Cargue = @par_SICD_Codigo_Cargue,                  
	SICD_Codigo_Descargue = @par_SICD_Codigo_Descargue,                  
	Fecha_Entrega = @par_Fecha_Entrega,                  
                    
	Largo = @par_Largo,                    
	Alto = @par_Alto,                    
	Ancho = @par_Ancho,                    
	Peso_Volumetrico = @par_Peso_Volumetrico,                  
	Peso_A_Cobrar = @par_Peso_A_Cobrar,                  
	Flete_Pactado = @par_Flete_Pactado,                  
	Ajuste_Flete = @par_Ajuste_Flete,                    
                    
	CATA_LNPA_Codigo = @par_Linea_Negocio_Paqueteria,                    
	Maneja_Detalle_Unidades = @par_Maneja_Detalle_Unidades,                    
	Recoger_Oficina_Destino = @par_Recoger_Oficina_Destino,                  
	OFIC_Codigo_Recibe = @par_OFIC_Codigo_Recibe,                  
                  
	Latitud = @par_Latitud,                    
	Longitud = @par_Longitud,                    
	CATA_HERP_Codigo = @par_HERP_Codigo,                    
	Liquidar_Unidad = @par_Liquidar_Unidad,                
	TERC_Codigo_Aforador = @par_TERC_Codigo_Aforador,                
	OFIC_Codigo_Registro_Manual = @par_OFIC_Codigo_Registro_Manual,            
	Guia_Creada_Ruta_Conductor = @par_Guia_Creada_Ruta_Conductor,      
	ZOCI_Codigo_Entrega = @par_ZONA_Codigo,    
	Remesa_Urbana = @par_Remesa_Urbana,
	Producto_Al_Cobro = @par_Producto_Al_Cobro,
	Numero_Invias = @par_Numero_Invias  
                    
	WHERE EMPR_Codigo = @par_EMPR_Codigo                    
	AND ENRE_Numero = @par_ENRE_Numero        
         
	--Asignar Preimpreso        
	DECLARE @Numeracion VARCHAR (50) = NULL        
	SELECT @Numeracion = Numeracion FROM Encabezado_Remesas WHERE EMPR_Codigo = @par_EMPR_Codigo AND Numero = @par_ENRE_Numero        
	IF ISNULL(@Numeracion, '') != ''        
	BEGIN        
	Update Detalle_Asignacion_Guias_Preimpresas SET         
	ENRE_Numero = @par_ENRE_Numero, USUA_Codigo_Modifica = @par_USUA_Codigo_Crea, Fecha_Modifica = GETDATE()        
	WHERE EMPR_Codigo = @par_EMPR_Codigo        
	AND OFIC_Codigo_Origen = @par_OFIC_Codigo_Registro_Manual        
	AND TERC_Codigo_Responsable = @par_TERC_Codigo_Aforador        
	AND Numero_Preimpreso = @Numeracion        
	END        
	--Asignar Preimpreso        
        
	SELECT ENRE_Numero As Numero FROM Remesas_Paqueteria                    
	WHERE EMPR_Codigo = @par_EMPR_Codigo                    
	AND ENRE_Numero = @par_ENRE_Numero                    
	END
GO
----------------------------------------------------------
PRINT 'gsp_obtener_remesa_paqueteria'
GO
DROP PROCEDURE gsp_obtener_remesa_paqueteria
GO
CREATE PROCEDURE gsp_obtener_remesa_paqueteria
(                                        
	@par_EMPR_Codigo smallint,                                    
	@par_Numero Numeric = NULL,                
	@par_Numero_Documento Numeric = NULL,                
	@par_TIDO_Codigo Numeric = NULL                
)                                        
AS                                    
BEGIN                      
if @par_Numero = 0 or @par_Numero is null    
begin    
select @par_Numero = Numero from Encabezado_Remesas where Numero_Documento = @par_Numero_Documento and TIDO_Codigo = 100    
end    
    
 select DISTINCT                                         
 1 as Obtener,                                        
 ENRE.EMPR_Codigo,                                          
 ENRE.Fecha,                                          
 ENRE.Numero,                                        
 ENRE.Numeracion,                                         
 ENRE.Numero_Documento,                                          
 ENRE.Remesa_Cortesia,                                        
 ENRE.Documento_Cliente,                                          
 ENRE.Observaciones,                                          
 ENRE.Fecha_Documento_Cliente,                                          
 ENRE.CATA_FOPR_Codigo,                                          
 ENRE.CATA_MEPA_Codigo,                                          
 ENRE.TERC_Codigo_Cliente,                                          
 ENRE.DTCV_Codigo,                                          
 ENRE.PRTR_Codigo,                                          
 ENRE.Peso_Cliente,                                          
 ENRE.Cantidad_Cliente,                                          
 ENRE.Valor_Comercial_Cliente,                                          
 ENRE.Peso_Volumetrico_Cliente,                                          
 ENPR.CATA_TERP_Codigo,                                          
 ENPR.CATA_TTRP_Codigo,                                          
 ENPR.CATA_TDRP_Codigo,                                          
 ENPR.CATA_TIRP_Codigo,                                          
 ENPR.CATA_TPRP_Codigo,                                          
 ENPR.CATA_TSRP_Codigo,                                          
                                        
 ENRE.TERC_Codigo_Remitente,                                          
 ENRE.CIUD_Codigo_Remitente,                                          
 ENRE.Direccion_Remitente,                                          
 ENRE.Telefonos_Remitente,                                          
 ENRE.TERC_Codigo_Destinatario,                                          
 ENRE.CIUD_Codigo_Destinatario,                                          
 ENRE.Direccion_Destinatario,                                          
 ENRE.Telefonos_Destinatario,                                          
 ENRE.Valor_Flete_Cliente,                                          
 ENRE.Valor_Manejo_Cliente,                                          
 ENRE.Valor_Seguro_Cliente,                                          
 ENRE.Valor_Descuento_Cliente,                                          
 ENRE.Total_Flete_Cliente,                                        
 ENRE.Valor_Comision_Oficina,                                        
 ENRE.Valor_Comision_Agencista,                                        
 ENRE.Total_Flete_Transportador,                                          
 ENRE.Estado,                                        
 ISNULL(ENPR.OFIC_Codigo_Origen,0) AS OFIC_Codigo_Origen,                                        
 ISNULL(OFOR.Nombre, '') AS NombreOficinaOrigen,                                        
 ISNULL(DTCV.ETCV_Numero,DTCV2.ETCV_Numero) As ETCV_Numero,                                        
 ISNULL(DTCV.LNTC_Codigo,DTCV2.LNTC_Codigo) As LNTC_Codigo,                                          
 ISNULL(DTCV.TLNC_Codigo,DTCV2.TLNC_Codigo) As TLNC_Codigo,                                        
 ISNULL(DTCV.RUTA_Codigo,DTCV2.RUTA_Codigo) As RUTA_Codigo,                                        
 ISNULL(DTCV.TATC_Codigo,DTCV2.TATC_Codigo) As TATC_Codigo,                   
 ISNULL(TTTC.NombreTarifa,'') As NombreTarifa,                                        
 ISNULL(DTCV.TTTC_Codigo,DTCV2.TTTC_Codigo) As TTTC_Codigo,                                        
 ISNULL(TTTC.Nombre,'') As NombreTipoTarifa,                                        
                                        
 ENPR.Fecha_Interfaz_Cargue_Archivo,                                        
 ENPR.Fecha_Interfaz_Cargue_WMS,                                        
 ISNULL(ENRE.VEHI_Codigo,0) as VEHI_Codigo,                              
 ISNULL(VEHI.Placa,'') As VEHI_Placa,                  
 ISNULL(VEHI.Codigo_Alterno,'') As VEHI_CodigoAlterno,                  
 ISNULL(ENRE.SEMI_Codigo,0) As SEMI_Codigo,                                         
                                        
 ENRE.CATA_TIRE_Codigo,                                         
 ISNULL(ENPR.Reexpedicion,0) As Reexpedicion,                                        
 ISNULL(ENRE.Valor_Reexpedicion,0) As Valor_Reexpedicion,                              
 REMI.CATA_TIID_Codigo As TIID_Remitente,                                        
 REMI.Numero_Identificacion As Identificacion_Remitente,                          
 RTRIM(LTRIM(ISNULL(REMI.Razon_Social,'') + ISNULL(REMI.Nombre,'') + ' ' + ISNULL(REMI.Apellido1, '') + ' ' + ISNULL(REMI.Apellido2,''))) As NombreRemitente,                                        
 ISNULL(REMI.Correo_Facturacion, '') AS Correo_Remitente,                                        
 ISNULL(ENRE.Barrio_Remitente,'') As Barrio_Remitente,                      
 ISNULL(ENRE.Codigo_Postal_Remitente,'') As Codigo_Postal_Remitente,                                        
 ISNULL(ENPR.Observaciones_Remitente,'') As Observaciones_Remitente,                                        
                                        
 DEST.CATA_TIID_Codigo As TIID_Destinatario,                                        
 DEST.Numero_Identificacion As Identificacion_Destinatario,                                        
 LTRIM(RTRIM(ISNULL(DEST.Razon_Social,'') + ISNULL(DEST.Nombre,'') + ' ' + ISNULL(DEST.Apellido1, '') + ' ' + ISNULL(DEST.Apellido2,''))) As NombreDestinatario,                                        
 ISNULL(DEST.Correo_Facturacion, '') AS Correo_Destinatario,                                        
 ISNULL(ENRE.Barrio_Destinatario,'') As Barrio_Destinatario,                                          
                                          
                                         
 ISNULL(ENRE.Codigo_Postal_Destinatario, '') As Codigo_Postal_Destinatario,                                        
 ISNULL(ENPR.Observaciones_Destinatario,'') As Observaciones_Destinatario,                                        
 ISNULL(ENPR.Descripcion_Mercancia,'') As Descripcion_Mercancia,                                        
 ISNULL(ENPR.OFIC_Codigo_Origen,0) As OFIC_Codigo_Origen,                                        
 ISNULL(ENPR.OFIC_Codigo_Destino,0) As OFIC_Codigo_Destino,                                           
 ISNULL(ENPR.OFIC_Codigo_Actual,0) As OFIC_Codigo_Actual,                                        
 --ISNULL(OFOR.Nombre,'') As NombreOficinaOrigen,                                        
 ISNULL(OFDE.Nombre,'') As NombreOficinaDestino,                                        
 ISNULL(OFAC.Nombre,'') As NombreOficinaActual,                                        
                                     
 ENPR.CATA_ESRP_Codigo,                              
 DERP.Fecha_Crea AS Fecha_Estado_Remesa,                          
 OFER.Nombre AS Oficina_Nombre_Estado_Remesa,                          
 ESRP.Nombre As NombreEstadoRemesa,                                        
 ENRE.ENPD_Numero,                 
                 
--IIF (ENRE.ENPD_NUMERO IS NULL,EPRC.NUMERO_DOCUMENTO, EPLR.NUMERO_DOCUMENTO)                
--AS NumeroDocumentoPlanilla,                  
            
CASE WHEN ENRE.ENPD_NUMERO > 0 THEN EPRE.Numero_Documento ELSE IIF (ENRE.ENPD_NUMERO IS NULL,EPRC.NUMERO_DOCUMENTO, EPLR.NUMERO_DOCUMENTO)  END AS NumeroDocumentoPlanilla,            
                
 --CASE                                     
-- WHEN ENRE.ENPR_Numero = 0 THEN                
 --WHEN ENRE.ENPD_Numero IS NULL THEN                
 --(CASE WHEN ENPD.Numero_Documento = 0 THEN ENPE.Numero_Documento ELSE ENPD.Numero_Documento END )                                         
 --IIF(ENRE.ENPD_Numero IS NULL ,ENRE.ENPR_NUMERO,ENPD.Numero_Documento)                                        
 --ELSE ENPR.Numero_Documento END  AS NumeroDocumentoPlanilla,                      
                
                
                
 ENPD.Fecha AS FechaPlanillaActual,                                     
 ISNULL(ENFA.Numero_Documento, 0) AS ENFA_Numero_Documento,                                      
 ISNULL(COND.Razon_Social,'') + ISNULL(COND.Nombre,'') + ' ' + ISNULL(COND.Apellido1, '') + ' ' + ISNULL(COND.Apellido2,'') As NombreConductor,                                        
 ENRE.OFIC_Codigo,                                        
 OFIC.Nombre As NombreOficina,                                          
 ENPR.Centro_Costo,                            
 ENPR.CATA_LISC_Codigo,                                          
 SICA.Nombre AS SitioCargue,                                        
 ENPR.SICD_Codigo_Cargue,                                          
 SIDE.Nombre AS SitioDescargue,                 
 ENPR.SICD_Codigo_Descargue,                                          
 ENPR.Fecha_Entrega,                                          
 ENRE.Valor_Flete_Transportador,                                          
 ENRE.Total_Flete_Transportador,                                        
 ENPR.Largo,                                        
 ENPR.Alto,                                        
 ENPR.Ancho,                                        
 ENPR.Peso_Volumetrico,                                        
 ENPR.Peso_A_Cobrar,                                      
 ENPR.Flete_Pactado,                                        
 ENPR.Ajuste_Flete,                                          
 ENPR.CATA_LNPA_Codigo,                                          
 ENPR.Recoger_Oficina_Destino,                                        
 ENPR.OFIC_Codigo_Recibe,                                        
 OFRE.Nombre AS OFIC_Nombre_Recibe,                                        
 ENPR.Maneja_Detalle_Unidades,                                        
 ENPR.ZOCI_Codigo_Entrega,                                        
 ENPR.Latitud,                                        
 ENPR.Longitud,                                        
 ENPR.CATA_HERP_Codigo,                                          
 ENPR.Liquidar_Unidad,                                        
 ISNULL(ENRE.Valor_Otros, 0) Valor_Otros,                                        
 ISNULL(ENRE.Valor_Cargue, 0) Valor_Cargue,                                        
 ISNULL(ENRE.Valor_Descargue, 0) Valor_Descargue,                                      
 ISNULL(ENPR.Devolucion, '') Devolucion,                                      
 ISNULL(ENPR.Fecha_Devolucion, '') Fecha_Devolucion,                          
 ISNULL(ELRG.Numero_Documento, 0) ELRG_NumeroDocumento,                                
 ISNULL(ENPR.TERC_Codigo_Aforador, 0) TERC_Codigo_Aforador,                                  
 ISNULL(ENPR.OFIC_Codigo_Registro_Manual, 0) OFIC_Codigo_Registro_Manual,                      
 ISNULL(NERP.Campo1, '') AS NovedadRecibe,                    
 ISNULL(ELGU.Numero_Documento, 0) AS ELGU_NumeroDocumento,          
 ENPR.Remesa_Urbana,      
 ENPR.Producto_Al_Cobro,
 ENPR.Numero_Invias                     
 from                         
 Remesas_Paqueteria as ENPR                                        
                                          
 LEFT JOIN Sitios_Cargue_Descargue AS SICA ON                                          
 ENPR.EMPR_Codigo = SICA.EMPR_Codigo             
 AND ENPR.SICD_Codigo_Cargue = SICA.Codigo                                          
                                          
 LEFT JOIN Sitios_Cargue_Descargue AS SIDE ON                                          
 ENPR.EMPR_Codigo = SIDE.EMPR_Codigo                                          
 AND ENPR.SICD_Codigo_Descargue = SIDE.Codigo                                          
                                          
 INNER JOIN Encabezado_Remesas AS ENRE                                          
 ON ENPR.EMPR_Codigo = ENRE.EMPR_Codigo                                        
 AND ENPR.ENRE_Numero = ENRE.Numero                                          
                                          
 LEFT JOIN Terceros As REMI ON                                        
 ENRE.EMPR_Codigo = REMI.EMPR_Codigo                                        
 AND ENRE.TERC_Codigo_Remitente = REMI.Codigo           
                                         
 LEFT JOIN Terceros As DEST ON                                        
 ENRE.EMPR_Codigo = DEST.EMPR_Codigo                                        
 AND ENRE.TERC_Codigo_Destinatario = DEST.Codigo                                         
                                         
 LEFT JOIN V_Estado_Remesa_Paqueteria AS ESRP ON                                        
 ENPR.EMPR_Codigo = ESRP.EMPR_Codigo                                   
 AND ENPR.CATA_ESRP_Codigo = ESRP.Codigo                                        
                                        
 LEFT JOIN Oficinas AS OFIC ON                                        
 ENRE.EMPR_Codigo = OFIC.EMPR_Codigo                                        
 AND ENRE.OFIC_Codigo = OFIC.Codigo                                        
             
 LEFT JOIN Oficinas As OFOR ON                                        
 ENPR.EMPR_Codigo = OFOR.EMPR_Codigo                                        
 AND ENPR.OFIC_Codigo_Origen = OFOR.Codigo                                        
                                        
 LEFT JOIN Oficinas As OFDE ON                                        
 ENPR.EMPR_Codigo = OFDE.EMPR_Codigo                                        
 AND ENPR.OFIC_Codigo_Destino = OFDE.Codigo                                        
                                         
 LEFT JOIN Oficinas As OFAC ON                                        
 ENPR.EMPR_Codigo = OFAC.EMPR_Codigo                                        
 AND ENPR.OFIC_Codigo_Actual = OFAC.Codigo                                        
                                        
 LEFT JOIN Oficinas As OFRE ON                                        
 ENPR.EMPR_Codigo = OFRE.EMPR_Codigo                                        
 AND ENPR.OFIC_Codigo_Recibe = OFRE.Codigo                                        
                                           
 LEFT JOIN Detalle_Tarifario_Carga_Ventas AS DTCV                                          
 ON ENPR.EMPR_Codigo = DTCV.EMPR_Codigo                                         
 AND ENRE.DTCV_Codigo = DTCV.Codigo                                        
                                          
 LEFT JOIN Detalle_Tarifario_Carga_Ventas AS DTCV2                                          
 ON ENPR.EMPR_Codigo = DTCV2.EMPR_Codigo                                          
 AND ENRE.EMPR_Codigo = DTCV2.EMPR_Codigo                                          
 AND ENRE.ETCV_Numero = DTCV2.ETCV_Numero                                          
 AND ENRE.CIUD_Codigo_Remitente = DTCV2.CIUD_Codigo_Origen                                          
 AND ENRE.CIUD_Codigo_Destinatario= DTCV2.CIUD_Codigo_Destino                                        
 AND ENRE.CATA_FOPR_Codigo= DTCV2.CATA_FPVE_Codigo                                      
                                         
 LEFT JOIN V_Tipo_Tarifa_Transporte_Carga As TTTC ON                                        
 ISNULL(DTCV.EMPR_Codigo,DTCV2.EMPR_Codigo) = TTTC.EMPR_Codigo                                        
 AND ISNULL(DTCV.TATC_Codigo,DTCV2.TATC_Codigo) = TTTC.TATC_Codigo                                        
 AND ISNULL(DTCV.TTTC_Codigo,DTCV2.TTTC_Codigo) = TTTC.Codigo                                        
                                        
 LEFT JOIN Vehiculos AS VEHI ON                                        
 ENRE.EMPR_Codigo = VEHI.EMPR_Codigo                                        
 AND ENRE.VEHI_Codigo = VEHI.Codigo                                        
                  
 LEFT JOIN Terceros As COND ON                                        
 ENRE.EMPR_Codigo = COND.EMPR_Codigo                                        
 AND ENRE.TERC_Codigo_Conductor = COND.Codigo                            
 AND ENRE.TERC_Codigo_Conductor > 0                            
                              
 LEFT JOIN Encabezado_Planilla_Despachos As ENPD ON                                        
 ENPD.EMPR_Codigo = ENPR.EMPR_Codigo                                        
 AND ENPD.Numero = ENPR.ENPD_Numero_Ultima_Planilla                          
                                     
 LEFT JOIN Encabezado_Planilla_Despachos As EPLR ON --Numero planilla de Recoleccion                            
 ENRE.ENPR_Numero = EPLR.Numero                
                
 LEFT JOIN Encabezado_Planilla_Despachos As EPRC ON --Numero planilla de Recoleccion                            
 ENRE.ENPR_Numero = EPRC.Numero                
                
 LEFT JOIN Encabezado_Planilla_Despachos As EPRE ON                 
 EPRE.EMPR_Codigo = ENRE.EMPR_Codigo                                     
 AND EPRE.Numero = ENRE.ENPD_Numero                                         
                                        
                 
 LEFT JOIN Encabezado_Planilla_Despachos As ENPE ON                                        
 ENPE.EMPR_Codigo = ENRE.EMPR_Codigo                                        
 AND ENPE.Numero = ENRE.ENPE_Numero                                      
                                      
 LEFT JOIN Encabezado_Facturas As ENFA ON                                        
 ENRE.EMPR_Codigo = ENFA.EMPR_Codigo                                        
 AND ENRE.ENFA_Numero = ENFA.Numero                                    
                          
 LEFT JOIN Detalle_Legalizacion_Recaudo_Guias As DLRG ON                                        
 ENRE.EMPR_Codigo = DLRG.EMPR_Codigo                                        
 AND ENRE.Numero = DLRG.ENRE_Numero                                    
                                    
 LEFT JOIN Encabezado_Legalizacion_Recaudo_Guias As ELRG ON                                        
 DLRG.EMPR_Codigo = ELRG.EMPR_Codigo                                        
 AND DLRG.ELRG_Numero = ELRG.Numero                              
                              
 LEFT JOIN (                              
 SELECT TOP 1 ERPA.* FROM Detalle_Estados_Remesas_Paqueteria ERPA                              
 LEFT JOIN Encabezado_Planilla_Despachos ENDP1 ON                              
 ERPA.EMPR_Codigo = ENDP1.EMPR_Codigo                              
 AND ERPA.ENPD_Numero = ENDP1.Numero                      
                     
 WHERE ERPA.EMPR_Codigo = @par_EMPR_Codigo                              
 AND ERPA.ENRE_Numero = @par_Numero                              
 AND ISNULL(ENDP1.Anulado, 0) = 0                          
 AND ERPA.OFIC_Codigo IS NOT NULL                          
                              
 ORDER BY ID DESC                              
 ) AS DERP ON                              
 ENPR.EMPR_Codigo = DERP.EMPR_Codigo                                        
 AND ENPR.CATA_ESRP_Codigo = DERP.CATA_ESPR_Codigo                          
                          
 LEFT JOIN Oficinas OFER ON                      
 DERP.EMPR_Codigo = OFER.EMPR_Codigo                          
 AND DERP.OFIC_Codigo = OFER.Codigo                       
                       
 LEFT JOIN Valor_Catalogos NERP ON                          
 ENPR.EMPR_Codigo = NERP.EMPR_Codigo                          
 AND ENPR.CATA_NERP_Codigo = NERP.Codigo                     
                     
 LEFT JOIN (                      
 SELECT DLGU.EMPR_Codigo, DLGU.ENRE_Numero, MAX(ENLG.Numero_Documento) AS Numero_Documento FROM Detalle_Legalizacion_Guias DLGU                      
 INNER JOIN Encabezado_Legalizacion_Guias ENLG ON                            
 ENLG.EMPR_Codigo = DLGU.EMPR_Codigo                            
 AND ENLG.Numero = DLGU.ELGU_Numero                      
 WHERE DLGU.EMPR_Codigo = @par_EMPR_Codigo                      
 AND DLGU.ENRE_Numero = @par_Numero                    
 AND ENLG.Estado = 1                    
 AND ENLG.Anulado = 0                    
 group by DLGU.EMPR_Codigo, DLGU.ENRE_Numero                      
 ) AS ELGU ON                      
 ENRE.EMPR_Codigo = ELGU.EMPR_Codigo                            
 AND ENRE.Numero = ELGU.ENRE_Numero                              
                             
 WHERE                                      
 ENRE.EMPR_Codigo = @par_EMPR_Codigo                                        
 AND ENRE.Numero = @par_Numero                                        
 AND ENRE.TIDO_Codigo IN(110,111,100)-->paqueteria, mensajeria                
END
GO
----------------------------------------------------------
