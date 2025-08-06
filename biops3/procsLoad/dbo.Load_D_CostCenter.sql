  

  

  

  

  

  

  

--  =============================================  

--  Author:		<Author , ,SAMN>  

--  Create  date:  <Create  Date , ,>  

--  Description:	EXEC  [dbo].[Load_d_CostCenter]    

--  =============================================  

CREATE  PROCEDURE  [dbo].[Load_d_CostCenter]    

AS  

BEGIN  

	SET  NOCOUNT  ON;  

  --*******************************************************************************************************************************  

        --                                                                                                                DECLARING  VARIABLES  

    --*******************************************************************************************************************************      

      IF  OBJECT_ID('tempdb..##TMP_F0006_V2')  is  not  null  DROP  TABLE  ##TMP_F0006_V2  

  

	    IF  OBJECT_ID('tempdb..##TMP_F0116')  is  not  null  DROP  TABLE  ##TMP_F0116  

  

	  IF  OBJECT_ID('tempdb..##TMP_F0010')  is  not  null  DROP  TABLE  ##TMP_F0010  

  

	  ---##TMP_F0006_V2  

	  

	select    

	MCMCU_CostCenter   ,  

	MCCO_Company ,  

	MCAN8_AddressNumber ,  

      MCSTYL_CostCenterType  as  CostCenterType ,  

    MCDC_DescripCompressed  as    DescriptionCompressed ,  

    MCRP04_CategoryCodeCostCt004  as  CostCenterCategoryCode ,  

    MCRMCU1_RelatedBusinessUnit  as  RelatedBusinessUnit ,  

    MCDL01_Description001  as  DescriptionCostCenter  

      into  ##TMP_F0006_V2  

	from  [RDL00001_EnterpriseDataLanding].jde.F0006_V2  

  

	where  MCCO_Company  in  (  N'00001'   ,  N'00024'   ,    N'00077'   ,N'09011' ,    N'09052' ,  N'99050' ,  N'00074' ,  N'09041'  )  

	---and    TRIM  (MCMCU_CostCenter)  in  (  '101' ,'112' ,'370' ,'403' ,'118')  

	---##TMP_F0116:  Address  Based  on  maximum  date  

	SELECT  

			ALAN8_AddressNumber   ,    

			ALADDS_State ,  

			Max  (ALEFTB_DateBeginningEffective)  as  LEFTB_DateBeginningEffective   ,  

			ALCTY1_City   ,  

			ALCTR_Country  

			into  ##TMP_F0116  

			FROM  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F0116]  

			WHERE  ALEFTB_DateBeginningEffective<=cast  (GETDATE()  as  date)  

                        GROUP  BY  ALAN8_AddressNumber ,  

			ALADDS_State ,  

			ALCTY1_City ,  

			ALCTR_Country  

  

			--##TMP_F0010  

  

			select    

			CCNAME   ,  

			CCCRCD ,  

			CCCO  

			into  ##TMP_F0010  

			from  [RDL00001_EnterpriseDataLanding].jde.F0010  

  

  

    Truncate  table  [dbo].[D_CostCenter]  ;  

  

    insert  into  [dbo].[D_CostCenter]  

  

  

    (  

  

          

              [CostCenter]  

             ,[CostCenterType]  

             ,[DescriptionCompressed]  

             ,[Company]  

             ,[CostCenterCategoryCode]  

             ,[CostCenterCategory]  

             ,[RelatedBusinessUnit]  

	     ,[DescriptionCostCenter]  

	     ,[Site]  

	     ,CurrencyCode  

	     ,AddressNumber  

  

  

  

  

  

    )  

  

  

  

  

  

  

  

select      

MCMCU_CostCenter  as  CostCenter ,  

MCSTYL_CostCenterType  as  CostCenterType ,  

MCDC_DescripCompressed  as    DescriptionCompressed ,  

MCCO_Company    as  Company   ,  

MCRP04_CategoryCodeCostCt004  as  CostCenterCategoryCode ,  

LTRIM  (  RTRIM  (T2.DRDL01))  AS    CostCenterCategory ,  

MCRMCU1_RelatedBusinessUnit  as  RelatedBusinessUnit ,  

MCDL01_Description001  as  DescriptionCostCenter ,  

T3.ALCTY1_City    as  [Site] ,  

T4.CCCRCD  as  CurrencyCode ,  

T1.MCAN8_AddressNumber  as  AddressNumber  

  

from  [RDL00001_EnterpriseDataLanding].[JDE].[F0006_V2]    T1  

  

  left  join  [RDL00001_EnterpriseDataLanding].JDE.F0005  T2  

  

  on    T1.MCRP04_CategoryCodeCostCt004=LTRIM  (RTRIM  (T2.DRKY))  

  

  and  T2.DRSY  =  '00'    

  

    and    T2.DRRT  =  '04'  

  

left  join  ##TMP_F0116    T3  

on  T1.MCAN8_AddressNumber=T3.ALAN8_AddressNumber  

  

left  join  ##TMP_F0010    T4  

on  T1.MCCO_Company=T4.CCCO  

  

  

  END
