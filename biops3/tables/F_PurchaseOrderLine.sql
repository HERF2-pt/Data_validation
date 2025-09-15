SELECT TOP 1000
    *

FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine


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

SELECT *
FROM
    RDL00001_EnterpriseDataWarehouse.dbo.D_ItemBranch
WHERE ItemBranchkey='56796'


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

SELECT
    TABLE_SCHEMA + '.' + TABLE_NAME AS TABLE_FULL_NAME
    ,COLUMN_NAME
    ,DATA_TYPE
    ,IS_NULLABLE
    ,TABLE_CATALOG
    ,GetDate() AS Date
    ,ORDINAL_POSITION
FROM [RDL00001_EnterpriseDataWarehouse].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE '%PurchaseOrderLine%' AND TABLE_SCHEMA='dbo'
ORDER BY TABLE_NAME, COLUMN_NAME

SELECT
    CASE WHEN 'BuyerNumber' = '2141873'  THEN 'CS'
     WHEN 'ItemNumber' = '555555' AND 'Company' = '09052' THEN 'Subcontractor'
     WHEN 'ItemNumber' = '222222' AND 'Company' IN ('00024','09011') THEN 'Subcontractor'
     WHEN 'ItemNumber' = '111111' AND 'Company' IN ('00077','09041') THEN 'Subcontractor'
     WHEN 'SecondItem' LIKE '%*OP%' AND 'GLClassCode' = 'IN20' AND 'Company' = '00001' THEN 'Subcontractor'
     ELSE 'General' END AS 'PO_Type'
FROM
    RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine p
    LEFT JOIN RDL00001_EnterpriseDataWarehouse.dbo.D_ItemMaster ib ON p.ItemKey=ib.ItemKey