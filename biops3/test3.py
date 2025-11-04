import pyodbc
import pandas as pd

# Define connection string
conn_str = (
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=NADWDAT1A;"
    "DATABASE=RDL00001_EnterpriseDataWarehouse;"
    "Trusted_Connection=yes;"
)

# Connect and execute
with pyodbc.connect(conn_str) as conn:
    cursor = conn.cursor()
    cursor.execute("EXEC Load_D_DatesUpdate_Cube_Job")
    rows = cursor.fetchall()
    columns = [column[0] for column in cursor.description]
    df = pd.DataFrame(rows, columns=columns)

print(df)
