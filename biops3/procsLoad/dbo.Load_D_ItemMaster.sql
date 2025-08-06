  

  

  

  

  

  

  

--  =============================================  

--  Author:		<Author , ,Name>  

--  Create  date:  <Create  Date , ,>  

--  Description:	EXEC  [dbo].[Load_d_ItemMaster]    

--  =============================================  

CREATE  PROCEDURE  [dbo].[Load_d_ItemMaster]    

AS  

BEGIN  

	SET  NOCOUNT  ON;  

  --*******************************************************************************************************************************  

        --                                                                                                                DECLARING  VARIABLES  

    --*******************************************************************************************************************************      

      

    

    Merge  [dbo].[d_ItemMaster]    t  

    using    

  

    (    

  

    select    

IMITM_IdentifierShortItem  as  ItemNumber   ,  

Trim  (IMDSC1_DescriptionLine1)  as  ItemDesc ,  

Trim  (IMDSC2_DescriptionLine2)  as  ItemDesc2 ,  

Trim  (  IMSRTX_SearchText)  as  SearchType ,  

Trim  (  IMDRAW_DrawingNumber)  as  DrawingNumber ,  

Trim  (IMRVNO_RevisionNumber)  as  RevisionNumber ,  

Trim  (IMSTKT_StockingType)  as  StockingType ,  

  Trim  (IMPRP4_PurchasingReportCode4)  as  MasterPlanningFamilyCd ,  

  Trim  (T2.DRDL01)  as  MasterPlanningFamilyDesc ,  

  Trim  (IMPRP1_PurchasingReportCode1)  as  CommodityClassCd ,  

  Trim  (T3.DRDL01)    as  CommodityClassDesc ,  

  TRIM  (T1.IMPRP2_PurchasingReportCode2)  as  CommoditySubClassCd ,  

    Trim  (T4.DRDL01)  as  CommoditySubClassDesc ,  

  TRIM  (  IMLITM_Identifier2ndItem)  as  SecondItem ,  

    T1.IMAITM_Identifier3rdItem  as  ThirdItemNumber ,  

    T1.IMCOORE_CountryOfOriginRequired  as  CountryOfOriginRequired ,  

    T1.IMUOM1_UnitOfMeasurePrimary  as  UnitOfMesure ,  

      T1.[IMBPFG_BulkPackedFlag]  as  BulkPackedFlag ,  

    T1.[IMBUYR_Buyer]  as  BuyerNumber ,  

    T1.[IMUPMJ_DateUpdated]  as  DateUpdated ,  

    T1.[IMGLPT_GlCategory]  as  GLclass ,  

    T1.[IMIFLA_ItemFlashMessage]  as  ItemFlashMessage ,  

    T1.[IMLNTY_LineType]  as  LineType ,  

    T1.[IMOPC_OrderPolicyCode]  as  OrderPolicyCode ,  

    T1.[IMOPV_OrderPolicyValue]  as  OrderPolicyValue ,  

    T1.[IMPRP1_PurchasingReportCode1]  as  PurchasingCode1 ,  

    T1.[IMPRP2_PurchasingReportCode2]  as  PurchasingCode2 ,  

    T1.[IMPRP3_PurchasingReportCode3]  as  PurchasingCode3 ,  

    T1.[IMUSER_UserId]  as  UserId ,  

    ISD.IIHSCD_HarmonizedShippingCode  as  HarmonizedShippingCode  

  

  from  [RDL00001_EnterpriseDataLanding].jde.F4101_V2  T1  

  

left  join    [RDL00001_EnterpriseDataLanding].jde.F0005  T2  

  

on  TRIM  (T1.IMPRP4_PurchasingReportCode4)  =  TRIM  (T2.DRKY)  

  

and  Trim  (T2.DRSY)='41'  

  

and  Trim  (T2.DRRT)='P4'  

  

  

left  join    [RDL00001_EnterpriseDataLanding].jde.F0005  T3  

  

on    Trim(T1.IMPRP1_PurchasingReportCode1)  =  TRIM  (T3.DRKY)  

  

and  Trim  (T3.DRSY)='41'  

  

and  Trim  (T3.DRRT)='P1'  

  

left  join    [RDL00001_EnterpriseDataLanding].jde.F0005  T4  

  

on    Trim(T1.IMPRP2_PurchasingReportCode2)  =  TRIM  (T4.DRKY)  

  

and  Trim  (T4.DRSY)='41'  

  

and  Trim  (T4.DRRT)='P2'  

  

LEFT  JOIN  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4908]  AS  ISD  

                                ON  T1.IMITM_IdentifierShortItem  =  ISD.IIITM_IdentifierShortItem  

              )    as  s  

  

	      on  t.ItemNumber=s.ItemNumber  

          

    ---Insert  new  Status  when  not  matched  

  

      WHEN  NOT  MATCHED  BY  TARGET  

      

        THEN    

      INSERT  (    

      [ItemNumber]  

             ,[ItemDesc]  

             ,[ItemDesc2]  

             ,[SearchType]  

             ,[DrawingNumber]  

             ,[RevisionNumber]  

             ,[StockingType]  

             ,[MasterPlanningFamilyCd]  

             ,[MasterPlanningFamilyDesc]  

             ,[CommodityClassCd]  

             ,[CommodityClassDesc]  

             ,[CommoditySubClassCd]  

             ,[CommoditySubClassDesc]  

	     ,  [SecondItem]  

	     ,[ThirdItemNumber]  

	     ,[CountryOfOriginRequired]  

	     ,[UnitOfMesure]  

	     ,[BulkPackedFlag]  

             ,[BuyerNumber]  

             ,[DateUpdated]  

             ,[GLclass]  

             ,[ItemFlashMessage]  

             ,[LineType]  

             ,[OrderPolicyCode]  

             ,[OrderPolicyValue]  

             ,[PurchasingCode1]  

             ,[PurchasingCode2]  

             ,[PurchasingCode3]  

             ,[UserId]  

             ,[HarmonizedShippingCode]  

  

                      )  

  

Values  (s.[ItemNumber]  

             ,s.[ItemDesc]  

             ,s.[ItemDesc2]  

             ,s.[SearchType]  

             ,s.[DrawingNumber]  

             ,s.[RevisionNumber]  

             ,s.[StockingType]  

             ,s.[MasterPlanningFamilyCd]  

             ,s.[MasterPlanningFamilyDesc]  

             ,s.[CommodityClassCd]  

             ,s.[CommodityClassDesc]  

             ,s.[CommoditySubClassCd]  

             ,s.[CommoditySubClassDesc]  

	     ,  s.[SecondItem]  

	     ,s.[ThirdItemNumber]  

	     ,s.[CountryOfOriginRequired]  

	     ,s.[UnitOfMesure]  

	     ,s.[BulkPackedFlag]  

             ,s.[BuyerNumber]  

             ,s.[DateUpdated]  

             ,s.[GLclass]  

             ,s.[ItemFlashMessage]  

             ,s.[LineType]  

             ,s.[OrderPolicyCode]  

             ,s.[OrderPolicyValue]  

             ,s.[PurchasingCode1]  

             ,s.[PurchasingCode2]  

             ,s.[PurchasingCode3]  

             ,s.[UserId]  

             ,s.[HarmonizedShippingCode]  

  

  

		    )  

  

----update  status  when  matched  

  

		    	    WHEN  MATCHED  THEN    

    UPDATE  SET  

              t.[SecondItem]=s.[SecondItem]  

               ,t.[ItemDesc]=s.[ItemDesc]  

             ,t.[ItemDesc2]=s.[ItemDesc2]  

             ,t.[SearchType]=s.[SearchType]  

             ,t.[DrawingNumber]=s.[DrawingNumber]  

             ,t.[RevisionNumber]=s.[RevisionNumber]  

             ,t.[StockingType]=s.[StockingType]  

             ,t.[MasterPlanningFamilyCd]=s.[MasterPlanningFamilyCd]  

             ,t.[MasterPlanningFamilyDesc]=s.[MasterPlanningFamilyDesc]  

             ,t.[CommodityClassCd]=s.[CommodityClassCd]  

             ,t.[CommodityClassDesc]=s.[CommodityClassDesc]  

             ,t.[CommoditySubClassCd]=s.[CommoditySubClassCd]  

             ,t.[CommoditySubClassDesc]=s.[CommoditySubClassDesc]  

	     ,t.[ThirdItemNumber]=s.[ThirdItemNumber]  

	     ,t.[CountryOfOriginRequired]=s.[CountryOfOriginRequired]  

	     ,t.[UnitOfMesure]=s.[UnitOfMesure]  

	     ,t.[BulkPackedFlag]=s.[BulkPackedFlag]  

             ,t.[BuyerNumber]=s.[BuyerNumber]  

             ,t.[DateUpdated]=s.[DateUpdated]  

             ,t.[GLclass]=s.[GLclass]  

             ,t.[ItemFlashMessage]=s.[ItemFlashMessage]  

             ,t.[LineType]=s.[LineType]  

             ,t.[OrderPolicyCode]=s.[OrderPolicyCode]  

             ,t.[OrderPolicyValue]=s.[OrderPolicyValue]  

             ,t.[PurchasingCode1]=s.[PurchasingCode1]  

             ,t.[PurchasingCode2]=s.[PurchasingCode2]  

             ,t.[PurchasingCode3]=s.[PurchasingCode3]  

             ,t.[UserId]=s.[UserId]  

             ,t.[HarmonizedShippingCode]=s.[HarmonizedShippingCode]  

	      

  

  

  

	      WHEN  NOT  MATCHED  BY  Source  

	    Then  delete  

	    ;  

  

  

  

    

END  

  

  

  

  

  

  

  

  

