# Recurring refresh for current month, run by GitHub Actions

import datetime
import sys

from pipeline_common import MATCH_FILES, get_gcs_bucket, get_kaggle_client, process_and_upload


def refresh():
    kaggle_api = get_kaggle_client()
    bucket = get_gcs_bucket()

    now = datetime.datetime.now()
    current_year = now.year
    current_month = now.month
    month_yyyymm = f"{current_year}{current_month:02d}"
    month_mm = f"{current_month:02d}"

    failures = []
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

    if failures:
        print(f"\nRefresh finished with {len(failures)} failure(s):")
        for f in failures:
            print(f"  - {f}")
        sys.exit(1)  # non-zero exit -> GitHub Actions marks the run failed

    print(f"\nRefresh completed successfully for {current_year}-{month_mm}.")


if __name__ == "__main__":
    refresh()