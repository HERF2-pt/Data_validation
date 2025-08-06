import sys
import os
# Añade la carpeta 'utils' al path
sys.path.append(os.path.abspath(os.path.join(
    os.path.dirname(__file__), '..', 'utils')))
from connpp import execute_queryPP
from connpd import execute_query
import pandas as pd
# from utils.connpd import execute_query
# from utils.connpp import execute_queryPP
import openpyxl
from openpyxl import load_workbook



table_names = [
    'D_Company',
    'D_CostCenter',
    'D_ItemBranch',
    'D_ItemMaster',
    'D_Supplier',
    'F_ProductCost_Purchase',
    'F_PurchaseOrderLine',
    'F_SafetyStock'
]
table_namesLoad = [
    'Load_D_Company',
    'Load_D_CostCenter',
    'Load_D_ItemBranch',
    'Load_D_ItemMaster',
    'Load_D_Supplier',
    'Load_F_ProductCost_Purchase',
    'Load_F_PurchaseOrderLine',
    'Load_F_SafetyStock'
]

# Agregar el prefijo 'dbo.Load_' a cada nombre de tabla
table_namesLoad = [f'dbo.Load_{name}' for name in table_names]

# Obtener la ruta absoluta del script actual
script_dir = os.path.dirname(os.path.abspath(__file__))
# Dictionnaire pour stocker les DataFrames
dfs = {}

for table in table_namesLoad:
    # Exécute la requête
    query = f""" EXEC sp_helptext '{table}'"""
    df = execute_queryPP(f"{query}")
    # Stocke le DataFrame dans le dictionnaire avec le nom de la table
    dfs[f"df_{table}"] = df

    csv_path = os.path.join(script_dir, f"{table}.sql")
    # Guardar el DataFrame
    import csv

    df.to_csv(csv_path, index=False, quoting=csv.QUOTE_NONE,
              escapechar=' ', header=False)

    # df.to_csv(csv_path, index=False, headers=False)

# Optionnel : accès à un DataFrame spécifique
# Exemple : dfs["df_D_Company"]

# df=execute_queryPP(f' EXEC sp_helptext {table_names[0]}')
