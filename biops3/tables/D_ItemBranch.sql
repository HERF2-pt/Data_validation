SELECT top 100 * FROM RDL00001_EnterpriseDataWarehouse.dbo.D_ItemBranch
go---------------------------------
----------------------------------
SELECT top 100 OriginalAmount, SecondItem, * FROM RDL00001_EnterpriseDataWarehouse.dbo.D_ItemBranch I
join RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine P
on I.ItemBranchkey=p.ItemBranchkey
where SecondItem is not null

SELECT TABLE_NAME,
       TABLE_SCHEMA + '.' + TABLE_NAME AS TABLE_FULL_NAME,
       COLUMN_NAME,
       DATA_TYPE,
       IS_NULLABLE,
       TABLE_CATALOG,
       GetDate() AS Date,
       ORDINAL_POSITION from
[RDL00001_EnterpriseDataWarehouse].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE '%D_ItemBranch%' and TABLE_SCHEMA='dbo'
ORDER BY TABLE_NAME, COLUMN_NAME


