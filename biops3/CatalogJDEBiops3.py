from selenium import webdriver
from bs4 import BeautifulSoup
import pandas as pd
import openpyxl
import time

# List of tables to scrape
table_list = [
    "F4311", "F4102", "F4111", "F0005", "F0006",
    "F4301", "F0101", "F0401", "F0010", "F0015",
    "F1113", "F4908", "F4101", "F4105", "F00092"
]

schema_url = "https://jde.erpref.com/920/Schema/Detail"

def main():
    # Extract column definitions from each table
    column_df = extract_table_structure(table_list)

    # Extract table descriptions from schema page
    description_df = extract_jde_tables(schema_url)

    # Prepare description DataFrame for merging
    description_df_renamed = description_df[['Name', 'Description']].rename(columns={'Name': 'TableName'})

    # Merge on TableName
    merged_df = column_df.merge(description_df_renamed, on='TableName', how='left')

    # Add date column
    merged_df["Date"] = pd.to_datetime("today")

    # Optional: rename columns for clarity
    merged_df = merged_df.rename(columns={'TableName': 'Table', 'Description': 'Description_table'})

    # Reorder columns
    final_df = merged_df[
        [
            "Table",
            "Description_table",
            "Field",
            "Description",
            "Data Type",
            "Length",
            "Column",
            "Date",
        ]
    ]

    # Save to Excel
    with pd.ExcelWriter("catalog.xlsx", engine="openpyxl", mode="a", if_sheet_exists="replace") as writer:
        final_df.to_excel(writer, sheet_name="JDE_WEB", startrow=2, index=False)

    print("✅ Excel file updated successfully.")

# Function to extract structure of each table
def extract_table_structure(tables):
    driver = webdriver.Chrome()
    results = []

    for table_name in tables:
        url = f"https://jde.erpref.com/920/Table/Detail/{table_name}"
        driver.get(url)
        time.sleep(5)

        soup = BeautifulSoup(driver.page_source, 'html.parser')
        table = soup.find('table', {'id': 'erpcolumns'})

        if table:
            df = pd.read_html(str(table))[0]
            df.columns = df.columns.str.strip()
            df['TableName'] = table_name
            results.append(df)
        else:
            print(f"⚠️ Table not found: {table_name}")

    driver.quit()

    combined_df = pd.concat(results, ignore_index=True)
    return combined_df

# Function to extract table descriptions from schema page
def extract_jde_tables(url):
    driver = webdriver.Chrome()
    driver.get(url)
    driver.implicitly_wait(10)

    soup = BeautifulSoup(driver.page_source, 'html.parser')
    tables = soup.find_all('table')
    dfs = [pd.read_html(str(table))[0] for table in tables]
    driver.quit()

    combined_df = pd.concat(dfs, ignore_index=True)
    filtered_df = combined_df[combined_df['Name'].isin(table_list)]

    return filtered_df

# Run the script
main()
