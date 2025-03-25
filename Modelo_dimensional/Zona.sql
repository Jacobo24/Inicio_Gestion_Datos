SELECT 
    tienda.ZONA_ID AS id_zona,
    zona.ZONA AS nombre_zona,
    tienda.TIENDA_DESC AS nombre_tienda,
    provincia.PROVINCIA_ID AS id_provincia,
    provincia.PROV_DESC AS nombre_provincia
FROM [DATAEX].[011_tienda] AS tienda
LEFT JOIN [DATAEX].[013_zona] AS zona ON tienda.ZONA_ID = zona.ZONA_ID
LEFT JOIN [DATAEX].[012_provincia] AS provincia ON tienda.PROVINCIA_ID = provincia.PROVINCIA_ID;

SELECT COUNT(*) AS total_filas
FROM [DATAEX].[011_tienda];