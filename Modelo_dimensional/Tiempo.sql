SELECT 
    date.Date,
    date.Anno,
    date.Mes,
    date.Mes_desc,
    date.Week,
    date.Dia,
    date.Diadelasemana,
    date.Diadelesemana_desc,
    date.Festivo,
    date.Findesemana,
    date.Laboral,
    date.InicioMes,
    date.FinMes
FROM [DATAEX].[002_date] AS date;

-- SELECT COUNT(*) AS total_filas FROM [DATAEX].[002_date];