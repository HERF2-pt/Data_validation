from utils.olapConn import query_cube
import pandas as pd
from datetime import datetime

serverName = 'NADWOLAPPP1A'
cube = 'RDL00001_Procurement'
queryMeasures = '''SELECT * FROM $SYSTEM.MDSCHEMA_MEASURES;'''

# execute example
qr='''EVALUATE
SUMMARIZECOLUMNS(
    'F_PurchaseOrderLine'[OrderNumber],
    "AverageRequest", [AverageRequest_versus_AveragePromisedDelivery],
    "AverageLeadtime", [Average_Leadtime_OriginalPromisedDate]
    
)   '''


qr='''EVALUATE
SUMMARIZECOLUMNS(
    'F_PurchaseOrderLine'[OrderNumber],
    
    "AverageLeadtime", [Cancelled_Amount_PO]
    
)   '''
qr='''EVALUATE
SUMMARIZECOLUMNS(
    'F_PurchaseOrderLine'[OrderNumber],
    'F_PurchaseOrderLine'[LineNumber],
    'F_PurchaseOrderLine'[ReceptionDate],
    'F_PurchaseOrderLine'[CancelDate],
    'D_ItemMaster'[SecondItemNumber],
    "Not_Received_Line_Count", [Not_Received_Line_Count],
    "Not_Received_Distinct_Item_Count", [Not_Received_Distinct_Item_Count]

    
)   '''
df_example = query_cube(
    qr, cube=cube, server=serverName)    

df_example.columns
df_example[df_example['F_PurchaseOrderLine[OrderNumber]'] == '25107000']


# Get list of valid measures
df_measures = query_cube(queryMeasures, cube=cube, server=serverName)
df_measures = df_measures.dropna(axis=1, how='all')
df_filtered = df_measures[~df_measures['MEASURE_NAME'].str.startswith('__')]
df_filtered = df_measures[df_measures['MEASURE_IS_VISIBLE'] == 1]


# Initialize merged DataFrame
df_merged: = None
measure_dfs = []
for measure in df_filtered['MEASURE_NAME']:
    queryCalculate = f'''EVALUATE
SUMMARIZECOLUMNS(
    'F_PurchaseOrderLine'[BranchKey],
    "[{measure}]", [{measure}]
)'''
    try:
        df_calculate = query_cube(
            queryCalculate, cube=cube, server=serverName)
        df_name=f'df_{measure}' 
        df_merged = pd.merge(df_merged, df_calculate, on='BranchKey', how='outer')
        measure_dfs.append(df_calculate)
    except Exception as e:
        print(f"Failed to query measures for measure {measure}: {e}")
    

# Add extraction timestamp
df_merged['QueryDate'] = datetime.today().timestamp()

# Drop empty columns
df_merged = df_merged.dropna(axis=1, how='all')

# Save to Excel
df_merged.to_excel(f"MeasuresByBranchKey_{serverName}.xlsx", index=False)
