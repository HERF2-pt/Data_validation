import json
from copy import deepcopy

# Step 1: Load the JSON file into a Python dictionary
with open("modelbim.json", "r", encoding="utf-8") as f:
    model_json = json.load(f)

target_tables = {
    "D_P_OrderDate",
    "D_P_GL_Date",
    "D_P_ReceiptDate",
    "D_P_RequestDate",
    "D_P_Promised_DeliveryDate",
    "D_P_Original_PromisedDate",
    "D_P_InvoiceDate",
    "D_P_CancelDate"
}

target_columns = {
    "Date",
    "FirstDayOfMonth",
    "FirstDayOfYear",
    "FiscalFirstDayOfMonth",
    "FiscalFirstDayOfMonth_EU",
    "FiscalFirstDayOfYear",
    "FiscalFirstDayOfYear_EU",
    "FiscalLastDayOfMonth",
    "FiscalLastDayOfMonth_EU",
    "FiscalLastDayOfYear",
    "FiscalLastDayOfYear_EU",
    "LastDayOfMonth",
    "LastDayOfYear"
}

# The annotation to add
date_annotation = {
    "name": "Format",
    "value": "<Format Format=\"DateTimeShortDatePattern\" />"
}

# Update tables/columns as specified
for table in model_json["model"]["tables"]:
    if table["name"] in target_tables:
        for column in table.get("columns", []):
            if column["name"] in target_columns:
                # Set dataType and formatString (no comma at end!)
                column["dataType"] = "dateTime"
                column["formatString"] = "Short Date"
                # Handle annotations
                if "annotations" not in column:
                    column["annotations"] = []
                # Check if the annotation already exists
                existing = next(
                    (a for a in column["annotations"] if a["name"] == "Format"), None)
                if existing:
                    existing["value"] = date_annotation["value"]
                else:
                    column["annotations"].append(deepcopy(date_annotation))

# Save updated JSON if desired
with open("SemanticModel_updated.json", "w", encoding="utf-8") as f:
    json.dump(model_json, f, indent=2)

for table in model_json["model"]["tables"]:
    if table["name"] in target_tables:
        print(f"Processing table: {table['name']}")  # Debug
        for column in table.get("columns", []):
            if column["name"] in target_columns:
                print(f"  Updating column: {column['name']}")  # Debug
