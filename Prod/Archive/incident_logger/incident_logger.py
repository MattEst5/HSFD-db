import psycopg2
from datetime import datetime

def connect():
    conn = psycopg2.connect( 
        host="localhost",
        database="postgres",
        user="postgres",
        password=""
    )
    return conn 

def main():
    try:
        conn = connect()
        print("Connected to HSFD.db")

        while True:
            incident_data = {
                "incident_type": "",
                "station_id": "",
                "description": "",
                "duration_hours": "",
                "call_time": ""
            }

            #Prompt user for inputs
            for field in incident_data:
                if field == "duration_hours":
                    value = input(f"Enter {field.replace('_', ' ')} (or type 'cancel' to exit): ")
                    if value.lower() == 'cancel':
                        print("❌ Logging cancelled.")
                        conn.close()
                        return
                    try:
                        minutes = float(value)
                        value = round(minutes / 60, 2)
                    except ValueError:
                        print("❌ Invalid input for duration. Logging cancelled.")
                        conn.close()
                        return
                else:
                    value = input(f"Enter {field.replace('_', ' ')} (or type 'cancel' to exit): ")
                    if value.lower() == 'cancel':
                        print("❌ Logging cancelled.")
                        conn.close()
                        return
                    
                incident_data[field] = value

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
                    incident_data["description"],
                    incident_data["duration_hours"],
                    incident_data["call_time"]
                )
                update_shift_ids(conn)
                print("✅ Incident inserted successfully.")

                while True:
                    unit_id = input(f"Enter unit_id assigned to incident {incident_id} (or press Enter to skip): ")
                    if unit_id == "":
                        break
                    insert_incident_unit(conn, incident_id, unit_id)

            elif choice == 'edit':
                field_to_edit = input("Which field would you like to edit?").lower().replace(' ', '_')
                if field_to_edit in incident_data:
                    new_value = input(f"Enter new value for {field_to_edit}: ")
                    incident_data[field_to_edit] = new_value
                    continue #Return to review loop
                else:
                    print("❌ Invalid field name.")
                    continue

            elif choice == 'cancel':
                print("❌ Logging cancelled.")
                conn.close()
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


def insert_incident(conn, incident_type, station_id, description, duration_hours, call_time):
    cur = conn.cursor()
    insert_query = """ 
        INSERT INTO incidents(incident_type, station_id, description, duration_hours, call_time)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING incident_id;
    """
    cur.execute(insert_query, (incident_type, station_id, description, duration_hours, call_time))
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
    print(f"✅ Unit {unit_id} added to incident {incident_id}.")

def update_shift_ids(conn):
    cur = conn.cursor()
    cur.execute("SELECT update_incident_shifts();")
    conn.commit()
    cur.close()
    print("✅ Shift IDs updated.")
    
if __name__ == "__main__":
    main()