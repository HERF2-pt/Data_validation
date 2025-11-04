# file: ssas_tabular_export.py

import json
import os

# Import pythonnet and TOM assemblies only when needed (so importing this module is lightweight)
def _load_tom():
    import clr
    try:
      clr.AddReference(r"C:\Program Files (x86)\Microsoft SQL Server\130\SDK\Assemblies\Microsoft.AnalysisServices.Tabular")
      clr.AddReference(r"C:\Program Files (x86)\Microsoft SQL Server\130\SDK\Assemblies\Microsoft.AnalysisServices.Core")
    except Exception as ex:
        raise ImportError("Failed to load TOM assemblies. Ensure SSMS/AMO-TOM client libraries are installed.") from ex
    from Microsoft.AnalysisServices.Tabular import Server, JsonScripter
    return Server, JsonScripter


def export_tabular_model_metadata(server_name, database_name, output_path=None):
    """
    Export only the metadata (database object JSON) for an SSAS Tabular database, without a TMSL Create wrapper.

    Parameters:
      - server_name (str): SSAS server name. Use 'Server\\Instance' for named instances.
      - database_name (str): Tabular database name.
      - output_path (str, optional): Full file path to write JSON.
        If None, writes '<cwd>/<database_name>_modelBim.json'.

    Returns:
      - output_path (str): The path to the written JSON file.

    Raises:
      - Exception/ImportError with helpful messages on failures.
    """
    Server, JsonScripter = _load_tom()

    # Connect
    srv = Server()
    try:
        srv.Connect(server_name)
        db = srv.Databases.FindByName(database_name)
        if db is None:
            raise ValueError(f"Database '{database_name}' not found on server '{server_name}'.")
        # Script to TMSL JSON (usually wrapped in a create/createOrReplace/alter)
        tmsl = JsonScripter.ScriptCreate(db)

        # Unwrap to pure database metadata
        doc = json.loads(tmsl)
        metadata = None

        # Common envelope keys
        for cmd in ("create", "createOrReplace", "alter"):
            if isinstance(doc, dict) and cmd in doc:
                inner = doc[cmd]
                if isinstance(inner, dict):
                    if "database" in inner:
                        metadata = inner["database"]
                    elif "objects" in inner and isinstance(inner["objects"], list):
                        for obj in inner["objects"]:
                            if isinstance(obj, dict) and (obj.get("type") == "database" or "model" in obj):
                                metadata = obj
                                break
                break

        # Some servers return an array of commands
        if metadata is None and isinstance(doc, list):
            for item in doc:
                if not isinstance(item, dict):
                    continue
                for cmd in ("create", "createOrReplace", "alter"):
                    if cmd in item and isinstance(item[cmd], dict) and "database" in item[cmd]:
                        metadata = item[cmd]["database"]
                        break
                if metadata is not None:
                    break

        if metadata is None:
            # Fallback: return the raw document if structure is unexpected
            metadata = doc

        # Resolve output path
        if not output_path:
            output_path = os.path.join(os.getcwd(), f"{database_name}_modelBim.json")

        # Ensure directory exists
        os.makedirs(os.path.dirname(output_path), exist_ok=True)

        # Write JSON
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(metadata, f, ensure_ascii=False, indent=2)

        return output_path

    finally:
        try:
            srv.Disconnect()
        except Exception:
            pass
