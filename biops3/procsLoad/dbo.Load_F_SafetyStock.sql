  

  

  

  

  

  

  

--  =============================================  

--  Author:		<Author , ,Name>  

--  Create  date:  <Create  Date , ,>  

--  Description:	EXEC  [dbo].[Load_F_SafetyStock]  

  

/*select  *  from  [RDL00001_EnterpriseDataStaging].[dbo].[F_SafetyStock]    

  

where  ItemNumber=119981    and  CostCenter='101'*/  

--  =============================================  

CREATE  PROCEDURE  [dbo].[Load_F_SafetyStock]    

AS  

BEGIN  

	SET  NOCOUNT  ON;  

  --*******************************************************************************************************************************  

        --                                                                                                                DECLARING  VARIABLES  

    --*******************************************************************************************************************************      

      

        

        

  

	    IF  OBJECT_ID('tempdb..##TMP_F4102')  is  not  null  DROP  TABLE  ##TMP_F4102  

  

  

	  

			--##TMP_F41021  

  

			select    

			  T1.IBITM_IdentifierShortItem  

			 ,  T1.IBMCU_CostCenter  

			--   ,  T3.LILOCN_Location  

                          --   ,LILOTN_Lot  

			-- ,    LIPQOH_QtyOnHandPrimaryUn    

			 ,  IBSAFE_SafetyStockDaysSupply  

			 ,  T2.  MCCO_Company  as  MCCO_Company  

			-- ,    T3.  IBVEND_PrimaryLastVendorNo  

			-- ,LIPBIN_PrimaryBinPS  

		  

			into  ##TMP_F4102  

			from  [RDL00001_EnterpriseDataLanding].JDE_BI_OPS.V_F4102  T1  

  

			inner  join    [RDL00001_EnterpriseDataLanding].JDE_BI_OPS.V_F0006  T2  

  

			on  T1.IBMCU_CostCenter  =  T2.MCMCU_CostCenter  

  

				  where      IBGLPT_GlCategory  in  (N'IN10' ,  N'IN20')  

		  

  

		  

  

	---where  MCCO_Company  in  (  N'00001'   ,  N'00024'   ,    N'00077'   ,N'09011' ,    N'09052' ,  N'99050' ,  N'00074' ,  N'09041'  )  

  

	  ---  and    TRIM  (MCMCU_CostCenter)  in  (  '101' ,'112' ,'370' ,'403' ,'118')  

  

	  /*  and    (  LIPQOH_QtyOnHandPrimaryUn  <>0  OR  (  LIPQOH_QtyOnHandPrimaryUn=0  and  T3.LILOCN_Location  not  in  (  '9' ,  '8' ,  '7' ,  '0' ,'1')))  

	OR  (IBSAFE_SafetyStockDaysSupply<>0)*/  

Truncate  table  [dbo].[F_SafetyStock]  

  

INSERT    into  [dbo].[F_SafetyStock]    (    

ItemNumber ,  

CostCenter ,  

--LocationCode ,  

--LotSN ,  

CompanyCode ,  

--QtyOnHand ,  

SafetyStock ,  

--SupplierNumber ,  

--OnHandAmount ,  

SafetyStockAmount  

--MaxStandardCost ,  

--PrimaryBinPS  

)  

  

select    

IBITM_IdentifierShortItem  as    ItemNumber ,  

IBMCU_CostCenter  as  CostCenter ,  

--LILOCN_Location  as  LocationCode ,  

--LILOTN_Lot  as  LotSN ,  

MCCO_Company  as  CompagnyCode ,  

--LIPQOH_QtyOnHandPrimaryUn    as  QtyOnHand ,  

IBSAFE_SafetyStockDaysSupply  as  SafetyStock ,  

--IBVEND_PrimaryLastVendorNo  as  SupplierNumber ,  

--cast  ((LIPQOH_QtyOnHandPrimaryUn  *  T2.MaxUnitCost)  as  numeric  (15 ,4))  as  OnHandAmount ,  

cast  ((IBSAFE_SafetyStockDaysSupply  *  T2.MaxUnitCost)  as  numeric  (15 ,4))  as    SafetyStockAmount  

  

--T2.MaxUnitCost ,  

--LIPBIN_PrimaryBinPS  

  

From    ##TMP_F4102      T1  

left  join    

(  select  max  (MaxUnitCost)  as  MaxUnitCost   ,  

ItemNumber ,  

CostCenter  

  

from  [RDL00001_EnterpriseDataStaging].dbo.F_ProductCost  

where  CostMethod='07'  

group  by  ItemNumber ,  

CostCenter  )  T2  

  

on  T1.IBITM_IdentifierShortItem  =T2.ItemNumber  

  

and  T1.IBMCU_CostCenter=T2.CostCenter  

    

END  

  

  

  

  

  

  

  

  

