--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: firefighters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.firefighters (
    firefighter_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    rank character varying(50),
    shift character varying(5),
    station_assignment integer,
    status character varying(20),
    hire_date date,
    unit_id integer,
    CONSTRAINT firefighters_shift_check CHECK (((shift)::text = ANY ((ARRAY['A'::character varying, 'B'::character varying, 'C'::character varying, 'Admin'::character varying])::text[]))),
    CONSTRAINT firefighters_status_check CHECK (((status)::text = ANY ((ARRAY['Active'::character varying, 'Retired'::character varying, 'Medical Leave'::character varying])::text[])))
);


ALTER TABLE public.firefighters OWNER TO postgres;

--
-- Name: firefighters_firefighter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.firefighters_firefighter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.firefighters_firefighter_id_seq OWNER TO postgres;

--
-- Name: firefighters_firefighter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.firefighters_firefighter_id_seq OWNED BY public.firefighters.firefighter_id;


--
-- Name: firefightershifts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.firefightershifts (
    firefighter_id integer NOT NULL,
    shift_id integer NOT NULL
);


ALTER TABLE public.firefightershifts OWNER TO postgres;

--
-- Name: incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidents (
    incident_id integer NOT NULL,
    incident_date date NOT NULL,
    incident_type character varying(50),
    station_id integer,
    description text,
    duration_hours numeric(5,2),
    CONSTRAINT incidents_duration_hours_check CHECK ((duration_hours > (0)::numeric)),
    CONSTRAINT incidents_incident_type_check CHECK (((incident_type)::text = ANY ((ARRAY['Fire'::character varying, 'Rescue'::character varying, 'Medical'::character varying, 'HazMat'::character varying, 'Alarm'::character varying, 'Other'::character varying])::text[])))
);


ALTER TABLE public.incidents OWNER TO postgres;

--
-- Name: incidents_incident_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incidents_incident_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.incidents_incident_id_seq OWNER TO postgres;

--
-- Name: incidents_incident_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incidents_incident_id_seq OWNED BY public.incidents.incident_id;


--
-- Name: incidentunits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidentunits (
    incident_id integer NOT NULL,
    unit_id integer NOT NULL
);


ALTER TABLE public.incidentunits OWNER TO postgres;

--
-- Name: shifts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shifts (
    shift_id integer NOT NULL,
    shift_name character varying(5),
    station_id integer,
    shift_date date,
    hours integer,
    CONSTRAINT shifts_shift_name_check CHECK (((shift_name)::text = ANY ((ARRAY['A'::character varying, 'B'::character varying, 'C'::character varying, 'Admin'::character varying])::text[])))
);


ALTER TABLE public.shifts OWNER TO postgres;

--
-- Name: shifts_shift_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shifts_shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shifts_shift_id_seq OWNER TO postgres;

--
-- Name: shifts_shift_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shifts_shift_id_seq OWNED BY public.shifts.shift_id;


--
-- Name: stations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stations (
    station_id integer NOT NULL,
    name character varying(100) NOT NULL,
    location character varying(250)
);


ALTER TABLE public.stations OWNER TO postgres;

--
-- Name: units; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.units (
    unit_id integer NOT NULL,
    unit_name character varying(50) NOT NULL,
    type character varying(25),
    station_id integer,
    CONSTRAINT units_type_check CHECK (((type)::text = ANY ((ARRAY['Engine'::character varying, 'Truck'::character varying, 'Rescue'::character varying, 'Boat'::character varying, 'Brush'::character varying, 'ATV'::character varying, 'Haz-Mat'::character varying, 'Dive'::character varying, 'Command'::character varying])::text[])))
);


ALTER TABLE public.units OWNER TO postgres;

--
-- Name: firefighters firefighter_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters ALTER COLUMN firefighter_id SET DEFAULT nextval('public.firefighters_firefighter_id_seq'::regclass);


--
-- Name: incidents incident_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents ALTER COLUMN incident_id SET DEFAULT nextval('public.incidents_incident_id_seq'::regclass);


--
-- Name: shifts shift_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts ALTER COLUMN shift_id SET DEFAULT nextval('public.shifts_shift_id_seq'::regclass);


--
-- Data for Name: firefighters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.firefighters (firefighter_id, first_name, last_name, rank, shift, station_assignment, status, hire_date, unit_id) FROM stdin;
1	Ed	Smith	Cheif	Admin	1	Active	1998-03-24	101
2	Tom	Reed	Asst. Chief	Admin	1	Active	1999-01-22	102
3	Davin	Freemore	Lieutenant	A	3	Active	2000-02-29	3
4	Kenny	Carter	Shift Commander	B	1	Active	2000-03-20	121
5	Jamie	Cruz	Captain	B	6	Active	2000-06-14	10
6	Kevin	Worth	Lieutenant	B	7	Active	2000-09-10	7
7	Keith	Moss	Shift Commander	A	1	Active	2000-11-05	121
8	Bobby	White	Lieutenant	A	4	Active	2001-02-18	4
9	Jared	Story	Captain	A	6	Active	2004-06-21	10
10	Josh	Kindcan	Fire Marshal	Admin	1	Active	2005-02-24	402
11	David	Colbeer	Driver	A	1	Active	2005-06-08	1
12	Josh	Stacey	Captain	C	1	Active	2007-04-11	5
13	Jon	Doore	Captain	C	6	Active	2007-07-22	10
14	Brian	Darter	Driver	B	6	Active	2007-08-25	10
15	Clint	Bendold	Shift Commander	C	1	Active	2007-09-05	121
16	Kenny	Towelert	Lieutenant	C	7	Active	2007-10-10	7
17	Andrew	Maybest	Driver	A	6	Active	2007-10-15	6
18	Richard	Islandfield	Driver	C	3	Active	2007-10-21	3
19	Roberta	Mester	Lieutenant	C	3	Active	2007-10-22	3
20	Clint	Dunbar	Lieutenant	B	3	Active	2008-01-13	3
21	Kevin	McBaind	Lieutenant	B	6	Active	2008-01-16	6
22	Alan	Benson	Lieutenant	C	6	Active	2008-02-14	6
23	Wade	Deiby	Lieutenant	A	1	Active	2008-03-21	1
67	Grant	Munkel	Firefighter	C	1	Active	2022-07-11	1
68	Taylor	McDonald	Firefighter	B	4	Active	2023-04-10	4
69	Abraham	Mierna	Firefighter	A	6	Active	2023-04-10	6
70	Heriberto	Lopez	Proby	C	1	Active	2024-08-20	1
71	Jacob	Cant	Proby	C	6	Active	2024-08-20	6
72	Alex	Marweiny	Proby	A	1	Active	2024-08-20	1
73	Kevin	Goffwin	Proby	A	1	Active	2025-01-20	1
74	Colton	Floss	Proby	B	1	Active	2025-01-20	1
75	Halis	Dukes	Proby	A	6	Active	2025-01-20	6
76	Javis	Millhams	Proby	B	6	Active	2025-01-20	6
24	Alvin	Gomez	Lieutenant	B	4	Active	2011-04-25	4
25	Jeffrey	Smitch	Driver	C	7	Active	2011-07-30	7
26	Blake	Carmen	Captain	A	1	Active	2011-08-11	5
27	Chris	Sholben	Lieutenant	A	6	Active	2012-04-15	6
28	Casey	Lurch	Captain	B	1	Active	2014-08-15	5
29	Ty	Newfy	Driver	B	4	Active	2015-07-01	4
30	Nathan	Whitemead	Lieutenant	A	7	Active	2015-09-12	7
31	Quincy	Lewis	Lieutenant	C	4	Active	2015-10-24	4
32	Tyler	Smoke	Driver	B	3	Active	2015-10-25	3
33	Solomon	Sticks	Lieutenant	C	1	Active	2016-04-04	1
34	Addison	Mund	Fire Marshal	Admin	1	Active	2016-04-05	401
35	John	Premop	Driver	C	6	Active	2017-06-05	10
36	Kevin	Dawn	Lieutenant	B	1	Active	2016-09-10	1
37	Paul	Mulch	Driver	A	4	Active	2018-06-01	4
39	Matt	Estridge	Driver	B	6	Active	2017-06-12	6
40	Cam	Mood	Driver	A	7	Active	2017-09-29	7
41	Mason	Spot	Driver	B	7	Active	2018-06-04	7
42	Tracey	Blay	Training Ofc.	Admin	1	Active	2018-07-04	301
43	Eric	Meyer	Driver	C	4	Active	2018-07-04	4
44	Dylan	Pickles	Driver	A	3	Active	2018-07-07	3
45	Cody	Smoke	Driver	C	1	Active	2018-09-09	1
46	Chase	Rogers	Training Ofc.	Admin	1	Active	2019-06-13	302
47	Drew	Gimman	Driver	B	1	Active	2019-06-13	5
48	Nate	Mall	Driver	C	6	Active	2019-06-13	6
49	Kyle	Mossburg	Driver	C	1	Active	2019-06-13	1
50	Allan	Dose	Driver	A	1	Active	2019-06-13	5
51	Sean	Drawer	Driver	A	1	Active	2020-05-19	5
52	Benjamin	Wolmover	Firefighter	A	4	Active	2020-05-20	4
53	Spencer	Molecky	Firefighter	C	3	Active	2020-05-20	3
54	Ross	Drip	Firefighter	A	3	Active	2020-05-20	3
55	Hunter	Mixton	Driver	B	7	Active	2020-05-22	7
56	Dylan	Trainor	Driver	B	1	Active	2020-06-19	1
57	Brandon	Streed	Firefighter	B	4	Active	2020-06-19	4
58	Taylor	Moose	Firefighter	C	6	Active	2020-06-19	10
59	Barrett	Flowers	Firefighter	A	1	Active	2021-04-24	1
60	Braxton	Cloner	Firefighter	C	7	Active	2021-07-16	7
61	Justin	Spears	Firefighter	C	4	Active	2021-07-16	4
62	Austin	Pudding	Firefighter	B	7	Active	2022-04-27	7
63	Osbel	Angler	Firefighter	C	4	Active	2022-04-28	4
64	Conner	Reed	Firefighter	B	3	Active	2022-06-19	3
65	Jerry	Drost	Firefigher	A	6	Active	2022-06-24	6
66	Jaxon	Mannin	Firefighter	A	6	Active	2022-07-11	6
\.


--
-- Data for Name: firefightershifts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.firefightershifts (firefighter_id, shift_id) FROM stdin;
1	6
2	6
4	1
5	4
6	5
10	6
14	4
20	2
21	4
24	3
28	1
29	3
32	2
34	6
36	1
39	4
41	5
42	6
46	6
47	1
55	5
56	1
57	3
62	5
64	2
68	3
74	1
76	4
\.


--
-- Data for Name: incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incidents (incident_id, incident_date, incident_type, station_id, description, duration_hours) FROM stdin;
1	2025-04-10	Alarm	7	School smoke detector - no fire	0.07
2	2025-04-10	Alarm	6	Sprinkler Alarm - False	0.23
3	2025-04-10	Medical	6	Chest pains - 1 transported	0.20
4	2025-04-10	Alarm	3	Trash Fire - unauthorized	0.07
5	2025-04-10	Medical	1	Overdose - 1 transported	0.09
\.


--
-- Data for Name: incidentunits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incidentunits (incident_id, unit_id) FROM stdin;
1	121
1	7
1	6
1	10
2	121
2	6
2	4
2	10
3	6
4	121
4	3
4	1
4	5
5	1
\.


--
-- Data for Name: shifts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shifts (shift_id, shift_name, station_id, shift_date, hours) FROM stdin;
1	B	1	2025-04-10	24
2	B	3	2025-04-10	24
3	B	4	2025-04-10	24
4	B	6	2025-04-10	24
5	B	7	2025-04-10	24
6	Admin	1	2025-04-10	8
\.


--
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stations (station_id, name, location) FROM stdin;
1	Central	310 Broadway St.
3	Station 3	758 Park Ave.
4	Station 4	525 Airport Rd.
6	Station 6	220 Lakeshore Dr.
7	Station 7	1311 Golf Links Rd.
\.


--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.units (unit_id, unit_name, type, station_id) FROM stdin;
1	Engine 1	Engine	1
3	Engine 3	Engine	3
4	Engine 4	Engine	4
6	Engine 6	Engine	6
7	Engine 7	Engine	7
5	Truck 5	Truck	1
10	Truck 10	Truck	6
121	121	Command	1
101	101	Command	1
102	102	Command	1
12	Rescue 12	Rescue	1
2	Rescue 2	Rescue	4
14	Brush Truck 14	Brush	1
401	401	Command	1
402	402	Command	1
301	301	Command	1
302	302	Command	1
\.


--
-- Name: firefighters_firefighter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.firefighters_firefighter_id_seq', 76, true);


--
-- Name: incidents_incident_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incidents_incident_id_seq', 5, true);


--
-- Name: shifts_shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shifts_shift_id_seq', 6, true);


--
-- Name: firefighters firefighters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_pkey PRIMARY KEY (firefighter_id);


--
-- Name: firefightershifts firefightershifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefightershifts
    ADD CONSTRAINT firefightershifts_pkey PRIMARY KEY (firefighter_id, shift_id);


--
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (incident_id);


--
-- Name: incidentunits incidentunits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_pkey PRIMARY KEY (incident_id, unit_id);


--
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (shift_id);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (station_id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (unit_id);


--
-- Name: firefighters firefighters_station_assignment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_station_assignment_fkey FOREIGN KEY (station_assignment) REFERENCES public.stations(station_id);


--
-- Name: firefighters firefighters_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(unit_id);


--
-- Name: firefightershifts firefightershifts_firefighter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefightershifts
    ADD CONSTRAINT firefightershifts_firefighter_id_fkey FOREIGN KEY (firefighter_id) REFERENCES public.firefighters(firefighter_id);


--
-- Name: firefightershifts firefightershifts_shift_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefightershifts
    ADD CONSTRAINT firefightershifts_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES public.shifts(shift_id);


--
-- Name: incidents incidents_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);


--
-- Name: incidentunits incidentunits_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(incident_id);


--
-- Name: incidentunits incidentunits_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(unit_id);


--
-- Name: shifts shifts_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);


--
-- Name: units units_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);


--
-- PostgreSQL database dump complete
--

