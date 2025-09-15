from utils.olapConn import query_cube
import pandas as pd
import openpyxl
from openpyxl import load_workbook
from datetime import datetime


serverName = 'NADWOLAPPP1A'
queryCubes = '''SELECT  [CATALOG_NAME] ,[DATABASE_ID], [DATE_MODIFIED]
FROM 
    $SYSTEM.DBSCHEMA_CATALOGS;'''

# Get the list of cubes in a dataframe
df_allCubes = query_cube(query=queryCubes)
# ------------------------

queryMeasures = '''SELECT  *
    FROM $SYSTEM.MDSCHEMA_MEASURES;'''
# example
# df_Measures = query_cube(queryMeasures, cube='RDL00001_Procurement')
# df.head()

# Collect measures from all cubes in a concatenated dataframe
measure_dfs = []

for cube_name in df_allCubes['CATALOG_NAME']:
    try:
        df_measures = query_cube(
            queryMeasures, cube=cube_name, server=serverName)
        df_measures['CubeName'] = cube_name  # Add cube name for reference
        df_measures['Server'] = serverName  # Add server info
        measure_dfs.append(df_measures)
    except Exception as e:
        print(f"Failed to query measures for cube {cube_name}: {e}")

# Combine all into one DataFrame
df_allMeasures_combined = pd.concat(measure_dfs, ignore_index=True)
# add the date of extraction
df_allMeasures_combined['QueryDate'] = datetime.today().date()

# save it
df_allMeasures_combined.to_excel(f"AllMeasures{serverName}.xlsx", index=False)
