SELECT 
    clientes.Customer_ID AS id_cliente,
    clientes.CODIGO_POSTAL AS codigo_postal,
    clientes.Edad AS edad,
    clientes.GENERO AS genero,
    clientes.RENTA_MEDIA_ESTIMADA AS renta_media,
    clientes.STATUS_SOCIAL AS estado_social,
    clientes.Fecha_nacimiento AS fecha_nacimiento,
    clientes.ENCUESTA_CLIENTE_ZONA_TALLER AS encuesta_taller,
    clientes.ENCUESTA_ZONA_CLIENTE_VENTA AS encuesta_venta,
    cp.poblacion AS ciudad,
    cp.provincia AS provincia,
    mosaic.Max_Mosaic AS segmento_mosaic,
    mosaic.Max_Mosaic_G AS segmento_mosaic_g,
    mosaic.Renta_Media AS renta_media_mosaic,
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
LEFT JOIN [DATAEX].[019_mosaic] mosaic ON TRY_CAST(cp.codigopostalid AS INT) = TRY_CAST(mosaic.CP AS INT); -- Join con CP (1:0..1).



SELECT COUNT(*) AS total_filas
FROM [DATAEX].[003_clientes];