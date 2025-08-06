--  ============================================= 
--  Author:		<Author , ,BART> 
--  Create  date:  <Create  Date ,2025-07-03 ,> 
--  Description:	EXEC  [dbo].[Load_F_ProductCost_Purchase]   
--  ============================================= 
CREATE PROCEDURE [dbo].[Load_F_ProductCost_Purchase] AS BEGIN
SET
        NOCOUNT ON;

--******************************************************************************************************************************* 
--                                                                                                                DECLARING  VARIABLES 
--*******************************************************************************************************************************     
DECLARE @IdentityAuditId decimal(18, 0),
@RowCountAffected decimal(18, 0),
@Database varchar(22),
@BeginDate varchar(10)
SET
        @Database = 'RDL00001_EnterpriseDataStaging' --  To  have  the  financial  year  of  the  current  date  for  the  standard  cost 
SELECT
        @BeginDate = [FiscalYear]
FROM
        [RDL00001_EnterpriseDataStaging].[Shared].[DimDate]
WHERE
        [Date] = CONVERT(DATE, CURRENT_TIMESTAMP) --PRINT  @BeginDate 
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (DELETE) 
         
         
         DEBUT 
         
         
         ************************************************************************************************/
        --  Insert  empty  ROW  into  the  AUDIT  Table  for  deleted  records 
        EXEC @IdentityAuditId = RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION 0,
        @Database,
        'F_ProductCost_Purchase',
        'D',
        'F',
        0,
        0,
        0,
        'N'
DELETE FROM
        dbo.F_ProductCost_Purchase --  SET  THE  VARIABLE  WITH  THE  ROW  COUNT  OF  THE  DELETE 
SELECT
        @RowCountAffected = @ @ROWCOUNT --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED 
        EXEC @IdentityAuditId = RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION @IdentityAuditId,
        @Database,
        'F_ProductCost_Purchase',
        'D',
        'S',
        @RowCountAffected,
        0,
        0,
        'Y' --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED 
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (DELETE) 
         
         
         FIN 
         
         
         ************************************************************************************************/
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (INSERT) 
         
         
         DEBUT 
         
         
         ************************************************************************************************/
        --  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records 
        EXEC @IdentityAuditId = RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION 0,
        @Database,
        'F_ProductCost_Purchase',
        'I',
        'F',
        0,
        0,
        0,
        'N'
INSERT INTO
        [dbo].[F_ProductCost_Purchase] (
                [DRDL02_Description01002_new],
                [DRDL02_Description01002],
                [DRDL01_Description001],
                [COMCU_CostCenter],
                [COLOCN_Location],
                [COITM_IdentifierShortItem],
                [CCCRCD],
                [COLEDG_LedgType],
                [COUNCS_AmountUnitCost],
                [CCCO],
                [Cost_Type]
        )
SELECT
        CASE
                WHEN TRIM([DRDL01_Description001]) IN (
                        'Standard',
                        'Last  In',
                        'Last  In  Primary  Vendor'
                ) THEN @BeginDate
                WHEN TRIM([DRDL01_Description001]) LIKE 'Actual  2%' THEN REPLACE(TRIM([DRDL02_Description01002]), 'A', '')
                ELSE 0
        END [DRDL02_Description01002_new],
        TRIM([DRDL02_Description01002]) [DRDL02_Description01002],
        TRIM([DRDL01_Description001]) [DRDL01_Description001],
        [COMCU_CostCenter],
        [COLOCN_Location],
        [COITM_IdentifierShortItem],
        CCCRCD,
        [COLEDG_LedgType],
        ISNULL([COUNCS_AmountUnitCost], 0) AS [COUNCS_AmountUnitCost],
        [CCCO],
        CASE
                WHEN TRIM([DRDL01_Description001]) LIKE 'Actual  2%'
                OR TRIM([DRDL01_Description001]) = 'Standard' THEN 'Standard'
                WHEN TRIM([DRDL01_Description001]) = 'Last  In' THEN 'Last  In'
                WHEN TRIM([DRDL01_Description001]) = 'Last  In  Primary  Vendor' THEN 'Last  In  Primary  Vendor'
                ELSE ''
        END Cost_Type
FROM
        [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4105]
        LEFT OUTER JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4101] ON [COITM_IdentifierShortItem] = [IMITM_IdentifierShortItem]
        LEFT OUTER JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F0005] ON LTRIM(RTRIM([COLEDG_LedgType])) = LTRIM(RTRIM([DRKY_UserDefinedCode]))
        AND LTRIM(RTRIM([DRSY_ProductCode])) = '40'
        AND LTRIM(RTRIM([DRRT_UserDefinedCodes])) = 'CM'
        LEFT OUTER JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F0006] ON [MCMCU_CostCenter] = [COMCU_CostCenter]
        LEFT OUTER JOIN [RDL00001_EnterpriseDataLanding].[JDE].[F0010] ON [MCCO_Company] = [CCCO]
WHERE
        [IMSTKT_StockingType] IN ('P', 'B', 'O', 'U', 'X', 'H') --  SET  THE  VARIABLE  WITH  THE  ROW  COUNT  OF  THE  DELETE 
SELECT
        @RowCountAffected = @ @ROWCOUNT --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED 
        EXEC RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION @IdentityAuditId,
        @Database,
        'F_ProductCost_Purchase',
        'I',
        'S',
        @RowCountAffected,
        0,
        0,
        'Y'
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (INSERT) 
         
         
         FIN 
         
         
         ************************************************************************************************/
END