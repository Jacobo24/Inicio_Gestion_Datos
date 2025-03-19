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
    cp.provincia AS provincia
FROM [DATAEX].[003_clientes] AS clientes
LEFT JOIN [DATAEX].[005_cp] AS cp ON clientes.CODIGO_POSTAL = cp.CP;