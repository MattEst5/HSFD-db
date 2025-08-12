import sys
import os
sys.path.append(os.path.abspath("./Prod"))

from loggerV4 import Incident
from datetime import datetime

def test_calculate_duration_invalid_dates():
    incident = Incident(
        "Fire",
        1,
        "Test Dispatch",
        "Test Actions",
        "bad_date",
        "bad_date",
        "bad_date",
        "bad_date"
    )
    assert incident.duration_hours == 0
