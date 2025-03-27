SELECT 
    tienda.TIENDA_ID,
    zona.ZONA,
    tienda.TIENDA_DESC,
    provincia.PROVINCIA_ID,
    provincia.PROV_DESC
FROM [DATAEX].[011_tienda] AS tienda
LEFT JOIN [DATAEX].[013_zona] AS zona ON tienda.ZONA_ID = zona.ZONA_ID
LEFT JOIN [DATAEX].[012_provincia] AS provincia ON tienda.PROVINCIA_ID = provincia.PROVINCIA_ID;

-- SELECT COUNT(*) AS total_filas FROM [DATAEX].[011_tienda];