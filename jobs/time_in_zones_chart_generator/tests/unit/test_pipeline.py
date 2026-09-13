from datetime import datetime

import pandas as pd

from time_in_zones_chart_generator.pipeline import convert_to_json, process_data, validate_and_filter_df


def test_validate_and_filter_df_keeps_valid_rows():
    df = pd.DataFrame(
        [
            {
                "start_date_local": "2026-09-10T08:00:00",
                "icu_hr_zones": [100, 110, 120, 130, 140, 150, 160],
                "icu_hr_zone_times": [1, 2, 3, 4, 5, 6, 7],
            },
            {
                "start_date_local": "not-a-date",
                "icu_hr_zones": [100, 110],
                "icu_hr_zone_times": [1, 2],
            },
        ]
    )

    result = validate_and_filter_df(df)

    assert len(result) == 1
    assert result.iloc[0]["start_date_local"] == "2026-09-10T08:00:00"


def test_process_data_sums_zone_times_for_current_week():
    today = datetime.today()
    zones = [100, 110, 120, 130, 140, 150, 160]
    df = pd.DataFrame(
        [
            {
                "start_date_local": today.isoformat(),
                "icu_hr_zones": zones,
                "icu_hr_zone_times": [1, 2, 3, 4, 5, 6, 7],
            },
            {
                "start_date_local": today.isoformat(),
                "icu_hr_zones": zones,
                "icu_hr_zone_times": [10, 20, 30, 40, 50, 60, 70],
            },
        ]
    )
    expected_week = f"{today.isocalendar().year}-W{today.isocalendar().week:02d}"

    result = process_data(df)
    week_row = result[result["week"] == expected_week].iloc[0]

    assert len(result) == 27
    assert week_row["Zone 1 (Max HR: 100bpm)"] == 11
    assert week_row["Zone 7 (Max HR: 160bpm)"] == 77


def test_convert_to_json_uses_records_orientation():
    df = pd.DataFrame([{"week": "2026-W37", "zone_1": 12}])

    assert convert_to_json(df) == '[{"week":"2026-W37","zone_1":12}]'
