SELECT 
    producto.Id_Producto AS id_producto,
    producto.Modelo AS modelo,
    producto.CATEGORIA_ID AS id_categoria,
    categoria.Equipamiento AS categoria_producto,
    producto.Fuel_ID AS id_combustible,
    fuel.FUEL AS tipo_combustible,
    producto.TRANSMISION_ID AS id_transmision,
    producto.TIPO_CARROCERIA AS tipo_carroceria,
    producto.Kw AS potencia_kw,

    -- Agregaciones de ventas
    COUNT(sales.Id_Producto) AS cantidad_vendida,
    SUM(sales.PVP) AS pvp_total

FROM [DATAEX].[001_sales] AS sales
LEFT JOIN [DATAEX].[006_producto] AS producto 
    ON sales.Id_Producto = producto.Id_Producto
LEFT JOIN [DATAEX].[014_categoría_producto] AS categoria 
    ON producto.CATEGORIA_ID = categoria.CATEGORIA_ID
LEFT JOIN [DATAEX].[015_fuel] AS fuel 
    ON producto.Fuel_ID = fuel.Fuel_ID

GROUP BY 
    producto.Id_Producto,
    producto.Modelo,
    producto.CATEGORIA_ID,
    categoria.Equipamiento,
    producto.Fuel_ID,
    fuel.FUEL,
    producto.TRANSMISION_ID,
    producto.TIPO_CARROCERIA,
    producto.Kw;
