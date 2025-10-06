import json
# Define the file path (use r'' to avoid needing to double the backslashes)
file_path = r"C:\Repos\PTG.BI.PTSA.SSAS.RDL00001_Procurement_V2\RDL00001_Procurement_v2\RDL00001_Procurement_v2\model.bim"

# Load the JSON file into a Python dictionary
with open(file_path, "r", encoding="utf-8") as f:
    model_json = json.load(f)

# Remove all measures where the name contains 'YTD_'
for table in model_json["model"]["tables"]:
    if "measures" in table:
        original_count = len(table["measures"])
        table["measures"] = [m for m in table["measures"] if 'YTD_' not in m.get("name", "")]
        removed_count = original_count - len(table["measures"])
        if removed_count > 0:
            print(f"Removed {removed_count} YTD_ measures from table: {table['name']}")
# 3. Save updated model (overwrite or new file)
#!dont forget to update first the original model.bim
with open("modelbim2.json", "w", encoding="utf-8") as f:
    json.dump(model_json, f, indent=2)
