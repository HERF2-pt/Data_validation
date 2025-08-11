# fmt: off
import sqlite3
import pandas as pd
import openpyxl
from openpyxl import load_workbook
from connpd import execute_query
from connpp import execute_queryPP
import sys
import os

sys.path.append(os.path.abspath(os.path.join(
    os.path.dirname(__file__), '..', 'utils')))
# fmt: on
# isort: skip
###############################################


# from utils.connpd import execute_query
# from utils.connpp import execute_queryPP


table_names = [
    "D_Company",
    "D_CostCenter",
    "D_ItemBranch",
    "D_ItemMaster",
    "D_Supplier",
    "F_ProductCost_Purchase",
    "F_PurchaseOrderLine",
    "F_SafetyStock",
]

# Obtener la ruta absoluta del script actual
script_dir = os.path.dirname(os.path.abspath(__file__))
# Dictionnaire pour stocker les DataFrames
# Ruta completa al archivo SQLite
db_path = os.path.join(script_dir, "biops.db")
# Diccionario para guardar los DataFrames
# Crear conexión a archivo SQLite en la misma carpeta
conn = sqlite3.connect(db_path)
dataframes = {}


"""
    CREER LES TABLES DANS SQLLITE
"""
for table in table_names:
    """
        # Guardar en SQLite como tabla
    """
    query = f"SELECT  * FROM RDL00001_EnterpriseDataWarehouse.dbo.{table}"
    df_result = execute_queryPP(query)

    df_result.to_sql(table, conn, if_exists="replace", index=False)

    """
        # Guardar en SQLite como tabla END
    """

    # Create queries
    query2 = f"SELECT top 100 * FROM RDL00001_EnterpriseDataWarehouse.dbo.{table}"
    # Créer un DataFrame avec une seule colonne
    df = pd.DataFrame({"query": [query2]})

    csv_path = os.path.join(script_dir, f"{table}.sql")
    # Sauvegarder le DataFrame en CSV
    df.to_csv(csv_path, index=False, header=False)

"""
    fin
"""


# Cerrar la conexión
conn.close()
