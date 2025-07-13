import psycopg2
from datetime import datetime, timedelta

shift_rosters = {
    'A': {
        1: [51, 26, 23, 50, 72, 11, 59, 7, 73],
        4: [3, 44, 54],
        7: [37, 8, 52],
        10: [9, 75, 27, 17, 65, 66, 69],
        13: [30, 40, 62]
    },
    'B': {
        2: [74, 4, 36, 47, 56, 28],
        5: [20, 32, 64],
        8: [24, 29, 68],
        11: [76, 14, 5, 21, 39],
        14: [55, 41, 6]
    },
    'C': {
        3: [15, 12, 49, 70, 45, 33, 67],
        6: [19, 18, 53],
        9: [31, 61, 43],
        12: [13, 35, 71, 22, 48, 58],
        15: [16, 25, 60]
    }
}

def connect():
    conn = psycopg2.connect(
        host="localhost",
        database="postgres",
        user="postgres",
        password=""
    )
    return conn

def insert_shifts_for_day(conn, shift_name, shift_date):
    cur = conn.cursor()

    #Query all station_shift_ids for the shift_name
    cur.execute("""
        SELECT station_shift_id
        FROM stationshifts
        WHERE shift_name = %s;
    """, (shift_name,))
    
    rows = cur.fetchall()
    
    for row in rows:
        station_shift_id = row[0]

        #Insert into shifts table
        insert_query = """
            INSERT INTO shifts(station_shift_id, shift_date, hours)
            VALUES(%s, %s, %s);
        """
        cur.execute(insert_query, (station_shift_id, shift_date, 24))

    conn.commit()
    cur.close()
    print(f"✅ALL {shift_name} shifts logged for {shift_date}.")

def insert_firefightershifts_for_day(conn, shift_name, shift_date):
    cur = conn.cursor()

    if shift_name not in shift_rosters:
        print(f"❌ No roster found for shift {shift_name}.")
        return
        
    roster = shift_rosters[shift_name]

    for station_shift_id, firefighter_ids in roster.items():
        for firefighter_id in firefighter_ids:
            start_time = f"{shift_date} 07:00:00"
            end_time_dt = datetime.strptime(shift_date, "%Y-%m-%d") + timedelta(days=1)
            end_time = end_time_dt.strftime("%Y-%m-%d 07:00:00")

            insert_query = """
                INSERT INTO firefightershifts(firefighter_id, station_shift_id, start_time, end_time)
                VALUES(%s, %s, %s, %s);
            """
        cur.execute(insert_query, (firefighter_id, station_shift_id, start_time, end_time))

    conn.commit()
    cur.close()
    print(f"✅ All firefighter shifts logged for {shift_name} shift on {shift_date}.")



def main():
    try:
        conn = connect()
        print("Connected to HSFD.db")

        shift_name = input("Enter shift name (A/B/C): ")
        shift_date = input("Enter shift date (YYYY-MM-DD): ")

        insert_shifts_for_day(conn, shift_name, shift_date)
        insert_firefightershifts_for_day(conn, shift_name, shift_date)

        conn.close()
        print("Connection closed. Goodbye!")

    except Exception as e:
        print("Something went wrong:")
        print(e)

if __name__ == "__main__":
    main()

