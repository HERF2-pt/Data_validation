  

  

  

  

  

  

  

--  =============================================  

--  Author:		<Author , ,Name>  

--  Create  date:  <Create  Date , ,>  

--  Description:	EXEC  [dbo].[Load_d_Supplier]    

  

--select  *  from  [RDL00001_EnterpriseDataStaging].[dbo].[D_Supplier]    

--  =============================================  

CREATE    PROCEDURE  [dbo].[Load_d_Supplier]    

AS  

BEGIN  

	SET  NOCOUNT  ON;  

  --*******************************************************************************************************************************  

        --                                                                                                                DECLARING  VARIABLES  

    --*******************************************************************************************************************************      

      

        

        

  

	    IF  OBJECT_ID('tempdb..##TMP_F0401')  is  not  null  DROP  TABLE  ##TMP_F0401  

  

  

	  

			--##TMP_F0401  

  

			select    

			  A6AN8_AddressNumber  

                         ,  ABALPH_NameAlpha  

			 ,  ABAT1_AddressType1  

			into  ##TMP_F0401  

			from  [RDL00001_EnterpriseDataLanding].jde.F0401  T1  

  

			left  join  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_V0101]  T2  

  

			on  T1.A6AN8_AddressNumber=T2.ABAN8_AddressNumber  

  

Truncate  table  [dbo].[D_Supplier]  

  

INSERT    into  [dbo].[D_Supplier]    (    

  

SupplierNumber ,  

SupplierName ,  

[SearchType]  

  

)  

  

select    

A6AN8_AddressNumber  as  SupplierNumber ,  

ABALPH_NameAlpha  as  SupplierName ,  

ABAT1_AddressType1  as  SearchType  

From    ##TMP_F0401    

  

  

    

END  

  

  

  

  

  

  

  

  

