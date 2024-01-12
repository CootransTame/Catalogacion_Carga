--OJO SELECCIONAR COORECTAMENTE LA BD--
USE GESCARGA50_PRUEBAS;

-------------gsp_lst_Guia_Sin_Cumplir_xVehiculo --------------------------

PRINT 'gsp_lst_Guia_Sin_Cumplir_xVehiculo'
GO
-- Si el procedimiento almacenado existe, elimínalo
IF OBJECT_ID(
    'dbo.gsp_lst_Guia_Sin_Cumplir_xVehiculo',
    'P'
) IS NOT NULL DROP PROCEDURE dbo.gsp_lst_Guia_Sin_Cumplir_xVehiculo;

GO
    -- Crea el nuevo procedimiento almacenado
    CREATE PROCEDURE dbo.gsp_lst_Guia_Sin_Cumplir_xVehiculo (
        @par_EMPR_Codigo NUMERIC (18, 0),
        @par_Placa VARCHAR(10) = NULL,
        @par_Fecha_Incial DATE = NULL,
        @par_Fecha_Final DATE = NULL,
        --@par_Oficina NUMERIC = NULL, 
        @par_Estado NUMERIC = NULL
    ) AS BEGIN
SELECT
    EMPR.Nombre_Razon_Social,
    ENRE.Numero_Documento AS Numero_Remesa,
    --Número Remesa           
    ENRE.Numeracion AS Preimpreso,
    --Preimpreso          
    ENRE.Fecha AS Fecha_Remesa,
    --Fecha remesa           
    ENPD.Fecha_Crea AS Fecha_Despacho,
    --Fecha Despacho           
    VALC.Campo1 as Forma_pago,
    ENRE.Peso_Cliente AS Peso,
    --Peso           
    ENRE.Cantidad_Cliente AS Unidades,
    --Unid  
    VEHI.Placa as Placa,
    -- Placa del vehiculo        
    CASE
        WHEN REMI.CATA_TINT_Codigo = 501
        /*Persona NATURAL*/
        THEN REMI.Nombre + ' ' + REMI.Apellido1 + ' ' + REMI.Apellido2
        ELSE REMI.Razon_Social
    END AS Cliente,
    --Remitente o Cliente           
    CASE
        WHEN DEST.CATA_TINT_Codigo = 501
        /*Persona NATURAL*/
        THEN DEST.Nombre + ' ' + DEST.Apellido1 + '  ' + DEST.Apellido2
        ELSE DEST.Razon_Social
    END AS Destinatario,
    --Destinatario           
    CIDE.Nombre AS Destino,
    -- Destino Remesa          
    ENRE.Observaciones,
    -- Observaciones Remesas    
    ENRE.OFIC_Codigo,
    CASE
        ENRE.Estado
        WHEN 1 then 'DEFINITIVO'
        WHEN 0 then 'BORRADOR'
    END as Estado
FROM
    Encabezado_Remesas ENRE
    INNER JOIN Valor_Catalogos VALC ON ENRE.EMPR_Codigo = VALC.EMPR_Codigo
    AND ENRE.CATA_FOPR_Codigo = VALC.Codigo
    INNER JOIN Remesas_Paqueteria REMA ON ENRE.Numero = REMA.ENRE_Numero
    INNER JOIN Terceros REMI ON ENRE.EMPR_Codigo = REMI.EMPR_Codigo
    AND ENRE.TERC_Codigo_Remitente = REMI.Codigo
    INNER JOIN Terceros DEST ON ENRE.EMPR_Codigo = DEST.EMPR_Codigo
    AND ENRE.TERC_Codigo_Destinatario = DEST.Codigo
    INNER JOIN Remesas_Paqueteria REPA ON ENRE.EMPR_Codigo = REPA.EMPR_Codigo
    AND ENRE.Numero = REPA.ENRE_Numero
    LEFT JOIN Ciudades AS CIDE ON REPA.EMPR_Codigo = CIDE.EMPR_Codigo
    AND REPA.CIUD_Codigo_Destino = CIDE.Codigo
    LEFT JOIN Encabezado_Planilla_Despachos ENPD ON ENRE.EMPR_Codigo = ENPD.EMPR_Codigo
    AND ENRE.ENPD_Numero = ENPD.Numero
    LEFT JOIN Vehiculos VEHI ON ENPD.EMPR_Codigo = VEHI.EMPR_Codigo
    AND ENPD.VEHI_Codigo = VEHI.Codigo
    LEFT JOIN Cumplido_Remesas CURE ON ENRE.EMPR_Codigo = CURE.EMPR_Codigo
    AND ENRE.Numero = CURE.ENRE_Numero
    INNER JOIN Empresas EMPR ON ENRE.EMPR_Codigo = EMPR.Codigo
WHERE
    ENRE.Anulado = 0
    AND ENRE.Cumplido = 0
    AND REMA.CATA_ESRP_Codigo = 6010 --AND ENRE.Fecha> '2023-01-01'
    --AND VEHI.Placa = 'ABC123'
    AND ENRE.EMPR_Codigo = @par_EMPR_Codigo
    AND ENRE.Fecha >= ISNULL(@par_Fecha_Incial, ENRE.Fecha)
    AND ENRE.Fecha <= ISNULL(@par_Fecha_Final, ENRE.Fecha) --AND ENRE.OFIC_Codigo = ISNULL(@par_Oficina, ENRE.OFIC_Codigo) 
    AND VEHI.Placa = ISNULL(@par_Placa, VEHI.Placa)
    AND ENRE.Estado = ISNULL(@par_Estado, ENRE.Estado)
ORDER BY
    ENRE.FECHA,
    ENRE.Numeracion ASC
END;

GO
    -------------gsp_lst_Guia_Sin_Cumplir_xOficina --------------------------
    PRINT 'gsp_lst_Guia_Sin_Cumplir_xOficina'
GO
    -- Si el procedimiento almacenado existe, elimínalo
    IF OBJECT_ID(
        'dbo.gsp_lst_Guia_Sin_Cumplir_xOficina',
        'P'
    ) IS NOT NULL DROP PROCEDURE dbo.gsp_lst_Guia_Sin_Cumplir_xOficina;

GO
    -- Crea el nuevo procedimiento almacenado
    CREATE PROCEDURE dbo.gsp_lst_Guia_Sin_Cumplir_xOficina (
        @par_EMPR_Codigo NUMERIC (18, 0),
        @par_Oficina NUMERIC = NULL
    ) AS BEGIN
SELECT
    CASE
        WHEN ENRE.TIDO_Codigo = 110 THEN 'Paqueteria'
        WHEN ENRE.TIDO_Codigo = 111 THEN 'Mensajería'
    END AS SERVICIO,
    ENRE.Numero_Documento GUÍA,
    ENRE.Numeracion Preimpreso,
    ENRE.Fecha,
    ESTA.Campo1 Estado,
    OFIC.Nombre Agencia --,* 
FROM
    Encabezado_Remesas ENRE
    INNER JOIN Remesas_Paqueteria REPA ON ENRE.Numero = REPA.ENRE_Numero
    LEFT JOIN Valor_Catalogos ESTA ON REPA.CATA_ESRP_Codigo = ESTA.Codigo
    LEFT JOIN Oficinas OFIC ON REPA.OFIC_Codigo_Actual = OFIC.Codigo
WHERE
    ENRE.Estado = 1
    AND ENRE.Anulado = 0
    and ENRE.Cumplido = 0
    AND ENRE.TIDO_Codigo IN (110, 111)
    AND ENRE.Fecha <= (GETDATE() -3)
    AND ENRE.Fecha >= (GETDATE() -60)
    AND ESTA.Codigo NOT IN (6020, 6017, 6001, 6005) --SIN CUMPLIR Y EN OFICINA
    AND ENRE.OFIC_Codigo = ISNULL(@par_Oficina, ENRE.OFIC_Codigo)
ORDER BY
    ENRE.TIDO_Codigo,
    ENRE.Fecha DESC,
    OFIC.Codigo,
    ENRE.Numero
END;

GO
    -------------gsp_lst_Guia_Sin_Entregar_xOficina --------------------------
    PRINT 'gsp_lst_Guia_Sin_Entregar_xOficina'
GO
    -- Si el procedimiento almacenado existe, elimínalo
    IF OBJECT_ID(
        'dbo.gsp_lst_Guia_Sin_Entregar_xOficina',
        'P'
    ) IS NOT NULL DROP PROCEDURE dbo.gsp_lst_Guia_Sin_Entregar_xOficina;

GO
    -- Crea el nuevo procedimiento almacenado
    CREATE PROCEDURE dbo.gsp_lst_Guia_Sin_Entregar_xOficina (
        @par_EMPR_Codigo NUMERIC (18, 0),
        @par_Oficina NUMERIC = NULL
    ) AS BEGIN
SELECT
    CASE
        WHEN ENRE.TIDO_Codigo = 110 THEN 'Paqueteria'
        WHEN ENRE.TIDO_Codigo = 111 THEN 'Mensajería'
    END AS SERVICIO,
    ENRE.Numero_Documento GUÍA,
    ENRE.Numeracion Preimpreso,
    ENRE.Fecha,
    ESTA.Campo1 Estado,
    OFIC.Nombre Agencia --,* 
FROM
    Encabezado_Remesas ENRE
    INNER JOIN Remesas_Paqueteria REPA ON ENRE.Numero = REPA.ENRE_Numero
    LEFT JOIN Valor_Catalogos ESTA ON REPA.CATA_ESRP_Codigo = ESTA.Codigo
    LEFT JOIN Oficinas OFIC ON REPA.OFIC_Codigo_Actual = OFIC.Codigo
WHERE
    ENRE.Estado = 1
    AND ENRE.Anulado = 0
    and ENRE.Cumplido = 0
    AND ENRE.TIDO_Codigo IN (110, 111)
    AND ENRE.Fecha >= (GETDATE() -45)
    AND ESTA.Codigo = 6020 --OFICINA DESTINO SIN ENTREGAR
    AND OFIC.CODIGO = ISNULL(@par_Oficina, OFIC.CODIGO)
ORDER BY
    ENRE.TIDO_Codigo,
    ENRE.Fecha DESC,
    OFIC.Codigo,
    ENRE.Numero
END;

GO
    -------------gsp_lst_Guia_Sin_redespachar_Intermedia --------------------------
    PRINT 'gsp_lst_Guia_Sin_redespachar_Intermedia'
GO
    -- Si el procedimiento almacenado existe, elimínalo
    IF OBJECT_ID(
        'dbo.gsp_lst_Guia_Sin_redespachar_Intermedia',
        'P'
    ) IS NOT NULL DROP PROCEDURE dbo.gsp_lst_Guia_Sin_redespachar_Intermedia;

GO
    -- Crea el nuevo procedimiento almacenado
    CREATE PROCEDURE dbo.gsp_lst_Guia_Sin_redespachar_Intermedia (
        @par_EMPR_Codigo NUMERIC (18, 0),
        @par_Oficina NUMERIC = NULL
    ) AS BEGIN
SELECT
    CASE
        WHEN ENRE.TIDO_Codigo = 110 THEN 'Paqueteria'
        WHEN ENRE.TIDO_Codigo = 111 THEN 'Mensajería'
    END AS SERVICIO,
    ENRE.Numero_Documento GUÍA,
    ENRE.Numeracion Preimpreso,
    ENRE.Fecha,
    ESTA.Campo1 Estado,
    OFIC.Nombre Agencia --,* 
FROM
    Encabezado_Remesas ENRE
    INNER JOIN Remesas_Paqueteria REPA ON ENRE.Numero = REPA.ENRE_Numero
    LEFT JOIN Valor_Catalogos ESTA ON REPA.CATA_ESRP_Codigo = ESTA.Codigo
    LEFT JOIN Oficinas OFIC ON REPA.OFIC_Codigo_Actual = OFIC.Codigo
WHERE
    ENRE.Estado = 1
    AND ENRE.Anulado = 0
    and ENRE.Cumplido = 0
    AND ENRE.TIDO_Codigo IN (110, 111)
    AND ENRE.Fecha >= (GETDATE() -45)
    AND ESTA.Codigo = 6017 --OFICINA INTERMEDIA
    AND OFIC.CODIGO = ISNULL(@par_Oficina, OFIC.CODIGO)
ORDER BY
    ENRE.TIDO_Codigo,
    ENRE.Fecha DESC,
    OFIC.Codigo,
    ENRE.Numero
END;

GO
    -------------gsp_lst_Sustancias_Peligrosas --------------------------
    PRINT 'gsp_lst_Sustancia_Peligrosas'
GO
    -- Si el procedimiento almacenado existe, elimínalo
    IF OBJECT_ID('dbo.gsp_lst_Sustancias_Peligrosas', 'P') IS NOT NULL DROP PROCEDURE dbo.gsp_lst_Sustancias_Peligrosas;

GO
    -- Crea el nuevo procedimiento almacenado
    CREATE PROCEDURE dbo.gsp_lst_Sustancias_Peligrosas (
        @par_EMPR_Codigo NUMERIC (18, 0),
        @par_Fecha_Incial DATE = NULL,
        @par_Fecha_Final DATE = NULL
    ) AS BEGIN
SELECT
    VEHI.Placa,
    ENRE.Numero_Documento,
    enre.Numeracion,
    CATV.Campo1 AS TIPO_DE_VEHICULO,
    TICA.Campo1 AS TIPO_DE_CARROCERIA,
    TIDV.Campo1 AS PROPIO_O_TERCERO,
    PRMT.Nombre AS CLASE_DE_MERCANCIA,
    PRTR.Nombre AS NOMBRE_DE_LA_MERCANCIA,
    PRMT.Codigo_Alterno AS NÚMERO_DE_UN,
    ENRE.Cantidad_Cliente AS CANTIDAD,
    ENRE.Peso_Cliente AS PESO,
    CONCAT (
        TERC.Razon_Social,
        ' ',
        TERC.Nombre,
        ' ',
        TERC.Apellido1
    ) CLIENTE,
    CIOR.Nombre AS ORIGEN,
    CIDE.Nombre AS DESTINO,
    REPA.Descripcion_Mercancia AS OBSERVACIONES
FROM
    ENCABEZADO_REMESAS ENRE
    LEFT JOIN Vehiculos VEHI ON ENRE.VEHI_Codigo = VEHI.Codigo
    LEFT JOIN Valor_Catalogos CATV ON VEHI.CATA_TIVE_Codigo = CATV.Codigo
    LEFT JOIN Valor_Catalogos TICA ON VEHI.CATA_TICA_Codigo = TICA.Codigo
    LEFT JOIN Valor_Catalogos TIDV ON VEHI.CATA_TIDV_Codigo = TIDV.Codigo
    LEFT JOIN Producto_Transportados PRTR ON ENRE.PRTR_Codigo = PRTR.Codigo
    LEFT JOIN Productos_Ministerio_Transporte PRMT ON PRTR.PRMI_Codigo = PRMT.Codigo
    LEFT JOIN Terceros TERC ON ENRE.TERC_Codigo_Remitente = TERC.Codigo
    LEFT JOIN Ciudades CIOR ON ENRE.CIUD_Codigo_Remitente = CIOR.Codigo
    LEFT JOIN Ciudades CIDE ON ENRE.CIUD_Codigo_Destinatario = CIDE.Codigo
    LEFT JOIN Remesas_Paqueteria REPA ON ENRE.Numero = REPA.ENRE_Numero
WHERE
    ENRE.Anulado = 0
    AND ENRE.Estado = 1
    AND ENRE.Fecha >= ISNULL(@par_Fecha_Incial, ENRE.Fecha)
    AND ENRE.Fecha <= ISNULL(@par_Fecha_Final, ENRE.Fecha)
    AND (
        REPA.Descripcion_Mercancia LIKE '%TINER %'
        OR REPA.Descripcion_Mercancia LIKE '%ALCOH%'
        OR REPA.Descripcion_Mercancia LIKE '%PINTU%'
        OR REPA.Descripcion_Mercancia LIKE '%VENEN%'
        OR REPA.Descripcion_Mercancia LIKE '%INSEC%'
        OR PRTR.Nombre LIKE '%CRUDO%'
        OR REPA.Descripcion_Mercancia LIKE '%cloro%'
        OR REPA.Descripcion_Mercancia LIKE '% GAS %'
        OR PATINDEX('%[0-9]%', PRTR.Nombre) = 1
    )
ORDER BY
    ENRE.Fecha
END;

GO
    -------------gsp_lst_Guia_Sin_Despachar_Origen --------------------------
    PRINT 'gsp_lst_Guia_Sin_Despachar_Origen'
GO
    -- Si el procedimiento almacenado existe, elimínalo
    IF OBJECT_ID(
        'dbo.gsp_lst_Guia_Sin_Despachar_Origen',
        'P'
    ) IS NOT NULL DROP PROCEDURE dbo.gsp_lst_Guia_Sin_Despachar_Origen;

GO
    -- Crea el nuevo procedimiento almacenado
    CREATE PROCEDURE dbo.gsp_lst_Guia_Sin_Despachar_Origen (
        @par_EMPR_Codigo NUMERIC (18, 0),
        @par_Oficina NUMERIC = NULL
    ) AS BEGIN
SELECT
    CASE
        WHEN ENRE.TIDO_Codigo = 110 THEN 'Paqueteria'
        WHEN ENRE.TIDO_Codigo = 111 THEN 'Mensajería'
    END AS SERVICIO,
    ENRE.Numero_Documento GUÍA,
    ENRE.Numeracion Preimpreso,
    ENRE.Fecha,
    ESTA.Campo1 Estado,
    OFIC.Nombre Agencia --,* 
FROM
    Encabezado_Remesas ENRE
    INNER JOIN Remesas_Paqueteria REPA ON ENRE.Numero = REPA.ENRE_Numero
    LEFT JOIN Valor_Catalogos ESTA ON REPA.CATA_ESRP_Codigo = ESTA.Codigo
    LEFT JOIN Oficinas OFIC ON REPA.OFIC_Codigo_Actual = OFIC.Codigo
WHERE
    ENRE.Estado = 1
    AND ENRE.Anulado = 0
    and ENRE.Cumplido = 0
    AND ENRE.TIDO_Codigo IN (110, 111)
    AND ENRE.Fecha <= (GETDATE() -4)
    AND ESTA.Codigo IN (6001, 6005) --OFICINA ORIGEN O EN RECOGIDA por mas de 4 días
    AND OFIC.CODIGO = ISNULL(@par_Oficina, OFIC.CODIGO)
ORDER BY
    ENRE.TIDO_Codigo,
    ENRE.Fecha DESC,
    OFIC.Codigo,
    ENRE.Numero
END;

GO