--script listados nuevos

INSERT INTO Menu_Aplicaciones VALUES (1,450319,45,'Guias sin cumplir carga en vehiculo',	4503,	20,	0,	1,	1,	1,	1,	1,	1,	0,	1,	0,	'#!lstGuiaSinCumplirVehi',	'#',	NULL)
INSERT INTO Menu_Aplicaciones VALUES (1,450320,45,'Guias sin despacho',	4503,	30,	0,	1,	1,	1,	1,	1,	1,	0,	1,	0,	'#!lstGuiaSinDespacharOrigen',	'#',	NULL)
INSERT INTO Menu_Aplicaciones VALUES (1,450321,45,'Guias en bodega sin reexpedir',	4503,	40,	0,	1,	1,	1,	1,	1,	1,	0,	1,	0,	'#!lstGuiaSinReexpedir',	'#',	NULL)
INSERT INTO Menu_Aplicaciones VALUES (1,450322,45,'Sustancias Peligrosas',	4503,	50,	0,	1,	1,	1,	1,	1,	1,	0,	1,	0,	'#!lstSustanciasPeligrosas',	'#',	NULL)
INSERT INTO Menu_Aplicaciones VALUES (1,12002,120,'Listados',120,30,1,	1,	1,	1,	1,	1,	0,	0,	0,	0,	'#!ConsultarListadosMantenimiento',	'#',NULL)
INSERT INTO Menu_Aplicaciones VALUES (1,1200201,120,'Actividades pendientes por cerrar',	12002,	10,	0,	1,	1,	1,	1,	1,	1,	0,	1,	0,	'#!lstActividadesPendCerrar',	'#',	NULL)
INSERT INTO Menu_Aplicaciones VALUES (1,1200202,120,'Hallazgos pendientes por cerrar',	12002,	20,	0,	1,	1,	1,	1,	1,	1,	0,	1,	0,	'#!lstHallazgosPendCerrar',	'#',	NULL)
INSERT INTO Menu_Aplicaciones VALUES (1, 460306, 46, 'MinTIC  6333 P11 Ingresos x envíos', 4603, 60, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, ('#!lstRes6333P11'), '#', NULL)

--Portal
INSERT INTO Menu_Aplicaciones VALUES (1, 26003, 260, 'Listados', 260, 30, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, ('#!ConsultarListadoGuiasPaqueteriaPortal'), '#', NULL)
INSERT INTO Menu_Aplicaciones VALUES (1, 2600301, 260, 'Listado Guias',26003, 10, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, ('#!lstGuiasPaqueteriaPortal'), '#', NULL)

-- gsp_lst_Guia_Sin_Cumplir_xVehiculo
-- lstGuiaSinCumplirVehi
-- CODIGO_LISTADO_GUIAS_SIN_CUMPLIR_EN_VEHICULO
-- NOMBRE_LISTADO_GUIAS_SIN_CUMPLIR_EN_VEHICULO


-- gsp_lst_Guia_Sin_Despachar_Origen
-- lstGuiaSinDespacharOrigen
-- listadoGuiaSinDespacharOrigen
-- Configurar_listado_Guia_Sin_Despachar_Origen
-- CODIGO_LISTADO_GUIAS_SIN_DESPACHAR_POR_OFICINA
-- NOMBRE_LISTADO_GUIAS_SIN_DESPACHAR_POR_OFICINA

-- gsp_lst_Guia_Sin_redespachar_Intermedia
-- lstGuiasSinReexpedir
-- listadoGuiasSinReexpedir
-- Configurar_listado_Guia_Sin_redespachar_Intermedia
-- CODIGO_LISTADO_GUIAS_SIN_REEXPEDIR_POR_OFICINA
-- NOMBRE_LISTADO_GUIAS_SIN_REEXPEDIR_POR_OFICINA


-- Informes
-- gsp_lst_Sustancias_Peligrosas
-- lstSustanciasPeligrosas
-- Configurar_listado_Guia_Sustancias_Peligrosas
-- CODIGO_LISTADO_SUSTANCIAS_PELIGROSAS
-- NOMBRE_LISTADO_SUSTANCIAS_PELIGROSAS


-- CODIGO_LISTADO_GUIAS_PORTAL
-- NOMBRE_LISTADO_GUIAS_PORTAL

--ANALIZAR LISTADOS DE MANTENIMIENTO -120
-- 12002 Listados
-- 1200201 Actividades pendientes por cerrar
-- 1200201 Hallazgos pendientes por cerrar

-- listado de Mintic -46
-- 4603 Listados
-- 460306 Informe P.1... 


-- gsp_lst_Guia_Sin_Cumplir_xOficina
-- gsp_lst_Guia_Sin_Entregar_xOficina

