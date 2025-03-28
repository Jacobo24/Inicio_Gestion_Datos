SELECT 
    clientes.Customer_ID,
    clientes.CODIGO_POSTAL,
    clientes.Edad,
    clientes.GENERO,
    clientes.RENTA_MEDIA_ESTIMADA,
    clientes.STATUS_SOCIAL,
    clientes.Fecha_nacimiento,
    clientes.ENCUESTA_CLIENTE_ZONA_TALLER,
    clientes.ENCUESTA_ZONA_CLIENTE_VENTA,
    cp.poblacion,
    cp.provincia,
    cp.lat,
    cp.lon,
    cp.CP,
    mosaic.Max_Mosaic,
    mosaic.Max_Mosaic_G,
    mosaic.Renta_Media,
    mosaic.A,
    mosaic.B,
    mosaic.C,
    mosaic.D,
    mosaic.E,
    mosaic.F,
    mosaic.G,
    mosaic.H,
    mosaic.I,
    mosaic.J,
    mosaic.K
FROM [DATAEX].[003_clientes] AS clientes
LEFT JOIN [DATAEX].[005_cp] cp ON clientes.CODIGO_POSTAL = cp.CP -- Join con CODIGO_POSTAL (1:0..1).
LEFT JOIN [DATAEX].[019_mosaic] mosaic ON TRY_CAST(cp.codigopostalid AS INT) = TRY_CAST(mosaic.CP AS INT) -- Join con CP (1:0..1).



-- SELECT COUNT(*) AS total_filas FROM [DATAEX].[003_clientes];