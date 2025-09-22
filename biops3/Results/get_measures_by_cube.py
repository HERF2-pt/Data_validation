from utils.olapConn import query_cube
import pandas as pd
import openpyxl
from openpyxl import load_workbook
from datetime import datetime


serverName = 'NADWOLAPPP1A'
cube: str = 'RDL00001_Procurement'
queryCubes = '''SELECT  [CATALOG_NAME] ,[DATABASE_ID], [DATE_MODIFIED]
FROM 
    $SYSTEM.DBSCHEMA_CATALOGS WHERE CA='''
queryMeasures = '''SELECT  *
    FROM $SYSTEM.MDSCHEMA_MEASURES;'''



################# getting the list of measure=
df_measures = query_cube(
    queryMeasures, cube=cube, server=serverName)
df_measures = df_measures.dropna(axis=1, how='all')
df_filtered = df_measures[~df_measures['MEASURE_NAME'].str.startswith('_')]

measure_dfs = []


for measure in df_measures['MEASURE_NAME']:
    queryCalculate = f'''EVALUATE
SUMMARIZECOLUMNS(
    'F_PurchaseOrderLine'[BranchKey],
    "[{measure}]", [{measure}]
)   '''
    try:
        df_calculate = query_cube(
            queryCalculate, cube=cube, server=serverName)
        df_calculate['MeasureName'] = measure  
        
        measure_dfs.append(df_calculate)
    except Exception as e:
        print(f"Failed to query measures for measure {measure}: {e}")

# Combine all into one DataFrame
df_allMeasures_combined = pd.concat(measure_dfs, ignore_index=True)
# add the date of extraction
df_allMeasures_combined['QueryDate'] = datetime.today().timestamp()
df_allMeasures_combined = df_allMeasures_combined.dropna(axis=1, how='all')

# save it
df_allMeasures_combined.to_excel(f"MeasuresCalculations{serverName}.xlsx", index=False)
