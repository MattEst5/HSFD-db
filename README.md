# 🚒 HSFD-db: Hot Springs Fire Department Database

## 🔥 Overview

This is a **relational PostgreSQL database and Python CLI toolkit** designed to simulate real-world fire department operations. Built from scratch for deep learning and career transition, this project includes robust data structures, automation tools, and realistic incident and staffing data.

Originally started in April 2025 as a SQL learning sandbox, **HSFD-db has evolved into a professional-grade database** with CLI tools for daily operational logging, reflecting true industry practices.

---

## 🧱 Schema Highlights

- **Firefighters:**  
  75 personnel with shift assignments and tracked work hours

- **Stations:**  
  5 fire stations serving the Hot Springs area

- **Units:**  
  Engines, ladders, rescues, and specialized apparatus assigned to stations

- **Incidents:**  
  Real incident data from April 10, 2025 onward, including call times, types, station assignments, and responding units

- **Shift System:**  
  Fully normalized schema with `stationshifts`, `shifts`, and `firefightershifts` tables enabling flexible and scalable staffing management

---

## 🛠️ Tools & Recent Improvements

### ✅ **CLI Automation Tools (2025-06)**
- **Incident Logger:**  
  Python tool to insert incidents with prompts, data validation, and linked units for each call

- **Shift Logger:**  
  Automates daily shift logging with dynamic firefighter assignments based on static shift rosters

### ✅ **Database Enhancements**
- Full schema normalization (**v3.0 – May 2025**)
- `update_incident_shifts()` function to auto-assign shifts based on incident call time
- Data integrity enforced via **foreign keys and composite primary keys**
- Improved daily workflow with CLI tools to support future GUI and full-stack integration

---

## ⚙️ SQL & Python Skills Demonstrated

- Advanced **JOINs**, **aggregations**, subqueries, and window functions
- User-defined functions and PL/pgSQL procedural logic
- Real-world CLI tools with Python, psycopg2, and dynamic user input handling
- Git version control, branching, and conflict resolution

---

## 🚀 What's Next

- Continuing structured Python learning to enable **Flask web development** for Firehouse RMS
- Building GUIs for daily data entry and operational dashboards
- Developing the long-term **Firehouse RMS** software vision for fire department data management, training, and operations

---

## 💡 Project Purpose

This database and toolset were created as part of my personal journey from a firefighter to a data and backend development professional, with the ultimate goal of building software to improve public safety operations and data management efficiency.

---

🔗 **Connect & Follow Along:**  
- [GitHub: MattEst5](https://github.com/MattEst5)

---
