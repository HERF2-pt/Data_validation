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


SELECT IB.IBMCU_CostCenter,U.T3MCU_CostCenter,IB.IBITM_IdentifierShortItem,U.T3SBN1_SuppDataNumericKey1, U.T3RMK_NameRemark
FROM [RDL00001_EnterpriseDataLanding].JDE_BI_OPS.V_F4102 IB
LEFT JOIN [RDL00001_EnterpriseDataLanding].JDE_BI_OPS.V_F00092 U
  ON trim(IBMCU_CostCenter) = TRIM(U.T3MCU_CostCenter)
  AND CAST(IB.IBITM_IdentifierShortItem AS CHAR) = CAST(U.[T3SBN1_SuppDataNumericKey1] AS CHAR)
--AND IB.ItemNumber = U.T3SBN1_SuppDataNumericKey1


-- where U.T3SBN1_SuppDataNumericKey1 is not null 
where  trim(T3RMK_NameRemark)='E20' and IBITM_IdentifierShortItem=828675


 select * from [RDL00001_EnterpriseDataLanding].JDE_BI_OPS.V_F00092
 where  trim(T3RMK_NameRemark)='E10'


