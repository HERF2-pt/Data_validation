SELECT
  PO.TransactionOriginator,
  d.FiscalYearName,
  count(*) AS TotalLignes,
  COUNT(DISTINCT PO.OrderNumber) AS TotalPO
FROM
  [RDL00001_EnterpriseDataWarehouse].[dbo].[F_PurchaseOrderLine] PO
  LEFT JOIN [RDL00001_EnterpriseDataWarehouse].[Shared].[DimDate] d ON PO.OrderDate = d.id
WHERE
  PO.TransactionOriginator IN (
    'DUME',
    'LAFR',
    'LARA',
    'LAVP2',
    'LECB',
    'TREM6',
    'ALBD',
    'LEDP',
    'CARN8',
    'CARI3'
  )
GROUP BY
  PO.TransactionOriginator,
  d.FiscalYearName
ORDER BY
  PO.TransactionOriginator,
  d.FiscalYearName 
  
  USE RDL00001_EnterpriseDataStaging;
  EXEC sp_helptext 'dbo.Load_D_Company'

  EXEC sp_helptext 'RDL00001_EnterpriseDataStaging.dbo.Load_D_Company'
