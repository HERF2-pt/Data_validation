SELECT
    TOP 100
    *
FROM
    RDL00001_EnterpriseDataWarehouse.dbo.D_CostCenter
SELECT
    [CostCenterKey] AS BranchKey
    ,[CostCenter] AS Branch
    ,[CostCenterType] AS BranchType
    ,[DescriptionCompressed]
    ,[Company] AS Cie
    ,[CostCenterCategory] AS BranchCategory
    ,[CostCenterCategoryCode] AS BranchCategoryCode
    ,[AddressNumber] AS ShiptoSoldTo
-- ,[RelatedBusinessUnit]
-- ,[DescriptionCostCenter]
FROM
    [RDL00001_EnterpriseDataWarehouse].[dbo].[D_CostCenter]
WHERE
    trim(CostCenter) IN (
        '101',
        '112',
        '118',
        '370',
        '403',
        '124',
        '535',
        '536',
        '537',
        '952'
    )
    AND trim(Company) IN (
        '00001',
        '00077',
        '09011',
        '09052',
        '09041',
        '00024'
    )