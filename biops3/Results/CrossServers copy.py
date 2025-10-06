import pandas as pd
from sqlalchemy import create_engine

# Create connection strings for SQLAlchemy
engine1 = create_engine(
    "mssql+pyodbc://@NADWDAT1A/RDL00001_EnterpriseDataWarehouse?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes")
engine2 = create_engine(
    "mssql+pyodbc://@NADWDATPP1A/RDL00001_EnterpriseDataWarehouse?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes")
ö

# Run queries and load into pandas DataFrames
query1 = "SELECT * FROM dbo.D_Company"
query2 = "SELECT TOP 100 * FROM dbo.F_PurchaseOrderLine"

df_company = pd.read_sql(query1, engine1)
df_purchase = pd.read_sql(query2, engine2)

# Merge (left join) on 'CompanyCode'
merged = pd.merge(df_company, df_purchase, how='left', on='CompanyCode')

# Display the result as JSON (first 5 rows)
# print(merged.head().to_json())
