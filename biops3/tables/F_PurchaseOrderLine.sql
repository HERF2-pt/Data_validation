SELECT OrderNumber, CompanyCode, LineNumber ,COUNT(DISTINCT OriginalAmount), COUNT(DISTINCT QuantityOpen), COUNT(DISTINCT QuantityOrder), COUNT(DISTINCT QuantityReceived)

FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine
    GROUP BY OrderNumber, CompanyCode, LineNumber
    HAVING COUNT(DISTINCT OriginalAmount)>1
    ORDER BY OrderNumber, LineNumber


SELECT OrderNumber, CompanyCode, LineNumber ,  COUNT(DISTINCT QuantityOrder), COUNT(DISTINCT LineTypeCode)

FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine
    GROUP BY OrderNumber, CompanyCode, LineNumber
    HAVING COUNT(DISTINCT LineTypeCode)>1
    ORDER BY OrderNumber, LineNumber


select OrderNumber, CompanyCode, LineNumber, ReceptionDate, OriginalAmount_cad,OriginalAmount, QuantityOpen,
CancelDate,   
    ROW_NUMBER() OVER (
        PARTITION BY OrderNumber, ItemBranchKey, ItemKey, LineNumber, CancelDate
        ORDER BY ReceptionDate DESC
    )
 AS LastReception

FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine
where OrderNumber=138319 
--where ReceptionDate is null
order by LineNumber, OrderNumber




SELECT D.FiscalYear, sum( P.OriginalAmount_cad)
FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine P
    JOIN RDL00001_EnterpriseDataWarehouse.dbo.D_P_Dates D
    ON P.OrderDate=D.Id
    group by D.FiscalYear

GO
SELECT min (date)

FROM
    RDL00001_EnterpriseDataWarehouse.dbo.D_P_Dates

go
    SELECT
    TABLE_SCHEMA + '.' + TABLE_NAME AS TABLE_FULL_NAME
    ,COLUMN_NAME
    ,DATA_TYPE
    ,IS_NULLABLE
    ,TABLE_CATALOG
    ,GetDate() AS Date
    ,ORDINAL_POSITION
FROM [RDL00001_EnterpriseDataWarehouse].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE '%ProductCost%' AND TABLE_SCHEMA='dbo'
ORDER BY TABLE_NAME, COLUMN_NAME

---------------------------
-----------------------------
SELECT TOP 1000
     *

FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine
    where OrderNumber='77242424'


SELECT OrderDate ,ReceptionDate, DATEDIFF(DAY,OrderDate,ReceptionDate),

    DATEDIFF(DAY, OrderDate, ReceptionDate) - 
    (DATEDIFF(WEEK, OrderDate, ReceptionDate) * 2) -
    CASE WHEN DATEPART(WEEKDAY, OrderDate) = 1 THEN 1 ELSE 0 END -
    CASE WHEN DATEPART(WEEKDAY, ReceptionDate) = 7 THEN 1 ELSE 0 END AS Leadtime_ReceiptDate

    ,CASE
        WHEN OrderDate IS NULL OR ReceptionDate IS NULL THEN NULL
        ELSE
            (
                SELECT COUNT(*)    FROM    
                    (   SELECT            DATEADD(DAY, number, OrderDate) AS theDate
                        FROM   master..spt_values
                        WHERE                            type = 'P'
                        AND number BETWEEN 0 AND DATEDIFF(DAY, OrderDate, ReceptionDate)                    ) AS Dates

                WHERE  DATEPART(WEEKDAY, theDate) NOT IN (1, 7) -- 1=Sunday, 7=Saturday (par défaut SQL Server)
            )
    END AS Leadtime_ReceiptDate
FROM RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine



WHERE SecondItemNumber IS NOT NULL

SELECT *
FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine
WHERE ItemBranchkey='56796'
GO

SELECT count(LineNumber)
FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine
WHERE CancelDate is  null 
and OrderDate>='2025-03-01'

SELECT count(distinct LineNumber)
FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine
WHERE CancelDate is not null 
and OrderDate>='2025-03-01'




WHERE ReceptionDate IS NULL
SELECT
    OrderNumber ,LineNumber ,CancelDate
    ,CONVERT(DATE, OrderDate) AS OrderDate
    ,CONVERT(DATE, ReceptionDate) AS ReceptionDate
    ,DATEDIFF(day, CONVERT(DATE, ReceptionDate), CONVERT(DATE, OrderDate)) AS DaysBetween
FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine
WHERE ReceptionDate IS NULL

SELECT COUNT (DISTINCT ItemKey)
FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine
-- group by ReceptionDate order by ReceptionDate asc
WHERE ReceptionDate IS NULL


