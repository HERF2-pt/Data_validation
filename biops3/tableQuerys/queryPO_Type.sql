
SELECT IB.ItemNumber ,p.itemNumber ,IB.SecondItem ,c.CompanyCode ,p.branch ,p.Shipto ,p.OrderType ,im.glclass--, PO_Type 

       ,CASE
		    -- Priorité la plus élevée : règle spécifique acheteur + compagnie (prime tout le reste)
		    WHEN P.BuyerNumber = 2141873 AND P.CompanyCode = '00001' THEN        'CS'
		        -- CS pour compagnie 00077 quand Branch = 535 et Ship-To = 537
		    WHEN P.CompanyCode = '00077'
        AND P.Branch = '535'
        AND P.ShipTo = '537' THEN
			  'CS'
		    -- Bloc Subcontractor (Sous-traitance) : règles par motifs d'ItemNumber et compagnie
		    -- Intention : ces règles s'appliquent avant Third-Party si elles correspondent
		    WHEN P.CompanyCode = '09052' AND IB.SecondItem LIKE '%555555%' THEN        'Subcontractor'

		    WHEN P.CompanyCode IN ('00024', '09011') AND IB.SecondItem LIKE '%222222%' THEN        'Subcontractor'

		    WHEN P.CompanyCode IN ('00077', '09041') AND (IB.SecondItem LIKE '%111111%' OR IB.SecondItem LIKE '%333333%') THEN 'Subcontractor'

		    -- Sous-traitance basée sur un indicateur opérationnel / classe GL pour la compagnie principale
		    -- Remarque : cette règle reste prioritaire sur Third-Party car placée avant
		    WHEN P.CompanyCode = '00001' AND (IB.SecondItem LIKE '%*OP%' OR IM.GLclass = 'IN20') THEN  'Subcontractor'

		    -- Third-Party : s'applique seulement si aucune règle ci-dessus n'a été satisfaite
		    WHEN P.OrderType = 'ON' THEN       'Third-Party'
		       -- Third-Party spécifique pour 00077 et 09041 lorsque les items sont 111111-9 ou 333333-6
		 WHEN P.CompanyCode IN ('00077', '09041')
        AND (IB.SecondItem LIKE '%111111-9%' OR IB.SecondItem LIKE '%333333-6%') THEN        'Third-Party'

		    -- Valeur par défaut
		    ELSE        'General'
		END AS PO_Type
--select count(*) 
FROM RDL00001_EnterpriseDataStaging.dbo.[F_PurchaseOrderLine] p
    LEFT JOIN RDL00001_EnterpriseDataWarehouse.dbo.[D_company] c ON p.CompanyCode=c.CompanyCode
    LEFT JOIN RDL00001_EnterpriseDataWarehouse.dbo.[D_ItemBranch] IB ON p.ItemNumber=IB.ItemNumber
    LEFT JOIN RDL00001_EnterpriseDataWarehouse.dbo.[D_ItemMaster] im ON p.ItemNumber=im.ItemNumber

--
WHERE

P.CompanyCode = '00001' AND (IB.SecondItem LIKE '%*OP%' )