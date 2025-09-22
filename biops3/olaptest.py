import pandas as pd
import pyodbc
import adodbapi
# Data source name or server details
server = 'cube01ProcurementPP.premiertech.com'
database = 'RDL00001_Procurement'


def execute_mdx_query(server, database, query_string):
    conn_str = (
        f"Provider=MSOLAP;"
        f"Data Source={server};"
        f"Initial Catalog={database};"
        f"Integrated Security=SSPI;"
    )
    conn = adodbapi.connect(conn_str)

    # Example: Get list of cubes
    cursor = conn.cursor()
    cursor.execute(query_string)

    # Fetch all rows and column names
    rows = cursor.fetchall()
    columns = [col[0] for col in cursor.description]

    # Convert to DataFrame
    return pd.DataFrame(rows, columns=columns)
