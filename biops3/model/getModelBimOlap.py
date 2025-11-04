
# script to GET THE MODEL.BIM FROM THE OLAP SERVER

import os
import json

import clr
#1 Load TOM from GAC (no version pinning). If this fails, 
clr.AddReference(r"C:\Program Files (x86)\Microsoft SQL Server\130\SDK\Assemblies\Microsoft.AnalysisServices.Tabular")
clr.AddReference(r"C:\Program Files (x86)\Microsoft SQL Server\130\SDK\Assemblies\Microsoft.AnalysisServices.Core")

##2 IMPORT. REMEMBER FIR TO DO THE CLR REFERENCES
from Microsoft.AnalysisServices.Tabular import Server, JsonScripter

server_name = r"NADWOLAP1A"  # add \InstanceName if named
database_name = r"RDL00002_99011_GL_Transactions"


srv = Server()
srv.Connect(server_name)

db = srv.Databases.FindByName(database_name)
if db is None:
    raise Exception(f"Database '{database_name}' not found on '{server_name}'")

# Most versions support this overload without SerializationOptions
tmsl = JsonScripter.ScriptCreate(db)

# Parse and extract just the database metadata
doc = json.loads(tmsl)

# The wrapper could be { "create": { "database": { ... } } } or { "createOrReplace": {...} } or "alter"
# Handle common shapes robustly:
metadata = None
for cmd in ("create", "createOrReplace", "alter"):
    if cmd in doc:
        inner = doc[cmd]
        # sometimes database is nested, sometimes it's directly the object with "object":{database}
        if "database" in inner:
            metadata = inner["database"]
        elif "objects" in inner:
            # array of objects; find the database entry
            for obj in inner["objects"]:
                if obj.get("type") == "database" or "model" in obj:
                    metadata = obj
                    break
        break

# Fallback: some versions return an array of commands
if metadata is None and isinstance(doc, list):
    for item in doc:
        for cmd in ("create", "createOrReplace", "alter"):
            if cmd in item and "database" in item[cmd]:
                metadata = item[cmd]["database"]
                break
        if metadata:
            break

if metadata is None:
    # If everything fails, keep original but warn
    metadata = doc

script_dir = os.path.dirname(os.path.abspath(__file__))
output_path = os.path.join(script_dir, f"{database_name}_modelBim.json")


with open(output_path, "w", encoding="utf-8") as f:
    json.dump(metadata, f, ensure_ascii=False, indent=2)

srv.Disconnect()


# file: run_export.py

