import logging
from datetime import datetime, timedelta

import pandas as pd


logger = logging.getLogger(__name__)


def validate_and_filter_df(df):
    """Return rows with valid dates and matching integer heart-rate zone data."""

    def is_valid_date(date_str):
        try:
            datetime.fromisoformat(date_str)
            return True
        except ValueError:
            return False

    def is_list_of_integers(value):
        return all(isinstance(item, int) for item in value)

    valid_rows = []
    for index, row in df.iterrows():
        start_date_local = row["start_date_local"]
        icu_hr_zones = row["icu_hr_zones"]
        icu_hr_zone_times = row["icu_hr_zone_times"]

        if (
            is_valid_date(start_date_local)
            and isinstance(icu_hr_zones, list)
            and isinstance(icu_hr_zone_times, list)
            and is_list_of_integers(icu_hr_zones)
            and is_list_of_integers(icu_hr_zone_times)
            and len(icu_hr_zones) == len(icu_hr_zone_times)
        ):
            valid_rows.append(row)

    return pd.DataFrame(valid_rows)


def process_data(df):
    """Sum heart-rate zone times by ISO week, including weeks without data."""
    df["start_date_local"] = pd.to_datetime(df["start_date_local"])
    df["week"] = (
        df["start_date_local"].dt.isocalendar().year.astype(str)
        + "-W"
        + df["start_date_local"].dt.isocalendar().week.apply(lambda week: f"{week:02d}")
    )

    weekly_sums = {}
    for index, row in df.iterrows():
        week = row["week"]
        hr_zones = row["icu_hr_zones"]
        hr_zone_times = row["icu_hr_zone_times"]

        if week not in weekly_sums:
            weekly_sums[week] = [0] * len(hr_zones)

        for i in range(len(hr_zones)):
            weekly_sums[week][i] += hr_zone_times[i]

    weekly_sums_df = pd.DataFrame.from_dict(
        weekly_sums,
        orient="index",
        columns=[f"zone_{i}" for i in range(1, 8)],
    )

    weekly_sums_df.reset_index(inplace=True)
    weekly_sums_df.rename(columns={"index": "week"}, inplace=True)

    unique_hr_zones = df["icu_hr_zones"].iloc[0]
    weekly_sums_df.columns = ["week"] + [
        f"Zone {i} (Max HR: {hr}bpm)" for i, hr in enumerate(unique_hr_zones, start=1)
    ]

    today = datetime.today()
    past_27_weeks = [(today - timedelta(weeks=i)).isocalendar()[:2] for i in range(27)]
    past_27_weeks = [f"{year}-W{week:02d}" for year, week in past_27_weeks]

    for week in past_27_weeks:
        if week not in weekly_sums_df["week"].values:
            weekly_sums_df = pd.concat(
                [weekly_sums_df, pd.DataFrame([[week] + [0] * 7], columns=weekly_sums_df.columns)],
                ignore_index=True,
            )

    weekly_sums_df.sort_values("week", inplace=True, ascending=False)
    weekly_sums_df.reset_index(drop=True, inplace=True)

    return weekly_sums_df


def convert_to_json(df):
    """Convert the DataFrame to a JSON string."""
    try:
        json_data = df.to_json(orient="records")
        logger.info("Data converted to JSON successfully.")
        return json_data
    except Exception as error:
        logger.error("Error converting data to JSON: %s", error)
        raise
