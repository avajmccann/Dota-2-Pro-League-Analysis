# Shared configuration and helper functions for Dota 2 pipeline
# Used by backfill.py and refresh.py

import json
import os

import pandas as pd
from google.cloud import storage
from kaggle.api.kaggle_api_extended import KaggleApi

# ---- Configuration ----

KAGGLE_DATASET = "bwandowando/dota-2-pro-league-matches-2023"
BUCKET_NAME = "dota2-analysis"
LOCAL_TMP_DIR = "./dota_tmp"

MATCH_FILES = ["picks_bans.csv", "players.csv", "main_metadata.csv", "teams.csv"]

CONSTANTS_FILES = {
    "Heroes.csv": "constants/Heroes.csv",
    "Leagues.csv": "constants/Leagues.csv",
}

# These two files have many columns, only specific ones need to be downloaded
COLUMNS_TO_KEEP = {
    "players.csv": [
        "player_slot", "firstblood_claimed", "account_id", "hero_id", "kills", "deaths",
        "assists", "level", "personaname", "radiant_win", "isRadiant", "win", "lose",
        "kills_per_min", "kda", "lane", "lane_role", "match_id", "leagueid",
    ],
    "main_metadata.csv": [
        "version", "match_id", "leagueid", "start_date_time", "duration", "radiant_win",
        "match_seq_num", "first_blood_time", "radiant_score", "dire_score",
        "radiant_team_id", "dire_team_id", "region", "throw", "loss", "comeback", "stomp",
    ],
}

# Authenticates Kaggle
def get_kaggle_client():

    for var in ("KAGGLE_USERNAME", "KAGGLE_KEY"):
        if not os.environ.get(var):
            raise EnvironmentError(
                "Missing required environment variable: {var}."
            )
    api = KaggleApi()
    api.authenticate()
    return api

# Authenticates Google Cloud Storage
# Must have FULL JSON KEY CONTENT in GCP_SA_KEY
def get_gcs_bucket():

    raw_key = os.environ.get("GCP_SA_KEY")
    if not raw_key:
        raise EnvironmentError(
            "Missing GCP_SA_KEY."
        )
    credentials_info = json.loads(raw_key)
    client = storage.Client.from_service_account_info(credentials_info)
    return client.bucket(BUCKET_NAME)

# Downloads a file from Kaggle dataset, sclices columns if needed
def process_and_upload(kaggle_api, bucket, kaggle_path, local_filename, gcs_destination_path):

    try:
        # Create local directory
        os.makedirs(LOCAL_TMP_DIR, exist_ok=True)
        # Download specified file
        kaggle_api.dataset_download_file(
            KAGGLE_DATASET, file_name=kaggle_path, path=LOCAL_TMP_DIR
        )
        # Get local file path
        downloaded_csv_path = os.path.join(LOCAL_TMP_DIR, local_filename)

        # Get target columns, slice if needed
        target_columns = COLUMNS_TO_KEEP.get(local_filename)
        if target_columns:
            df = pd.read_csv(downloaded_csv_path, usecols=target_columns)
        else:
            df = pd.read_csv(downloaded_csv_path)

        # Get new cleaned file path
        clean_local_path = os.path.join(LOCAL_TMP_DIR, f"clean_{local_filename}")
        df.to_csv(clean_local_path, index=False)

        # Upload to GCS
        blob = bucket.blob(gcs_destination_path)
        blob.upload_from_filename(clean_local_path)

        # Remove from local storage
        os.remove(downloaded_csv_path)
        os.remove(clean_local_path)

        # Success
        return True

    except Exception:
        print("Failed to process")
        return False

# Loads heroes/leagues reference tables
def process_constants(kaggle_api, bucket):
    results = []
    for filename, gcs_path in CONSTANTS_FILES.items():
        k_path = f"Constants/Constants.{filename}"
        results.append(process_and_upload(kaggle_api, bucket, k_path, filename, gcs_path))
    return results