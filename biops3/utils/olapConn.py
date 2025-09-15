import pandas as pd
from pyadomd import Pyadomd
import sys
from sys import path
import os
# Add ADOMD.NET path
path.append("C:\\Program Files\\Microsoft.NET\\ADOMD.NET\\150\\")


def execute_mdx_query(dataSource, catalog, query_string):
    """
    Connects to an SSAS OLAP cube and executes the given MDX query,
    returning results as a Pandas DataFrame.
    """
    conn_str = (
        "Provider=MSOLAP;"
        f"Data Source={dataSource};"
        f"Catalog={catalog};"
        "Integrated Security=SSPI"
    )

    conn = Pyadomd(conn_str)
    conn.open()  # ✅ Explicitly open the connection

    try:
        cursor = conn.cursor()
        cursor.execute(query_string)
        columns = [col.name for col in cursor.description]
        rows = cursor.fetchall()
        return pd.DataFrame(rows, columns=columns)
    finally:
        try:
            cursor.close()
        except:
            pass
        conn.close()


cube = 'cube01ProcurementPP.premiertech.com'
catalog = 'RDL00001_Procurement'
query = "SELECT * FROM $SYSTEM.MDSCHEMA_MEASURES"


df = execute_mdx_query(dataSource=cube, catalog=catalog, query_string=query)


# Display results
print(df.head())
