import psycopg2

def connect():
    conn = psycopg2.connect(
        host="localhost",
        database="postgres",
        user="postgres",
        password=""
    )
    return conn

def check_last_incident(conn):
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

def main():
    try:
        conn = connect()

        last_incident = check_last_incident(conn)
        print("The last incident logged was: ", last_incident)

        conn.close()
        print("Connection closed. Goodbye!")

    except Exception as e:
        print("Something went wrong.")
        print(e)

if __name__ == "__main__":
    main()