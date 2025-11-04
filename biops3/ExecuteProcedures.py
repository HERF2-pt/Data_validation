from openpyxl import load_workbook
import pandas as pd
import os
from utils.connpd import execute_query, executeQuery


from utils.connpp import execute_queryPP

import sys
print(sys.path)


stored_procedure = "Load_D_DatesUpdate_Cube_Job"
result= executeQuery(stored_procedure)

stored_procedure = "select * from D_DatesUpdate_Cube"
result= executeQuery(stored_procedure)




print(exProcedureStocke)

exProcedureStocke = executeQuery("""
EXEC [dbo].[Load_D_DatesUpdate_Cube_Job]
""")

if exProcedureStocke:
    print("Procedure executed successfully.")
else:
    print("Procedure execution failed.")

# DW_dboPD.to_csv('DW_dboPD.csv', index=False)
