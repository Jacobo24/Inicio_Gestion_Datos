SELECT
    sales.[CODE],
    tienda.[TIENDA_ID],
    clientes.[Customer_ID],
    producto.[Id_Producto],
    tiempo.[Date],
    sales.[Sales_Date],
    sales.[PVP],
    sales.[MANTENIMIENTO_GRATUITO],
    sales.[SEGURO_BATERIA_LARGO_PLAZO],
    sales.[FIN_GARANTIA],
    sales.[COSTE_VENTA_NO_IMPUESTOS],
    sales.[IMPUESTOS],
    sales.[EN_GARANTIA],
    sales.[EXTENSION_GARANTIA],
    costes.[Margen],
    costes.[Margendistribuidor],
    costes.[Costetransporte],
    costes.[GastosMarketing],
    costes.[Comisión_marca],
    logistic.[Lead_compra],
    logistic.[fue_Lead],
    rev.[DIAS_DESDE_ULTIMA_REVISION],
    edad.[Car_Age],
    rev.[km_ultima_revision],
    rev.[Revisiones],

    -- Cálculo de Margen en Euros Bruto
    ROUND(sales.[PVP] * costes.[Margen] * 0.01 * (1 - sales.[IMPUESTOS] / 100), 2) AS Margen_eur_bruto,

    -- Cálculo de Margen en Euros Neto
    ROUND(
        sales.[PVP] * costes.[Margen] * 0.01 * (1 - sales.[IMPUESTOS] / 100)
        - sales.[COSTE_VENTA_NO_IMPUESTOS] 
        - (costes.[Margendistribuidor] * 0.01 + costes.[GastosMarketing] * 0.01 - costes.[Comisión_marca] * 0.01)
            * sales.[PVP] * (1 - sales.[IMPUESTOS] / 100)
        - costes.[Costetransporte], 
    2) AS Margen_eur,
    
    -- Tasa de Churn: Indica si la venta se considera cancelada (1) o no (0)
    CASE
        -- Caso 1: Revisión registrada y en el rango de 0 a 400 días (No churn)
        WHEN rev.[DIAS_DESDE_ULTIMA_REVISION] IS NOT NULL 
             AND rev.[DIAS_DESDE_ULTIMA_REVISION] <> '' 
             AND TRY_CAST(REPLACE(rev.[DIAS_DESDE_ULTIMA_REVISION], '.', '') AS INT) BETWEEN 0 AND 400
            THEN 0
        -- Caso 2: Revisión registrada y mayor a 400 días (Churn)
        WHEN rev.[DIAS_DESDE_ULTIMA_REVISION] IS NOT NULL 
             AND rev.[DIAS_DESDE_ULTIMA_REVISION] <> '' 
             AND TRY_CAST(REPLACE(rev.[DIAS_DESDE_ULTIMA_REVISION], '.', '') AS INT) > 400
            THEN 1
        -- Caso 3: No hay información de revisión; se decide según la edad del coche
        WHEN rev.[DIAS_DESDE_ULTIMA_REVISION] IS NULL 
             OR rev.[DIAS_DESDE_ULTIMA_REVISION] = ''
            THEN CASE
                    WHEN edad.[Car_Age] <= 1 THEN 0    -- Coche nuevo: No churn
                    WHEN edad.[Car_Age] > 1 THEN 1   -- Coche viejo: Churn
                    ELSE 1
                 END
        -- Caso 4: Otros casos inesperados: Churn por precaución
        ELSE 1
    END AS Churn

FROM [DATAEX].[001_sales] sales
LEFT JOIN [DATAEX].[011_tienda] tienda 
    ON sales.[TIENDA_ID] = tienda.[TIENDA_ID]
LEFT JOIN [DATAEX].[003_clientes] clientes 
    ON sales.[Customer_ID] = clientes.[Customer_ID]
LEFT JOIN [DATAEX].[002_date] tiempo 
    ON sales.[Sales_Date] = tiempo.[Date]
LEFT JOIN [DATAEX].[017_logist] logistic 
    ON sales.[CODE] = logistic.[CODE]
LEFT JOIN [DATAEX].[004_rev] rev 
    ON sales.[CODE] = rev.[CODE]
LEFT JOIN [DATAEX].[018_edad] edad 
    ON sales.[CODE] = edad.[CODE]
LEFT JOIN [DATAEX].[006_producto] producto 
    ON sales.[Id_Producto] = producto.[Id_Producto]
LEFT JOIN [DATAEX].[007_costes] costes 
    ON producto.[Modelo] = costes.[Modelo];

-- SELECT COUNT(*) AS total_filas FROM [DATAEX].[001_sales];