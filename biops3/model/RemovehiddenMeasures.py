import json

# Load the JSON file into a Python dictionary
with open("modelbim.json", "r", encoding="utf-8") as f:
    model_json = json.load(f)

# Remove measures with "isHidden": true for each table
for table in model_json["model"]["tables"]:
    if "measures" in table:
        original_count = len(table["measures"])
        table["measures"] = [m for m in table["measures"] if not m.get("isHidden", False)]
        removed_count = original_count - len(table["measures"])
        if removed_count > 0:
            print(f"Removed {removed_count} hidden measures from table: {table['name']}")

#! Overwrite the original model before any further changes
with open("modelbim2.json", "w", encoding="utf-8") as f:
    json.dump(model_json, f, indent=2)

# Continue with your additional logic or save as a new file if needed
