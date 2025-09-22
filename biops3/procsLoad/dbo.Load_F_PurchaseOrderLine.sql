  

--  =============================================  

--  Author:		<Author , ,BART>  

--  Create  date:  <Create  Date ,2025-07-03 ,>  

--  Description:	EXEC  [dbo].[Load_F_Purchase]    

--  =============================================  

  

CREATE  PROCEDURE  [dbo].[Load_F_PurchaseOrderLine]  

AS  

BEGIN  

        SET  NOCOUNT  ON;  

        --*******************************************************************************************************************************  

        --                                                                                                                DECLARING  VARIABLES  

        --*******************************************************************************************************************************      

        DECLARE  @IdentityAuditId    decimal(18 ,  0)  

                     ,  @RowCountAffected  decimal(18 ,  0)  

                     ,  @Database                  varchar(22)  

                     ,  @BeginDate                datetime  

        SET  @Database  =  'RDL00001_EnterpriseDataStaging'  

  

        --  To  have  the  first  financial  date  of  the  year  5  years  ago  

        SELECT  TOP  1  

                @BeginDate  =  [Date]  

        FROM  [RDL00001_EnterpriseDataStaging].[Shared].[DimDate]  

        WHERE  [FiscalYear]  =  

        (  

                SELECT  TOP  1  

                        [FiscalYear]  

                FROM  [RDL00001_EnterpriseDataStaging].[Shared].[DimDate]  

                WHERE  [Date]  =  CONVERT(DATE ,  DATEADD(YEAR ,  -5 ,  CURRENT_TIMESTAMP))  

        )  

        ORDER  BY  [Date]  ASC;  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (DELETE)  

										DEBUT  

************************************************************************************************/  

  

        --  Insert  empty  ROW  into  the  AUDIT  Table  for  deleted  records  

        EXEC  @IdentityAuditId  =  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  0  

                                                                                                                                                                       ,  @Database  

                                                                                                                                                                       ,  'F_PurchaseOrderLine'  

                                                                                                                                                                       ,  'D'  

                                                                                                                                                                       ,  'F'  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  'N'  

        delete  from  dbo.F_PurchaseOrderLine  

  

        --  SET  THE  VARIABLE  WITH  THE  ROW  COUNT  OF  THE  DELETE  

        SElECT  @RowCountAffected  =  @@ROWCOUNT  

  

        --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED  

        EXEC  @IdentityAuditId  =  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  @IdentityAuditId  

                                                                                                                                                                       ,  @Database  

                                                                                                                                                                       ,  'F_PurchaseOrderLine'  

                                                                                                                                                                       ,  'D'  

                                                                                                                                                                       ,  'S'  

                                                                                                                                                                       ,  @RowCountAffected  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  'Y'  

        --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (DELETE)  

										FIN  

************************************************************************************************/  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (INSERT)  

										DEBUT  

************************************************************************************************/  

  

        --  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records  

        EXEC  @IdentityAuditId  =  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  0  

                                                                                                                                                                       ,  @Database  

                                                                                                                                                                       ,  'F_PurchaseOrderLine'  

                                                                                                                                                                       ,  'I'  

                                                                                                                                                                       ,  'F'  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  'N'  

        INSERT  INTO  [dbo].[F_PurchaseOrderLine]  

        (  

                [AccountNumber]  

             ,  [AmountOpen]  

             ,  [Branch]  

             ,  [BuyerNumber]  

             ,  [CarrierCode]  

             ,  [CatalogName]  

             ,  [CompanyCode]  

             ,  [CostCenter]  

             ,  [DescriptionLine1]  

             ,  [DescriptionLine2]  

             ,  [ExchangeRate]  

             ,  [ForeignAmount]  

             ,  [ItemNumber]  

             ,  [LastStatusCode]  

             ,  [LineNumber]  

             ,  [LineTypeCode]  

             ,  [NextStatusCode]  

             ,  [OrderNumber]  

             ,  [OrderType]  

             ,  [OriginalAmount]  

             ,  [CancelDate]  

             ,  [GLDate]  

             ,  [OrderDate]  

             ,  [OriginalPromisDate]  

             ,  [PromiseDate]  

             ,  [ReceptionDate]  

             ,  [RequestedDate]  

             ,  [ProjectNumber]  

             ,  [PurchaseOrderCode01]  

             ,  [QtyOpenQtyReceived]  

             ,  [QuantityOpen]  

             ,  [QuantityOrder]  

             ,  [QuantityReceived]  

             ,  [RelatedCO]  

             ,  [RelatedLine]  

             ,  [RelatedNumber]  

             ,  [RelatedOrderType]  

             ,  [Subledger]  

             ,  [SubledgerType]  

             ,  [SupplierNumber]  

             ,  [TransactionOriginator]  

             ,  [UnitCostPurchasing]  

             ,  [UnitPrice]  

             ,  [UOM]  

             ,  [OrderCO]  

             ,  [Currency]  

             ,  [Shipto]  

             ,  [OriginalAmount_cad]  

             ,  [CatalogPrice]  

             ,  [CatalogPrice_EffectiveDate]  

             ,  [CatalogPrice_ExpiredDate]  

             ,  [Supplierfirstpromiseddate]  

             ,  [RoutingApproval]  

             ,  [BuyerAcronym]  

        )  

        select  F4311.PDANI_AcctNoInputMode                                                                                      as  AccountNumber  

                   ,  F4311.PDAOPN_AmountOpen1                                                                                            as  AmountOpen  

                   ,  F4311.PDMCU_CostCenter                                                                                                as  Branch  

                   ,  F4311.PDANBY_BuyerNumber                                                                                            as  BuyerNumber  

                   ,  F4311.[PDURAB_UserReservedNumber]                                                                          as  CarrierCode  

                   ,  F4311.PDCATN_CatalogName                                                                                            as  CatalogName  

                   ,  F4311.[PDCO_Company]                                                                                                    as  CompanyCode  

                   ,  F4311.PDOMCU_PurchasingCostCenter                                                                          as  CostCenter  

                   ,  F4311.PDDSC1_DescriptionLine1                                                                                  as  DescriptionLine1  

                   ,  F4311.PDDSC2_DescriptionLine2                                                                                  as  DescriptionLine2  

                   ,  F4311.PDCRR_CurrencyConverRateOv                                                                            as  ExchangeRate  

                   ,  F4311.PDFEA_AmountForeignExtPrice                                                                          as  ForeignAmount  

                   ,  F4311.PDITM_IdentifierShortItem                                                                              as  ItemNumber  

                   ,  F4311.PDLTTR_StatusCodeLast                                                                                      as  LastStatusCode  

                   ,  F4311.PDLNID_LineNumber                                                                                              as  LineNumber  

                   ,  F4311.PDLNTY_LineType                                                                                                  as  LineTypeCode  

                   ,  F4311.PDNXTR_StatusCodeNext                                                                                  as  NextStatusCode  

                   ,  F4311.PDDOCO_DocumentOrderInvoiceE                                                                        as  OrderNumber  

                   ,  F4311.PDDCTO_OrderType                                                                                                as  OrderType  

                   ,  F4311.PDAEXP_AmountExtendedPrice                                                                            as  OriginalAmount  

                   ,  F4311.PDCNDJ_CancelDate                                                                                              as  CancelDate  

                   ,  F4311.PDDGL_DtForGLAndVouch1                                                                                    as  GLDate  

                   ,  F4311.PDTRDJ_DateTransactionJulian                                                                        as  OrderDate  

                   ,  F4311.PDOPDJ_DateOriginalPromisde                                                                          as  OriginalPromisDate  

                   ,  F4311.PDPDDJ_ScheduledPickDate                                                                                as  PromiseDate  

                   ,  CARDEX.ILTRDJ_DateTransactionJulian                                                                      as  ReceptionDate  

                   ,  F4311.PDDRQJ_DateRequestedJulian                                                                            as  RequestedDate  

                   ,  F4311.PDPRJM_ProjectNumber                                                                                        as  ProjectNumber  

                   ,  F4301.PHPOHC01_PurchaseOrderCode01                                                                        as  PurchaseOrderCode01  

                   ,  PDUORG_UnitsTransactionQty                                                                                        as  QtyOpenQtyReceived  

                   ,  F4311.PDUOPN_UnitsOpenQuantity                                                                                as  QuantityOpen  

                   ,  F4311.PDPQOR_UnitsPrimaryQtyOrder                                                                          as  QuantityOrder  

                   ,  CARDEX.ILTRQT_QuantityTransaction                                                                          as  QuantityReceived  

                   ,  F4311.PDRKCO_CompanyKeyRelated                                                                                as  RelatedCO  

                   ,  F4311.PDRLLN_RelatedPoSoLineNo                                                                                as  RelatedLine  

                   ,  F4311.PDRORN_RelatedPoSoNumber                                                                                as  RelatedNumber  

                   ,  F4311.PDRCTO_RelatedOrderType                                                                                  as  RelatedOrderType  

                   ,  F4311.PDSBL_Subledger                                                                                                  as  Subledger  

                   ,  F4311.PDSBLT_SubledgerType                                                                                        as  SubledgerType  

                   ,  F4311.PDAN8_AddressNumber                                                                                          as  SupplierNumber  

                   ,  F4311.PDTORG_TransactionOriginator                                                                        as  TransactionOriginator  

                   ,  F4311.PDAMC3_UnitCostPurchasing                                                                              as  UnitCostPurchasing  

                   ,  F4311.PDPRRC_PurchasingUnitPrice                                                                            as  UnitPrice  

                   ,  F4311.PDUOM_UnitOfMeasureAsInput                                                                            as  UOM  

                   ,  F4311.PDKCOO_CompanyKeyOrderNo                                                                                as  OrderCO  

                   ,  F4311.PDCRCD_CurrencyCodeFrom                                                                                  as  Currency  

                   ,  F4311.[PDSHAN_AddressNumberShipTo]                                                                        as  Shipto  

                   ,  F4311.PDAEXP_AmountExtendedPrice  *  ccd_cad.[transaction_Mutiplicator]  AS  [OriginalAmount_cad]  

                   ,  F41061.CatalogPrice  

                   ,  F41061.CBEFTJ_DateEffectiveJulian1  

                   ,  F41061.CBEXDJ_DateExpiredJulian1  

                   ,  F43199.OLPDDJ_ScheduledPickDate  

                   ,  F4311.PDARTG_RoutingApproval                                                                                    AS  RoutingApproval  

                   ,  V0101.ABALKY_AlternateAddressKey                                                                            AS  BuyerAcronym  

        from  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4311]                                                  F4311  

                LEFT  JOIN  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4301]                                F4301  

                        ON  F4311.PDDOCO_DocumentOrderInvoiceE  =  F4301.PHDOCO_DocumentOrderInvoiceE  

                              AND  F4311.PDKCOO_CompanyKeyOrderNo  =  F4301.PHKCOO_CompanyKeyOrderNo  

                              AND  F4311.PDDCTO_OrderType  =  F4301.PHDCTO_OrderType  

                LEFT  JOIN  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4111]                                CARDEX  

                        ON  F4311.PDDOCO_DocumentOrderInvoiceE  =  CARDEX.ILDOCO_DocumentOrderInvoiceE  

                              AND  F4311.PDDCTO_OrderType  =  CARDEX.ILDCTO_OrderType  

                              AND  F4311.PDKCOO_CompanyKeyOrderNo  =  CARDEX.ILKCOO_CompanyKeyOrderNo  

                              AND  F4311.PDLNID_LineNumber  =  CARDEX.ILLNID_LineNumber  

                              AND  F4311.PDAN8_AddressNumber  =  CARDEX.ILAN8_AddressNumber  

                LEFT  JOIN  [RDL00001_EnterpriseDataStaging].[dbo].[d_Currency_Conversion_by_date]  ccd_cad  

                        ON  F4311.PDTRDJ_DateTransactionJulian  =  ccd_cad.Date_cd  

                              and  F4311.PDCRCD_CurrencyCodeFrom  =  ccd_cad.From_Currency  

                              and  ccd_cad.[To_Currency]  =  'CAD'  

                LEFT  JOIN  

                (  

                        SELECT  CBAN8_AddressNumber  

                                   ,  CBITM_IdentifierShortItem  

                                   ,  CBPRRC_PurchasingUnitPrice  AS  CatalogPrice  

                                   ,  CBCRCD_CurrencyCodeFrom  

                                   ,  CBEFTJ_DateEffectiveJulian1  

                                   ,  CBEXDJ_DateExpiredJulian1  

                                   ,  CBCATN_CatalogName  

                        FROM  

                        (  

                                SELECT  CBAN8_AddressNumber  

                                           ,  CBITM_IdentifierShortItem  

                                           ,  CBCATN_CatalogName  

                                           ,  CBPRRC_PurchasingUnitPrice  

                                           ,  CBEFTJ_DateEffectiveJulian1  

                                           ,  CBEXDJ_DateExpiredJulian1  

                                           ,  CBCRCD_CurrencyCodeFrom  

                                           ,  ROW_NUMBER()  OVER  (PARTITION  BY  CBAN8_AddressNumber  

                                                                                                           ,  CBITM_IdentifierShortItem  

                                                                                                           ,  CBCATN_CatalogName  

                                                                                    ORDER  BY  CBEFTJ_DateEffectiveJulian1  DESC  

                                                                                  )  AS  rn  

                                FROM  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F41061]  

                        )  AS  ranked  

                        WHERE  rn  =  1  

                )                                                                                                                                                                F41061  

                        ON  F4311.PDAN8_AddressNumber  =  F41061.CBAN8_AddressNumber  

                              AND  F4311.PDITM_IdentifierShortItem  =  F41061.CBITM_IdentifierShortItem  

                              AND  F4311.PDCATN_CatalogName  =  F41061.CBCATN_CatalogName  

                              AND  F4311.PDTRDJ_DateTransactionJulian  

                              BETWEEN  F41061.CBEFTJ_DateEffectiveJulian1  AND  F41061.CBEXDJ_DateExpiredJulian1  

                LEFT  JOIN  

                (  

                        SELECT  MIN([OLPDDJ_ScheduledPickDate])  [OLPDDJ_ScheduledPickDate]  -- ,[OLUPMJ_DateUpdated]  

                                   ,  [OLDOCO_DocumentOrderInvoiceE]  

                                   ,  [OLDCTO_OrderType]  

                                   ,  [OLKCOO_CompanyKeyOrderNo]  

                                   ,  [OLLNID_LineNumber]  

                        FROM  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F43199]  

                        GROUP  BY  [OLDOCO_DocumentOrderInvoiceE]  

                                       ,  [OLDCTO_OrderType]  

                                       ,  [OLKCOO_CompanyKeyOrderNo]  

                                       ,  [OLLNID_LineNumber]  

                )                                                                                                                                                                F43199  

                        ON  F4311.[PDDOCO_DocumentOrderInvoiceE]  =  F43199.[OLDOCO_DocumentOrderInvoiceE]  

                              AND  F4311.[PDDCTO_OrderType]  =  F43199.[OLDCTO_OrderType]  

                              AND  F4311.[PDKCOO_CompanyKeyOrderNo]  =  F43199.[OLKCOO_CompanyKeyOrderNo]  

                              AND  F4311.[PDLNID_LineNumber]  =  F43199.[OLLNID_LineNumber]  

                LEFT  JOIN  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_V0101]                                V0101  

                        ON  F4311.PDANBY_BuyerNumber  =  V0101.[ABAN8_AddressNumber]  

        WHERE  F4311.PDKCOO_CompanyKeyOrderNo  IN  (  '00001' ,  '00077' ,  '09011' ,  '09052' ,  '09041' ,  '00024'  )  

                    AND  F4311.PDLNTY_LineType  in  (  'S' ,  'J' ,  'N' ,  'F' ,  'XX' ,  'ZZ' ,  'ND' ,  'SC' ,  'D'  )  

                    AND  F4311.PDDCTO_OrderType  in  (  'OP' ,  'ON'  )  

                    AND  F4311.PDTORG_TransactionOriginator  not  in  (  'NEXONIAUPD'  )  

                    AND  F4311.PDTRDJ_DateTransactionJulian  >=  @BeginDate;  

  

        --  SET  THE  VARIABLE  WITH  THE  ROW  COUNT  OF  THE  DELETE  

        SElECT  @RowCountAffected  =  @@ROWCOUNT  

  

        --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED  

        EXEC  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  @IdentityAuditId  

                                                                                                                                 ,  @Database  

                                                                                                                                 ,  'F_PurchaseOrderLine'  

                                                                                                                                 ,  'I'  

                                                                                                                                 ,  'S'  

                                                                                                                                 ,  @RowCountAffected  

                                                                                                                                 ,  0  

                                                                                                                                 ,  0  

                                                                                                                                 ,  'Y'  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (INSERT)  

										FIN  

************************************************************************************************/  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  StandardPastYears  

										DEBUT  

************************************************************************************************/  

  

        --  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records  

        EXEC  @IdentityAuditId  =  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  0  

                                                                                                                                                                       ,  @Database  

                                                                                                                                                                       ,  'F_PurchaseOrderLine'  

                                                                                                                                                                       ,  'U'  

                                                                                                                                                                       ,  'F'  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  'N';  

        DROP  TABLE  IF  EXISTS  #StandardPastYears  

        SELECT  [DRDL02_Description01002_new]  

                   ,  [COMCU_CostCenter]  

                   ,  [COITM_IdentifierShortItem]  

                   ,  [COUNCS_AmountUnitCost]  

        INTO  #StandardPastYears  

        FROM  [RDL00001_EnterpriseDataStaging].[dbo].[F_ProductCost_Purchase]  

        WHERE  [Cost_Type]  =  'StandardPastYears'  

        UPDATE  A  

        SET  [StandardCost]  =  Std.COUNCS_AmountUnitCost  

        FROM  [RDL00001_EnterpriseDataStaging].[dbo].[F_PurchaseOrderLine]  A  

                LEFT  JOIN  [RDL00001_EnterpriseDataStaging].[Shared].[DimDate]  B  

                        ON  A.OrderDate  =  B.[Date]  

                LEFT  JOIN  #StandardPastYears                                                                    as  Std  

                        ON  B.[FiscalYear]  =  Std.DRDL02_Description01002_new  

                              and  A.Branch  =  Std.COMCU_CostCenter  

                              and  A.ItemNumber  =  Std.COITM_IdentifierShortItem  

        WHERE  Std.COITM_IdentifierShortItem  IS  NOT  NULL;  

        SElECT  @RowCountAffected  =  @@ROWCOUNT  

  

        --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED  

        EXEC  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  @IdentityAuditId  

                                                                                                                                 ,  @Database  

                                                                                                                                 ,  'F_PurchaseOrderLine'  

                                                                                                                                 ,  'U'  

                                                                                                                                 ,  'S'  

                                                                                                                                 ,  @RowCountAffected  

                                                                                                                                 ,  0  

                                                                                                                                 ,  0  

                                                                                                                                 ,  'Y'  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  StandardPastYears  

										FIN  

************************************************************************************************/  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  Last  In  

										DEBUT  

************************************************************************************************/  

  

        --  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records  

        EXEC  @IdentityAuditId  =  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  0  

                                                                                                                                                                       ,  @Database  

                                                                                                                                                                       ,  'F_PurchaseOrderLine'  

                                                                                                                                                                       ,  'U'  

                                                                                                                                                                       ,  'F'  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  'N';  

        DROP  TABLE  IF  EXISTS  #LastIn  

        SELECT  [DRDL02_Description01002_new]  

                   ,  [COMCU_CostCenter]  

                   ,  [COITM_IdentifierShortItem]  

                   ,  [COUNCS_AmountUnitCost]  

                   ,  [valid_from]  

                   ,  [valid_to]  

        INTO  #LastIn  

        FROM  [RDL00001_EnterpriseDataStaging].[dbo].[F_ProductCost_Purchase]  

        WHERE  [Cost_Type]  =  'Last  In'  

        UPDATE  A  

        SET  [LastInCost]  =  LastIn.COUNCS_AmountUnitCost  

        FROM  [RDL00001_EnterpriseDataStaging].[dbo].[F_PurchaseOrderLine]  A  

                LEFT  JOIN  #LastIn                                                                                          as  LastIn  

                        ON  A.Branch  =  LastIn.COMCU_CostCenter  

                              AND  A.ItemNumber  =  LastIn.COITM_IdentifierShortItem  

                              AND  A.OrderDate  

                              Between  LastIn.valid_from  and  LastIn.valid_to  

        WHERE  LastIn.COITM_IdentifierShortItem  IS  NOT  NULL  

        SElECT  @RowCountAffected  =  @@ROWCOUNT  

  

        --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED  

        EXEC  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  @IdentityAuditId  

                                                                                                                                 ,  @Database  

                                                                                                                                 ,  'F_PurchaseOrderLine'  

                                                                                                                                 ,  'U'  

                                                                                                                                 ,  'S'  

                                                                                                                                 ,  @RowCountAffected  

                                                                                                                                 ,  0  

                                                                                                                                 ,  0  

                                                                                                                                 ,  'Y'  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  Last  In  

										FIN  

************************************************************************************************/  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  Last  In  Primary  Vendor  

										DEBUT  

************************************************************************************************/  

  

        --  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records  

        EXEC  @IdentityAuditId  =  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  0  

                                                                                                                                                                       ,  @Database  

                                                                                                                                                                       ,  'F_PurchaseOrderLine'  

                                                                                                                                                                       ,  'U'  

                                                                                                                 ,  'F'  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  'N';  

        DROP  TABLE  IF  EXISTS  #LastInPrimaryVendor  

        SELECT  [DRDL02_Description01002_new]  

                   ,  [COMCU_CostCenter]  

                   ,  [COITM_IdentifierShortItem]  

                   ,  [COUNCS_AmountUnitCost]  

                   ,  [valid_from]  

                   ,  [valid_to]  

        INTO  #LastInPrimaryVendor  

        FROM  [RDL00001_EnterpriseDataStaging].[dbo].[F_ProductCost_Purchase]  

        WHERE  [Cost_Type]  =  'Last  In  Primary  Vendor'  

        UPDATE  A  

        SET  [LastInPrimaryVendorCost]  =  LastInPV.COUNCS_AmountUnitCost  

        FROM  [RDL00001_EnterpriseDataStaging].[dbo].[F_PurchaseOrderLine]  A  

                LEFT  JOIN  #LastInPrimaryVendor                                                                as  LastInPV  

                        ON  A.Branch  =  LastInPV.COMCU_CostCenter  

                              AND  A.ItemNumber  =  LastInPV.COITM_IdentifierShortItem  

                              AND  A.OrderDate  

                              Between  LastInPV.valid_from  and  LastInPV.valid_to  

        WHERE  LastInPV.COITM_IdentifierShortItem  IS  NOT  NULL  

        SElECT  @RowCountAffected  =  @@ROWCOUNT  

  

        --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED  

        EXEC  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  @IdentityAuditId  

                                                                                                                                 ,  @Database  

                                                                                                                                 ,  'F_PurchaseOrderLine'  

                                                                                                                                 ,  'U'  

                                                                                                                                 ,  'S'  

                                                                                                                                 ,  @RowCountAffected  

                                                                                                                                 ,  0  

                                                                                                                                 ,  0  

                                                                                                                                 ,  'Y'  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  Last  In  Primary  Vendor  

										FIN  

************************************************************************************************/  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  Standard  

										DEBUT  

************************************************************************************************/  

  

        --  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records  

        EXEC  @IdentityAuditId  =  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  0  

                                                                                                                                                                       ,  @Database  

                                                                                                                                                                       ,  'F_PurchaseOrderLine'  

                                                                                                                                                                       ,  'U'  

                                                                                                                                                                       ,  'F'  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  'N';  

        DROP  TABLE  IF  EXISTS  #StdCurrent  

        SELECT  [DRDL02_Description01002_new]  

                   ,  [COMCU_CostCenter]  

                   ,  [COITM_IdentifierShortItem]  

                   ,  [COUNCS_AmountUnitCost]  

                   ,  [valid_from]  

                   ,  [valid_to]  

        INTO  #StdCurrent  

        FROM  [RDL00001_EnterpriseDataStaging].[dbo].[F_ProductCost_Purchase]  

        WHERE  [Cost_Type]  =  'Standard'  

        UPDATE  A  

        SET  [StandardCost]  =  Std.COUNCS_AmountUnitCost  

        FROM  [RDL00001_EnterpriseDataStaging].[dbo].[F_PurchaseOrderLine]  A  

                LEFT  JOIN  #StdCurrent                                                                                  as  Std  

                        ON  A.Branch  =  Std.COMCU_CostCenter  

                              AND  A.ItemNumber  =  Std.COITM_IdentifierShortItem  

                              AND  A.OrderDate  

                              Between  Std.valid_from  and  Std.valid_to  

        WHERE  Std.COITM_IdentifierShortItem  IS  NOT  NULL  

        SElECT  @RowCountAffected  =  @@ROWCOUNT  

  

        --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED  

        EXEC  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  @IdentityAuditId  

                                                                                                                                 ,  @Database  

                                                                                                                                 ,  'F_PurchaseOrderLine'  

                                                                                                                                 ,  'U'  

                                                                                                                                 ,  'S'  

                                                                                                                                 ,  @RowCountAffected  

                                                                                                                                 ,  0  

                                                                                                                                 ,  0  

                                                                                                                                 ,  'Y'  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  Standard  

										FIN  

************************************************************************************************/  

  

        /***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  Last  In  Past  Years  

										DEBUT  

************************************************************************************************/  

  

        --  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records  

        EXEC  @IdentityAuditId  =  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  0  

                                                                                                                                                                       ,  @Database  

                                                                                                                                                                       ,  'F_PurchaseOrderLine'  

                                                                                                                                                                       ,  'U'  

                                                                                                                                                                       ,  'F'  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  0  

                                                                                                                                                                       ,  'N';  

        DROP  TABLE  IF  EXISTS  #LastInPastYears  

        SELECT  [DRDL02_Description01002_new]  

                   ,  [COMCU_CostCenter]  

                   ,  [COITM_IdentifierShortItem]  

                   ,  [COUNCS_AmountUnitCost]  

        INTO  #LastInPastYears  

        FROM  [RDL00001_EnterpriseDataStaging].[dbo].[F_ProductCost_Purchase]  

        WHERE  [Cost_Type]  =  'StandardPastYears'  

        UPDATE  A  

        SET  [LastInCost]  =  A.UnitPrice  

        FROM  [RDL00001_EnterpriseDataStaging].[dbo].[F_PurchaseOrderLine]  A  

                LEFT  JOIN  [RDL00001_EnterpriseDataStaging].[Shared].[DimDate]  B  

                        ON  A.OrderDate  =  B.[Date]  

                LEFT  JOIN  #LastInPastYears                                                                        as  Std  

                        ON  B.[FiscalYear]  =  Std.DRDL02_Description01002_new  

                              and  A.Branch  =  Std.COMCU_CostCenter  

                              and  A.ItemNumber  =  Std.COITM_IdentifierShortItem  

        WHERE  Std.COITM_IdentifierShortItem  IS  NOT  NULL  

        SElECT  @RowCountAffected  =  @@ROWCOUNT  

  

        --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED  

        EXEC  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  @IdentityAuditId  

                                                                                                                                 ,  @Database  

                                                                                                                                 ,  'F_PurchaseOrderLine'  

                                                                                                                                 ,  'U'  

                                                                                                                                 ,  'S'  

                                                                                                                                 ,  @RowCountAffected  

                                                                                                                                 ,  0  

                                                                                                                                 ,  0  

                                                                                                                                 ,  'Y'  

  

/***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  Last  In  Past  Years  

										FIN  

************************************************************************************************/  

  

/***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  Catalog  

										DEBUT  

************************************************************************************************/  

  

--  Insert  empty  ROW  into  the  AUDIT  Table  for  inserted  records  

--EXEC  @IdentityAuditId  =  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  0  

--                                                                                                                                                               ,  @Database  

--                                                                                                                                                               ,  'F_PurchaseOrderLine'  

--                                                                                                                                                               ,  'U'  

--                                                                                                                                                               ,  'F'  

--                                                                                                                                                               ,  0  

--                                                                                                                                                               ,  0  

--                                                                                                                                                               ,  0  

--                                                                                                                                                               ,  'N'  

--Update  A  

--SET  [CatalogPrice]  =  catalogs.[CBPRRC_PurchasingUnitPrice]  

--FROM  [RDL00001_EnterpriseDataStaging].[dbo].[F_PurchaseOrderLine]  A  

--        --LEFT  OUTER  JOIN  [RDL00001_EnterpriseDataStaging].[Shared].[DimDate]  B  ON  A.OrderDate  =  B.[Date]  

--        LEFT  OUTER  JOIN  

--        (  

--                SELECT  [CBITM_IdentifierShortItem]  

--                           ,  MAX([CBPRRC_PurchasingUnitPrice])  [CBPRRC_PurchasingUnitPrice]  

--                FROM  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F41061]  

--                group  by  [CBITM_IdentifierShortItem]  

--        )                                                                                                                          as  catalogs  

--                ON  A.ItemNumber  =  catalogs.[CBITM_IdentifierShortItem]  

--SElECT  @RowCountAffected  =  @@ROWCOUNT  

  

----  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED  

--EXEC  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  @IdentityAuditId  

--                                                                                                                         ,  @Database  

--                                                                                                                         ,  'F_PurchaseOrderLine'  

--                                                                                                                         ,  'U'  

--                                                                                                                         ,  'S'  

--                                                                                                                         ,  @RowCountAffected  

--                                                                                                                         ,  0  

--                                                                                                                         ,  0  

--                                                                                                                         ,  'Y'  

  

/***********************************************************************************************  

								REQUETE  PRINCIPALE  (UPDATE)  Catalog  

										FIN  

************************************************************************************************/  

END
