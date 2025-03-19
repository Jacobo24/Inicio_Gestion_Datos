SELECT 
    sales.CODE AS codigo_venta,
    sales.Customer_ID AS id_cliente,
    sales.TIENDA_ID AS id_tienda,
    tienda.ZONA_ID AS id_zona,
    tienda.PROVINCIA_ID AS id_provincia,
    sales.Id_Producto AS id_producto,
    sales.Sales_Date AS fecha_venta,
    sales.MOTIVO_VENTA_ID AS id_motivo_venta,
    sales.FORMA_PAGO_ID AS id_forma_pago,
    logist.Origen_Compra_ID AS id_origen_compra,
    
    -- Datos de la tabla de costes
    costes.Costetransporte AS coste_transporte,
    costes.GastosMarketing AS gastos_marketing,
    costes.Margen AS margen,
    costes.Margendistribuidor AS margen_distribuidor,
    costes.Modelo AS modelo_costes,
    
    -- Cálculo de Margen en Euros Bruto
    ROUND(sales.PVP * costes.Margen * 0.01 * (1 - sales.IMPUESTOS / 100), 2) AS Margen_eur_bruto,
    
    -- Cálculo de Margen en Euros Neto
    ROUND(
        sales.PVP * costes.Margen * 0.01 * (1 - sales.IMPUESTOS / 100)
        - sales.COSTE_VENTA_NO_IMPUESTOS 
        - (costes.Margendistribuidor * 0.01 + costes.GastosMarketing * 0.01 - costes.Comisión_Marca * 0.01)
          * sales.PVP * (1 - sales.IMPUESTOS / 100)
        - costes.Costetransporte, 
    2) AS Margen_eur

FROM [DATAEX].[001_sales] AS sales
LEFT JOIN [DATAEX].[011_tienda] AS tienda 
    ON sales.TIENDA_ID = tienda.TIENDA_ID
LEFT JOIN [DATAEX].[017_logist] AS logist 
    ON sales.CODE = logist.CODE
LEFT JOIN [DATAEX].[006_producto] AS producto 
    ON sales.Id_Producto = producto.Id_Producto
LEFT JOIN [DATAEX].[007_costes] AS costes 
    ON producto.Modelo = costes.Modelo;