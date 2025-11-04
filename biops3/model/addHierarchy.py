import json

# Define the file path
file_path = r"C:\Repos\PTG.BI.PTSA.SSAS.RDL00001_Procurement\RDL00001_Procurement_v2\RDL00001_Procurement_v2\model.bim"

# Load the JSON file
with open(file_path, "r", encoding="utf-8") as f:
    model_json = json.load(f)

# Define the new YMW hierarchy
new_hierarchy = {
    "name": "YMW",
    "levels": [
        {"name": "Year", "ordinal": 0, "column": "Year"},
        {"name": "Month", "ordinal": 1, "column": "Month"},
        {"name": "WeekOfYear", "ordinal": 2, "column": "WeekOfYear"}
    ]
}

# Define target tables
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

# Add YMW hierarchy to target tables
for table in model_json["model"]["tables"]:
    if table["name"] in target_tables:
        if "hierarchies" not in table:
            table["hierarchies"] = []
        table["hierarchies"].append(new_hierarchy.copy())
        print(f"Added 'YMW' hierarchy to table '{table['name']}'")

# Save the updated model
with open("modelbim2.json", "w", encoding="utf-8") as f:
    json.dump(model_json, f, indent=2)
