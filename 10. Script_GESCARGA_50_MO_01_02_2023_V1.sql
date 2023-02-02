PRINT 'gsp_consultar_guias_api_clientes'
GO
DROP PROCEDURE gsp_consultar_guias_api_clientes
GO
CREATE PROCEDURE gsp_consultar_guias_api_clientes
(
	@par_Numero_documento NUMERIC = NULL,
	@par_Numero_factura NUMERIC = NULL,            
	@par_Numero_pedido VARCHAR(30) = NULL,
	@par_Codigo_cliente NUMERIC
)
AS                                                                                        
BEGIN  

	SELECT TOP 200
	ENRE.Numero,
	ENRE.Numero_Documento,
	CIOR.Nombre AS CiudadOrigen,
	DEOR.Nombre AS DepartamentoOrigen,
	CIDE.Nombre AS CiudadDestino,
	DEDE.Nombre AS DepartamentoDestino,
	CONCAT(DEST.Numero_Identificacion,  IIF(DEST.Digito_Chequeo IS NULL, '', CONCAT('-', DEST.Digito_Chequeo))) AS IdDestinatario,
	ISNULL(DEST.Razon_Social, '') + ' ' + ISNULL(DEST.Nombre, '') + ' ' + ISNULL(DEST.Apellido1, '') + ' ' + ISNULL(DEST.Apellido2, '') AS NomDestinatario,
	ISNULL(DEST.Direccion, '') AS DirDestinatario,
	REPA.Fecha_Entrega AS FechaEntrega,
	IIF(REPA.CATA_ESRP_Codigo = 6030, 'true', 'false') AS Entregado


	FROM Remesas_Paqueteria REPA WITH (NOLOCK)

	INNER JOIN Encabezado_Remesas ENRE WITH (NOLOCK)
	ON REPA.EMPR_Codigo = ENRE.EMPR_Codigo
	AND REPA.ENRE_Numero = ENRE.Numero

	LEFT JOIN Ciudades CIOR WITH (NOLOCK)
	ON REPA.EMPR_Codigo = CIOR.EMPR_Codigo
	AND REPA.CIUD_Codigo_Origen = CIOR.Codigo

	LEFT JOIN Departamentos DEOR WITH (NOLOCK)
	ON CIOR.EMPR_Codigo = DEOR.EMPR_Codigo
	AND CIOR.DEPA_Codigo = DEOR.Codigo

	LEFT JOIN Ciudades CIDE WITH (NOLOCK)
	ON REPA.EMPR_Codigo = CIDE.EMPR_Codigo
	AND REPA.CIUD_Codigo_Destino = CIDE.Codigo

	LEFT JOIN Departamentos DEDE WITH (NOLOCK)
	ON CIDE.EMPR_Codigo = DEDE.EMPR_Codigo
	AND CIDE.DEPA_Codigo = DEDE.Codigo

	LEFT JOIN Terceros AS DEST WITH (NOLOCK)
	ON ENRE.EMPR_Codigo = DEST.EMPR_Codigo
	AND ENRE.TERC_Codigo_Destinatario = DEST.Codigo

	LEFT JOIN Encabezado_Facturas AS ENFA WITH (NOLOCK)
	ON ENRE.EMPR_Codigo = ENFA.EMPR_Codigo
	AND ENRE.ENFA_Numero = ENFA.Numero

	WHERE ENRE.EMPR_Codigo = 1
	AND (ENRE.Numero_Documento = @par_Numero_documento OR @par_Numero_documento IS NULL)
	AND (ENFA.Numero_Documento = @par_Numero_factura OR @par_Numero_factura IS NULL)
	AND (ENRE.Documento_Cliente = @par_Numero_pedido OR @par_Numero_pedido IS NULL)
	AND ENRE.TERC_Codigo_Cliente = @par_Codigo_cliente
	AND ENRE.Estado = 1
	AND ENRE.Anulado = 0
END
GO
-----------------------------------------------------
PRINT 'gsp_consultar_detalle_estados_guia_clientes'
GO
DROP PROCEDURE gsp_consultar_detalle_estados_guia_clientes
GO
CREATE PROCEDURE gsp_consultar_detalle_estados_guia_clientes
(
	@par_Numero NUMERIC                
)
AS                
BEGIN

	SELECT
	ISNULL(CIUD.Nombre, '') AS Ciudad,
	DERP.Fecha_Crea AS Fecha,
	ESRP.Campo1 AS Estado

	FROM Detalle_Estados_Remesas_Paqueteria DERP WITH (NOLOCK)

	INNER JOIN Valor_Catalogos ESRP WITH (NOLOCK)
	ON DERP.empr_codigo = ESRP.empr_codigo
	AND DERP.cata_espr_codigo = ESRP.codigo

	LEFT JOIN Oficinas OFIC WITH (NOLOCK)
	ON DERP.EMPR_Codigo = OFIC.EMPR_Codigo
	AND DERP.OFIC_Codigo = OFIC.Codigo

	LEFT JOIN Ciudades CIUD WITH (NOLOCK)
	ON OFIC.EMPR_Codigo = CIUD.EMPR_Codigo
	AND OFIC.CIUD_Codigo = CIUD.Codigo

	WHERE 
	DERP.EMPR_Codigo = 1
	AND DERP.ENRE_Numero = @par_Numero

	ORDER BY DERP.Fecha_Crea
END
GO
-----------------------------------------------------
PRINT 'gsp_obtener_guia_api'
GO
DROP PROCEDURE gsp_obtener_guia_api
GO
CREATE PROCEDURE gsp_obtener_guia_api
(
	@par_Numero_documento NUMERIC = NULL,
	@par_Preimpreso VARCHAR(50) = NULL,            
	@par_Tipo_servicio NUMERIC
)
AS                                                                                        
BEGIN  

	SELECT top 200
	ENRE.Numero,
	ENRE.Numero_Documento,
	ENRE.Numeracion AS Preimpreso,
	ENRE.Fecha,
	CIOR.Codigo AS CIOR_Codigo,
	CIOR.Nombre AS CIOR_Nombre,
	DEOR.Nombre AS DEOR_Nombre,

	ENRE.TERC_Codigo_Cliente AS CLIE_Codigo,
	ENRE.TERC_Codigo_Remitente AS REMI_Codigo,
	IIF(ENRE.TERC_Codigo_Cliente > 0, (ISNULL(CLIE.Razon_Social, '') + ' ' + ISNULL(CLIE.Nombre, '') + ' ' + ISNULL(CLIE.Apellido1, '') + ' ' + ISNULL(CLIE.Apellido2, '')),
	(ISNULL(REMI.Razon_Social, '') + ' ' + ISNULL(REMI.Nombre, '') + ' ' + ISNULL(REMI.Apellido1, '') + ' ' + ISNULL(REMI.Apellido2, ''))) AS REMI_Nombre,
	IIF(ENRE.TERC_Codigo_Cliente > 0, ISNULL(CLIE.Direccion, ''), ISNULL(REMI.Direccion, '')) AS REMI_Direccion,
	IIF(ENRE.TERC_Codigo_Cliente > 0, ISNULL(CLIE.Telefonos, ''), ISNULL(REMI.Telefonos, '')) AS REMI_telefono,

	CIDE.Codigo AS CIDE_Codigo,
	CIDE.Nombre AS CIDE_Nombre,
	DEDE.Nombre AS DEDE_Nombre,

	ISNULL(DEST.Razon_Social, '') + ' ' + ISNULL(DEST.Nombre, '') + ' ' + ISNULL(DEST.Apellido1, '') + ' ' + ISNULL(DEST.Apellido2, '') AS DEST_Nombre,
	ISNULL(DEST.Direccion, '') AS DEST_Direccion,
	ISNULL(DEST.Telefonos, '') AS DEST_telefono,
	ISNULL(ENPD.Numero_Documento, 0) AS NumeroDocumentoPlanilla,
	ISNULL(VEHI.Placa, '') AS VEHI_Placa
	

	FROM Remesas_Paqueteria REPA WITH (NOLOCK)

	INNER JOIN Encabezado_Remesas ENRE WITH (NOLOCK)
	ON REPA.EMPR_Codigo = ENRE.EMPR_Codigo
	AND REPA.ENRE_Numero = ENRE.Numero

	LEFT JOIN Ciudades CIOR WITH (NOLOCK)
	ON REPA.EMPR_Codigo = CIOR.EMPR_Codigo
	AND REPA.CIUD_Codigo_Origen = CIOR.Codigo

	LEFT JOIN Departamentos DEOR WITH (NOLOCK)
	ON CIOR.EMPR_Codigo = DEOR.EMPR_Codigo
	AND CIOR.DEPA_Codigo = DEOR.Codigo

	LEFT JOIN Ciudades CIDE WITH (NOLOCK)
	ON REPA.EMPR_Codigo = CIDE.EMPR_Codigo
	AND REPA.CIUD_Codigo_Destino = CIDE.Codigo

	LEFT JOIN Departamentos DEDE WITH (NOLOCK)
	ON CIDE.EMPR_Codigo = DEDE.EMPR_Codigo
	AND CIDE.DEPA_Codigo = DEDE.Codigo

	LEFT JOIN Terceros AS CLIE WITH (NOLOCK)
	ON ENRE.EMPR_Codigo = CLIE.EMPR_Codigo
	AND ENRE.TERC_Codigo_Cliente = CLIE.Codigo

	LEFT JOIN Terceros AS REMI WITH (NOLOCK)
	ON ENRE.EMPR_Codigo = REMI.EMPR_Codigo
	AND ENRE.TERC_Codigo_Remitente = REMI.Codigo

	LEFT JOIN Terceros AS DEST WITH (NOLOCK)
	ON ENRE.EMPR_Codigo = DEST.EMPR_Codigo
	AND ENRE.TERC_Codigo_Destinatario = DEST.Codigo

	LEFT JOIN Encabezado_Planilla_Despachos AS ENPD WITH (NOLOCK)
	ON REPA.EMPR_Codigo = ENPD.EMPR_Codigo
	AND REPA.ENPD_Numero_Ultima_Planilla = ENPD.Numero

	LEFT JOIN Vehiculos AS VEHI WITH (NOLOCK)
	ON ENRE.EMPR_Codigo = VEHI.EMPR_Codigo
	AND ENRE.VEHI_Codigo = VEHI.Codigo

	WHERE ENRE.EMPR_Codigo = 1
	AND (ENRE.Numero_Documento = @par_Numero_documento OR @par_Numero_documento IS NULL)
	AND (ENRE.Numeracion = @par_Preimpreso OR @par_Preimpreso IS NULL)
	AND ENRE.TIDO_Codigo = @par_Tipo_servicio
END
GO
-----------------------------------------------------