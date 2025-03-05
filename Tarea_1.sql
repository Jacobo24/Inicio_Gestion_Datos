-- Meter todas las tabl

SELECT * FROM [DATAEX].[001_sales]
SELECT * FROM [DATAEX].[002_date]
SELECT * FROM [DATAEX].[003_clientes]
SELECT * FROM [DATAEX].[004_rev]
SELECT * FROM [DATAEX].[005_cp]
SELECT * FROM [DATAEX].[006_producto]
SELECT * FROM [DATAEX].[007_costes]
SELECT * FROM [DATAEX].[008_cac]
SELECT * FROM [DATAEX].[009_motivo_venta]
SELECT * FROM [DATAEX].[010_forma_pago]
SELECT * FROM [DATAEX].[011_tienda]
SELECT * FROM [DATAEX].[012_provincia]
SELECT * FROM [DATAEX].[013_zona]
SELECT * FROM [DATAEX].[014_categoría_producto]
SELECT * FROM [DATAEX].[015_fuel]
SELECT * FROM [DATAEX].[016_origen_venta]
SELECT * FROM [DATAEX].[017_logist]
SELECT * FROM [DATAEX].[018_edad]
SELECT * FROM [DATAEX].[019_Mosaic]

-- Ver las top 10 de la tabla de ventas. Con top 10 me refiero a las 10 primeras filas.

SELECT TOP (10) *
  FROM [DATAEX].[001_sales]

-- ver que hay en la tabla

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '001_sales';

-- La columna tiene valores únicos

SELECT COUNT(DISTINCT CODE) AS Unicos_CODE, COUNT(*) AS Total_Filas
  FROM [DATAEX].[001_sales]

SELECT COUNT(DISTINCT Customer_ID) AS Unicos_Customer, COUNT(*) AS Total_Filas
    FROM [DATAEX].[001_sales]



-- La columna no puede tener valores nulos

SELECT COUNT(*) AS Nulos_CODE
    FROM [DATAEX].[001_sales]
    WHERE CODE IS NULL;


-- La columna representa una entidad única

SELECT Customer_ID, COUNT(*) AS Repeticiones
FROM [DATAEX].[001_sales]
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

-- Columnas están en varias tablas y pueden ser claves foráneas (FK)
SELECT COLUMN_NAME, TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN (
    SELECT COLUMN_NAME 
    FROM INFORMATION_SCHEMA.COLUMNS
    GROUP BY COLUMN_NAME
    HAVING COUNT(*) > 1
)
ORDER BY COLUMN_NAME;