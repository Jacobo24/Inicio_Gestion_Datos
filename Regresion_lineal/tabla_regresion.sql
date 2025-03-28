SELECT 
    sales.PVP AS PVP,
    AVG(sales.Car_Age) AS Edad_Media_Coche,
    AVG(sales.km_ultima_revision) AS Km_Medio_Por_Revision,
    AVG(CAST(Churn AS FLOAT)) AS churn_percentage,
    AVG(sales.margen) AS Margen
FROM [dbo].[fact_sales] sales
GROUP BY sales.PVP;