🔥 Overview
This is a relational PostgreSQL database designed to simulate real-world fire department operations, including incidents, firefighter staffing, shifts, stations, and unit deployment. Originally built from scratch for hands-on learning, this project has evolved through multiple schema refactors and now reflects industry-standard normalization, indexing, and relational integrity.

🧱 Schema Highlights
Firefighters: 75 personnel with shift assignments and tracked work hours

Stations: 7 locations serving the Hot Springs area

Units: Engines, ladders, rescues, etc. assigned to stations

Incidents: Real incident data from April 10 2025 onward, including call time, station, and linked responders

Shifts System: Fully normalized structure using stationshifts, shifts, and firefightershifts for flexible time tracking and analysis

🛠️ Recent Improvements
Full schema normalization (v3.0 – May 2025)

New update_incident_shifts() function to auto-assign shifts based on incident call time

Schema now reflects true many-to-many relationships between firefighters and shifts

Data integrity enforced with foreign keys and composite primary keys

⚙️ SQL Tools & Techniques Used
Subqueries & Window Functions

Joins & Aggregations

User-defined functions

Data backups & restoration

Schema refactoring and optimization

📈 What's Next
Building out views for analytical dashboards

Power BI integration

Adding incident daily

Public-facing queries for showcasing skills
