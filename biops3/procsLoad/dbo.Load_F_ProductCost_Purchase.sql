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
@BeginDate varchar(10),
@BeginDateFY varchar(10)
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
        'N' --  To  have  the  financial  year  of  the  current  date  for  the  standard  cost 
SELECT
        @BeginDate = [FiscalYear]
FROM
        [RDL00001_EnterpriseDataStaging].[Shared].[DimDate]
WHERE
        [Date] = CONVERT(DATE, CURRENT_TIMESTAMP) --  To  have  the  first  financial  date  of  the  year  5  years  ago 
SELECT
        @BeginDateFY = MIN([Date])
FROM
        [RDL00001_EnterpriseDataStaging].[Shared].[DimDate]
WHERE
        [FiscalYear] = (
                SELECT
                        [FiscalYear]
                FROM
                        [RDL00001_EnterpriseDataStaging].[Shared].[DimDate]
                WHERE
                        [Date] = CONVERT(DATE, DATEADD(YEAR, -5, CURRENT_TIMESTAMP))
        );

--  To  get  the  first  day  of  the  fiscal  year 
DROP TABLE IF EXISTS #DimDate 
SELECT
        MIN([Id]) [Id],
        [FiscalYear] INTO #DimDate 
FROM
        [RDL00001_EnterpriseDataStaging].[Shared].[DimDate]
WHERE
        [Date] >= @BeginDateFY
GROUP BY
        [FiscalYear] DROP TABLE IF EXISTS #ProductCosts 
SELECT
        CASE
                WHEN TRY_CAST([COLEDG_LedgType] AS INT) IN (01, 07, 22) THEN @BeginDate
                WHEN TRY_CAST([COLEDG_LedgType] AS INT) IN (57, 58, 59, 60, 61, 62) THEN TRY_CAST(
                        REPLACE(TRIM([DRDL02_Description01002]), 'A', '') AS INT
                )
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
                WHEN TRY_CAST([COLEDG_LedgType] AS INT) IN (07, 57, 58, 59, 60, 61, 62) THEN 'Standard'
                WHEN TRY_CAST([COLEDG_LedgType] AS INT) = 01 THEN 'Last  In'
                WHEN TRY_CAST([COLEDG_LedgType] AS INT) = 22 THEN 'Last  In  Primary  Vendor'
                ELSE ''
        END Cost_Type INTO #ProductCosts 
FROM
        [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4105]
        LEFT OUTER JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4102] F4102 ON (
                [COITM_IdentifierShortItem] = [IBITM_IdentifierShortItem]
                AND TRIM([COMCU_CostCenter]) = TRIM([IBMCU_CostCenter])
        )
        LEFT OUTER JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F0005] ON TRIM([COLEDG_LedgType]) = TRIM([DRKY_UserDefinedCode])
        AND TRIM([DRSY_ProductCode]) = '40'
        AND TRIM([DRRT_UserDefinedCodes]) = 'CM'
        LEFT OUTER JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F0006] ON [MCMCU_CostCenter] = [COMCU_CostCenter]
        LEFT OUTER JOIN [RDL00001_EnterpriseDataLanding].[JDE].[F0010] ON [MCCO_Company] = [CCCO]
WHERE
        TRIM([IBSTKT_StockingType]) IN ('P', 'B', 'O', 'U', 'X', 'H')
        AND (
                TRY_CAST([COLEDG_LedgType] AS INT) IN (
                        01,
                        07,
                        22,
                        57,
                        58,
                        59,
                        60,
                        61,
                        62
                )
        )
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
                [Cost_Type],
                [Date]
        )
SELECT
        A.[DRDL02_Description01002_new],
        A.[DRDL02_Description01002],
        A.[DRDL01_Description001],
        A.[COMCU_CostCenter],
        A.[COLOCN_Location],
        A.[COITM_IdentifierShortItem],
        A.[CCCRCD],
        A.[COLEDG_LedgType],
        A.[COUNCS_AmountUnitCost],
        A.[CCCO],
        A.[Cost_Type],
        B.Id AS Dates
FROM
        #ProductCosts            A 
        INNER JOIN #DimDate  B 
        ON A.DRDL02_Description01002_new = B.FiscalYear --  SET  THE  VARIABLE  WITH  THE  ROW  COUNT  OF  THE  DELETE 
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