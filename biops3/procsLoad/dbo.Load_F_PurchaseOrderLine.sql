--  ============================================= 
--  Author:		<Author , ,BART> 
--  Create  date:  <Create  Date ,2025-07-03 ,> 
--  Description:	EXEC  [dbo].[Load_F_Purchase]   
--  ============================================= 
CREATE PROCEDURE [dbo].[Load_F_PurchaseOrderLine] AS BEGIN
SET
        NOCOUNT ON;

--******************************************************************************************************************************* 
--                                                                                                                DECLARING  VARIABLES 
--*******************************************************************************************************************************     
DECLARE @IdentityAuditId decimal(18, 0),
@RowCountAffected decimal(18, 0),
@Database varchar(22),
@BeginDate datetime
SET
        @Database = 'RDL00001_EnterpriseDataStaging' --  To  have  the  first  financial  date  of  the  year  5  years  ago 
SELECT
        @BeginDate = MIN([Date])
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

/*********************************************************************************************** 
 
 
 REQUETE  PRINCIPALE  (DELETE) 
 
 
 DEBUT 
 
 
 ************************************************************************************************/
--  Insert  empty  ROW  into  the  AUDIT  Table  for  deleted  records 
EXEC @IdentityAuditId = RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION 0,
@Database,
'F_PurchaseOrderLine',
'D',
'F',
0,
0,
0,
'N'
DELETE FROM
        dbo.F_PurchaseOrderLine --  SET  THE  VARIABLE  WITH  THE  ROW  COUNT  OF  THE  DELETE 
SELECT
        @RowCountAffected = @ @ROWCOUNT --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED 
        EXEC @IdentityAuditId = RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION @IdentityAuditId,
        @Database,
        'F_PurchaseOrderLine',
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
        'F_PurchaseOrderLine',
        'I',
        'F',
        0,
        0,
        0,
        'N'
INSERT INTO
        [dbo].[F_PurchaseOrderLine] (
                [AccountNumber],
                [AmountOpen],
                [Branch],
                [BuyerNumber],
                [CarrierCode],
                [CatalogName],
                [CompanyCode],
                [CostCenter],
                [DescriptionLine1],
                [DescriptionLine2],
                [ExchangeRate],
                [ForeignAmount],
                [ItemNumber],
                [LastStatusCode],
                [LineNumber],
                [LineTypeCode],
                [NextStatusCode],
                [OrderNumber],
                [OrderType],
                [OriginalAmount],
                [CancelDate],
                [GLDate],
                [OrderDate],
                [OriginalPromisDate],
                [PromiseDate],
                [ReceptionDate],
                [RequestedDate],
                [ProjectNumber],
                [PurchaseOrderCode01],
                [QtyOpenQtyReceived],
                [QuantityOpen],
                [QuantityOrder],
                [QuantityReceived],
                [RelatedCO],
                [RelatedLine],
                [RelatedNumber],
                [RelatedOrderType],
                [Subledger],
                [SubledgerType],
                [SupplierNumber],
                [TransactionOriginator],
                [UnitCostPurchasing],
                [UnitPrice],
                [UOM],
                [OrderCO],
                [Currency],
                [Shipto]
        )
SELECT
        F4311.PDANI_AcctNoInputMode AS AccountNumber,
        F4311.PDAOPN_AmountOpen1 AS AmountOpen,
        F4311.PDMCU_CostCenter AS Branch,
        F4311.PDANBY_BuyerNumber AS BuyerNumber,
        F4311.[PDURAB_UserReservedNumber] AS CarrierCode,
        F4311.PDCATN_CatalogName AS CatalogName,
        F4311.[PDCO_Company] AS CompanyCode,
        F4311.PDOMCU_PurchasingCostCenter AS CostCenter,
        F4311.PDDSC1_DescriptionLine1 AS DescriptionLine1,
        F4311.PDDSC2_DescriptionLine2 AS DescriptionLine2,
        F4311.PDCRR_CurrencyConverRateOv AS ExchangeRate,
        F4311.PDFEA_AmountForeignExtPrice AS ForeignAmount,
        F4311.PDITM_IdentifierShortItem AS ItemNumber,
        F4311.PDLTTR_StatusCodeLast AS LastStatusCode,
        F4311.PDLNID_LineNumber AS LineNumber,
        F4311.PDLNTY_LineType AS LineTypeCode,
        F4311.PDNXTR_StatusCodeNext AS NextStatusCode,
        F4311.PDDOCO_DocumentOrderInvoiceE AS OrderNumber,
        F4311.PDDCTO_OrderType AS OrderType,
        F4311.PDAEXP_AmountExtendedPrice AS OriginalAmount,
        F4311.PDCNDJ_CancelDate AS CancelDate,
        F4311.PDDGL_DtForGLAndVouch1 AS GLDate,
        F4311.PDTRDJ_DateTransactionJulian AS OrderDate,
        F4311.PDOPDJ_DateOriginalPromisde AS OriginalPromisDate,
        F4311.PDPDDJ_ScheduledPickDate AS PromiseDate,
        CARDEX.ILTRDJ_DateTransactionJulian AS ReceptionDate,
        F4311.PDDRQJ_DateRequestedJulian AS RequestedDate,
        F4311.PDPRJM_ProjectNumber AS ProjectNumber,
        F4301.PHPOHC01_PurchaseOrderCode01 AS PurchaseOrderCode01,
        PDUORG_UnitsTransactionQty AS QtyOpenQtyReceived,
        F4311.PDUOPN_UnitsOpenQuantity AS QuantityOpen,
        F4311.PDPQOR_UnitsPrimaryQtyOrder AS QuantityOrder,
        CARDEX.ILTRQT_QuantityTransaction AS QuantityReceived,
        F4311.PDRKCO_CompanyKeyRelated AS RelatedCO,
        F4311.PDRLLN_RelatedPoSoLineNo AS RelatedLine,
        F4311.PDRORN_RelatedPoSoNumber AS RelatedNumber,
        F4311.PDRCTO_RelatedOrderType AS RelatedOrderType,
        F4311.PDSBL_Subledger AS Subledger,
        F4311.PDSBLT_SubledgerType AS SubledgerType,
        F4311.PDAN8_AddressNumber AS SupplierNumber,
        F4311.PDTORG_TransactionOriginator AS TransactionOriginator,
        F4311.PDAMC3_UnitCostPurchasing AS UnitCostPurchasing,
        F4311.PDPRRC_PurchasingUnitPrice AS UnitPrice,
        F4311.PDUOM_UnitOfMeasureAsInput AS UOM,
        F4311.PDKCOO_CompanyKeyOrderNo AS OrderCO,
        F4311.PDCRCD_CurrencyCodeFrom AS Currency,
        F4311.[PDSHAN_AddressNumberShipTo] AS Shipto
FROM
        [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4311] F4311
        LEFT OUTER JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4301] F4301 ON F4311.PDDOCO_DocumentOrderInvoiceE = F4301.PHDOCO_DocumentOrderInvoiceE
        AND F4311.PDKCOO_CompanyKeyOrderNo = F4301.PHKCOO_CompanyKeyOrderNo
        AND F4311.PDDCTO_OrderType = F4301.PHDCTO_OrderType
        LEFT OUTER JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4111] CARDEX ON F4311.PDDOCO_DocumentOrderInvoiceE = CARDEX.ILDOCO_DocumentOrderInvoiceE
        AND F4311.PDDCTO_OrderType = CARDEX.ILDCTO_OrderType
        AND F4311.PDKCOO_CompanyKeyOrderNo = CARDEX.ILKCOO_CompanyKeyOrderNo
        AND F4311.PDLNID_LineNumber = CARDEX.ILLNID_LineNumber
        AND F4311.PDAN8_AddressNumber = CARDEX.ILAN8_AddressNumber
WHERE
        F4311.PDKCOO_CompanyKeyOrderNo IN (
                '00001',
                '00077',
                '09011',
                '09052',
                '09041',
                '00024'
        )
        AND TRIM(F4311.PDLNTY_LineType) IN (
                'S',
                'J',
                'N',
                'F',
                'XX',
                'ZZ',
                'ND',
                'SC',
                'D'
        )
        AND TRIM(F4311.PDDCTO_OrderType) IN ('OP', 'ON')
        AND TRIM(F4311.PDTORG_TransactionOriginator) NOT IN ('NEXONIAUPD')
        AND F4311.PDTRDJ_DateTransactionJulian >= @BeginDate;

--  SET  THE  VARIABLE  WITH  THE  ROW  COUNT  OF  THE  DELETE 
SELECT
        @RowCountAffected = @ @ROWCOUNT --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED 
        EXEC RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION @IdentityAuditId,
        @Database,
        'F_PurchaseOrderLine',
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
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (UPDATE)  Standard 
         
         
         DEBUT 
         
         
         ************************************************************************************************/
        --  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records 
        EXEC @IdentityAuditId = RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION 0,
        @Database,
        'F_PurchaseOrderLine',
        'U',
        'F',
        0,
        0,
        0,
        'N'
UPDATE
        A
SET
        [StandardCost] = Std.COUNCS_AmountUnitCost
FROM
        [RDL00001_EnterpriseDataStaging].[dbo].[F_PurchaseOrderLine] A
        LEFT OUTER JOIN [RDL00001_EnterpriseDataStaging].[Shared].[DimDate] B ON A.OrderDate = B.[Date]
        LEFT OUTER JOIN (
                SELECT
                        [DRDL02_Description01002_new],
                        [COMCU_CostCenter],
                        [COITM_IdentifierShortItem],
                        MAX([COUNCS_AmountUnitCost]) [COUNCS_AmountUnitCost]
                FROM
                        [RDL00001_EnterpriseDataStaging].[dbo].[F_ProductCost_Purchase]
                WHERE
                        [Cost_Type] = 'Standard'
                GROUP BY
                        [DRDL02_Description01002_new],
                        [COMCU_CostCenter],
                        [COITM_IdentifierShortItem]
        ) AS Std ON B.[FiscalYear] = Std.DRDL02_Description01002_new
        AND trim(A.Branch) = trim(Std.COMCU_CostCenter)
        AND A.ItemNumber = Std.COITM_IdentifierShortItem
SELECT
        @RowCountAffected = @ @ROWCOUNT --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED 
        EXEC RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION @IdentityAuditId,
        @Database,
        'F_PurchaseOrderLine',
        'U',
        'S',
        @RowCountAffected,
        0,
        0,
        'Y'
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (UPDATE)  Standard 
         
         
         FIN 
         
         
         ************************************************************************************************/
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (UPDATE)  Last  In 
         
         
         DEBUT 
         
         
         ************************************************************************************************/
        --  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records 
        EXEC @IdentityAuditId = RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION 0,
        @Database,
        'F_PurchaseOrderLine',
        'U',
        'F',
        0,
        0,
        0,
        'N'
UPDATE
        A
SET
        [LastInCost] = LastIn.COUNCS_AmountUnitCost
FROM
        [RDL00001_EnterpriseDataStaging].[dbo].[F_PurchaseOrderLine] A
        LEFT OUTER JOIN [RDL00001_EnterpriseDataStaging].[Shared].[DimDate] B ON A.OrderDate = B.[Date]
        LEFT OUTER JOIN (
                SELECT
                        [COMCU_CostCenter],
                        [COITM_IdentifierShortItem],
                        [DRDL02_Description01002_new],
                        MAX([COUNCS_AmountUnitCost]) [COUNCS_AmountUnitCost]
                FROM
                        [RDL00001_EnterpriseDataStaging].[dbo].[F_ProductCost_Purchase]
                WHERE
                        [Cost_Type] = 'Last  In'
                GROUP BY
                        [COMCU_CostCenter],
                        [COITM_IdentifierShortItem],
                        [DRDL02_Description01002_new]
        ) AS LastIn ON trim(A.Branch) = trim(LastIn.COMCU_CostCenter)
        AND A.ItemNumber = LastIn.COITM_IdentifierShortItem
        AND B.[FiscalYear] = LastIn.DRDL02_Description01002_new
SELECT
        @RowCountAffected = @ @ROWCOUNT --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED 
        EXEC RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION @IdentityAuditId,
        @Database,
        'F_PurchaseOrderLine',
        'U',
        'S',
        @RowCountAffected,
        0,
        0,
        'Y'
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (UPDATE)  Last  In 
         
         
         FIN 
         
         
         ************************************************************************************************/
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (UPDATE)  Last  In  Primary  Vendor 
         
         
         DEBUT 
         
         
         ************************************************************************************************/
        --  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records 
        EXEC @IdentityAuditId = RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION 0,
        @Database,
        'F_PurchaseOrderLine',
        'U',
        'F',
        0,
        0,
        0,
        'N'
UPDATE
        A
SET
        [LastInPrimaryVendorCost] = LastInPV.COUNCS_AmountUnitCost
FROM
        [RDL00001_EnterpriseDataStaging].[dbo].[F_PurchaseOrderLine] A
        LEFT OUTER JOIN [RDL00001_EnterpriseDataStaging].[Shared].[DimDate] B ON A.OrderDate = B.[Date]
        LEFT OUTER JOIN (
                SELECT
                        [COMCU_CostCenter],
                        [COITM_IdentifierShortItem],
                        [DRDL02_Description01002_new],
                        MAX([COUNCS_AmountUnitCost]) [COUNCS_AmountUnitCost]
                FROM
                        [RDL00001_EnterpriseDataStaging].[dbo].[F_ProductCost_Purchase]
                WHERE
                        [Cost_Type] = 'Last  In  Primary  Vendor'
                GROUP BY
                        [COMCU_CostCenter],
                        [COITM_IdentifierShortItem],
                        [DRDL02_Description01002_new]
        ) AS LastInPV ON trim(A.Branch) = trim(LastInPV.COMCU_CostCenter)
        AND A.ItemNumber = LastInPV.COITM_IdentifierShortItem
        AND B.[FiscalYear] = LastInPV.DRDL02_Description01002_new
SELECT
        @RowCountAffected = @ @ROWCOUNT --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED 
        EXEC RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION @IdentityAuditId,
        @Database,
        'F_PurchaseOrderLine',
        'U',
        'S',
        @RowCountAffected,
        0,
        0,
        'Y'
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (UPDATE)  Last  In  Primary  Vendor 
         
         
         FIN 
         
         
         ************************************************************************************************/
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (UPDATE)  Catalog 
         
         
         DEBUT 
         
         
         ************************************************************************************************/
        --  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records 
        EXEC @IdentityAuditId = RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION 0,
        @Database,
        'F_PurchaseOrderLine',
        'U',
        'F',
        0,
        0,
        0,
        'N'
UPDATE
        A
SET
        [CatalogPrice] = catalogs.[CBPRRC_PurchasingUnitPrice]
FROM
        [RDL00001_EnterpriseDataStaging].[dbo].[F_PurchaseOrderLine] A --LEFT  OUTER  JOIN  [RDL00001_EnterpriseDataStaging].[Shared].[DimDate]  B  ON  A.OrderDate  =  B.[Date] 
        LEFT OUTER JOIN (
                SELECT
                        [CBITM_IdentifierShortItem],
                        MAX([CBPRRC_PurchasingUnitPrice]) [CBPRRC_PurchasingUnitPrice]
                FROM
                        [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F41061]
                GROUP BY
                        [CBITM_IdentifierShortItem]
        ) AS catalogs ON A.ItemNumber = catalogs.[CBITM_IdentifierShortItem]
SELECT
        @RowCountAffected = @ @ROWCOUNT --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED 
        EXEC RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION @IdentityAuditId,
        @Database,
        'F_PurchaseOrderLine',
        'U',
        'S',
        @RowCountAffected,
        0,
        0,
        'Y'
        /*********************************************************************************************** 
         
         
         REQUETE  PRINCIPALE  (UPDATE)  Catalog 
         
         
         FIN 
         
         
         ************************************************************************************************/
END