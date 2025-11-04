import json
# Define the file path (use r'' to avoid needing to double the backslashes)
file_path = r"C:\Repos\PTG.BI.PTSA.SSAS.RDL00001_Procurement_V2\RDL00001_Procurement_v2\RDL00001_Procurement\model.bim"

# Load the JSON file into a Python dictionary
with open(file_path, "r", encoding="utf-8") as f:
    model_json = json.load(f)
# Define the fixed hierarchy structure
fixed_hierarchy = {
    "name": "YMW_Fiscal",
    "levels": [
        {"name": "FiscalYear", "ordinal": 0, "column": "FiscalYear"},
        {"name": "FiscalMonth", "ordinal": 1, "column": "FiscalMonth"},
        {"name": "FiscalWeekOfYear", "ordinal": 2, "column": "FiscalWeekOfYear"}
    ]
}


#++++++++++++++++++++++++++++++++++++++++++
for table in model_json["model"]["tables"]:
    for idx, hierarchy in enumerate(table.get("hierarchies", [])):
        if "YMW" in hierarchy.get("name", ""):
            table["hierarchies"][idx] = fixed_hierarchy.copy()
            print(f"Replaced hierarchy '{hierarchy['name']}' in table '{table['name']}' at index {idx}")



#----------------------------------------------
# 3. Save updated model (overwrite or new file)
#!dont forget to update first the original model.bim
with open("modelbim2.json", "w", encoding="utf-8") as f:
    json.dump(model_json, f, indent=2)
