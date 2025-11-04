  

  

  

  

  

  

  

  

--  =============================================  

--  Author:		<Author , ,Name>  

--  Create  date:  <Create  Date , ,>  

--  Description:	EXEC  [dbo].[Load_d_ItemBranch]    

  

--select  *  from  [RDL00001_EnterpriseDataStaging].[dbo].[d_ItemBranch]    

--  =============================================  

CREATE  PROCEDURE  [dbo].[Load_d_ItemBranch]    

AS  

BEGIN  

	SET  NOCOUNT  ON;  

  --*******************************************************************************************************************************  

        --                                                                                                                DECLARING  VARIABLES  

    --*******************************************************************************************************************************      

      

        

          IF  OBJECT_ID('tempdb..##TMP_F0005')  is  not  null  DROP  TABLE  ##TMP_F0005  

  

	    IF  OBJECT_ID('tempdb..##TMP_F4102')  is  not  null  DROP  TABLE  ##TMP_F4102  

---  ##TMP_F4102  

DROP  TABLE  IF  EXISTS  #F00092  

SELECT  LTRIM(RTRIM(CAST(T3MCU_CostCenter  AS  NVARCHAR(50))))  as  MCU  

           ,  TRY_CONVERT(BIGINT ,  T3SBN1_SuppDataNumericKey1)            as  SBA1  

           ,  T3RMK_NameRemark  

           ,  CAST(T3UPDJ_UpdatedDate  AS  DATE)                                          as  UpdatedDate  

           ,  ROW_NUMBER()  OVER  (PARTITION  BY  T3MCU_CostCenter  

                                                                           ,  T3SBN1_SuppDataNumericKey1  

                                                    ORDER  BY  CAST(T3UPDJ_UpdatedDate  AS  DATE)  DESC  

                                                  )                                                                    as  rn  

INTO  #F00092  

FROM  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F00092]  

WHERE  T3TYDT_TypeofData  =  'PC'  

            AND  T3SDB_SupplementalDatabaseCode  =  'IB'  

  

	    select    

	    IBITM_IdentifierShortItem     ,  

	    IBLITM_Identifier2ndItem ,  

	    IBAITM_Identifier3rdItem ,  

	    IBMCU_CostCenter ,  

            IBLTLV_LeadtimeLevel    

           ,  IBGLPT_GlCategory    

         ,  IBSTKT_StockingType    

         ,IBLNTY_LineType    

         ,IBITC_IssueTypeCode    

	     ,  IBPRP1_PurchasingReportCode1  

       ,  IBPRP2_PurchasingReportCode2  

       ,IBPRP3_PurchasingReportCode3    

       ,IBORIG_CountryOfOrigin  

             ,  IBROPI_ReorderPointInput  

       ,    IBROQI_ReorderQuantityInput  

       ,    IBRQMX_ReorderQuantityMaximum      

       ,    IBRQMN_ReorderQuantityMinimum    

       ,    IBWOMO_OrderMultiples    

       ,    IBPRP4_PurchasingReportCode4  

       ,    IBBUYR_Buyer  

       ,IBABCS_AbcCode1SalesInv  

       ,IBUPMJ_DateUpdated  as  DateModification  

       ,IBVEND_PrimaryLastVendorNo  

       ,T3RMK_NameRemark  

	    into  ##TMP_F4102  

	    from  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4102]  IB  

	      left  join  #F00092                                                                                F00092  

                ON  F00092.rn  =  1  

                      AND  TRIM(IB.IBMCU_CostCenter)  =  F00092.MCU  

                      AND  TRY_CONVERT(BIGINT ,  IB.IBITM_IdentifierShortItem)  =  F00092.SBA1  

	    /*T1  

	    inner  join  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F0006]    T2  

  

        on    T1.IBMCU_CostCenter=T2.MCMCU_CostCenter  

  

        ---and  MCCO_Company  in  (  N'00001'   ,  N'00024'   ,    N'00077'   ,N'09011' ,    N'09052' ,  N'99050' ,  N'00074' ,  N'09041'  )*/  

	--and    TRIM  (MCMCU_CostCenter)  in  (  '101' ,'112' ,'370' ,'403' ,'118')*/  

---##TMP_F0005  

  

select    

  DRDL01_Description001     ,  

DRKY_UserDefinedCode   ,  

DRSY_ProductCode   ,  

DRRT_UserDefinedCodes    

into  ##TMP_F0005  

from  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F0005]  

  

  

Truncate  table  [dbo].[d_ItemBranch]  

  

    

      INSERT    into  [dbo].[d_ItemBranch]    (    

      ItemNumber  

 ,SecondItem  

 ,ThirdItemNumber  

 ,CostCenter  

 ,LeadTime  

 ,CatGL  

 ,StockingType  

 ,LineType  

 ,IssueCode  

 ,PRP1Code  

 ,PRP2Code  

 ,PRP3Code  

 ,PRP1Desc  

 ,PRP2Desc  

 ,PRP3Desc  

 ,CountryOfOrigin  

 ,ReOrderInput  

 ,ReOrderQuantityInput  

 ,ReOrderQuantityMaximum  

 ,ReOrderQuantityMinimum  

 ,OrderMultiple  

 ,MasterPlanningFamilyCd  

 ,MasterPlanningFamilyDesc  

 ,BuyerNumber  

 ,ABCCategoryCode  

 ,ConcatBranchShortItem  

 ,ConcatBranchSecondItem  

 ,DateUpdated  

 ,[PreferredSupplier]  

 ,[EngPoolCode])  

  

select    

        IBITM_IdentifierShortItem  as  ItemNumber  

       ,  IBLITM_Identifier2ndItem  as  SecondItem  

       ,  IBAITM_Identifier3rdItem  as  ThirdItemNumber  

       ,IBMCU_CostCenter  as  CostCenter  

       ,  IBLTLV_LeadtimeLevel  as  LeadTime  

       ,  IBGLPT_GlCategory  as  CatGL  

       ,  IBSTKT_StockingType  as  StockingType  

       ,IBLNTY_LineType  as  LineType  

       ,IBITC_IssueTypeCode  as  IssueCode  

       ,IBPRP1_PurchasingReportCode1  as  PRP1Code  

       ,IBPRP2_PurchasingReportCode2  as  PRP2Code  

       ,IBPRP3_PurchasingReportCode3  as  PRP3Code  

       ,T2.DRDL01_Description001  as  PRP1Desc  

       ,T3.DRDL01_Description001  as  PRP2Desc  

       ,T4.DRDL01_Description001  as  PRP3Desc  

       ,IBORIG_CountryOfOrigin  as  CountryOfOrigin  

       ,  IBROPI_ReorderPointInput  as  ReOrderInput  

       ,  IBROQI_ReorderQuantityInput  as  ReOrderQuantityInput  

       ,  IBRQMX_ReorderQuantityMaximum  as    ReOrderQuantityMaximum  

       ,    IBRQMN_ReorderQuantityMinimum  as    ReOrderQuantityMinimum  

       ,  IBWOMO_OrderMultiples    as  OrderMultiple  

       ,  IBPRP4_PurchasingReportCode4  as  MasterPlanningFamilyCd  

       ,  T5.DRDL01_Description001  as  MasterPlanningFamilyDesc  

       ,    IBBUYR_Buyer  as  BuyerNumber  

       ,IBABCS_AbcCode1SalesInv  as  ABCCategoryCode  

       ,CONCAT(IBMCU_CostCenter ,'-' ,IBITM_IdentifierShortItem)  as  ConcatBranchShortItem  

       ,CONCAT(IBMCU_CostCenter ,'-' ,IBLITM_Identifier2ndItem)  as  ConcatBranchSecondItem  

       ,DateModification  

       ,IBVEND_PrimaryLastVendorNo  

       ,T3RMK_NameRemark  

  

  

  from  ##TMP_F4102  T1  

  

left  join    ##TMP_F0005  T2  

  

on  T1.IBPRP1_PurchasingReportCode1  =  T2.DRKY_UserDefinedCode  

  

and    T2.DRSY_ProductCode=N'41'  

  

and  T2.DRRT_UserDefinedCodes=N'P1'  

  

  

left  join    ##TMP_F0005  T3  

  

on    T1.IBPRP2_PurchasingReportCode2  =    T3.DRKY_UserDefinedCode  

  

and  (T3.DRSY_ProductCode)=N'41'  

  

and  (T3.DRRT_UserDefinedCodes)=N'P2'  

  

left  join    ##TMP_F0005  T4  

  

on    T1.IBPRP3_PurchasingReportCode3  =  T4.DRKY_UserDefinedCode  

  

and  T4.DRSY_ProductCode=N'41'  

  

and  T4.DRRT_UserDefinedCodes=N'P3'  

  

left  join    ##TMP_F0005  T5  

  

on    T1.IBPRP4_PurchasingReportCode4  =  T5.DRKY_UserDefinedCode  

  

and  T5.DRSY_ProductCode=N'41'  

  

and  T5.DRRT_UserDefinedCodes=N'P4'  

  

  

  

  

  

    

END  

  

  

  

  

  

  

  

  

