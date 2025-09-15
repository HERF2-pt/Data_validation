--  ============================================= 
--  Author:		<Author , ,ANDM2> 
--  Create  date:  <Create  Date , ,> 
--  Description:	Exec  [dbo].[Load_f_execution_log] 
--  ============================================= 
CREATE PROCEDURE [dbo].[Load_f_execution_log] AS BEGIN
SET
	NOCOUNT ON;

--******************************************************************************************************************************* 
--                                                                                                                DECLARING  VARIABLES 
--*******************************************************************************************************************************     
IF OBJECT_ID('tempdb..##TMP_f_execution_log') IS NOT NULL DROP TABLE ##TMP_f_execution_log
SET
	TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

--  Insert  statements  for  procedure  here 
SELECT
	catalogId,
	userkey,
	RequestType,
	Format,
	ItemAction,
	Parent,
	Folder,
	date_key AS Executiondatekey,
	MIN(TimeStart) AS TimeStart,
	MAX(TimeEnd) AS TimeEnd,
	SUM(DATEDIFF(SECOND, TimeStart, TimeEnd)) AS TimeElapsed --  Durée 
,
	SUM(TimeDataReTrieval) / 1000 AS TimeDataReTrieval,
	SUM(TimeProcessing) / 1000 AS TimeProcessing,
	SUM(TimeRendering) / 1000 AS TimeRendering,
	STATUS,
	SUM(ByteCount) AS ByteCount,
CASE
		WHEN ItemAction IN ('Render', 'ConceptualSchema') THEN COUNT(*)
		ELSE 0
	END AS NumberOfExecutions --  Nombre  total  d'exécutions 
	--INTO ##TMP_f_execution_log
FROM
	ReportServer.dbo.ExecutionLog3
	LEFT JOIN [dbo].[d_date] d_date ON d_date.date_cd = CONVERT(DATE, ExecutionLog3.TimeStart)
	LEFT JOIN [dbo].[d_catalog] d_catalog ON d_catalog.Path COLLATE SQL_Latin1_General_CP1_CI_AS = ExecutionLog3.ItemPath COLLATE SQL_Latin1_General_CP1_CI_AS
	LEFT JOIN [dbo].[d_users] d_users ON d_users.username COLLATE SQL_Latin1_General_CP1_CI_AS = ExecutionLog3.UserName COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE
	RequestType <> 'Refresh  Cache' --  Exclut  les  exécutions  liées  au  cache 
	AND ItemAction IN (
		'Execute',
		'Render',
		'DataRefresh',
		'ASModelStream',
		'ConceptualSchema'
	) --  Actions  réelles  d'exécution 
	AND d_catalog.Type IN (2, 4, 13) --  Type  du  rapport  (2  =  paginé ,  13  =  Power  BI) 
GROUP BY
	CatalogId,
	ItemPath,
	userkey,
	ExecutionLog3.UserName,
	RequestType,
	Format,
	ItemAction,
	CONVERT(DATE, ExecutionLog3.TimeStart),
	date_key,
	Parent,
	Folder,
	STATUS
INSERT INTO
	[dbo].f_execution_log
SELECT
	[catalogId],
	[userkey],
	[requesttype],
	[Format],
	[itemaction],
	[Parent],
	[Folder],
	[Executiondatekey],
	[TimeStart],
	[TimeEnd],
	[TimeElapsed],
	[TimeDataRetrieval],
	[TimeProcessing],
	[TimeRendering],
	[Status],
	[ByteCount],
	[NumberOfExecutions]
FROM
	##TMP_f_execution_log  el_tmp
WHERE
	NOT EXISTS (
		SELECT
			1
		FROM
			[dbo].[f_execution_log] el
		WHERE
			el.catalogId = el_tmp.catalogId
			AND el.userkey = el_tmp.userkey
			AND el.Executiondatekey = el_tmp.Executiondatekey
			AND el.requesttype COLLATE SQL_Latin1_General_CP1_CI_AS = el_tmp.RequestType COLLATE SQL_Latin1_General_CP1_CI_AS
			AND el.Format COLLATE SQL_Latin1_General_CP1_CI_AS = el_tmp.Format COLLATE SQL_Latin1_General_CP1_CI_AS
			AND el.Parent COLLATE SQL_Latin1_General_CP1_CI_AS = el_tmp.Parent COLLATE SQL_Latin1_General_CP1_CI_AS
			AND el.Folder COLLATE SQL_Latin1_General_CP1_CI_AS = el_tmp.Folder COLLATE SQL_Latin1_General_CP1_CI_AS
			AND el.TimeStart = el_tmp.TimeStart
			AND el.TimeEnd = el_tmp.TimeEnd
	)
END