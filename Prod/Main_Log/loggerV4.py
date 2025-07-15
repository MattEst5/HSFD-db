import psycopg2
from datetime import datetime, timedelta
from dotenv import load_dotenv, find_dotenv
import os
from rich.console import Console, Group
from rich.panel import Panel
from rich.prompt import Prompt
from rich.align import Align

console = Console()
load_dotenv(find_dotenv())

class Incident:
    def __init__(self, incident_type, station_id, dspch_notes, actions_taken, call_time, enrt_time, arrival_time, completed_time):
        self.incident_type = incident_type
        self.station_id = station_id
        self.dspch_notes = dspch_notes
        self.actions_taken = actions_taken
        self.call_time = call_time
        self.enrt_time = enrt_time
        self.arrival_time = arrival_time
        self.completed_time = completed_time 

        self.duration_hours = self.calculate_duration()
        self.response_time = self.calculate_response()

    def calculate_duration(self):
        try:
            arrival_dt = datetime.strptime(self.arrival_time, "%Y-%m-%d %H:%M:%S")
            completed_dt = datetime.strptime(self.completed_time, "%Y-%m-%d %H:%M:%S")
            duration = completed_dt - arrival_dt
            return round(duration.total_seconds() / 3600, 2)
        except Exception as e:
            print(f"❌ Duration calculation error: {e}")
            return 0
        
    def calculate_response(self):
        try:
            call_time_dt = datetime.strptime(self.call_time, "%Y-%m-%d %H:%M:%S")
            arrival_dt = datetime.strptime(self.arrival_time, "%Y-%m-%d %H:%M:%S")
            response = arrival_dt - call_time_dt
            return round(response.total_seconds() / 60, 2)
        except Exception as e:
            print(f"❌ Response time calculation error: {e}")
            return 0
        
    def insert_to_db(self, conn):
        cur = conn.cursor()
        insert_query = """
            INSERT INTO incidents(
                incident_type,
                station_id,
                dspch_notes,
                actions_taken,
                duration_hours,
                response_time,
                call_time,
                enrt_time,
                arrival_time,
                completed_time)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                RETURNING incident_id;            
        """
        cur.execute(insert_query, (
            self.incident_type,
            self.station_id,
            self.dspch_notes,
            self.actions_taken,
            self.duration_hours,
            self.response_time,
            self.call_time,
            self.enrt_time,
            self.arrival_time,
            self.completed_time,
        ))
        incident_id = cur.fetchone()[0]
        conn.commit()
        cur.close()
        print(f"✅ Incident inserted successfully with ID {incident_id}.")
        return incident_id

class Shift:
    def __init__(self, shift_name, shift_date, roster):
        self.shift_name = shift_name
        self.shift_date = shift_date
        self.roster = roster    

    def insert_shifts(self, conn):
        cur = conn.cursor()
        for station_shift_id in self.roster.keys():
            insert_query = """
                INSERT INTO shifts(station_shift_id, shift_date, hours)
                VALUES(%s, %s, %s);
            """
            cur.execute(insert_query, (station_shift_id, self.shift_date, 24))
        conn.commit()
        cur.close()
        print(f"✅ All {self.shift_name} shifts logged for {self.shift_date}.")   

    def insert_firefightershifts(self,conn):
        cur = conn.cursor()

        for station_shift_id, firefighter_ids in self.roster.items():
            for firefighter_id in firefighter_ids:
                start_time = f"{self.shift_date} 07:00:00"
                end_time_dt = datetime.strptime(self.shift_date, "%Y-%m-%d") + timedelta(days=1)
                end_time = end_time_dt.strftime("%Y-%m-%d 07:00:00")

                insert_query = """
                    INSERT INTO firefightershifts(firefighter_id, station_shift_id, start_time, end_time)
                    VALUES(%s, %s, %s, %s);
                """
                cur.execute(insert_query, (firefighter_id, station_shift_id, start_time, end_time))

        conn.commit()
        cur.close()
        print(f"✅ All firefighter shifts logged for {self.shift_name} shift on {self.shift_date}.") 

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

#----------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------
def connect():
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD") 
    ) 
    return conn
    
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

def last_20(conn):
    cur = conn.cursor()
    insert_query = """
        SELECT incident_id, incident_type, station_id, dspch_notes, actions_taken, call_time, duration_hours, response_time
        FROM incidents
        ORDER BY incident_id DESC
        LIMIT 20    
    """
    cur.execute(insert_query)
    call_summary = cur.fetchall()
    return call_summary  

#-----------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------

def log_new_incident(conn):
    try:
        print("🚨Incident Logger🚨")
        print("Connected to HSFD.db")

        while True:
            incident_type = input("Enter Incident Type (or type 'cancel' to exit): ")
            if incident_type.lower() == 'cancel':
                print("❌ Logging cancelled")
                return
            
            station_id = input("Enter Station ID (or type 'cancel' to exit): ")
            if station_id.lower() == 'cancel':
                print("❌ Logging cancelled")
                return
            
            dspch_notes = input("Enter Dispatch Notes (or type 'cancel' to exit): ")
            if dspch_notes.lower() == 'cancel':
                print("❌ Logging cancelled")
                return
            
            actions_taken = input("Enter actions taken (or type 'cancel' to exit): ")
            if actions_taken.lower() == 'cancel':
                print("❌ Logging cancelled")
                return
            
            call_time = input("Enter call time(YYYY-MM-DD HH:MM:SS) (or type 'cancel' to exit): ")
            if call_time.lower() == 'cancel':
                print("❌ Logging cancelled")
                return
            
            enrt_time = input("Enter en route time(YYYY-MM-DD HH:MM:SS) (or type 'cancel' to exit): ")
            if enrt_time.lower() == 'cancel':
                print("❌ Logging cancelled")
                return
            
            arrival_time = input("Enter arrival time(YYYY-MM-DD HH:MM:SS) (or type 'cancel' to exit): ")
            if arrival_time.lower() == 'cancel':
                print("❌ Logging cancelled")
                return
            
            completed_time = input("Enter completed time(YYYY-MM-DD HH:MM:SS) (or type 'cancel' to exit): ")
            if completed_time.lower() == 'cancel':
                print("❌ Logging cancelled")
                return
            
            incident = Incident(
                incident_type,
                station_id,
                dspch_notes,
                actions_taken,
                call_time,
                enrt_time,
                arrival_time,
                completed_time
            )

            #Display review summary
            print("\n📝 Please review your entry:")
            print(f"Incident Type: {incident.incident_type}")
            print(f"Station ID: {incident.station_id}")
            print(f"Dispatch Notes: {incident.dspch_notes}")
            print(f"Actions Taken: {incident.actions_taken}")
            print(f"Call Time: {incident.call_time}")
            print(f"En Route: {incident.enrt_time}")
            print(f"Arrival Time: {incident.arrival_time}")
            print(f"Completed Time: {incident.completed_time}")
            print(f"Duration Hours: {incident.duration_hours}")
            print(f"Response Time: {incident.response_time}")

            choice = input("\nConfirm? (y/n/cancel): ").lower()

            if choice == 'y':
                incident_id = incident.insert_to_db(conn)
                update_shift_ids(conn)
                print(f"✅ Incident {incident_id} inserted successfully.")

                while True:
                    unit_id = input(f"Enter Unit ID assigned to incident {incident_id} (or press Enter to skip): ")
                    if unit_id == "":
                        break
                    insert_incident_unit(conn, incident_id, unit_id)

                print("✅ All units entered successfully.")

            elif choice == 'cancel':
                print("❌ Logging cancelled")
                return
            
            else:
                print("❌ Entry discarded. Restarting entry.")
                continue

            another = input("\nAdd another incident? (y/n): ")
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

        if shift_name in shift_rosters:
            roster = shift_rosters[shift_name]
            shift = Shift(shift_name, shift_date, roster)
            shift.insert_shifts(conn)
            shift.insert_firefightershifts(conn)
        else:
            print(f"❌ No roster found for shift {shift_name}.")

        conn.close()
        print("Connection closed. Goodbye!")

    except Exception as e:
        print("Something went wrong.")
        print(e)

def check_last_incident(conn):
    try:
        conn = connect()
        last_incident = get_last_incident(conn)

        console.clear()

        if last_incident:
            header = Align.center("[bold red]🔥 Last Incident Logged 🔥[/bold red]")
            details = (
                f"[bold cyan]Incident ID:[/bold cyan] {last_incident[0]}\n"
                f"[bold cyan]Type:[/bold cyan] {last_incident[1]}\n"
                f"[bold cyan]Station ID:[/bold cyan] {last_incident[2]}\n"
                f"[bold cyan]Description:[/bold cyan] {last_incident[3]}\n"
                f"[bold cyan]Call Time:[/bold cyan] {last_incident[5]}"
            )

            panel_content = Group(
                header,
                details
            )

            check_panel = Panel.fit(
                panel_content,
                title="[bold yellow]🔥 FireHouse 🔥[/bold yellow]",
                border_style="bright_red"
            )

            console.print(check_panel)
        else:
            console.print(Panel("[bold red]No incidents found.[/bold red]", title="⚠️ Alert", border_style="red"))

        conn.close()

    except Exception as e:
        console.print("[bold red]❌ Something went wrong.[/bold red]")
        console.print(f"[italic]{e}[/italic]")

def incident_summary(conn):
    try:
        print("Connected to HSFD.db")

        inc_summary = last_20(conn)

        for incident in inc_summary:
            print(f"ID: {incident[0]} Type: {incident[1]}, Station: {incident[2]}, Dispatch: {incident[3]}, Actions: {incident[4]}, Call Time: {incident[5]}, Duration: {incident[6]}, Response Time: {incident[7]}")

    except Exception as e:
        print("Somthing went wrong")
        print(e)

#-----------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------

def main_menu():
    conn = connect()

    while True:
        header = Align.center("[bold red]🔥 HSFD Main Menu 🔥[/bold red]")

        menu_options = """
[cyan]1.[/cyan] 🚨 Log new [bold]incident[/bold]
[cyan]2.[/cyan] 🕒 Log new [bold]shift[/bold]
[cyan]3.[/cyan] 🔍 Check [bold]last incident[/bold]
[cyan]4.[/cyan] 📔 [bold]Incident Summary[/bold]
[cyan]5.[/cyan] ❌ [bold red]Exit[/bold red]
        """

        panel_content = Group(
            header,
            menu_options
        )

        menu_panel = Panel.fit(
            panel_content,
            title="[bold yellow]🔥 FireHouse 🔥[/bold yellow]",
            border_style="bright_red"
        )

        console.print(menu_panel)

        choice = Prompt.ask("[bold green]Select an option (1-5)[/bold green]")

        if choice == "1":
            log_new_incident(conn)
        elif choice == "2":
            log_new_shift(conn)
        elif choice == "3":
            check_last_incident(conn)
        elif choice == "4":
            incident_summary(conn)    
        elif choice == "5":
            console.print("[bold red]Goodbye![/bold red] 👋")
            conn.close()
            break
        else:
            console.print("[bold red]❌ Invalid choice. Please enter 1-5.[/bold red]")


if __name__ == "__main__":
    main_menu()