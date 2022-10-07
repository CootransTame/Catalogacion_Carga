 print 'gsp_consultar_ciudades'
/****** Object:  StoredProcedure [dbo].[gsp_consultar_ciudades]    Script Date: 6/09/2021 2:38:03 p. m. ******/
DROP PROCEDURE [dbo].[gsp_consultar_ciudades]
GO

/****** Object:  StoredProcedure [dbo].[gsp_consultar_ciudades]    Script Date: 6/09/2021 2:38:03 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[gsp_consultar_ciudades]            
(            
@par_EMPR_Codigo SMALLINT,            
@par_Codigo INT = NULL,            
@par_Codigo_Alterno VARCHAR(20) = NULL,            
@par_Ciudad VARCHAR(40) = NULL,            
@par_Departamento VARCHAR(35) = NULL,            
@par_PAIS_Codigo NUMERIC = NULL,          
@par_NumeroPagina INT = NULL,            
@par_Estado INT = NULL,            
@par_RegistrosPagina INT = NULL,            
@par_Pais VARCHAR(35) = NULL            
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
    AND ((CIUD.Codigo_Alterno LIKE '%' + @par_Codigo_Alterno + '%') OR (@par_Codigo_Alterno IS NULL))            
    AND ((CIUD.Nombre LIKE '%' + @par_Ciudad + '%') OR (@par_Ciudad IS NULL))            
    AND ((DEPA.Nombre LIKE '%' + @par_Departamento + '%') OR (@par_Departamento IS NULL))            
    AND ((PAIS.Nombre LIKE '%' + @par_Pais + '%') OR (@par_Pais IS NULL))           
 AND PAIS.Codigo = ISNULL(@par_PAIS_Codigo, PAIS.Codigo)           
    );            
                        
   WITH Pagina AS            
   (            
            
   SELECT            
    0 AS Obtener,            
    CIUD.EMPR_Codigo,            
    CIUD.Codigo,            
    CIUD.Nombre AS Ciudad,            
    CIUD.Codigo_Alterno,            
    --CIUD.Tarifa_Impuesto1,            
    --CIUD.Tarifa_Impuesto2,      
 CIUD.Codigo_Postal,    
    CIUD.Estado,            
    CIUD.DEPA_Codigo,            
    DEPA.Nombre AS Departamento,            
    DEPA.PAIS_Codigo,            
    PAIS.Nombre AS Pais,            
    CONCAT(CIUD.Nombre,' (',DEPA.Nombre,')') AS CiudadDepartamento,            
 (SELECT COUNT(*) FROM Sitios_Cargue_Descargue WHERE CIUD_Codigo = CIUD.Codigo AND EMPR_Codigo = @par_EMPR_Codigo) AS Cantidad_Sitios,       
 (SELECT COUNT(*) FROM Zona_Ciudades WHERE CIUD_Codigo = CIUD.Codigo AND EMPR_Codigo = @par_EMPR_Codigo) AS Cantidad_Zonas,       
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
    AND ((CIUD.Codigo_Alterno LIKE '%' + @par_Codigo_Alterno + '%') OR (@par_Codigo_Alterno IS NULL))            
    AND ((CIUD.Nombre LIKE '%' + @par_Ciudad + '%') OR (@par_Ciudad IS NULL))            
    AND ((DEPA.Nombre LIKE '%' + @par_Departamento + '%') OR (@par_Departamento IS NULL))            
    AND ((PAIS.Nombre LIKE '%' + @par_Pais + '%') OR (@par_Pais IS NULL))            
 AND PAIS.Codigo = ISNULL(@par_PAIS_Codigo, PAIS.Codigo)           
 )            
 SELECT DISTINCT            
 0 AS Obtener,            
 EMPR_Codigo,            
 Codigo,            
 Ciudad,            
 Codigo_Alterno,            
 --Tarifa_Impuesto1,            
 --Tarifa_Impuesto2,     
 ISNULL(Codigo_Postal,'0') as Codigo_Postal,    
 Estado,            
 DEPA_Codigo,            
 Departamento,            
 PAIS_Codigo,            
 CiudadDepartamento,             
 Pais,            
 Cantidad_Sitios,        
 Cantidad_Zonas,      
 @CantidadRegistros AS TotalRegistros,            
 @par_NumeroPagina AS PaginaObtener,            
 @par_RegistrosPagina AS RegistrosPagina            
 FROM            
  Pagina            
 WHERE            
  RowNumber > (ISNULL(@par_NumeroPagina, 1) -1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)            
  AND RowNumber <= ISNULL(@par_NumeroPagina, 1) * ISNULL(@par_RegistrosPagina, @CantidadRegistros)            
 order by Ciudad            
            
END            
GO


