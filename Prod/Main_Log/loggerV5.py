import os
import sys
from pathlib import Path
from datetime import datetime, timedelta

import psycopg2
from dotenv import load_dotenv
from rich.console import Console, Group
from rich.panel import Panel
from rich.prompt import Prompt
from rich.align import Align
from rich.table import Table
from rich.style import Style

console = Console()

# ---- Shift policy (24 -> 48 effective 2026-01-16) ----
SHIFT_CHANGEOVER_DATE = datetime.strptime("2026-01-16", "%Y-%m-%d").date()
SHIFT_START_CLOCK = "07:00:00"  # you can change later if needed

def get_shift_hours(shift_date_str: str) -> int:
    """
    Returns shift length in hours based on policy date.
    Before 2026-01-16 -> 24 hours
    On/after 2026-01-16 -> 48 hours
    """
    shift_date = datetime.strptime(shift_date_str, "%Y-%m-%d").date()
    return 24 if shift_date < SHIFT_CHANGEOVER_DATE else 48

def resource_path(relative_name: str) -> Path:
    """Resolve bundled resource path (dev + PyInstaller onefile)."""
    if getattr(sys, "frozen", False) and hasattr(sys, "_MEIPASS"):
        base = Path(sys._MEIPASS)          # temp extraction dir
    else:
        base = Path(__file__).resolve().parent  # script directory
    return base / relative_name

env_path = resource_path(".env")
load_dotenv(dotenv_path=env_path, override=True)

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

        hours = get_shift_hours(self.shift_date)

        # Build shift_start and shift_end timestamps
        shift_start_dt = datetime.strptime(f"{self.shift_date} {SHIFT_START_CLOCK}", "%Y-%m-%d %H:%M:%S")
        shift_end_dt = shift_start_dt + timedelta(hours=hours)

        for station_shift_id in self.roster.keys():
            insert_query = """
                INSERT INTO shifts(station_shift_id, shift_date, hours, shift_start, shift_end)
                VALUES(%s, %s, %s, %s, %s);
            """
            cur.execute(insert_query, (station_shift_id, self.shift_date, hours, shift_start_dt, shift_end_dt))

        conn.commit()
        cur.close()
        print(f"✅ All {self.shift_name} shifts logged for {self.shift_date} ({hours} hours).") 

    def insert_firefightershifts(self, conn):
        cur = conn.cursor()

        hours = get_shift_hours(self.shift_date)

        start_dt = datetime.strptime(f"{self.shift_date} {SHIFT_START_CLOCK}", "%Y-%m-%d %H:%M:%S")
        end_dt = start_dt + timedelta(hours=hours)

        for station_shift_id, firefighter_ids in self.roster.items():
            for firefighter_id in firefighter_ids:
                insert_query = """
                    INSERT INTO firefightershifts(firefighter_id, station_shift_id, start_time, end_time)
                    VALUES(%s, %s, %s, %s);
                """
                cur.execute(insert_query, (firefighter_id, station_shift_id, start_dt, end_dt))

        conn.commit()
        cur.close()
        print(f"✅ All firefighter shifts logged for {self.shift_name} shift on {self.shift_date} ({hours} hours).") 

shift_rosters = {
    "A": {
        1:  [7, 23, 26, 51, 54, 59, 76, 80],                 # Station 1 A
        4:  [3, 50, 71],                                     # Station 3 A
        7:  [8, 37, 66],                                     # Station 4 A
        10: [9, 27, 30, 44, 52, 74, 78],                     # Station 6 A
        13: [40, 65],                                        # Station 7 A
    },
    "B": {
        2:  [4, 28, 36, 47, 56, 57, 68, 72, 77],             # Station 1 B
        5:  [20, 32, 64],                                    # Station 3 B
        8:  [24, 29, 62],                                    # Station 4 B
        11: [5, 14, 21, 39, 75],                             # Station 6 B
        14: [6, 41, 55],                                     # Station 7 B
    },
    "C": {
        3:  [12, 15, 33, 45, 49, 58, 69, 70, 79],            # Station 1 C
        6:  [18, 19, 67],                                    # Station 3 C
        9:  [31, 43, 61],                                    # Station 4 C
        12: [13, 22, 35, 48, 63],                            # Station 6 C
        15: [16, 25, 60],                                    # Station 7 C
    },
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
        SELECT i.incident_id, i.incident_type, s.station_number, i.dspch_notes, i.duration_hours, i.call_time
        FROM incidents i
        JOIN stations s ON s.station_id = i.station_id
        ORDER BY i.incident_id DESC
        LIMIT 1;
        """
    cur.execute(insert_query)
    last_incident = cur.fetchone()
    cur.close()
    return last_incident

def get_station_id_from_number(conn, station_number: int) -> int | None:
    """
    Translate a public-facing station_number (e.g., 2, 6) into internal station_id.
    Returns None if not found.
    """
    cur = conn.cursor()
    cur.execute(
        "SELECT station_id FROM public.stations WHERE station_number = %s;",
        (station_number,)
    )
    row = cur.fetchone()
    cur.close()
    return row[0] if row else None  

def last_20(conn):
    cur = conn.cursor()
    insert_query = """
        SELECT i.incident_id,
        i.incident_type,
        s.station_number,
        i.dspch_notes,
        i.actions_taken,
        i.call_time,
        i.duration_hours,
        i.response_time
        FROM incidents i
        JOIN stations s ON s.station_id = i.station_id
        ORDER BY i.incident_id DESC
        LIMIT 20;    
    """
    cur.execute(insert_query)
    call_summary = cur.fetchall()
    return call_summary  

#-----------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------

def log_new_incident(conn):
    try:
        console.print("🚨 [bold red]Incident Logger[/bold red] 🚨")
        console.print("[cyan]Connected to HSFD.db[/cyan]")

        while True:
            incident_type = Prompt.ask("Enter [bold red]Incident Type[/bold red] (or type 'cancel' to exit)").strip().capitalize()
            if incident_type.lower() == 'cancel':
                console.print("[bold red]❌ Logging cancelled[/bold red]")
                return
            
            station_number_int = None
            station_id = None
            
            while True:
                station_number = Prompt.ask("Enter [bold red]Station Number[/bold red] (or type 'cancel' to exit)").strip()
                if station_number.lower() == 'cancel':
                    console.print("[bold red]❌ Logging cancelled[/bold red]")
                    return
                if not station_number.isdigit():
                    console.print("[bold red]❌ Station number must be a number.[/bold red]")
                    continue

                station_number_int = int(station_number)

                station_id = get_station_id_from_number(conn, station_number_int)
                if station_id is None:
                    console.print(f"[bold red]❌ Station Number {station_number_int} not found in stations table.[/bold red]")
                    continue

                break    
            
            dspch_notes = Prompt.ask("Enter [bold red]Dispatch Notes[/bold red] (or type 'cancel' to exit)").title()
            if dspch_notes.lower() == 'cancel':
                console.print("[bold red]❌ Logging cancelled[/bold red]")
                return
            
            actions_taken = Prompt.ask("Enter [bold red]Actions Taken[/bold red] (or type 'cancel' to exit)")
            if actions_taken.lower() == 'cancel':
                console.print("[bold red]❌ Logging cancelled[/bold red]")
                return
            
            call_time = Prompt.ask("Enter [bold red]Call Time (YYYY-MM-DD HH:MM:SS)[/bold red] (or type 'cancel' to exit)")
            if call_time.lower() == 'cancel':
                console.print("[bold red]❌ Logging cancelled[/bold red]")
                return
            
            enrt_time = Prompt.ask("Enter [bold red]Time Out (YYYY-MM-DD HH:MM:SS)[/bold red] (or type 'cancel' to exit)")
            if enrt_time.lower() == 'cancel':
                console.print("[bold red]❌ Logging cancelled[/bold red]")
                return
            
            arrival_time = Prompt.ask("Enter [bold red]Arrival Time (YYYY-MM-DD HH:MM:SS)[/bold red] (or type 'cancel' to exit)")
            if arrival_time.lower() == 'cancel':
                console.print("[bold red]❌ Logging cancelled[/bold red]")
                return
            
            completed_time = Prompt.ask("Enter [bold red]Time Completed (YYYY-MM-DD HH:MM:SS)[/bold red] (or type 'cancel' to exit)")
            if completed_time.lower() == 'cancel':
                console.print("[bold red]❌ Logging cancelled[/bold red]")
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
            review = Group(
            f"[bold cyan]Incident Type:[/bold cyan] {incident.incident_type}",
            f"[bold cyan]Station Number:[/bold cyan] {station_number_int}",
            f"[bold cyan]Dispatch Notes:[/bold cyan] {incident.dspch_notes}",
            f"[bold cyan]Actions Taken:[/bold cyan] {incident.actions_taken}",
            f"[bold cyan]Call Time:[/bold cyan] {incident.call_time}",
            f"[bold cyan]En Route:[/bold cyan] {incident.enrt_time}",
            f"[bold cyan]Arrival Time:[/bold cyan] {incident.arrival_time}",
            f"[bold cyan]Completed Time:[/bold cyan] {incident.completed_time}",
            f"[bold cyan]Duration (hrs):[/bold cyan] {incident.duration_hours}",
            f"[bold cyan]Response Time (min):[/bold cyan] {incident.response_time}",
            )

            console.print(Panel.fit(review, title="[bold yellow]📝 Review Incident Entry[/bold yellow]", border_style="bright_red"))

            choice = Prompt.ask("[bold green]Confirm? (y/n/cancel)[/bold green]").lower()

            if choice == 'y':
                incident_id = incident.insert_to_db(conn)
                update_shift_ids(conn)
                print(f"✅ Incident {incident_id} inserted successfully.")

                while True:
                    unit_id = input(f"Enter Unit ID assigned to incident {incident_id} (or press Enter to skip): ")
                    if unit_id == "":
                        break
                    insert_incident_unit(conn, incident_id, unit_id)

                console.print("✅ [bold green] All units entered successfully.[bold green]")

            elif choice == 'cancel':
                print("❌ Logging cancelled")
                return
            
            else:
                print("❌ Entry discarded. Restarting entry.")
                continue

            another = input("\nAdd another incident? (y/n): ")
            if another.lower() != 'y':
                break

        print("Goodbye! 👋")

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
                f"[bold cyan]Station Number:[/bold cyan] {last_incident[2]}\n"
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

#Rich Table integration; 2nd func below
def incident_summary(conn):
    try:
        inc_summary = last_20(conn)
        incident_summary_table(inc_summary)

    except Exception as e:
        console.print("[bold red]❌ Something went wrong.[/bold red]")
        console.print(f"[italic]{e}[/italic]")

def incident_summary_table(inc_summary):

    table = Table(title="🔥 HSFD Incident Summary 🔥", border_style="bright_red")

    table.add_column("ID", justify="center", style="cyan", no_wrap=True)        
    table.add_column("Type", style=None)
    table.add_column("Station", justify="center", style="green")
    table.add_column("Dispatch Notes", style="white")
    table.add_column("Actions Taken", style="white")
    table.add_column("Call Time", style="yellow")
    table.add_column("Duration (hrs)", justify="right", style="blue")
    table.add_column("Response (min)", justify="right", style="blue")

    for incident in inc_summary:
        row_style = None

        if incident[1].lower() == "fire":
            row_style = "bold red"
        elif incident[1].lower() == "medical":
            row_style = "bold blue"
        elif incident[1].lower() == "other":
            row_style = "bold magenta"
        else:
            row_style = "white"
    
        table.add_row(
            str(incident[0]),              #ID
            incident[1],                   #Type
            "Station" + " " + str(incident[2]),  #Station
            incident[3],                   #Dispatch Notes
            incident[4],                   #Actions Taken
            str(incident[5]),              #Call Time
            str(incident[6]),              #Duration
            str(incident[7]),               #Response Time
            style=row_style
        )

        table.add_row(*["-" * 5 for _ in range(8)], style="dim")

    console.print(table)

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