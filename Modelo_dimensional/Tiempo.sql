SELECT 
    date.Date AS fecha,
    date.Anno AS año,
    date.Mes AS mes,
    date.Mes_desc AS mes_descripcion,
    date.Week AS semana,
    date.Dia AS dia,
    date.Diadelasemana AS dia_semana,
    date.Diadelesemana_desc AS dia_semana_descripcion,
    date.Festivo AS es_festivo,
    date.Findesemana AS es_fin_de_semana,
    date.Laboral AS es_laboral,
    date.InicioMes AS inicio_de_mes,
    date.FinMes AS fin_de_mes
FROM [DATAEX].[002_date] AS date;

SELECT COUNT(*) AS total_filas
FROM [DATAEX].[002_date];