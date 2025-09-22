import json
from copy import deepcopy


# Step 1: Load the JSON file into a Python dictionary
#!dont forget tho update the original model
with open("modelbim.json", "r", encoding="utf-8") as f:
    model_json = json.load(f)

target_tables = {
    "D_PO_OrderDate",
    "D_PO_GL_Date",
    "D_PO_ReceiptDate",
    "D_PO_RequestDate",
    "D_PO_Promised_DeliveryDate",
    "D_PO_Original_PromisedDate",
    "D_PO_CancelDate",
    "D_PO_Supplier_First_PromiseDate",
    "D_date_Effective_Thru",
    "D_date_Effective_From"

}

target_columns = {
    "DayOfMonth",
    "FiscalMonth",
    "FiscalMonth_EU",
    "FiscalQuarter",
    "FiscalQuarter_EU",
    "FiscalWeekOfYear",
    "FiscalWeekOfYear_EU",
    "FiscalYear",
    "FiscalYear_EU",
    "MONTH",
    "WeekOfYear"
}


# 1. ###################
# Update tables/columns as specified
for table in model_json["model"]["tables"]:
    if table["name"] in target_tables:
        for column in table.get("columns", []):
            if column["name"] in target_columns:
                column["formatString"] = "0"
                column["sourceProviderType"] = "Integer"
                if column.get("dataType") != "int64":
                    column["dataType"] = "int64"


ymw_hierarchy = {
    "name": "YMW",
    "levels": [
        {"name": "Year", "ordinal": 0, "column": "Year"},
        {"name": "Month", "ordinal": 1, "column": "Month"},
        {"name": "WeekOfYear", "ordinal": 2, "column": "WeekOfYear"}
    ]
}

# 2. #### Inject hierarchy into each target table
for table in model_json["model"]["tables"]:
    if table["name"] in target_tables:
        if "hierarchies" not in table:
            table["hierarchies"] = []
        existing = next(
            (h for h in table["hierarchies"] if h["name"] == "YMW"), None)
        if not existing:
            table["hierarchies"].append(ymw_hierarchy)

# Save updated JSON if desired
#!dont forget tho update the original model avant de faire les changements. 
#!le script prendre ce fichier qui est dans cet dossier/ folder
with open("SemanticModel_intUpdated.json", "w", encoding="utf-8") as f:
    json.dump(model_json, f, indent=2)

for table in model_json["model"]["tables"]:
    if table["name"] in target_tables:
        print(f"Processing table: {table['name']}")  # Debug
        for column in table.get("columns", []):
            if column["name"] in target_columns:
                print(f"  Updating column: {column['name']}")  # Debug
