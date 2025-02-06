SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '001_sales';

----- Agrupar por producto y contar el numero de productos y el precio medio

SELECT
    [Id_Producto],
    COUNT([Id_Producto]) AS Numero_Productos,
    ROUND(AVG([PVP]), 2) AS Precio_Medio
FROM [DATAEX].[001_sales]
GROUP BY [Id_Producto]

-- ALTER TABLE [DATAEX].[001_sales]
-- ADD COLUMN [Id_Producto] VARCHAR(225); -- Ajusta el tamaño según lo necesites

-- Agrupar por producto y contar distintivos y quitar los nulos de producto

SELECT
    [Id_Producto],
    COUNT([Id_Producto]) AS Numero_Productos,
    COUNT(DISTINCT[Id_Producto]) AS Productos_Unicos, -- Cuenta productos distintos
    ROUND(AVG(CAST([PVP] AS FLOAT)), 2) AS Precio_Medio
FROM [DATAEX].[001_sales]
WHERE [Id_Producto] IS NOT NULL
GROUP BY [Id_Producto]


-- Convertir la fecha de texto en número

SELECT
    Sales_Date,
    CAST(CONVERT(DATE, Sales_Date, 103) AS DATE) AS Fecha_Convertida
FROM [DATAEX].[001_sales]