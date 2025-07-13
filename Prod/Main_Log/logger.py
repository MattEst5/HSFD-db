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


def main_menu():
    conn = connect()

    while True:
        print("\n🔥 Main Menu 🔥")
        print("1. Log new incident")
        print("2. Log new shift")
        print("3. Check last incident")
        print("4. Exit")

        choice = input("Select an option (1-4): ")

        if choice == "1":
            log_new_incident(conn)
        elif choice == "2":
            log_new_shift(conn)
        elif choice == "3":
            check_last_incident(conn)
        elif choice == "4":
            print("Goodbye!")
            conn.close()
            break
        else:
            print("❌ Invalid choice. Please enter 1-4.")

def log_new_incident(conn):
    try:
        print("🚨Incident Logger🚨")
        print("Connected to HSFD.db")

        while True:
            incident_data = {
                "incident_type": "",
                "station_id": "",
                "dspch_notes": "",
                "actions_taken": "",
                "duration_hours": "",
                "call_time": "",
                "enrt_time": "",
                "arrival_time": "",
                "completed_time": "",
            }

            #Prompt user for inputs
            for field in incident_data:
                if field == "duration_hours":
                    continue

                value = input(f"Enter {field.replace('_', ' ')} (or type 'cancel' to exit) ")  

                if value.lower() == 'cancel':
                    print("❌ Logging cancelled.")
                    return
                
                if field in ["enrt_time", "arrival_time", "completed_time", "call_time"]:
                    try:
                        datetime.strptime(value, "%Y-%m-%d %H:%M:%S")
                    except ValueError:
                        print("❌ Invalid datetime format. Use YYYY-MM-DD HH:MM:SS. Logging cancelled.")

                incident_data[field] = value

            if incident_data["arrival_time"] and incident_data["completed_time"]:
                arrival_dt = datetime.strptime(incident_data["arrival_time"], "%Y-%m-%d %H:%M:%S")
                completed_dt = datetime.strptime(incident_data["completed_time"], "%Y-%m-%d %H:%M:%S")
                duration = completed_dt - arrival_dt
                incident_data["duration_hours"] = round(duration.total_seconds() / 3600, 2)
            else:
                incident_data["duration_hours"] = 0                   

            #Display review summary
            print("\n📝 Please review your entry:")
            for key, val in incident_data.items():
                print(f"{key.replace('_', ' ').title()}: {val}")

            choice = input("\nConfirm? (y/n/edit/cancel): ").lower()

            if choice == 'y':
                #Insert incident and get its ID
                incident_id = insert_incident(
                    conn,
                    incident_data["incident_type"],
                    incident_data["station_id"],
                    incident_data["dspch_notes"],
                    incident_data["actions_taken"],
                    incident_data["duration_hours"],
                    incident_data["call_time"],
                    incident_data["enrt_time"],
                    incident_data["arrival_time"],
                    incident_data["completed_time"]
                )
                update_shift_ids(conn)
                print("✅ Incident inserted successfully.")

                while True:
                    unit_id = input(f"Enter Unit ID assigned to incident {incident_id} (or press Enter to skip): ")
                    if unit_id == "":
                        break
                    insert_incident_unit(conn, incident_id, unit_id)
                    
                print("✅ All units entered successfully.")

            elif choice == 'edit':
                field_to_edit = input("Which field would you like to edit?").lower().replace(' ', '_')
                if field_to_edit in incident_data:
                    new_value = input(f"Enter new value for {field_to_edit}: ")
                    incident_data[field_to_edit] = new_value
        
                    # Skip asking for the same field again, and go back to review
                    print("\n📝 Please review your entry:")
                    for key, val in incident_data.items():
                        print(f"{key.replace('_', ' ').title()}: {val}")

                    incident_id = insert_incident( 
                        conn,
                        incident_data["incident_type"],
                        incident_data["station_id"],
                        incident_data["dspch_notes"],
                        incident_data["actions_taken"],
                        incident_data["duration_hours"],
                        incident_data["call_time"],
                        incident_data["enrt_time"],
                        incident_data["arrival_time"],
                        incident_data["completed_time"]
                    )
                    update_shift_ids(conn)
                    print("✅ Incident inserted successfully.")

                    while True:
                        unit_id = input(f"Enter Unit ID assigned to incident {incident_id} (or press Enter to cancel) ")
                        if unit_id == "":
                            break
                        insert_incident_unit(conn, incident_id, unit_id)

                    print("✅ All units entered successfully.")


                else:
                    print("❌ Invalid field name.")
                    continue

            elif choice == 'cancel':
                print("❌ Logging cancelled.")
                return 
        
            else:
                print("❌ Entry discarded.")
                continue #Restart entire logging

            another = input("Add another incident? (y/n): ")
            if another.lower() != 'y':
                break 

        conn.close()
        print("Connection closed. Goodbye!")

    except Exception as e:
        print("Something went wrong:")
        print(e)

def log_new_shift(conn):
    try:
        conn = connect()
        print("🚨Shift Logger🚨")
        print("Connected to HSFD.db")

        shift_name = input("Enter shift name (A/B/C): ")
        shift_date = input("Enter shift date (YYYY-MM-DD): ")

        insert_shifts_for_day(conn, shift_name, shift_date)
        insert_firefightershifts_for_day(conn, shift_name, shift_date)

        conn.close()
        print("Connection closed. Goodbye!")

    except Exception as e:
        print("Something went wrong.")
        print(e)

def check_last_incident(conn):
    try:
        conn = connect()

        last_incident = get_last_incident(conn)
        if last_incident:
            print("\n---------------------------")
            print("📝 Last Incident Logged 📝")
            print(f"Incident ID: {last_incident[0]}")
            print(f"Type: {last_incident[1]}")
            print(f"Station ID: {last_incident[2]}")
            print(f"Description: {last_incident[3]}")
            print(f"Call_time: {last_incident[5]}")
            print("---------------------------")
        else:
            print("No incidents found.")

        conn.close()

    except Exception as e:
        print("Something went wrong.")
        print(e)

#Utility Functions for Incident Logger ------------------------------------
def insert_incident(conn, incident_type, station_id, dspch_notes, actions_taken, duration_hours, call_time, enrt_time, arrival_time, completed_time):
    cur = conn.cursor()
    insert_query = """
        INSERT INTO incidents(incident_type, station_id, dspch_notes, actions_taken, duration_hours, call_time, enrt_time, arrival_time, completed_time)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING incident_id;
    """
    cur.execute(insert_query, (incident_type, station_id, dspch_notes, actions_taken, duration_hours, call_time, enrt_time, arrival_time, completed_time))
    incident_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    print(f"✅ Incident inserted successfully with ID {incident_id}.")
    return incident_id 

def insert_incident_unit(conn, incident_id, unit_id):
    cur = conn.cursor()
    insert_query = """
        INSERT INTO incidentunits(incident_id, unit_id)
        VALUES(%s, %s);
    """
    cur.execute(insert_query, (incident_id, unit_id))
    conn.commit()
    cur.close()
    print(f"🚒 Unit {unit_id} added to incident {incident_id}.")

def update_shift_ids(conn):
    cur = conn.cursor()
    cur.execute("SELECT update_incident_shifts();")
    conn.commit()
    cur.close()
    print("✅ Shift IDs updated")
#-------------------------------------------------------------------------

#Utility Functions for Shift Logger -------------------------------------
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
    print(f"✅ ALL firefighter shifts logged for {shift_name} shift on {shift_date}.")
#----------------------------------------------------------------------------------------------------

#Utility Function for incident checker-------------------------------------------------------------
def get_last_incident(conn):
    cur = conn.cursor()
    insert_query = """
        SELECT * FROM incidents
        ORDER BY incident_id DESC
        LIMIT 1;
    """
    cur.execute(insert_query)
    last_incident = cur.fetchone()
    cur.close()
    return last_incident
#------------------------------------------------------------------------------------------------------

if __name__ == "__main__":
    main_menu()