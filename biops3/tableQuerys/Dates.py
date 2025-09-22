import sys
import os
# Añade la carpeta 'utils' al path
sys.path.append(os.path.abspath(os.path.join(
    os.path.dirname(__file__), '..', 'utils')))
from connpp import execute_queryPP
from connpd import execute_query
import pandas as pd

import openpyxl
from openpyxl import load_workbook


select_columns = """
    TABLE_NAME
    ,TABLE_SCHEMA+'.'+TABLE_NAME as TABLE_FULL_NAME
	,COLUMN_NAME
	,DATA_TYPE	
 	,IS_NULLABLE
	,TABLE_CATALOG 
    ,GetDate() as Date
    ,ORDINAL_POSITION
	"""
#####################
###################
## Connect to the Data Lake and extract the catalog of JDE_BI_OPS
testDates = execute_queryPP(f"""
SELECT 
	{select_columns}
        
FROM [RDL00001_EnterpriseDataWarehouse].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE '%DimDate%' and TABLE_SCHEMA='Shared'
and  COLUMN_NAME IN (
    'Date',
    'DayOfMonth',
    'DayOfWeekName',
    'FirstDayOfMonth',
    'FirstDayOfYear',
    'FiscalFirstDayOfMonth',
    'FiscalFirstDayOfMonth_EU',
    'FiscalFirstDayOfYear',
    'FiscalFirstDayOfYear_EU',
    'FiscalLastDayOfMonth',
    'FiscalLastDayOfMonth_EU',
    'FiscalLastDayOfYear',
    'FiscalLastDayOfYear_EU',
    'FiscalMonth',
    'FiscalMonth_EU',
    'FiscalMonthName',
    'FiscalMonthName_EU',
    'FiscalQuarter',
    'FiscalQuarter_EU',
    'FiscalWeekOfYear',
    'FiscalWeekOfYear_EU',
    'FiscalYear',
    'FiscalYear_EU',
    'FiscalYearName',
    'FiscalYearName_EU',
    'Id',
    'LastDayOfMonth',
    'LastDayOfYear',
    'Month',
    'MonthName',
    'WeekOfYear',
    'Year'
)

ORDER BY TABLE_NAME,COLUMN_NAME""")

testDates.to_csv('SharedDimDateBiops3.csv', index=False)