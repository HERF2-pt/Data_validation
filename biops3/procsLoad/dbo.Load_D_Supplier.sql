--  ============================================= 
--  Author:		<Author , ,Name> 
--  Create  date:  <Create  Date , ,> 
--  Description:	EXEC  [dbo].[Load_d_Supplier]   
--select  *  from  [RDL00001_EnterpriseDataStaging].[dbo].[D_Supplier]   
--  ============================================= 
CREATE PROCEDURE [dbo].[Load_d_Supplier] AS BEGIN
SET
	NOCOUNT ON;

--******************************************************************************************************************************* 
--                                                                                                                DECLARING  VARIABLES 
--*******************************************************************************************************************************     
IF OBJECT_ID('tempdb..##TMP_F0401') IS NOT NULL DROP TABLE ##TMP_F0401 
--##TMP_F0401 
SELECT
	A6AN8_AddressNumber,
	ABALPH_NameAlpha,
	ABAT1_AddressType1 INTO ##TMP_F0401 
FROM
	[RDL00001_EnterpriseDataLanding].jde.F0401 T1
	LEFT JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_V0101] T2 ON T1.A6AN8_AddressNumber = T2.ABAN8_AddressNumber TRUNCATE TABLE [dbo].[D_Supplier]
INSERT INTO
	[dbo].[D_Supplier] (
		SupplierNumber,
		SupplierName,
		[SearchType]
	)
SELECT
	A6AN8_AddressNumber AS SupplierNumber,
	ABALPH_NameAlpha AS SupplierName,
	ABAT1_AddressType1 AS SearchType
FROM
	##TMP_F0401   
END