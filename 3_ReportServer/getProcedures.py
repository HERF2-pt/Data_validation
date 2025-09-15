from openpyxl import load_workbook
import openpyxl
import pandas as pd

import sys
import os
# Añade la carpeta 'utils' al path
sys.path.append(os.path.abspath(os.path.join(
    os.path.dirname(__file__), '..', 'utils')))
from connpd import execute_query
from connpp import execute_queryPP
# from utils.connpd import execute_query
# from utils.connpp import execute_queryPP


table_names = [
    'Load_f_execution_log'

]
table_namesLoad = [
    'Load_f_execution_log',

]

# Agregar el prefijo 'dbo.Load_' a cada nombre de tabla
table_namesLoad = [f'dbo.{name}' for name in table_names]

# Obtener la ruta absoluta del script actual
script_dir = os.path.dirname(os.path.abspath(__file__))
# Dictionnaire pour stocker les DataFrames
dfs = {}

for table in table_namesLoad:
    # Exécute la requête
    query = f""" EXEC sp_helptext '{table}'"""
    df = execute_queryPP(f"{query}", database="RDL00005_Monitoring_BI")
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
