PRINT 'gsp_inactivar_usuario_60dias_noIngreso'
GO
DROP PROCEDURE gsp_inactivar_usuario_60dias_noIngreso
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sergio Arboleda
-- Create date: 2021-dic-10
-- Description:	Inactivar automaticamente cuentas que no ingresen por mas de 60 días
-- se exentuan los usuarios de Siplaf y de trazabilidad web (SIPLAF - usuario)
-- se ejecuta por job diariamente.
-- =============================================
CREATE PROCEDURE [dbo].[gsp_inactivar_usuario_60dias_noIngreso]

AS  
BEGIN  
 UPDATE Usuarios set Habilitado = 0 
 
 FROM Usuarios AS USUA

INNER JOIN Terceros AS TERC
ON USUA.EMPR_Codigo = TERC.EMPR_Codigo
AND USUA.TERC_Codigo_Empleado = TERC.Codigo

WHERE 
USUA.Habilitado = 1 --1 ACTIVO / 0 INACTIVO
and USUA.TERC_Codigo_Empleado > 0
AND USUA.Fecha_Ultimo_Ingreso < (GETDATE() - 60)
and USUA.Codigo_Usuario <> 'usuario' --usuario de consulta web de trazabilidad
and USUA.Codigo_Usuario <> 'SIPLAF' --usuario de consulta SIPLAF

END  