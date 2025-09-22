from utils.olapConn import query_cube
import pandas as pd
import openpyxl
from datetime import datetime
import os

serverName = 'NADWOLAPPP1A'
cube = 'RDL00001_Procurement'
queryMeasures = '''SELECT * FROM $SYSTEM.MDSCHEMA_MEASURES;'''

# execute example
qr_CurrencyMesures = '''EVALUATE
SUMMARIZECOLUMNS(
    'F_PurchaseOrderLine'[OrderNumber],
    'D_Company'[Cie],
    'D_Branch'[Branch],
    'F_PurchaseOrderLine'[LineNumber],
    'D_ItemBranch'[ShortItemNumber],
    'F_PurchaseOrderLine'[Currency],
    'F_PurchaseOrderLine'[OriginalAmount_cad],
    "Total_Amount_PO", [Total_Amount_PO],
    "Cancelled_Amount_PO", [Cancelled_Amount_PO],
    "Active_Amount_PO", [Active_Amount_PO],
    "Not_Received_Amount_PO", [Not_Received_Amount_PO],
    "Total_Amount_PO_Freight", [Total_Amount_PO_Freight],
    "Total_Amount_PO_Tariffs", [Total_Amount_PO_Tariffs],
    "Total_Amount_PO_Rush", [Total_Amount_PO_Rush]
)
   '''

df_currencyMeasures = query_cube(
    qr_CurrencyMesures, cube=cube, server=serverName)

#!################
####################
qr = '''EVALUATE
SUMMARIZECOLUMNS(
    'F_PurchaseOrderLine'[OrderNumber],
    
    "AverageLeadtime", [Cancelled_Amount_PO]
    
)   '''

df_SimpleMeasure = query_cube(
    qr, cube=cube, server=serverName)
#!#######################
#################


#########
############
qr_validation = '''
EVALUATE
SUMMARIZECOLUMNS(
    'F_PurchaseOrderLine'[OrderDate],
    'F_PurchaseOrderLine'[CancelDate],
    'F_PurchaseOrderLine'[ReceptionDate],
    'F_PurchaseOrderLine'[OrderNumber],
    'F_PurchaseOrderLine'[LineNumber],
    'D_ItemBranch'[SecondItemNumber],
    'F_PurchaseOrderLine'[QuantityOrder],
   "Not_Received_Item_Count", [Not_Received_Item_Count],
   "Not_Received_Distinct_Item_Count", [Not_Received_Distinct_Item_Count]
    )
'''

df_validation = query_cube(
    qr_validation, cube=cube, server=serverName)
df_validation.columns
df_validation[df_validation['F_PurchaseOrderLine[OrderNumber]'] == 25107000]


#########
############

#!SAVING THE RESULTS DATAFRAMES IN AN EXCEL

# List of dataframe names you want to save (add more as needed)
df_names = [
    "df_currencyMeasures",
    "df_validation",
    "df_SimpleMeasure"
    # Add more dataframes here, e.g., "df_other"
]
# The output Excel file path
excel_file = "Test_measures.xlsx"
existing_sheets = {}
file_exists = os.path.exists(excel_file)
# Update or add the dataframes

try:
    if file_exists:
        # Append mode with sheet replacement
        with pd.ExcelWriter(
            excel_file, engine="openpyxl", mode="a", if_sheet_exists="replace"
        ) as writer:
            for name in df_names:
                if name in globals() and globals()[name] is not None:
                    df = globals()[name].copy()
                    df.to_excel(writer, sheet_name=name, startrow=2, index=False)
                    print(f"Successfully saved '{name}' to Excel")
                else:
                    print(f"Dataframe '{name}' does not exist or is None. Skipping...")
    else:
        # Write mode
        with pd.ExcelWriter(excel_file, engine="openpyxl", mode="w") as writer:
            for name in df_names:
                if name in globals() and globals()[name] is not None:
                    df = globals()[name].copy()
                    df.to_excel(writer, sheet_name=name, startrow=2, index=False)
                    print(f"Successfully saved '{name}' to Excel")
                else:
                    print(f"Dataframe '{name}' does not exist or is None. Skipping...")
    
    print(f"Excel file '{excel_file}' has been created/updated successfully!")

except Exception as e:
    print(f"Error saving to Excel: {str(e)}")