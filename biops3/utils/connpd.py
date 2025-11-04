# CONNECTION

import pandas as pd
from sqlalchemy import create_engine, text

# Define connection parameters
server = "NADWDAT1A"
database = "RDL00001_EnterpriseDataWarehouse"
driver = "ODBC Driver 17 for SQL Server"

# Create SQLAlchemy engine
connection_string = (
    f"mssql+pyodbc://@{server}/{database}?driver={driver}&Trusted_Connection=yes"
)
engine = create_engine(connection_string)


def execute_query(query):

    # Execute a SQL query and return the result as a pandas DataFrame.

    with engine.connect() as connection:
        result = pd.read_sql(query, connection)
    return result


def executeQuery(stored_procedure):
    with engine.connect() as connection:
        connection.execute(text(stored_procedure))  # No fetch here
        print("Stored procedure executed successfully.")


# # Execute the stored procedure
# with engine.connect() as connection:
#     connection.execute(text(stored_procedure))  # No fetch here
#     print("Stored procedure executed successfully.")