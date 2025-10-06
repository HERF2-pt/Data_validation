from utils import connpd
from utils import connpp
import pandas as pd


tablePD=connpd.execute_query("select * from RDL00001_EnterpriseDataWarehouse.dbo.D_Company")

tablePP=connpp.execute_queryPP("select top 100 * from RDL00001_EnterpriseDataWarehouse.dbo.F_PurchaseOrderLine")

result=tablePD.merge(tablePP, on='CompanyCode', how="left", right_index=False)
