from datetime import datetime
import pytest

def calculate_response(call_time, arrival_time):
    call_time_dt = datetime.strptime(call_time, "%Y-%m-%d %H:%M:%S")
    arrival_dt = datetime.strptime(arrival_time, "%Y-%m-%d %H:%M:%S")
    response = arrival_dt - call_time_dt
    return round(response.total_seconds() / 60, 2)

def test_calculate_response_normal():
    assert calculate_response("2025-07-13 12:00:00", "2025-07-13 12:10:00") == 10.0

def test_calculate_response_half_minute():
    assert calculate_response("2025-07-13 12:00:00", "2025-07-13 12:00:30") == 0.5

def test_calculate_response_invalid_dates():
    with pytest.raises(ValueError):
        calculate_response("bad_date", "another_bad_date")