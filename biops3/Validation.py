import pandas as pd
from utils.connpd import execute_query
from utils.connpp import execute_queryPP


# open the catalog.xlsx file and read the DataLake sheet
Cataloge_DataLake = pd.read_excel(
    "catalog.xlsx",
    sheet_name="DL_biops_DataLake",
    skiprows=2,  # Salta las dos primeras filas (0-indexed)
)


# execute connection and query to the Data Warehouse for D_ItemMaster
d_item_master = execute_query("""
SELECT * FROM [RDL00001_EnterpriseDataWarehouse].[dbo].[D_ItemMaster]
 """)

# execute connection and query to the Data Warehouse for D_ItemBranch
d_item_branch = execute_queryPP("""
SELECT * FROM [RDL00001_EnterpriseDataWarehouse].[dbo].[D_ItemBranch]
 """)

tableName=''
df_DescribeTable = execute_query(f"""
SELECT * 
FROM [RDL00001_EnterpriseDataLanding].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE '%{tableName}%'
ORDER BY TABLE_NAME,COLUMN_NAME""")
df_DescribeTable.head()