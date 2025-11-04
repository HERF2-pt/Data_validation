import json
# Define the file path (use r'' to avoid needing to double the backslashes)
file_path = r"C:\Repos\RDL99011_BI\RDL00002_99011_SSAS_Sales_and_Orders\RDL00002_99011.Sales Orders\Sales Orders\RDL00002_99011_Sales and Orders.bim"

# Load the JSON file into a Python dictionary
# Define the fixed hierarchy structure
# Text to replace
oldText = r'"\"Product Name\",RELATED(Products[Product Name]),",'

# newText SQL block
newText = r'''"\"Product Name\",RELATED(Products[Product Name]),",
"\"Product Description\",RELATED(Products[Product Description]),",'''

# ++++++++++++++++++++++++++++++++++++++++++
# Read, replace, and write back
with open(file_path, "r", encoding="utf-8") as file:
    content = file.read()

updated_content = content.replace(oldText, newText)
# ----------------------------------------------
# 3. Save updated model (overwrite or new file)
#!dont forget to update first the original model.bim
with open("modelbim2.json", "w", encoding="utf-8") as f:
    f.write(updated_content)
