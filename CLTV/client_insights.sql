-- Si la tabla de salida ya existe, se elimina.
IF OBJECT_ID('client_insights', 'U') IS NOT NULL
    DROP TABLE client_insights;

-- Declaración de Variables.
DECLARE
    -- Tasa de descuento para cálculos financieros.
    @discount_rate FLOAT = 0.07,

    -- Coeficientes del modelo de churn (adaptados a los nombres de tus variables).
    @b_intercepto FLOAT,
    @b_pvp FLOAT,
    @b_edad FLOAT,
    @b_km FLOAT,
    @b_revisiones FLOAT;

-- Carga de Coeficientes: Extracción de los coeficientes del modelo previamente entrenado.
SELECT
    @b_intercepto = MAX(CASE WHEN Variable = 'Intercepto' THEN Coeficiente END),
    @b_pvp        = MAX(CASE WHEN Variable = 'PVP' THEN Coeficiente END),
    @b_edad       = MAX(CASE WHEN Variable = 'Edad_Media_Coche' THEN Coeficiente END),
    @b_km         = MAX(CASE WHEN Variable = 'Km_Medio_Por_Revision' THEN Coeficiente END),
    @b_revisiones = MAX(CASE WHEN Variable = 'Revisiones' THEN Coeficiente END)
FROM churn_coef;

-- CTE Retención: Calcular la probabilidad de retención para cada cliente.
WITH retencion_cte AS (
    SELECT
        c.Customer_ID,
        LEAST(1, GREATEST(0,
            1 - (
                @b_intercepto +
                AVG(f.PVP) * @b_pvp +
                MAX(f.Car_Age) * @b_edad +
                AVG(f.km_ultima_revision) * @b_km +
                AVG(f.Revisiones) * @b_revisiones
            )
        )) AS retencion_estimado
    FROM dim_client c
    LEFT JOIN fact_sales f ON c.Customer_ID = f.Customer_ID
    GROUP BY c.Customer_ID
)

-- Consulta principal: Generar el dataset de clientes con sus métricas y segmentaciones.
SELECT
    c.Customer_ID,
    c.Edad,
    -- Modelo Predictivo: Probabilidad de Churn y Retención.
    CASE 
        WHEN r.retencion_estimado IS NULL THEN NULL
        ELSE 1 - r.retencion_estimado
    END AS churn_estimado,
    r.retencion_estimado,

    -- CLTV (Customer Lifetime Value): Valor del cliente a lo largo de 1 a 5 años.
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1)
    ) AS CLTV_1_anio,
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2)
    ) AS CLTV_2_anios,
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + @discount_rate, 3)
    ) AS CLTV_3_anios,
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + @discount_rate, 3) +
        POWER(r.retencion_estimado, 4) / POWER(1 + @discount_rate, 4)
    ) AS CLTV_4_anios,
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + @discount_rate, 3) +
        POWER(r.retencion_estimado, 4) / POWER(1 + @discount_rate, 4) +
        POWER(r.retencion_estimado, 5) / POWER(1 + @discount_rate, 5)
    ) AS CLTV_5_anios

INTO client_insights  -- Creación de la tabla de salida.
FROM dim_client c
LEFT JOIN fact_sales f ON c.Customer_ID = f.Customer_ID
LEFT JOIN retencion_cte r ON c.Customer_ID = r.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Edad,
    c.GENERO,
    c.STATUS_SOCIAL,
    c.RENTA_MEDIA_ESTIMADA,
    c.CODIGO_POSTAL,
    c.poblacion,
    c.provincia,
    c.Max_Mosaic_G,
    c.ENCUESTA_ZONA_CLIENTE_VENTA,
    c.ENCUESTA_CLIENTE_ZONA_TALLER,
    r.retencion_estimado;

ALTER TABLE client_insights
ADD CONSTRAINT PK_client_insights PRIMARY KEY (Customer_ID);

-- Mostrar los registros de la tabla generada.
SELECT * FROM client_insights;