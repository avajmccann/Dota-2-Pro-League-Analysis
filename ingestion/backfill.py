# One-time historical backfill for pipeline

# Must run export commands in terminal before running to get keys

import datetime

from pipeline_common import (
    MATCH_FILES,
    get_gcs_bucket,
    get_kaggle_client,
    process_and_upload,
    process_constants,
)

def backfill():
    kaggle_api = get_kaggle_client()
    bucket = get_gcs_bucket()

    failures = []

    now = datetime.datetime.now()
    current_year = now.year
    current_month = now.month

    # All past years
    for year in range(2016, current_year):
        for file in MATCH_FILES:
            ok = process_and_upload(
                kaggle_api,
                bucket,
                kaggle_path=f"{year}/{file}",
                local_filename=file,
                gcs_destination_path=f"matches/{year}/{file}",
            )
            if not ok:
                failures.append(f"{year}/{file}")

    # 2. Every already-finished month of the current year
    for month in range(1, current_month):
        month_yyyymm = f"{current_year}{month:02d}"
        month_mm = f"{month:02d}"
        for file in MATCH_FILES:
            ok = process_and_upload(
                kaggle_api,
                bucket,
                kaggle_path=f"{month_yyyymm}/{file}",
                local_filename=file,
                gcs_destination_path=f"matches/{current_year}/{month_mm}/{file}",
            )
            if not ok:
                failures.append(f"{current_year}/{month_mm}/{file}")

    # 3. Reference/constants tables (heroes, leagues).
    constants_results = process_constants(kaggle_api, bucket)
    if not all(constants_results):
        failures.append("constants (heroes/leagues)")

    if failures:
        print(f"\nBackfill finished with {len(failures)} failure(s):")
        for f in failures:
            print(f"  - {f}")
        raise SystemExit(1)

    print("\nBackfill completed successfully -- all historical data loaded.")


if __name__ == "__main__":
    backfill()