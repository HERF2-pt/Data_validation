
-- =============================================
-- Author:		<Author,,Bart>
-- Create date: <Create Date,2025-07-03,>
-- Description:	<EXEC [dbo].[Load_F_PurchaseOrderLine]>
-- =============================================

CREATE PROCEDURE [dbo].[Load_F_PurchaseOrderLine]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @IdentityAuditId  decimal(18, 0)
          , @RowCountAffected decimal(18, 0)
          , @Database         varchar(22)
    SET @Database = 'RDL00001_EnterpriseDataWarehouse'

    /***********************************************************************************************
								REQUETE PRINCIPALE (DELETE)
										DEBUT
************************************************************************************************/

    -- Insert empty ROW into the AUDIT Table for deleted records
    EXEC @IdentityAuditId = [RDL00001_EnterpriseDataLanding].dbo.SYS_AUDIT_TRANSACTION 0
                                                                                     , @Database
                                                                                     , 'F_PurchaseOrderLine'
                                                                                     , 'D'
                                                                                     , 'F'
                                                                                     , 0
                                                                                     , 0
                                                                                     , 0
                                                                                     , 'N'
    delete from [dbo].[F_PurchaseOrderLine]

    -- SET THE VARIABLE WITH THE ROW COUNT OF THE DELETE
    SElECT @RowCountAffected = @@ROWCOUNT

    -- UPDATE THE AUDIT TABLE WITH THE ROWCOUNTAFFECTED
    EXEC @IdentityAuditId = [RDL00001_EnterpriseDataLanding].dbo.SYS_AUDIT_TRANSACTION @IdentityAuditId
                                                                                     , @Database
                                                                                     , 'F_PurchaseOrderLine'
                                                                                     , 'D'
                                                                                     , 'S'
                                                                                     , @RowCountAffected
                                                                                     , 0
                                                                                     , 0
                                                                                     , 'Y'
    -- UPDATE THE AUDIT TABLE WITH THE ROWCOUNTAFFECTED

    /***********************************************************************************************
								REQUETE PRINCIPALE (DELETE)
										FIN
************************************************************************************************/

    /***********************************************************************************************
								REQUETE PRINCIPALE (INSERT)
										DEBUT
************************************************************************************************/

    -- Insert empty ROW into the AUDIT Table for inserted records
    EXEC @IdentityAuditId = [RDL00001_EnterpriseDataLanding].dbo.SYS_AUDIT_TRANSACTION 0
                                                                                     , @Database
                                                                                     , 'F_PurchaseOrderLine'
                                                                                     , 'I'
                                                                                     , 'F'
                                                                     , 0
                                                                                     , 0
                                                                                     , 0
                                                                                     , 'N'
    INSERT INTO [RDL00001_EnterpriseDataWarehouse].[dbo].[F_PurchaseOrderLine]
    (
        [ItemKey]
      , [ItemBranchkey]
      , [AccountNumber]
      , [AmountOpen]
      , [Branch]
      , [BuyerNumber]
      , [CarrierCode]
      , [CatalogName]
      , [CompanyCode]
      , [CostCenter]
      , [DescriptionLine1]
      , [DescriptionLine2]
      , [ExchangeRate]
      , [ForeignAmount]
      , [LastStatusCode]
      , [LineNumber]
      , [LineTypeCode]
      , [NextStatusCode]
      , [OrderNumber]
      , [OrderType]
      , [OriginalAmount]
      , [CancelDate]
      , [GLDate]
      , [OrderDate]
      , [OriginalPromisDate]
      , [PromiseDate]
      , [ReceptionDate]
      , [RequestedDate]
      , [ProjectNumber]
      , [PurchaseOrderCode01]
      , [QtyOpenQtyReceived]
      , [QuantityOpen]
      , [QuantityOrder]
      , [QuantityReceived]
      , [RelatedCO]
      , [RelatedLine]
      , [RelatedNumber]
      , [RelatedOrderType]
      , [Subledger]
      , [SubledgerType]
      , [SupplierNumber]
      , [TransactionOriginator]
      , [UnitCostPurchasing]
      , [UnitPrice]
      , [UOM]
      , [OrderCO]
      , [Currency]
      , [Shipto]
	  , [StandardCost]
      , [LastInCost]
      , [LastInPrimaryVendorCost]
      , [CatalogPrice]
    )
    SELECT isnull([ItemKey], -1)     as [ItemKey]
         , isnull(ItemBranchkey, -1) as ItemBranchkey
         , [AccountNumber]
         , [AmountOpen]
         , [Branch]
         , P.[BuyerNumber]
         , [CarrierCode]
         , [CatalogName]
         , [CompanyCode]
         , P.[CostCenter]
         , [DescriptionLine1]
         , [DescriptionLine2]
         , [ExchangeRate]
         , [ForeignAmount]
         , [LastStatusCode]
         , [LineNumber]
         , [LineTypeCode]
         , [NextStatusCode]
         , [OrderNumber]
         , [OrderType]
         , [OriginalAmount]
         , [CancelDate]
         , [GLDate]
         , [OrderDate]
         , [OriginalPromisDate]
         , [PromiseDate]
         , [ReceptionDate]
         , [RequestedDate]
         , [ProjectNumber]
         , [PurchaseOrderCode01]
         , [QtyOpenQtyReceived]
         , [QuantityOpen]
         , [QuantityOrder]
         , [QuantityReceived]
         , [RelatedCO]
         , [RelatedLine]
         , [RelatedNumber]
         , [RelatedOrderType]
         , [Subledger]
         , [SubledgerType]
         , P.[SupplierNumber]
         , [TransactionOriginator]
         , [UnitCostPurchasing]
         , [UnitPrice]
         , [UOM]
         , [OrderCO]
         , [Currency]
         , [Shipto]
		 , [StandardCost]
         , [LastInCost]
         , [LastInPrimaryVendorCost]
         , [CatalogPrice]
   select *  FROM [RDL00001_EnterpriseDataStaging].[dbo].[F_PurchaseOrderLine]              P
        Left join [RDL00001_EnterpriseDataWarehouse].[dbo].[D_ItemMaster] IM
            ON P.ItemNumber = IM.ItemNumber
        Left join [RDL00001_EnterpriseDataWarehouse].[dbo].[D_ItemBranch] IB
            ON P.ItemNumber = IB.ItemNumber
               and trim(P.Branch) = trim(IB.CostCenter)
END