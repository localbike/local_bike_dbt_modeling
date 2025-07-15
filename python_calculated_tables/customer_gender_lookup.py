# CREATED BY : reusnep@consulting-agency.com
# LAST UPDATE: 2025-07-14

import pandas as pd
import gender_guesser.detector as gender
from google.cloud import bigquery
from pandas_gbq import to_gbq

# Initialize the BigQuery client
client = bigquery.Client(project="local-bike-data-platform")

# Initialize the gender detector
d = gender.Detector()

# --------- Step 1: Function to detect and normalize gender values --------- #

def detect_gender(name):
    """
    Uses the gender-guesser library to detect gender from a first name.
    Maps raw results to simplified categories: 'male', 'female', 'ambiguous', 'unknown'.
    """
    raw = d.get_gender(name)
    mapping = {
        "male": "male",
        "mostly_male": "male",
        "female": "female",
        "mostly_female": "female",
        "andy": "unknown",
        "unknown": "unknown"
    }
    return mapping.get(raw, "unknown")

# --------- Step 2: Generic function to enrich a dataset with gender info --------- #

def enrich_gender(table_name, first_name_field, destination_table):
    """
    Fetches distinct first names from a given BigQuery table,
    detects gender for each name, and writes the result to a destination table.
    
    Args:
        table_name (str): Source table name in BigQuery.
        first_name_field (str): Name of the column containing first names.
        destination_table (str): Destination table name for gender lookups.
    """
    query = f"""
        SELECT DISTINCT {first_name_field}
        FROM `local-bike-data-platform.local_bike_data_lake.{table_name}`
        WHERE {first_name_field} IS NOT NULL
    """
    df = client.query(query).to_dataframe()
    df["gender"] = df[first_name_field].apply(detect_gender)

    # Export the enriched gender data to BigQuery
    to_gbq(
        dataframe=df,
        destination_table=f'gender_lookups.{destination_table}',
        project_id='local-bike-data-platform',
        if_exists='replace'
    )
    print(f"✅ Gender enrichment complete: `{table_name}` → `{destination_table}`")

# --------- Step 3: Apply the enrichment to 'customers' and 'staffs' tables --------- #

enrich_gender("customers", "first_name", "customers_gender")
enrich_gender("staffs", "first_name", "staffs_gender")
