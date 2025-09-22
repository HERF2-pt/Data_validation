
# cube_query.py
import adodbapi
import pandas as pd


def query_cube(query: str, server: str = 'cube01ProcurementPP.premiertech.com', cube: str = 'RDL00001_Procurement') -> pd.DataFrame:
    """
    Exécute une requête MDX sur un cube OLAP et retourne les résultats sous forme de DataFrame.

    :param query: Requête MDX à exécuter (obligatoire)
    :param server: Nom du serveur OLAP (par défaut: cube01ProcurementPP.premiertech.com)
    :param cube: Nom du cube ou catalogue (par défaut: RDL00001_Procurement)
    :return: DataFrame contenant les résultats de la requête
    """
    conn_str = (
        "Provider=MSOLAP;"
        f"Data Source={server};"
        f"Initial Catalog={cube};"
        "Integrated Security=SSPI;"
    )

    conn = adodbapi.connect(conn_str)
    cursor = conn.cursor()
    cursor.execute(query)

    rows = cursor.fetchall()
    columns = [col[0] for col in cursor.description]

    df = pd.DataFrame(rows, columns=columns)
    cursor.close()
    return df


# example
# df = query_cube('SELECT * FROM $system.mdschema_MEASURES')
# df.head()
