--  ============================================= 
--  Author:		<Author , ,SAMN> 
--  Create  date:  <Create  Date , ,> 
--  Description:	EXEC  [dbo].[Load_d_Company]   
--  ============================================= 
CREATE PROCEDURE [dbo].[Load_d_Company] AS BEGIN
SET
	NOCOUNT ON;

--******************************************************************************************************************************* 
--                                                                                                                DECLARING  VARIABLES 
--*******************************************************************************************************************************     
MERGE [dbo].[d_Company] t USING (
	SELECT
		DISTINCT T1.MCCO_Company AS CompanyCode,
		Trim (T2.CCNAME) AS CompanyName,
		Trim(T2.CCCRCD) AS CurrencyCode
	FROM
		[RDL00001_EnterpriseDataLanding].JDE.F0006_V2 T1
		LEFT JOIN [RDL00001_EnterpriseDataLanding].JDE.F0010 T2 ON T1.MCCO_Company = LTRIM(RTRIM(T2.CCCO))
	WHERE
		Trim (T1.MCCO_Company) IN (
			N'00001',
			N'00024',
			N'00077',
			N'09011',
			N'09052',
			N'99050',
			N'00074',
			N'09041'
		) ---where  Trim  (T1.MCCO_Company)      in  (  N'00001'   ,    N'00077'   ,N'09011' ,    N'09052'  ) 
) AS s ON s.CompanyCode = t.CompanyCode ----update  status  when  matched 
WHEN MATCHED THEN
UPDATE
SET
	t.CompanyName = s.CompanyName ---Insert  new  Status  when  not  matched 
	WHEN NOT MATCHED BY TARGET THEN
INSERT
	(
		CompanyCode,
		CompanyName,
		CurrencyCode
	)
VALUES
	(
		s.CompanyCode,
		s.CompanyName,
		s.CurrencyCode
	);

END