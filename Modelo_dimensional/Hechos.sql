SELECT 
    sales.CODE AS codigo_venta,
    sales.Customer_ID AS id_cliente,
    clientes.CODIGO_POSTAL AS codigo_postal,
    cp.poblacion AS ciudad,
    cp.provincia AS provincia,
    sales.TIENDA_ID AS id_tienda,
    tienda.TIENDA_DESC AS nombre_tienda,
    tienda.ZONA_ID AS id_zona,
    zona.ZONA AS nombre_zona,
    tienda.PROVINCIA_ID AS id_provincia,
    provincia.PROV_DESC AS nombre_provincia,
    sales.Id_Producto AS id_producto,
    producto.Modelo AS modelo_producto,
    sales.Sales_Date AS fecha_venta,
    fecha.Anno AS año,
    fecha.Mes AS mes,
    fecha.Mes_desc AS mes_descripcion,
    fecha.Week AS semana,
    sales.MOTIVO_VENTA_ID AS id_motivo_venta,
    motivo_venta.MOTIVO_VENTA AS motivo_venta,
    sales.FORMA_PAGO_ID AS id_forma_pago,
    forma_pago.FORMA_PAGO AS forma_pago,
    logist.Origen_Compra_ID AS id_origen_compra,
    origen.Origen AS origen_compra,
    sales.PVP AS precio_venta,
    sales.IMPUESTOS AS impuestos,
    sales.COSTE_VENTA_NO_IMPUESTOS AS coste_venta,
    sales.MANTENIMIENTO_GRATUITO AS mantenimiento,
    sales.SEGURO_BATERIA_LARGO_PLAZO AS seguro_bateria,
    sales.EXTENSION_GARANTIA AS extension_garantia,
    logist.Fue_Lead AS fue_lead,
    logist.Lead_compra AS lead_compra,
    logist.t_logist_days AS dias_logisticos,
    logist.t_prod_date AS fecha_produccion,
    logist.t_stock_dates AS fechas_stock,
    
    -- Cálculo de Margen en Euros Bruto
    ROUND(sales.PVP * (costes.Margen) * 0.01 * (1 - sales.IMPUESTOS / 100), 2) AS Margen_eur_bruto,

    -- Cálculo de Margen en Euros Neto
    ROUND(
        sales.PVP * (costes.Margen) * 0.01 * (1 - sales.IMPUESTOS / 100) 
        - sales.COSTE_VENTA_NO_IMPUESTOS 
        - (costes.Margendistribuidor * 0.01 + costes.GastosMarketing * 0.01 - costes.Comisión_Marca * 0.01) 
        * sales.PVP * (1 - sales.IMPUESTOS / 100) 
        - costes.Costetransporte, 
    2) AS Margen_eur

FROM [DATAEX].[001_sales] AS sales
LEFT JOIN [DATAEX].[003_clientes] AS clientes ON sales.Customer_ID = clientes.Customer_ID
LEFT JOIN [DATAEX].[005_cp] AS cp ON clientes.CODIGO_POSTAL = cp.CP
LEFT JOIN [DATAEX].[011_tienda] AS tienda ON sales.TIENDA_ID = tienda.TIENDA_ID
LEFT JOIN [DATAEX].[013_zona] AS zona ON tienda.ZONA_ID = zona.ZONA_ID
LEFT JOIN [DATAEX].[012_provincia] AS provincia ON tienda.PROVINCIA_ID = provincia.PROVINCIA_ID
LEFT JOIN [DATAEX].[006_producto] AS producto ON sales.Id_Producto = producto.Id_Producto
LEFT JOIN [DATAEX].[002_date] AS fecha ON sales.Sales_Date = fecha.Date
LEFT JOIN [DATAEX].[009_motivo_venta] AS motivo_venta ON sales.MOTIVO_VENTA_ID = motivo_venta.MOTIVO_VENTA_ID
LEFT JOIN [DATAEX].[010_forma_pago] AS forma_pago ON sales.FORMA_PAGO_ID = forma_pago.FORMA_PAGO_ID
LEFT JOIN [DATAEX].[017_logist] AS logist ON sales.CODE = logist.CODE
LEFT JOIN [DATAEX].[016_origen_venta] AS origen ON logist.Origen_Compra_ID = origen.Origen_Compra_ID
LEFT JOIN [DATAEX].[007_costes] AS costes ON producto.Modelo = costes.Modelo;