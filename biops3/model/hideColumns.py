import json
# Define the file path (use r'' to avoid needing to double the backslashes)
file_path = r"C:\Repos\PTG.BI.PTSA.SSAS.RDL00001_Procurement_V2\RDL00001_Procurement_v2\RDL00001_Procurement_v2\model.bim"

# Load the JSON file into a Python dictionary
with open(file_path, "r", encoding="utf-8") as f:
    model_json = json.load(f)


# Define columns to hide as a list of (table, column) tuples
columns_to_hide = [
    ("D_PO_OrderDate", "Id"),
    ("D_PO_GL_Date", "Id"),
    ("D_PO_ReceiptDate", "Id"),
    ("D_PO_RequestDate", "Id"),
    ("D_PO_Promised_DeliveryDate", "Id"),
    ("D_PO_Original_PromisedDate", "Id"),
    ("D_PO_CancelDate", "Id"),
    ("D_PO_Supplier_First_PromiseDate", "Id"),
    ("D_date_Effective_Thru", "Id"),
    ("D_date_Effective_From", "Id"),
    ("D_ItemBranch", "ItemBranchkey"),
    ("D_ItemMaster", "ItemKey"),
    ("F_PurchaseOrderLine", "ItemKey"),
    ("F_PurchaseOrderLine", "ItemBranchkey"),
    ("F_PurchaseOrderLine", "BranchKey"),
    ("D_Supplier", "SupplierKey"),
    ("D_Company", "Companykey"),
    ("D_Branch", "BranchKey"),
    ("F_ProductCost_Purchase", "ItemKey"),
    ("F_ProductCost_Purchase", "ItemBranchkey"),
    ("F_ProductCost_Purchase", "BranchKey"),
    ("Currency Conversion by Date", "Date_key"),
    ("D_Catalog", "CatalogKey"),
    ("F_PurchaseOrderLine", "OriginalAmount_cad_V0")
]

# Convert to set for efficient lookup
columns_to_hide_set = set(columns_to_hide)

# Update the model_json to hide the specified columns
for table in model_json['model']['tables']:
    table_name = table['name']
    for column in table.get('columns', []):
        col_name = column['name']
        if (table_name, col_name) in columns_to_hide_set:
            column['isHidden'] = True


# 3. Save updated model (overwrite or new file)
#!dont forget to update first the original model.bim
with open("modelbim2.json", "w", encoding="utf-8") as f:
    json.dump(model_json, f, indent=2)
