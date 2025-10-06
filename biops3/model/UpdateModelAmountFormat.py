import json
from copy import deepcopy


# Step 1: Load the JSON file into a Python dictionary
#!dont forget tho update the original model
with open("modelbim.json", "r", encoding="utf-8") as f:
    model_json = json.load(f)

target_measures = {
    "Active_Amount_PO",
    "Cancelled_Amount_PO",
    "LYTD_Cancelled_Amount_PO",
    "LYTD_Total_Amount_PO",
    "LYTD_Total_Amount_PO_Freight",
    "LYTD_Total_Amount_PO_Rush",
    "LYTD_Total_Amount_PO_Tariffs",
    "Not_Received_Amount_PO",
    "Total_Amount_PO",
    "Total_Amount_PO_Freight",
    "Total_Amount_PO_Rush",
    "Total_Amount_PO_Tariffs",
    "YTD_Cancelled_Amount_PO",
    "YTD_Total_Amount_PO",
    "YTD_Total_Amount_PO_Freight",
    "YTD_Total_Amount_PO_Rush",
    "YTD_Total_Amount_PO_Tariffs",
    "Not_Received_Original_Amount_PO"

}

# Update formatString for target measures
# Define the annotation to add
currency_annotation = {
    "name": "Format",
    "value": "<Format Format=\"Currency\" Accuracy=\"2\"><Currency LCID=\"4105\" DisplayName=\"\" Symbol=\"\" PositivePattern=\"0\" NegativePattern=\"1\" /></Format>"
}

# Update formatString and annotations for target measures
for table in model_json["model"]["tables"]:
    for measure in table.get("measures", []):
        if measure["name"] in target_measures:
            measure["formatString"] = "\"\"#,0.00;-\"\"#,0.00;\"\"#,0.00"
            # Add or update annotation
            if "annotations" not in measure:
                measure["annotations"] = []
            existing = next(
                (a for a in measure["annotations"] if a["name"] == "Format"), None)
            if existing:
                existing["value"] = currency_annotation["value"]
            else:
                measure["annotations"].append(currency_annotation)

            print(f"Processing table: {table['name']}")
            print(f"  Updating column: {measure['name']}")
# Save updated JSON if desired
#!dont forget tho update the original model avant de faire les changements.
#!le script prendre ce fichier qui est dans cet dossier/ folder
with open("SemanticModel_intUpdated.json", "w", encoding="utf-8") as f:
    json.dump(model_json, f, indent=2)
