# fmt: off
import pandas as pd
import openpyxl
import sys
import os

# Ensure parent directory is in path for module import
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from utils.olapConn import query_cube

# Define parameters
server = 'NADWOLAP1A'
cube = 'RDL00002_99011_GL_Transactions'

# OLAP queries
olapCubeQueries = {
    "measuresQuery": "SELECT * FROM $SYSTEM.TMSCHEMA_MEASURES",
    # "dimensionsQuery": "SELECT * FROM $SYSTEM.MDSCHEMA_DIMENSIONS",
    # "hierarchiesQuery": "SELECT * FROM $SYSTEM.MDSCHEMA_HIERARCHIES",
    "relationshipsQuery": "SELECT * FROM $SYSTEM.TMSCHEMA_RELATIONSHIPS",
    "tablesQuery": "SELECT * FROM $SYSTEM.TMSCHEMA_TABLES",
    "columnsQuery": "SELECT * FROM $SYSTEM.DBSCHEMA_COLUMNS WHERE TABLE_SCHEMA <> '$SYSTEM' AND COLUMN_OLAP_TYPE='ATTRIBUTE'",
    "columnCalculated":"SELECT [ExplicitName],Expression, tableID,IsHidden, SourceColumn FROM $SYSTEM.TMSCHEMA_COLUMNS where ExplicitDataType=1",
}

# Collect metadata
cubeMetadata = {}

for key, query in olapCubeQueries.items():
    df_name = key.replace("Query", "_df")
    try:
        df = query_cube(server=server, cube=cube, query=query)
        if not isinstance(df, pd.DataFrame):
            raise ValueError(f"query_cube did not return a DataFrame for '{key}'")
        df_cleaned = df.dropna(axis=1, how='all')
        cubeMetadata[df_name] = df_cleaned
    except Exception as e:
        print(f"Failed to query '{key}' for cube '{cube}': {e}")

# Optional: Preview one DataFrame
if 'measures_df' in cubeMetadata:
    print(cubeMetadata['measures_df'].head())

# Prepare Excel output
script_dir = os.path.dirname(os.path.abspath(__file__))
excel_file = os.path.join(script_dir, f"{cube}_metadata.xlsx")
file_exists = os.path.exists(excel_file)

# Write to Excel
mode = "a" if file_exists else "w"
writer_args = {
    "path": excel_file,
    "engine": "openpyxl",
    "mode": mode
}
if file_exists:
    writer_args["if_sheet_exists"] = "replace"

with pd.ExcelWriter(**writer_args) as writer:
    for sheet_name, df in cubeMetadata.items():
        clean_name = sheet_name.replace("_df", "").capitalize()
        df.to_excel(writer, sheet_name=clean_name, startrow=2, index=False)
