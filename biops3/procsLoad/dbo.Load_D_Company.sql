  

  

  

  

  

  

  

--  =============================================  

--  Author:		<Author , ,SAMN>  

--  Create  date:  <Create  Date , ,>  

--  Description:	EXEC  [dbo].[Load_d_Company]    

--  =============================================  

CREATE    PROCEDURE  [dbo].[Load_d_Company]    

AS  

BEGIN  

	SET  NOCOUNT  ON;  

  --*******************************************************************************************************************************  

        --                                                                                                                DECLARING  VARIABLES  

    --*******************************************************************************************************************************      

      

  

    Merge  [dbo].[d_Company]    t  

    using    

  

    (  select    

        

            distinct        

	      Trim  (T1.MCCO)  as  CompanyCode ,  

	      Trim  (T2.CCNAME)  as  CompanyName ,  

	      Trim(T2.CCCRCD)  as  CurrencyCode ,  

	      ISNULL(CieAcronym.DRDL01_Description001 ,  'XX')  as  CieAcronym  

  

            from  [RDL00001_EnterpriseDataLanding].JDE.F0006  T1  

  

	    Left  JOIN    [RDL00001_EnterpriseDataLanding].JDE.F0010  T2  

  

	    ON  LTRIM(RTRIM(MCCO))  =  LTRIM(RTRIM(CCCO))  

  

	    LEFT  JOIN  [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F0005]  CieAcronym    

	    ON  trim(CieAcronym.DRSY_ProductCode)  =  '00'  

	      AND  trim(CieAcronym.DRRT_UserDefinedCodes)  =  '21'  

	      AND  trim(T1.MCRP21)  =  trim(CieAcronym.DRKY_UserDefinedCode)  

  

	    where  trim(T1.[MCMCU])    in  (  '1' ,  '77'   ,  '9011' ,  '9052' ,'9041' ,  '24')  AND  T1.MCSTYL  =  'BS'  

  

  

	    )    as  s  

  

	on  s.CompanyCode=t.CompanyCode  

  

  

----update  status  when  matched  

  

		    	    WHEN  MATCHED  THEN    

    UPDATE  SET  

          

        t.CompanyName=s.CompanyName ,  

	t.[CurrencyCode]  =  s.CurrencyCode ,  

	t.[CieAcronym]  =  s.CieAcronym  

  

  

	        ---Insert  new  Status  when  not  matched  

  

      WHEN  NOT  MATCHED  BY  TARGET  

      

        THEN    

      INSERT  (    

	              CompanyCode ,  

		      CompanyName ,  

		      CurrencyCode ,  

		      [CieAcronym]  

                      )  

  

Values  (s.CompanyCode ,  

		s.CompanyName ,  

		s.CurrencyCode ,  

		s.CieAcronym  

  

		    );  

		      

		      

	  

  

  

  

  

    

END  

  

  

  

  

  

  

  

  

