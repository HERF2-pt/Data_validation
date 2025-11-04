import pandas as pd
from sqlalchemy import create_engine

# Define connection parameters
server = "NADWDATPP1A"
driver = "ODBC Driver 17 for SQL Server"


def get_engine(database):

    connection_string = (
        f"mssql+pyodbc://@{server}/{database}?driver={driver}&Trusted_Connection=yes"
    )
    engine = create_engine(connection_string)
    return engine


def execute_queryPP(query, database="RDL00001_EnterpriseDataStaging"):

    engine = get_engine(database)
    with engine.connect() as connection:
        result = pd.read_sql(query, connection)
    return result


def execute_queryST(query, database="RDL00001_EnterpriseDataStaging"):

    engine = get_engine(database)
    with engine.connect() as connection:
        result = pd.read_sql(query, connection)
    return result


# Usage example:
# Example SQL query
query = f""" EXEC sp_helptext 'Load_f_execution_log'"""

# Specify the new database name
new_database = "RDL00005_Monitoring_BI"

# Call the function with the new database
df = execute_queryPP(query, database=new_database)

# Display the result
print(df.head())


# # CONNECTION

# import pandas as pd
# from sqlalchemy import create_engine

# # Define connection parameters
# server = "NADWDATPP1A"
# database = "RDL00001_EnterpriseDataStaging"
# driver = "ODBC Driver 17 for SQL Server"

# # Create SQLAlchemy engine
# connection_string = (
#     f"mssql+pyodbc://@{server}/{database}?driver={driver}&Trusted_Connection=yes"
# )
# engine = create_engine(connection_string)


# def execute_queryPP(query):
#     """
#     Execute a SQL query and return the result as a pandas DataFrame.

#     Parameters:
#     query (str): The SQL query to execute.

#     Returns:
#     pd.DataFrame: The result of the query.
#     """
#     with engine.connect() as connection:
#         result = pd.read_sql(query, connection)
#     return result


# def execute_queryST(query):
#     """
#     Execute a SQL query and return the result as a pandas DataFrame.

#     Parameters:
#     query (str): The SQL query to execute.

#     Returns:
#     pd.DataFrame: The result of the query.
#     """
#     with engine.connect() as connection:
#         result = pd.read_sql(query, connection)
#     return result


# # otra forma de hacerlo: df = pd.read_sql(query, engine)
# # Read data into DataFrame V_F4311
# # this one is to large
# # V_F4311 = execute_query('SELECT * FROM RDL00001_EnterpriseDataLanding.[JDE_BI_OPS].[V_F4311]')


# # Cataloge_BI_OPS.head()


# # Display the first few rows
# # Cataloge_BI_OPS.head()
