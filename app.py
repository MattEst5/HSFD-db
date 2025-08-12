from flask import Flask, render_template, request, redirect, url_for, flash
import psycopg2
import os

app = Flask(__name__)
app.secret_key = "FirePlug_"

def connect():
    return psycopg2.connect(
        host="localhost",
        database="HSFD_",
        user="fireplug_",
        password="Emily!05"
    )

@app.route("/log_incident", methods=["GET", "POST"])
def log_incident():
    if request.method == "POST":
        incident_type = request.form["incident_type"]
        station_id = request.form["station_id"]
        dspch_notes = request.form["dspch_notes"]
        actions_taken = request.form["actions_taken"]

        try:
            conn = connect()
            cur = conn.cursor()

            cur.execute("""
                INSERT INTO incidents(incident_type, station_id, dspch_notes, actions_taken, call_time)
                VALUES (%s, %s, %s, %s, NOW())
            """, (incident_type, station_id, dspch_notes, actions_taken))

            conn.commit()
            cur.close()
            conn.close()

            flash("✅ Incident logged successfully!", "success")
            return redirect(url_for("log_incident"))
        except Exception as e:
            print("Error:", e)
            flash("❌ Failed to log incident.", "error")

    return render_template("log_incident.html")

if __name__ == "__main__":
    app.run(debug=True)