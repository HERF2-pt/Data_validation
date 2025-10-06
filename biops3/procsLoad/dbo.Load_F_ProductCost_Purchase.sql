CREATE  PROCEDURE  [dbo].[Load_F_ProductCost_Purchase]


AS


BEGIN





        --  ============================================= 


        --  Author:		<Author , ,BART> 


        --  Create  date:  <Create  Date ,2025-09-09 ,> 


        --  Description:	EXEC  [dbo].[Load_F_ProductCost_Purchase]   


        --  ============================================= 


        DECLARE  @IdentityAuditIdInsert    DECIMAL(18 ,  0) 
 

                     ,  @IdentityAuditIdUpdate    DECIMAL(18 ,  0) 
 

                     ,  @IdentityAuditIdDelete    DECIMAL(18 ,  0) 
 

                     ,  @RowCountAffectedInsert  DECIMAL(18 ,  0) 
 

                     ,  @RowCountAffectedUpdate  DECIMAL(18 ,  0) 
 

                     ,  @RowCountAffectedDelete  DECIMAL(18 ,  0) 
 

                     ,  @Database                              VARCHAR(22)


        SET  @Database  =  'RDL00001_EnterpriseDataStaging'





        /*********************************************************************************************** 
 

								REQUETE  PRINCIPALE  (MERGE) 
 

										DEBUT 
 

************************************************************************************************/





        --  Insert  empty  ROWS  into  the  AUDIT  Table  for  inserted  and  updated  records 


        EXEC  @IdentityAuditIdInsert  =  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  0 
 

                                                                                                                                                                                   ,  @Database 
 

                                                                                                                                                                                   ,  'F_ProductCost_Purchase' 
 

                                                                                                                                                                                   ,  'I' 
 

                                                                                                                                                                                   ,  'F' 
 

                                                                                                                                                                                   ,  0 
 

                                                                                                                                                                                   ,  0 
 

                                                                                                                                                                                   ,  0 
 

                                                                                                                                                                                   ,  'N';


        EXEC  @IdentityAuditIdUpdate  =  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  0 
 

                                                                                                                                                                                   ,  @Database 
 

                                                                                                                                                                                   ,  'F_ProductCost_Purchase' 
 

                                                                                                                                                                                   ,  'U' 
 

                                                                                                                                                                                   ,  'F' 
 

                                                                                                                                                                                   ,  0 
 

                                                                                                                                                                                   ,  0 
 

                                                                                                                                                                                   ,  0 
 

                                                                                                                                                                                   ,  'N';


        DROP  TABLE  IF  EXISTS  #SourceData;


        SELECT DRDL02_Description01002 
 

                    ,DRDL01_Description001 
 

                    ,COMCU_CostCenter 
 

                    ,COLOCN_Location 
 

                    ,COITM_IdentifierShortItem 
 

                    ,CCCRCD 
 

                    ,COLEDG_LedgType 
 

                    ,COUNCS_AmountUnitCost 
 

                    ,CCCO 
 

                    ,Cost_Type


        INTO  #SourceData


        FROM


                ( 
 

                SELECT TRIM(f05.DRDL02_Description01002)      AS  DRDL02_Description01002 
 

                            ,TRIM(f05.DRDL01_Description001)          AS  DRDL01_Description001 
 

                            ,TRIM(pc.COMCU_CostCenter)                      AS  COMCU_CostCenter 
 

                            ,pc.COLOCN_Location 
 

                            ,pc.COITM_IdentifierShortItem 
 

                            ,f10.CCCRCD 
 

                            ,TRIM(pc.COLEDG_LedgType)                        AS  COLEDG_LedgType 
 

                            ,ISNULL(pc.COUNCS_AmountUnitCost ,  0)  AS  COUNCS_AmountUnitCost 
 

                            ,f10.CCCO 
 

                            ,CASE 
 

                                      WHEN  TRY_CAST(pc.COLEDG_LedgType  AS  INT)  =  7  THEN 
 

                                              'Standard' 
 

                                      WHEN  TRY_CAST(pc.COLEDG_LedgType  AS  INT)  =  1  THEN 
 

                                              'Last  In' 
 

                                      WHEN  TRY_CAST(pc.COLEDG_LedgType  AS  INT)  =  22  THEN 
 

                                              'Last  In  Primary  Vendor' 
 

                                      ELSE 
 

                                              '' 
 

                              END                                                                  AS  Cost_Type 
 

                            ,ROW_NUMBER()  OVER  (PARTITION  BY  TRIM(pc.COMCU_CostCenter) 
 

                                                                                           ,  pc.COITM_IdentifierShortItem 
 

                                                                                           ,  TRIM(pc.COLEDG_LedgType) 
 

                                                                    ORDER  BY  [COUPMJ_DateUpdated]  DESC 
 

                                                                  )                                  AS  rn


                FROM [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4105]                    pc


                        LEFT JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F4102]  f02


                        ON  pc.COITM_IdentifierShortItem  =  f02.IBITM_IdentifierShortItem


                                AND TRIM(pc.COMCU_CostCenter)  =  TRIM(f02.IBMCU_CostCenter)


                        LEFT JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F0005]  f05


                        ON  TRIM(pc.COLEDG_LedgType)  =  TRIM(f05.DRKY_UserDefinedCode)


                                AND TRIM(f05.DRSY_ProductCode)  =  '40'


                                AND TRIM(f05.DRRT_UserDefinedCodes)  =  'CM'


                        LEFT JOIN [RDL00001_EnterpriseDataLanding].[JDE_BI_OPS].[V_F0006]  f06


                        ON  f06.MCMCU_CostCenter  =  pc.COMCU_CostCenter


                        LEFT JOIN [RDL00001_EnterpriseDataLanding].[JDE].[F0010]                    f10


                        ON  f06.MCCO_Company  =  f10.CCCO


                WHERE  TRIM(f02.IBSTKT_StockingType)  IN  (  'P' ,  'B' ,  'O' ,  'U' ,  'X' ,  'H'  )


                        AND TRY_CAST(pc.COLEDG_LedgType  AS  INT)  IN  (  1 ,  7 ,  22  )


                        AND pc.[COLOTN_Lot]  =  '' 
 

        )  AS  ranked


        WHERE  rn  =  1


        DECLARE  @MergeSummary  TABLE  (ActionTaken NVARCHAR(20));


        MERGE  [dbo].[F_ProductCost_Purchase]  AS  t 
 

        USING  #SourceData  AS  s 
 

        ON  t.COMCU_CostCenter  =  s.COMCU_CostCenter


                AND t.COITM_IdentifierShortItem  =  s.COITM_IdentifierShortItem


                AND t.COLEDG_LedgType  =  s.COLEDG_LedgType


                AND t.is_current  =  1 
 

        WHEN  MATCHED  AND  t.COUNCS_AmountUnitCost  <>  s.COUNCS_AmountUnitCost  THEN 
 

                UPDATE  SET  t.[valid_to]  =  GETDATE()-1 
 

                                   ,  t.is_current  =  0 
 

        WHEN  NOT  MATCHED  BY  TARGET  THEN 
 

                INSERT 
 

                ( 
 

                        [DRDL02_Description01002] 
 

                     ,  [DRDL01_Description001] 
 

                     ,  [COMCU_CostCenter] 
 

                     ,  [COLOCN_Location] 
 

                     ,  [COITM_IdentifierShortItem] 
 

                     ,  [CCCRCD] 
 

                     ,  [COLEDG_LedgType] 
 

                     ,  [COUNCS_AmountUnitCost] 
 

                     ,  [CCCO] 
 

                     ,  [Cost_Type] 
 

                     ,  [Date] 
 

                     ,  [valid_from] 
 

                     ,  [valid_to] 
 

                     ,  [is_current] 
 

                ) 
 

                VALUES 
 

                (s.[DRDL02_Description01002] 
 

               ,  s.[DRDL01_Description001] 
 

               ,  s.[COMCU_CostCenter] 
 

               ,  s.[COLOCN_Location] 
 

               ,  s.[COITM_IdentifierShortItem] 
 

               ,  s.[CCCRCD] 
 

               ,  s.[COLEDG_LedgType] 
 

               ,  s.[COUNCS_AmountUnitCost] 
 

               ,  s.[CCCO] 
 

               ,  s.[Cost_Type] 
 

               ,  DATEADD(day ,  DATEDIFF(day ,  0 ,  GETDATE()) ,  0) 
 

               ,  GETDATE() 
 

               ,  '9999-12-31' 
 

               ,  1 
 

                ) 
 

        OUTPUT  $action 
 

        INTO  @MergeSummary;





        --  SET  THE  VARIABLE  WITH  THE  ROW  COUNT  OF  THE  INSERT  AND  UPDATE 


        SELECT @RowCountAffectedInsert  =  COUNT(*)


        FROM @MergeSummary


        WHERE  ActionTaken  =  'INSERT'


        SELECT @RowCountAffectedUpdate  =  COUNT(*)


        FROM @MergeSummary


        WHERE  ActionTaken  =  'UPDATE'





        --  UPDATE  THE  AUDIT  TABLE  WITH  THE  ROWCOUNTAFFECTED 


        EXEC  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  @IdentityAuditIdInsert 
 

                                                                                                                                 ,  @Database 
 

                                                                                                                                 ,  'F_ProductCost_Purchase' 
 

                                                                                                                                 ,  'I' 
 

                                                                                                                                 ,  'S' 
 

                                                                                                                                 ,  @RowCountAffectedInsert 
 

       ,  0 
 

                                                                                                                                 ,  0 
 

                                                                                                                                 ,  'Y'


        EXEC  RDL00001_EnterpriseDataLanding.dbo.SYS_AUDIT_TRANSACTION  @IdentityAuditIdUpdate 
 

                                                                                                                                 ,  @Database 
 

                                                                                                                                 ,  'F_ProductCost_Purchase' 
 

                                                                                                                                 ,  'U' 
 

                                                                                                                                 ,  'S' 
 

                                                                                                                                 ,  @RowCountAffectedUpdate 
 

                                                                                                                                 ,  0 
 

                                                                                                                                 ,  0 
 

                                                                                                                                 ,  'Y'





/***************************************************************************************************************************************************************************** 
 

								REQUETE  PRINCIPALE  (MERGE) 
 

										FIN 
 

******************************************************************************************************************************************************************************/


END
