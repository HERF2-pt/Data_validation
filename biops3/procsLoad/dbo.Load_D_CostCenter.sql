--  ============================================= 
--  Author:		<Author , ,SAMN> 
--  Create  date:  <Create  Date , ,> 
--  Description:	EXEC  [dbo].[Load_d_CostCenter]   
--  ============================================= 
CREATE PROCEDURE [dbo].[Load_d_CostCenter] AS BEGIN
SET
	NOCOUNT ON;

--******************************************************************************************************************************* 
--                                                                                                                DECLARING  VARIABLES 
--*******************************************************************************************************************************     
IF OBJECT_ID('tempdb..##TMP_F0006_V2') IS NOT NULL DROP TABLE ##TMP_F0006_V2 
IF OBJECT_ID('tempdb..##TMP_F0116') IS NOT NULL DROP TABLE ##TMP_F0116 
IF OBJECT_ID('tempdb..##TMP_F0010') IS NOT NULL DROP TABLE ##TMP_F0010 
---##TMP_F0006_V2 
SELECT
	MCMCU_CostCenter,
	MCCO_Company,
	MCAN8_AddressNumber,
	MCSTYL_CostCenterType AS CostCenterType,
	MCDC_DescripCompressed AS DescriptionCompressed,
	MCRP04_CategoryCodeCostCt004 AS CostCenterCategoryCode,
	MCRMCU1_RelatedBusinessUnit AS RelatedBusinessUnit,
	MCDL01_Description001 AS DescriptionCostCenter INTO ##TMP_F0006_V2 
FROM
	[RDL00001_EnterpriseDataLanding].jde.F0006_V2
WHERE
	MCCO_Company IN (
		N'00001',
		N'00024',
		N'00077',
		N'09011',
		N'09052',
		N'99050',
		N'00074',
		N'09041'
	) ---and    TRIM  (MCMCU_CostCenter)  in  (  '101' ,'112' ,'370' ,'403' ,'118') 
	---##TMP_F0116:  Address  Based  on  maximum  date 
SELECT
	ALAN8_AddressNumber,
	ALADDS_State,
	Max (ALEFTB_DateBeginningEffective) AS LEFTB_DateBeginningEffective,
	ALCTY1_City,
	ALCTR_Country INTO ##TMP_F0116 
FROM
	[RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F0116]
WHERE
	ALEFTB_DateBeginningEffective <= cast (GETDATE() AS date)
GROUP BY
	ALAN8_AddressNumber,
	ALADDS_State,
	ALCTY1_City,
	ALCTR_Country --##TMP_F0010 
SELECT
	CCNAME,
	CCCRCD,
	CCCO INTO ##TMP_F0010 
FROM
	[RDL00001_EnterpriseDataLanding].jde.F0010 TRUNCATE TABLE [dbo].[D_CostCenter];

INSERT INTO
	[dbo].[D_CostCenter] (
		[CostCenter],
		[CostCenterType],
		[DescriptionCompressed],
		[Company],
		[CostCenterCategoryCode],
		[CostCenterCategory],
		[RelatedBusinessUnit],
		[DescriptionCostCenter],
		[Site],
		CurrencyCode,
		AddressNumber
	)
SELECT
	MCMCU_CostCenter AS CostCenter,
	MCSTYL_CostCenterType AS CostCenterType,
	MCDC_DescripCompressed AS DescriptionCompressed,
	MCCO_Company AS Company,
	MCRP04_CategoryCodeCostCt004 AS CostCenterCategoryCode,
	LTRIM (RTRIM (T2.DRDL01)) AS CostCenterCategory,
	MCRMCU1_RelatedBusinessUnit AS RelatedBusinessUnit,
	MCDL01_Description001 AS DescriptionCostCenter,
	T3.ALCTY1_City AS [Site],
	T4.CCCRCD AS CurrencyCode,
	T1.MCAN8_AddressNumber AS AddressNumber
FROM
	[RDL00001_EnterpriseDataLanding].[JDE].[F0006_V2] T1
	LEFT JOIN [RDL00001_EnterpriseDataLanding].JDE.F0005 T2 ON T1.MCRP04_CategoryCodeCostCt004 = LTRIM (RTRIM (T2.DRKY))
	AND T2.DRSY = '00'
	AND T2.DRRT = '04'
	LEFT JOIN ##TMP_F0116    T3 
	ON T1.MCAN8_AddressNumber = T3.ALAN8_AddressNumber
	LEFT JOIN ##TMP_F0010    T4 
	ON T1.MCCO_Company = T4.CCCO
END