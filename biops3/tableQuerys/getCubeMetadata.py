# fmt: off
import pandas as pd
import openpyxl
from openpyxl import load_workbook
import sys
from sys import path
import os
# Add ADOMD.NET path
path.append("C:\\Program Files\\Microsoft.NET\\ADOMD.NET\\150\\")


sys.path.append(os.path.abspath(os.path.join(
    os.path.dirname(__file__), '../..', 'utils')))


# main.py

from utils.olapConn import execute_mdx_query

###
# Define your parameters
####
server = 'NADWOLAP1A'
cube = 'RDL00002_99011_GL_Transactions'
measuresQuery = "SELECT * FROM $SYSTEM.MDSCHEMA_MEASURES"
##
##
olapCubeQueries = {
    "measuresQuery": "SELECT * FROM $SYSTEM.MDSCHEMA_MEASURES",
    # "dimensionsQuery": "SELECT * FROM $SYSTEM.MDSCHEMA_DIMENSIONS",
    # "hierarchiesQuery": "SELECT * FROM $SYSTEM.MDSCHEMA_HIERARCHIES",
    # "relationshipsQuery": "SELECT * FROM $SYSTEM.DBSCHEMA_RELATIONSHIPS",
    "tablesQuery": "SELECT * FROM $SYSTEM.DBSCHEMA_TABLES where TABLE_TYPE='Table'",
    "columnsQuery": "SELECT * FROM $SYSTEM.DBSCHEMA_COLUMNS where TABLE_SCHEMA!='$SYSTEM' AND COLUMN_OLAP_TYPE='ATTRIBUTE'",
}

cubeMetadata = {}
for key, query in olapCubeQueries.items():
    df_name = key.replace("Query", "_df")
     # Execute the query
    df = execute_mdx_query(dataSource=server, catalog=cube, query_string=query)
    # Drop columns that are completely empty
    df_cleaned = df.dropna(axis=1, how='all')
    # Store the cleaned DataFrame
    cubeMetadata[df_name] = df_cleaned

# Example: Accessing the measures DataFrame
cubeMetadata['measures_df']

script_dir = os.path.dirname(os.path.abspath(__file__))
Excel_file = os.path.join(script_dir, f"{cube}_metadata.xlsx")
# Define your Excel file path
# Check if the file exists
file_exists = os.path.exists(Excel_file)

if file_exists:
    # Append mode with sheet replacement
    with pd.ExcelWriter(
        Excel_file, engine="openpyxl", mode="a", if_sheet_exists="replace"
    ) as writer:
        for sheet_name, df in cubeMetadata.items():
            clean_name = sheet_name.replace("_df", "").capitalize()
            df.to_excel(writer, sheet_name=clean_name, startrow=2, index=False)
else:
    # Write mode without if_sheet_exists
    with pd.ExcelWriter(
        Excel_file, engine="openpyxl", mode="w"
    ) as writer:
        for sheet_name, df in cubeMetadata.items():
            clean_name = sheet_name.replace("_df", "").capitalize()
            df.to_excel(writer, sheet_name=clean_name, startrow=2, index=False)
