--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-05-04 23:32:36

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

DROP DATABASE postgres;
--
-- TOC entry 4963 (class 1262 OID 5)
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en-US';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

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

--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 4963
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 24828)
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
-- TOC entry 219 (class 1259 OID 24827)
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
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 219
-- Name: firefighters_firefighter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.firefighters_firefighter_id_seq OWNED BY public.firefighters.firefighter_id;


--
-- TOC entry 223 (class 1259 OID 24854)
-- Name: firefightershifts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.firefightershifts (
    firefighter_id integer NOT NULL,
    shift_id integer NOT NULL
);


ALTER TABLE public.firefightershifts OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24875)
-- Name: incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidents (
    incident_id integer NOT NULL,
    incident_date date NOT NULL,
    incident_type character varying(50),
    station_id integer,
    description text,
    duration_hours numeric(5,2),
    shift character varying(10),
    CONSTRAINT incidents_duration_hours_check CHECK ((duration_hours > (0)::numeric)),
    CONSTRAINT incidents_incident_type_check CHECK (((incident_type)::text = ANY ((ARRAY['Fire'::character varying, 'Rescue'::character varying, 'Medical'::character varying, 'HazMat'::character varying, 'Alarm'::character varying, 'Other'::character varying])::text[]))),
    CONSTRAINT incidents_shift_check CHECK (((shift)::text = ANY ((ARRAY['A'::character varying, 'B'::character varying, 'C'::character varying, 'Admin'::character varying])::text[])))
);


ALTER TABLE public.incidents OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24874)
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
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 224
-- Name: incidents_incident_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incidents_incident_id_seq OWNED BY public.incidents.incident_id;


--
-- TOC entry 226 (class 1259 OID 24891)
-- Name: incidentunits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidentunits (
    incident_id integer NOT NULL,
    unit_id integer NOT NULL
);


ALTER TABLE public.incidentunits OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24842)
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
-- TOC entry 221 (class 1259 OID 24841)
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
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 221
-- Name: shifts_shift_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shifts_shift_id_seq OWNED BY public.shifts.shift_id;


--
-- TOC entry 217 (class 1259 OID 24811)
-- Name: stations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stations (
    station_id integer NOT NULL,
    name character varying(100) NOT NULL,
    location character varying(250)
);


ALTER TABLE public.stations OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24816)
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
-- TOC entry 4768 (class 2604 OID 24831)
-- Name: firefighters firefighter_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters ALTER COLUMN firefighter_id SET DEFAULT nextval('public.firefighters_firefighter_id_seq'::regclass);


--
-- TOC entry 4770 (class 2604 OID 24878)
-- Name: incidents incident_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents ALTER COLUMN incident_id SET DEFAULT nextval('public.incidents_incident_id_seq'::regclass);


--
-- TOC entry 4769 (class 2604 OID 24845)
-- Name: shifts shift_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts ALTER COLUMN shift_id SET DEFAULT nextval('public.shifts_shift_id_seq'::regclass);


--
-- TOC entry 4951 (class 0 OID 24828)
-- Dependencies: 220
-- Data for Name: firefighters; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.firefighters VALUES (1, 'Ed', 'Smith', 'Cheif', 'Admin', 1, 'Active', '1998-03-24', 101);
INSERT INTO public.firefighters VALUES (2, 'Tom', 'Reed', 'Asst. Chief', 'Admin', 1, 'Active', '1999-01-22', 102);
INSERT INTO public.firefighters VALUES (3, 'Davin', 'Freemore', 'Lieutenant', 'A', 3, 'Active', '2000-02-29', 3);
INSERT INTO public.firefighters VALUES (4, 'Kenny', 'Carter', 'Shift Commander', 'B', 1, 'Active', '2000-03-20', 121);
INSERT INTO public.firefighters VALUES (5, 'Jamie', 'Cruz', 'Captain', 'B', 6, 'Active', '2000-06-14', 10);
INSERT INTO public.firefighters VALUES (6, 'Kevin', 'Worth', 'Lieutenant', 'B', 7, 'Active', '2000-09-10', 7);
INSERT INTO public.firefighters VALUES (7, 'Keith', 'Moss', 'Shift Commander', 'A', 1, 'Active', '2000-11-05', 121);
INSERT INTO public.firefighters VALUES (8, 'Bobby', 'White', 'Lieutenant', 'A', 4, 'Active', '2001-02-18', 4);
INSERT INTO public.firefighters VALUES (9, 'Jared', 'Story', 'Captain', 'A', 6, 'Active', '2004-06-21', 10);
INSERT INTO public.firefighters VALUES (10, 'Josh', 'Kindcan', 'Fire Marshal', 'Admin', 1, 'Active', '2005-02-24', 402);
INSERT INTO public.firefighters VALUES (11, 'David', 'Colbeer', 'Driver', 'A', 1, 'Active', '2005-06-08', 1);
INSERT INTO public.firefighters VALUES (12, 'Josh', 'Stacey', 'Captain', 'C', 1, 'Active', '2007-04-11', 5);
INSERT INTO public.firefighters VALUES (13, 'Jon', 'Doore', 'Captain', 'C', 6, 'Active', '2007-07-22', 10);
INSERT INTO public.firefighters VALUES (14, 'Brian', 'Darter', 'Driver', 'B', 6, 'Active', '2007-08-25', 10);
INSERT INTO public.firefighters VALUES (15, 'Clint', 'Bendold', 'Shift Commander', 'C', 1, 'Active', '2007-09-05', 121);
INSERT INTO public.firefighters VALUES (16, 'Kenny', 'Towelert', 'Lieutenant', 'C', 7, 'Active', '2007-10-10', 7);
INSERT INTO public.firefighters VALUES (17, 'Andrew', 'Maybest', 'Driver', 'A', 6, 'Active', '2007-10-15', 6);
INSERT INTO public.firefighters VALUES (18, 'Richard', 'Islandfield', 'Driver', 'C', 3, 'Active', '2007-10-21', 3);
INSERT INTO public.firefighters VALUES (19, 'Roberta', 'Mester', 'Lieutenant', 'C', 3, 'Active', '2007-10-22', 3);
INSERT INTO public.firefighters VALUES (20, 'Clint', 'Dunbar', 'Lieutenant', 'B', 3, 'Active', '2008-01-13', 3);
INSERT INTO public.firefighters VALUES (21, 'Kevin', 'McBaind', 'Lieutenant', 'B', 6, 'Active', '2008-01-16', 6);
INSERT INTO public.firefighters VALUES (22, 'Alan', 'Benson', 'Lieutenant', 'C', 6, 'Active', '2008-02-14', 6);
INSERT INTO public.firefighters VALUES (23, 'Wade', 'Deiby', 'Lieutenant', 'A', 1, 'Active', '2008-03-21', 1);
INSERT INTO public.firefighters VALUES (67, 'Grant', 'Munkel', 'Firefighter', 'C', 1, 'Active', '2022-07-11', 1);
INSERT INTO public.firefighters VALUES (68, 'Taylor', 'McDonald', 'Firefighter', 'B', 4, 'Active', '2023-04-10', 4);
INSERT INTO public.firefighters VALUES (69, 'Abraham', 'Mierna', 'Firefighter', 'A', 6, 'Active', '2023-04-10', 6);
INSERT INTO public.firefighters VALUES (70, 'Heriberto', 'Lopez', 'Proby', 'C', 1, 'Active', '2024-08-20', 1);
INSERT INTO public.firefighters VALUES (71, 'Jacob', 'Cant', 'Proby', 'C', 6, 'Active', '2024-08-20', 6);
INSERT INTO public.firefighters VALUES (72, 'Alex', 'Marweiny', 'Proby', 'A', 1, 'Active', '2024-08-20', 1);
INSERT INTO public.firefighters VALUES (73, 'Kevin', 'Goffwin', 'Proby', 'A', 1, 'Active', '2025-01-20', 1);
INSERT INTO public.firefighters VALUES (74, 'Colton', 'Floss', 'Proby', 'B', 1, 'Active', '2025-01-20', 1);
INSERT INTO public.firefighters VALUES (75, 'Halis', 'Dukes', 'Proby', 'A', 6, 'Active', '2025-01-20', 6);
INSERT INTO public.firefighters VALUES (76, 'Javis', 'Millhams', 'Proby', 'B', 6, 'Active', '2025-01-20', 6);
INSERT INTO public.firefighters VALUES (24, 'Alvin', 'Gomez', 'Lieutenant', 'B', 4, 'Active', '2011-04-25', 4);
INSERT INTO public.firefighters VALUES (25, 'Jeffrey', 'Smitch', 'Driver', 'C', 7, 'Active', '2011-07-30', 7);
INSERT INTO public.firefighters VALUES (26, 'Blake', 'Carmen', 'Captain', 'A', 1, 'Active', '2011-08-11', 5);
INSERT INTO public.firefighters VALUES (27, 'Chris', 'Sholben', 'Lieutenant', 'A', 6, 'Active', '2012-04-15', 6);
INSERT INTO public.firefighters VALUES (28, 'Casey', 'Lurch', 'Captain', 'B', 1, 'Active', '2014-08-15', 5);
INSERT INTO public.firefighters VALUES (29, 'Ty', 'Newfy', 'Driver', 'B', 4, 'Active', '2015-07-01', 4);
INSERT INTO public.firefighters VALUES (30, 'Nathan', 'Whitemead', 'Lieutenant', 'A', 7, 'Active', '2015-09-12', 7);
INSERT INTO public.firefighters VALUES (31, 'Quincy', 'Lewis', 'Lieutenant', 'C', 4, 'Active', '2015-10-24', 4);
INSERT INTO public.firefighters VALUES (32, 'Tyler', 'Smoke', 'Driver', 'B', 3, 'Active', '2015-10-25', 3);
INSERT INTO public.firefighters VALUES (33, 'Solomon', 'Sticks', 'Lieutenant', 'C', 1, 'Active', '2016-04-04', 1);
INSERT INTO public.firefighters VALUES (34, 'Addison', 'Mund', 'Fire Marshal', 'Admin', 1, 'Active', '2016-04-05', 401);
INSERT INTO public.firefighters VALUES (35, 'John', 'Premop', 'Driver', 'C', 6, 'Active', '2017-06-05', 10);
INSERT INTO public.firefighters VALUES (36, 'Kevin', 'Dawn', 'Lieutenant', 'B', 1, 'Active', '2016-09-10', 1);
INSERT INTO public.firefighters VALUES (37, 'Paul', 'Mulch', 'Driver', 'A', 4, 'Active', '2018-06-01', 4);
INSERT INTO public.firefighters VALUES (39, 'Matt', 'Estridge', 'Driver', 'B', 6, 'Active', '2017-06-12', 6);
INSERT INTO public.firefighters VALUES (40, 'Cam', 'Mood', 'Driver', 'A', 7, 'Active', '2017-09-29', 7);
INSERT INTO public.firefighters VALUES (41, 'Mason', 'Spot', 'Driver', 'B', 7, 'Active', '2018-06-04', 7);
INSERT INTO public.firefighters VALUES (42, 'Tracey', 'Blay', 'Training Ofc.', 'Admin', 1, 'Active', '2018-07-04', 301);
INSERT INTO public.firefighters VALUES (43, 'Eric', 'Meyer', 'Driver', 'C', 4, 'Active', '2018-07-04', 4);
INSERT INTO public.firefighters VALUES (44, 'Dylan', 'Pickles', 'Driver', 'A', 3, 'Active', '2018-07-07', 3);
INSERT INTO public.firefighters VALUES (45, 'Cody', 'Smoke', 'Driver', 'C', 1, 'Active', '2018-09-09', 1);
INSERT INTO public.firefighters VALUES (46, 'Chase', 'Rogers', 'Training Ofc.', 'Admin', 1, 'Active', '2019-06-13', 302);
INSERT INTO public.firefighters VALUES (47, 'Drew', 'Gimman', 'Driver', 'B', 1, 'Active', '2019-06-13', 5);
INSERT INTO public.firefighters VALUES (48, 'Nate', 'Mall', 'Driver', 'C', 6, 'Active', '2019-06-13', 6);
INSERT INTO public.firefighters VALUES (49, 'Kyle', 'Mossburg', 'Driver', 'C', 1, 'Active', '2019-06-13', 1);
INSERT INTO public.firefighters VALUES (50, 'Allan', 'Dose', 'Driver', 'A', 1, 'Active', '2019-06-13', 5);
INSERT INTO public.firefighters VALUES (51, 'Sean', 'Drawer', 'Driver', 'A', 1, 'Active', '2020-05-19', 5);
INSERT INTO public.firefighters VALUES (52, 'Benjamin', 'Wolmover', 'Firefighter', 'A', 4, 'Active', '2020-05-20', 4);
INSERT INTO public.firefighters VALUES (53, 'Spencer', 'Molecky', 'Firefighter', 'C', 3, 'Active', '2020-05-20', 3);
INSERT INTO public.firefighters VALUES (54, 'Ross', 'Drip', 'Firefighter', 'A', 3, 'Active', '2020-05-20', 3);
INSERT INTO public.firefighters VALUES (55, 'Hunter', 'Mixton', 'Driver', 'B', 7, 'Active', '2020-05-22', 7);
INSERT INTO public.firefighters VALUES (56, 'Dylan', 'Trainor', 'Driver', 'B', 1, 'Active', '2020-06-19', 1);
INSERT INTO public.firefighters VALUES (57, 'Brandon', 'Streed', 'Firefighter', 'B', 4, 'Active', '2020-06-19', 4);
INSERT INTO public.firefighters VALUES (58, 'Taylor', 'Moose', 'Firefighter', 'C', 6, 'Active', '2020-06-19', 10);
INSERT INTO public.firefighters VALUES (59, 'Barrett', 'Flowers', 'Firefighter', 'A', 1, 'Active', '2021-04-24', 1);
INSERT INTO public.firefighters VALUES (60, 'Braxton', 'Cloner', 'Firefighter', 'C', 7, 'Active', '2021-07-16', 7);
INSERT INTO public.firefighters VALUES (61, 'Justin', 'Spears', 'Firefighter', 'C', 4, 'Active', '2021-07-16', 4);
INSERT INTO public.firefighters VALUES (62, 'Austin', 'Pudding', 'Firefighter', 'B', 7, 'Active', '2022-04-27', 7);
INSERT INTO public.firefighters VALUES (63, 'Osbel', 'Angler', 'Firefighter', 'C', 4, 'Active', '2022-04-28', 4);
INSERT INTO public.firefighters VALUES (64, 'Conner', 'Reed', 'Firefighter', 'B', 3, 'Active', '2022-06-19', 3);
INSERT INTO public.firefighters VALUES (65, 'Jerry', 'Drost', 'Firefigher', 'A', 6, 'Active', '2022-06-24', 6);
INSERT INTO public.firefighters VALUES (66, 'Jaxon', 'Mannin', 'Firefighter', 'A', 6, 'Active', '2022-07-11', 6);


--
-- TOC entry 4954 (class 0 OID 24854)
-- Dependencies: 223
-- Data for Name: firefightershifts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.firefightershifts VALUES (1, 6);
INSERT INTO public.firefightershifts VALUES (2, 6);
INSERT INTO public.firefightershifts VALUES (4, 1);
INSERT INTO public.firefightershifts VALUES (5, 4);
INSERT INTO public.firefightershifts VALUES (6, 5);
INSERT INTO public.firefightershifts VALUES (10, 6);
INSERT INTO public.firefightershifts VALUES (14, 4);
INSERT INTO public.firefightershifts VALUES (20, 2);
INSERT INTO public.firefightershifts VALUES (21, 4);
INSERT INTO public.firefightershifts VALUES (24, 3);
INSERT INTO public.firefightershifts VALUES (28, 1);
INSERT INTO public.firefightershifts VALUES (29, 3);
INSERT INTO public.firefightershifts VALUES (32, 2);
INSERT INTO public.firefightershifts VALUES (34, 6);
INSERT INTO public.firefightershifts VALUES (36, 1);
INSERT INTO public.firefightershifts VALUES (39, 4);
INSERT INTO public.firefightershifts VALUES (41, 5);
INSERT INTO public.firefightershifts VALUES (42, 6);
INSERT INTO public.firefightershifts VALUES (46, 6);
INSERT INTO public.firefightershifts VALUES (47, 1);
INSERT INTO public.firefightershifts VALUES (55, 5);
INSERT INTO public.firefightershifts VALUES (56, 1);
INSERT INTO public.firefightershifts VALUES (57, 3);
INSERT INTO public.firefightershifts VALUES (62, 5);
INSERT INTO public.firefightershifts VALUES (64, 2);
INSERT INTO public.firefightershifts VALUES (68, 3);
INSERT INTO public.firefightershifts VALUES (74, 1);
INSERT INTO public.firefightershifts VALUES (76, 4);
INSERT INTO public.firefightershifts VALUES (15, 7);
INSERT INTO public.firefightershifts VALUES (12, 7);
INSERT INTO public.firefightershifts VALUES (49, 7);
INSERT INTO public.firefightershifts VALUES (70, 7);
INSERT INTO public.firefightershifts VALUES (45, 7);
INSERT INTO public.firefightershifts VALUES (33, 7);
INSERT INTO public.firefightershifts VALUES (67, 7);
INSERT INTO public.firefightershifts VALUES (19, 8);
INSERT INTO public.firefightershifts VALUES (18, 8);
INSERT INTO public.firefightershifts VALUES (53, 8);
INSERT INTO public.firefightershifts VALUES (31, 9);
INSERT INTO public.firefightershifts VALUES (61, 9);
INSERT INTO public.firefightershifts VALUES (43, 9);
INSERT INTO public.firefightershifts VALUES (13, 10);
INSERT INTO public.firefightershifts VALUES (35, 10);
INSERT INTO public.firefightershifts VALUES (71, 10);
INSERT INTO public.firefightershifts VALUES (22, 10);
INSERT INTO public.firefightershifts VALUES (48, 10);
INSERT INTO public.firefightershifts VALUES (58, 10);
INSERT INTO public.firefightershifts VALUES (16, 11);
INSERT INTO public.firefightershifts VALUES (25, 11);
INSERT INTO public.firefightershifts VALUES (60, 11);
INSERT INTO public.firefightershifts VALUES (51, 13);
INSERT INTO public.firefightershifts VALUES (26, 13);
INSERT INTO public.firefightershifts VALUES (23, 13);
INSERT INTO public.firefightershifts VALUES (50, 13);
INSERT INTO public.firefightershifts VALUES (72, 13);
INSERT INTO public.firefightershifts VALUES (11, 13);
INSERT INTO public.firefightershifts VALUES (59, 13);
INSERT INTO public.firefightershifts VALUES (7, 13);
INSERT INTO public.firefightershifts VALUES (73, 13);
INSERT INTO public.firefightershifts VALUES (3, 14);
INSERT INTO public.firefightershifts VALUES (44, 14);
INSERT INTO public.firefightershifts VALUES (54, 14);
INSERT INTO public.firefightershifts VALUES (37, 15);
INSERT INTO public.firefightershifts VALUES (8, 15);
INSERT INTO public.firefightershifts VALUES (52, 15);
INSERT INTO public.firefightershifts VALUES (9, 16);
INSERT INTO public.firefightershifts VALUES (75, 16);
INSERT INTO public.firefightershifts VALUES (27, 16);
INSERT INTO public.firefightershifts VALUES (17, 16);
INSERT INTO public.firefightershifts VALUES (65, 16);
INSERT INTO public.firefightershifts VALUES (66, 16);
INSERT INTO public.firefightershifts VALUES (69, 16);
INSERT INTO public.firefightershifts VALUES (30, 17);
INSERT INTO public.firefightershifts VALUES (40, 17);
INSERT INTO public.firefightershifts VALUES (62, 17);
INSERT INTO public.firefightershifts VALUES (74, 18);
INSERT INTO public.firefightershifts VALUES (4, 18);
INSERT INTO public.firefightershifts VALUES (36, 18);
INSERT INTO public.firefightershifts VALUES (47, 18);
INSERT INTO public.firefightershifts VALUES (56, 18);
INSERT INTO public.firefightershifts VALUES (28, 18);
INSERT INTO public.firefightershifts VALUES (20, 19);
INSERT INTO public.firefightershifts VALUES (32, 19);
INSERT INTO public.firefightershifts VALUES (64, 19);
INSERT INTO public.firefightershifts VALUES (24, 20);
INSERT INTO public.firefightershifts VALUES (29, 20);
INSERT INTO public.firefightershifts VALUES (68, 20);
INSERT INTO public.firefightershifts VALUES (76, 21);
INSERT INTO public.firefightershifts VALUES (14, 21);
INSERT INTO public.firefightershifts VALUES (5, 21);
INSERT INTO public.firefightershifts VALUES (21, 21);
INSERT INTO public.firefightershifts VALUES (39, 21);
INSERT INTO public.firefightershifts VALUES (55, 22);
INSERT INTO public.firefightershifts VALUES (41, 22);
INSERT INTO public.firefightershifts VALUES (6, 22);
INSERT INTO public.firefightershifts VALUES (15, 23);
INSERT INTO public.firefightershifts VALUES (12, 23);
INSERT INTO public.firefightershifts VALUES (49, 23);
INSERT INTO public.firefightershifts VALUES (70, 23);
INSERT INTO public.firefightershifts VALUES (45, 23);
INSERT INTO public.firefightershifts VALUES (33, 23);
INSERT INTO public.firefightershifts VALUES (67, 23);
INSERT INTO public.firefightershifts VALUES (19, 24);
INSERT INTO public.firefightershifts VALUES (18, 24);
INSERT INTO public.firefightershifts VALUES (53, 24);
INSERT INTO public.firefightershifts VALUES (31, 25);
INSERT INTO public.firefightershifts VALUES (61, 25);
INSERT INTO public.firefightershifts VALUES (43, 25);
INSERT INTO public.firefightershifts VALUES (13, 26);
INSERT INTO public.firefightershifts VALUES (35, 26);
INSERT INTO public.firefightershifts VALUES (71, 26);
INSERT INTO public.firefightershifts VALUES (22, 26);
INSERT INTO public.firefightershifts VALUES (48, 26);
INSERT INTO public.firefightershifts VALUES (58, 26);
INSERT INTO public.firefightershifts VALUES (16, 27);
INSERT INTO public.firefightershifts VALUES (25, 27);
INSERT INTO public.firefightershifts VALUES (60, 27);
INSERT INTO public.firefightershifts VALUES (51, 28);
INSERT INTO public.firefightershifts VALUES (26, 28);
INSERT INTO public.firefightershifts VALUES (23, 28);
INSERT INTO public.firefightershifts VALUES (50, 28);
INSERT INTO public.firefightershifts VALUES (72, 28);
INSERT INTO public.firefightershifts VALUES (11, 28);
INSERT INTO public.firefightershifts VALUES (59, 28);
INSERT INTO public.firefightershifts VALUES (7, 28);
INSERT INTO public.firefightershifts VALUES (73, 28);
INSERT INTO public.firefightershifts VALUES (3, 29);
INSERT INTO public.firefightershifts VALUES (44, 29);
INSERT INTO public.firefightershifts VALUES (54, 29);
INSERT INTO public.firefightershifts VALUES (37, 30);
INSERT INTO public.firefightershifts VALUES (8, 30);
INSERT INTO public.firefightershifts VALUES (52, 30);
INSERT INTO public.firefightershifts VALUES (9, 31);
INSERT INTO public.firefightershifts VALUES (75, 31);
INSERT INTO public.firefightershifts VALUES (27, 31);
INSERT INTO public.firefightershifts VALUES (17, 31);
INSERT INTO public.firefightershifts VALUES (65, 31);
INSERT INTO public.firefightershifts VALUES (66, 31);
INSERT INTO public.firefightershifts VALUES (69, 31);
INSERT INTO public.firefightershifts VALUES (30, 32);
INSERT INTO public.firefightershifts VALUES (40, 32);
INSERT INTO public.firefightershifts VALUES (62, 32);
INSERT INTO public.firefightershifts VALUES (74, 33);
INSERT INTO public.firefightershifts VALUES (4, 33);
INSERT INTO public.firefightershifts VALUES (36, 33);
INSERT INTO public.firefightershifts VALUES (47, 33);
INSERT INTO public.firefightershifts VALUES (56, 33);
INSERT INTO public.firefightershifts VALUES (28, 33);
INSERT INTO public.firefightershifts VALUES (20, 34);
INSERT INTO public.firefightershifts VALUES (32, 34);
INSERT INTO public.firefightershifts VALUES (64, 34);
INSERT INTO public.firefightershifts VALUES (24, 35);
INSERT INTO public.firefightershifts VALUES (29, 35);
INSERT INTO public.firefightershifts VALUES (68, 35);
INSERT INTO public.firefightershifts VALUES (76, 36);
INSERT INTO public.firefightershifts VALUES (14, 36);
INSERT INTO public.firefightershifts VALUES (5, 36);
INSERT INTO public.firefightershifts VALUES (21, 36);
INSERT INTO public.firefightershifts VALUES (39, 36);
INSERT INTO public.firefightershifts VALUES (55, 37);
INSERT INTO public.firefightershifts VALUES (41, 37);
INSERT INTO public.firefightershifts VALUES (6, 37);
INSERT INTO public.firefightershifts VALUES (15, 38);
INSERT INTO public.firefightershifts VALUES (12, 38);
INSERT INTO public.firefightershifts VALUES (49, 38);
INSERT INTO public.firefightershifts VALUES (70, 38);
INSERT INTO public.firefightershifts VALUES (45, 38);
INSERT INTO public.firefightershifts VALUES (33, 38);
INSERT INTO public.firefightershifts VALUES (67, 38);
INSERT INTO public.firefightershifts VALUES (19, 39);
INSERT INTO public.firefightershifts VALUES (18, 39);
INSERT INTO public.firefightershifts VALUES (53, 39);
INSERT INTO public.firefightershifts VALUES (31, 40);
INSERT INTO public.firefightershifts VALUES (61, 40);
INSERT INTO public.firefightershifts VALUES (43, 40);
INSERT INTO public.firefightershifts VALUES (13, 41);
INSERT INTO public.firefightershifts VALUES (35, 41);
INSERT INTO public.firefightershifts VALUES (71, 41);
INSERT INTO public.firefightershifts VALUES (22, 41);
INSERT INTO public.firefightershifts VALUES (48, 41);
INSERT INTO public.firefightershifts VALUES (58, 41);
INSERT INTO public.firefightershifts VALUES (16, 42);
INSERT INTO public.firefightershifts VALUES (25, 42);
INSERT INTO public.firefightershifts VALUES (60, 42);
INSERT INTO public.firefightershifts VALUES (51, 43);
INSERT INTO public.firefightershifts VALUES (26, 43);
INSERT INTO public.firefightershifts VALUES (23, 43);
INSERT INTO public.firefightershifts VALUES (50, 43);
INSERT INTO public.firefightershifts VALUES (72, 43);
INSERT INTO public.firefightershifts VALUES (11, 43);
INSERT INTO public.firefightershifts VALUES (59, 43);
INSERT INTO public.firefightershifts VALUES (7, 43);
INSERT INTO public.firefightershifts VALUES (73, 43);
INSERT INTO public.firefightershifts VALUES (3, 44);
INSERT INTO public.firefightershifts VALUES (44, 44);
INSERT INTO public.firefightershifts VALUES (54, 44);
INSERT INTO public.firefightershifts VALUES (37, 45);
INSERT INTO public.firefightershifts VALUES (8, 45);
INSERT INTO public.firefightershifts VALUES (52, 45);
INSERT INTO public.firefightershifts VALUES (9, 46);
INSERT INTO public.firefightershifts VALUES (75, 46);
INSERT INTO public.firefightershifts VALUES (27, 46);
INSERT INTO public.firefightershifts VALUES (17, 46);
INSERT INTO public.firefightershifts VALUES (65, 46);
INSERT INTO public.firefightershifts VALUES (66, 46);
INSERT INTO public.firefightershifts VALUES (69, 46);
INSERT INTO public.firefightershifts VALUES (30, 47);
INSERT INTO public.firefightershifts VALUES (40, 47);
INSERT INTO public.firefightershifts VALUES (62, 47);
INSERT INTO public.firefightershifts VALUES (74, 48);
INSERT INTO public.firefightershifts VALUES (4, 48);
INSERT INTO public.firefightershifts VALUES (36, 48);
INSERT INTO public.firefightershifts VALUES (47, 48);
INSERT INTO public.firefightershifts VALUES (56, 48);
INSERT INTO public.firefightershifts VALUES (28, 48);
INSERT INTO public.firefightershifts VALUES (20, 49);
INSERT INTO public.firefightershifts VALUES (32, 49);
INSERT INTO public.firefightershifts VALUES (64, 49);
INSERT INTO public.firefightershifts VALUES (24, 50);
INSERT INTO public.firefightershifts VALUES (29, 50);
INSERT INTO public.firefightershifts VALUES (68, 50);
INSERT INTO public.firefightershifts VALUES (76, 51);
INSERT INTO public.firefightershifts VALUES (14, 51);
INSERT INTO public.firefightershifts VALUES (5, 51);
INSERT INTO public.firefightershifts VALUES (21, 51);
INSERT INTO public.firefightershifts VALUES (39, 51);
INSERT INTO public.firefightershifts VALUES (55, 52);
INSERT INTO public.firefightershifts VALUES (41, 52);
INSERT INTO public.firefightershifts VALUES (6, 52);
INSERT INTO public.firefightershifts VALUES (15, 53);
INSERT INTO public.firefightershifts VALUES (12, 53);
INSERT INTO public.firefightershifts VALUES (49, 53);
INSERT INTO public.firefightershifts VALUES (70, 53);
INSERT INTO public.firefightershifts VALUES (45, 53);
INSERT INTO public.firefightershifts VALUES (33, 53);
INSERT INTO public.firefightershifts VALUES (67, 53);
INSERT INTO public.firefightershifts VALUES (19, 54);
INSERT INTO public.firefightershifts VALUES (18, 54);
INSERT INTO public.firefightershifts VALUES (53, 54);
INSERT INTO public.firefightershifts VALUES (31, 55);
INSERT INTO public.firefightershifts VALUES (61, 55);
INSERT INTO public.firefightershifts VALUES (43, 55);
INSERT INTO public.firefightershifts VALUES (13, 56);
INSERT INTO public.firefightershifts VALUES (35, 56);
INSERT INTO public.firefightershifts VALUES (71, 56);
INSERT INTO public.firefightershifts VALUES (22, 56);
INSERT INTO public.firefightershifts VALUES (48, 56);
INSERT INTO public.firefightershifts VALUES (58, 56);
INSERT INTO public.firefightershifts VALUES (16, 57);
INSERT INTO public.firefightershifts VALUES (25, 57);
INSERT INTO public.firefightershifts VALUES (60, 57);
INSERT INTO public.firefightershifts VALUES (51, 58);
INSERT INTO public.firefightershifts VALUES (26, 58);
INSERT INTO public.firefightershifts VALUES (23, 58);
INSERT INTO public.firefightershifts VALUES (50, 58);
INSERT INTO public.firefightershifts VALUES (72, 58);
INSERT INTO public.firefightershifts VALUES (11, 58);
INSERT INTO public.firefightershifts VALUES (59, 58);
INSERT INTO public.firefightershifts VALUES (7, 58);
INSERT INTO public.firefightershifts VALUES (73, 58);
INSERT INTO public.firefightershifts VALUES (3, 59);
INSERT INTO public.firefightershifts VALUES (44, 59);
INSERT INTO public.firefightershifts VALUES (54, 59);
INSERT INTO public.firefightershifts VALUES (37, 60);
INSERT INTO public.firefightershifts VALUES (8, 60);
INSERT INTO public.firefightershifts VALUES (52, 60);
INSERT INTO public.firefightershifts VALUES (9, 61);
INSERT INTO public.firefightershifts VALUES (75, 61);
INSERT INTO public.firefightershifts VALUES (27, 61);
INSERT INTO public.firefightershifts VALUES (17, 61);
INSERT INTO public.firefightershifts VALUES (65, 61);
INSERT INTO public.firefightershifts VALUES (66, 61);
INSERT INTO public.firefightershifts VALUES (69, 61);
INSERT INTO public.firefightershifts VALUES (30, 62);
INSERT INTO public.firefightershifts VALUES (40, 62);
INSERT INTO public.firefightershifts VALUES (62, 62);
INSERT INTO public.firefightershifts VALUES (74, 63);
INSERT INTO public.firefightershifts VALUES (4, 63);
INSERT INTO public.firefightershifts VALUES (36, 63);
INSERT INTO public.firefightershifts VALUES (47, 63);
INSERT INTO public.firefightershifts VALUES (56, 63);
INSERT INTO public.firefightershifts VALUES (28, 63);
INSERT INTO public.firefightershifts VALUES (20, 64);
INSERT INTO public.firefightershifts VALUES (32, 64);
INSERT INTO public.firefightershifts VALUES (64, 64);
INSERT INTO public.firefightershifts VALUES (24, 65);
INSERT INTO public.firefightershifts VALUES (29, 65);
INSERT INTO public.firefightershifts VALUES (68, 65);
INSERT INTO public.firefightershifts VALUES (76, 66);
INSERT INTO public.firefightershifts VALUES (14, 66);
INSERT INTO public.firefightershifts VALUES (5, 66);
INSERT INTO public.firefightershifts VALUES (21, 66);
INSERT INTO public.firefightershifts VALUES (39, 66);
INSERT INTO public.firefightershifts VALUES (55, 67);
INSERT INTO public.firefightershifts VALUES (41, 67);
INSERT INTO public.firefightershifts VALUES (6, 67);
INSERT INTO public.firefightershifts VALUES (51, 68);
INSERT INTO public.firefightershifts VALUES (26, 68);
INSERT INTO public.firefightershifts VALUES (23, 68);
INSERT INTO public.firefightershifts VALUES (50, 68);
INSERT INTO public.firefightershifts VALUES (72, 68);
INSERT INTO public.firefightershifts VALUES (11, 68);
INSERT INTO public.firefightershifts VALUES (59, 68);
INSERT INTO public.firefightershifts VALUES (7, 68);
INSERT INTO public.firefightershifts VALUES (73, 68);
INSERT INTO public.firefightershifts VALUES (3, 69);
INSERT INTO public.firefightershifts VALUES (44, 69);
INSERT INTO public.firefightershifts VALUES (54, 69);
INSERT INTO public.firefightershifts VALUES (37, 70);
INSERT INTO public.firefightershifts VALUES (8, 70);
INSERT INTO public.firefightershifts VALUES (52, 70);
INSERT INTO public.firefightershifts VALUES (9, 71);
INSERT INTO public.firefightershifts VALUES (75, 71);
INSERT INTO public.firefightershifts VALUES (27, 71);
INSERT INTO public.firefightershifts VALUES (17, 71);
INSERT INTO public.firefightershifts VALUES (65, 71);
INSERT INTO public.firefightershifts VALUES (66, 71);
INSERT INTO public.firefightershifts VALUES (69, 71);
INSERT INTO public.firefightershifts VALUES (30, 72);
INSERT INTO public.firefightershifts VALUES (40, 72);
INSERT INTO public.firefightershifts VALUES (62, 72);
INSERT INTO public.firefightershifts VALUES (15, 73);
INSERT INTO public.firefightershifts VALUES (12, 73);
INSERT INTO public.firefightershifts VALUES (49, 73);
INSERT INTO public.firefightershifts VALUES (70, 73);
INSERT INTO public.firefightershifts VALUES (45, 73);
INSERT INTO public.firefightershifts VALUES (33, 73);
INSERT INTO public.firefightershifts VALUES (67, 73);
INSERT INTO public.firefightershifts VALUES (19, 74);
INSERT INTO public.firefightershifts VALUES (18, 74);
INSERT INTO public.firefightershifts VALUES (53, 74);
INSERT INTO public.firefightershifts VALUES (31, 75);
INSERT INTO public.firefightershifts VALUES (61, 75);
INSERT INTO public.firefightershifts VALUES (43, 75);
INSERT INTO public.firefightershifts VALUES (13, 76);
INSERT INTO public.firefightershifts VALUES (35, 76);
INSERT INTO public.firefightershifts VALUES (71, 76);
INSERT INTO public.firefightershifts VALUES (22, 76);
INSERT INTO public.firefightershifts VALUES (48, 76);
INSERT INTO public.firefightershifts VALUES (58, 76);
INSERT INTO public.firefightershifts VALUES (16, 77);
INSERT INTO public.firefightershifts VALUES (25, 77);
INSERT INTO public.firefightershifts VALUES (60, 77);
INSERT INTO public.firefightershifts VALUES (74, 78);
INSERT INTO public.firefightershifts VALUES (4, 78);
INSERT INTO public.firefightershifts VALUES (36, 78);
INSERT INTO public.firefightershifts VALUES (47, 78);
INSERT INTO public.firefightershifts VALUES (56, 78);
INSERT INTO public.firefightershifts VALUES (28, 78);
INSERT INTO public.firefightershifts VALUES (20, 79);
INSERT INTO public.firefightershifts VALUES (32, 79);
INSERT INTO public.firefightershifts VALUES (64, 79);
INSERT INTO public.firefightershifts VALUES (24, 80);
INSERT INTO public.firefightershifts VALUES (29, 80);
INSERT INTO public.firefightershifts VALUES (68, 80);
INSERT INTO public.firefightershifts VALUES (76, 81);
INSERT INTO public.firefightershifts VALUES (14, 81);
INSERT INTO public.firefightershifts VALUES (5, 81);
INSERT INTO public.firefightershifts VALUES (21, 81);
INSERT INTO public.firefightershifts VALUES (39, 81);
INSERT INTO public.firefightershifts VALUES (55, 82);
INSERT INTO public.firefightershifts VALUES (41, 82);
INSERT INTO public.firefightershifts VALUES (6, 82);
INSERT INTO public.firefightershifts VALUES (15, 83);
INSERT INTO public.firefightershifts VALUES (12, 83);
INSERT INTO public.firefightershifts VALUES (49, 83);
INSERT INTO public.firefightershifts VALUES (70, 83);
INSERT INTO public.firefightershifts VALUES (45, 83);
INSERT INTO public.firefightershifts VALUES (33, 83);
INSERT INTO public.firefightershifts VALUES (67, 83);
INSERT INTO public.firefightershifts VALUES (19, 84);
INSERT INTO public.firefightershifts VALUES (18, 84);
INSERT INTO public.firefightershifts VALUES (53, 84);
INSERT INTO public.firefightershifts VALUES (31, 85);
INSERT INTO public.firefightershifts VALUES (61, 85);
INSERT INTO public.firefightershifts VALUES (43, 85);
INSERT INTO public.firefightershifts VALUES (13, 86);
INSERT INTO public.firefightershifts VALUES (35, 86);
INSERT INTO public.firefightershifts VALUES (71, 86);
INSERT INTO public.firefightershifts VALUES (22, 86);
INSERT INTO public.firefightershifts VALUES (48, 86);
INSERT INTO public.firefightershifts VALUES (58, 86);
INSERT INTO public.firefightershifts VALUES (16, 87);
INSERT INTO public.firefightershifts VALUES (25, 87);
INSERT INTO public.firefightershifts VALUES (60, 87);
INSERT INTO public.firefightershifts VALUES (51, 88);
INSERT INTO public.firefightershifts VALUES (26, 88);
INSERT INTO public.firefightershifts VALUES (23, 88);
INSERT INTO public.firefightershifts VALUES (50, 88);
INSERT INTO public.firefightershifts VALUES (72, 88);
INSERT INTO public.firefightershifts VALUES (11, 88);
INSERT INTO public.firefightershifts VALUES (59, 88);
INSERT INTO public.firefightershifts VALUES (7, 88);
INSERT INTO public.firefightershifts VALUES (73, 88);
INSERT INTO public.firefightershifts VALUES (3, 89);
INSERT INTO public.firefightershifts VALUES (44, 89);
INSERT INTO public.firefightershifts VALUES (54, 89);
INSERT INTO public.firefightershifts VALUES (37, 90);
INSERT INTO public.firefightershifts VALUES (8, 90);
INSERT INTO public.firefightershifts VALUES (52, 90);
INSERT INTO public.firefightershifts VALUES (9, 91);
INSERT INTO public.firefightershifts VALUES (75, 91);
INSERT INTO public.firefightershifts VALUES (27, 91);
INSERT INTO public.firefightershifts VALUES (17, 91);
INSERT INTO public.firefightershifts VALUES (65, 91);
INSERT INTO public.firefightershifts VALUES (66, 91);
INSERT INTO public.firefightershifts VALUES (69, 91);
INSERT INTO public.firefightershifts VALUES (30, 92);
INSERT INTO public.firefightershifts VALUES (40, 92);
INSERT INTO public.firefightershifts VALUES (62, 92);
INSERT INTO public.firefightershifts VALUES (74, 93);
INSERT INTO public.firefightershifts VALUES (4, 93);
INSERT INTO public.firefightershifts VALUES (36, 93);
INSERT INTO public.firefightershifts VALUES (47, 93);
INSERT INTO public.firefightershifts VALUES (56, 93);
INSERT INTO public.firefightershifts VALUES (28, 93);
INSERT INTO public.firefightershifts VALUES (20, 94);
INSERT INTO public.firefightershifts VALUES (32, 94);
INSERT INTO public.firefightershifts VALUES (64, 94);
INSERT INTO public.firefightershifts VALUES (24, 95);
INSERT INTO public.firefightershifts VALUES (29, 95);
INSERT INTO public.firefightershifts VALUES (68, 95);
INSERT INTO public.firefightershifts VALUES (76, 96);
INSERT INTO public.firefightershifts VALUES (14, 96);
INSERT INTO public.firefightershifts VALUES (5, 96);
INSERT INTO public.firefightershifts VALUES (21, 96);
INSERT INTO public.firefightershifts VALUES (39, 96);
INSERT INTO public.firefightershifts VALUES (55, 97);
INSERT INTO public.firefightershifts VALUES (41, 97);
INSERT INTO public.firefightershifts VALUES (6, 97);
INSERT INTO public.firefightershifts VALUES (15, 98);
INSERT INTO public.firefightershifts VALUES (12, 98);
INSERT INTO public.firefightershifts VALUES (49, 98);
INSERT INTO public.firefightershifts VALUES (70, 98);
INSERT INTO public.firefightershifts VALUES (45, 98);
INSERT INTO public.firefightershifts VALUES (33, 98);
INSERT INTO public.firefightershifts VALUES (67, 98);
INSERT INTO public.firefightershifts VALUES (19, 99);
INSERT INTO public.firefightershifts VALUES (18, 99);
INSERT INTO public.firefightershifts VALUES (53, 99);
INSERT INTO public.firefightershifts VALUES (31, 100);
INSERT INTO public.firefightershifts VALUES (61, 100);
INSERT INTO public.firefightershifts VALUES (43, 100);
INSERT INTO public.firefightershifts VALUES (13, 101);
INSERT INTO public.firefightershifts VALUES (35, 101);
INSERT INTO public.firefightershifts VALUES (71, 101);
INSERT INTO public.firefightershifts VALUES (22, 101);
INSERT INTO public.firefightershifts VALUES (48, 101);
INSERT INTO public.firefightershifts VALUES (58, 101);
INSERT INTO public.firefightershifts VALUES (16, 102);
INSERT INTO public.firefightershifts VALUES (25, 102);
INSERT INTO public.firefightershifts VALUES (60, 102);
INSERT INTO public.firefightershifts VALUES (51, 103);
INSERT INTO public.firefightershifts VALUES (26, 103);
INSERT INTO public.firefightershifts VALUES (23, 103);
INSERT INTO public.firefightershifts VALUES (50, 103);
INSERT INTO public.firefightershifts VALUES (72, 103);
INSERT INTO public.firefightershifts VALUES (11, 103);
INSERT INTO public.firefightershifts VALUES (59, 103);
INSERT INTO public.firefightershifts VALUES (7, 103);
INSERT INTO public.firefightershifts VALUES (73, 103);
INSERT INTO public.firefightershifts VALUES (3, 104);
INSERT INTO public.firefightershifts VALUES (44, 104);
INSERT INTO public.firefightershifts VALUES (54, 104);
INSERT INTO public.firefightershifts VALUES (37, 105);
INSERT INTO public.firefightershifts VALUES (8, 105);
INSERT INTO public.firefightershifts VALUES (52, 105);
INSERT INTO public.firefightershifts VALUES (9, 106);
INSERT INTO public.firefightershifts VALUES (75, 106);
INSERT INTO public.firefightershifts VALUES (27, 106);
INSERT INTO public.firefightershifts VALUES (17, 106);
INSERT INTO public.firefightershifts VALUES (65, 106);
INSERT INTO public.firefightershifts VALUES (66, 106);
INSERT INTO public.firefightershifts VALUES (69, 106);
INSERT INTO public.firefightershifts VALUES (30, 107);
INSERT INTO public.firefightershifts VALUES (40, 107);
INSERT INTO public.firefightershifts VALUES (62, 107);
INSERT INTO public.firefightershifts VALUES (74, 108);
INSERT INTO public.firefightershifts VALUES (4, 108);
INSERT INTO public.firefightershifts VALUES (36, 108);
INSERT INTO public.firefightershifts VALUES (47, 108);
INSERT INTO public.firefightershifts VALUES (56, 108);
INSERT INTO public.firefightershifts VALUES (28, 108);
INSERT INTO public.firefightershifts VALUES (20, 109);
INSERT INTO public.firefightershifts VALUES (32, 109);
INSERT INTO public.firefightershifts VALUES (64, 109);
INSERT INTO public.firefightershifts VALUES (24, 110);
INSERT INTO public.firefightershifts VALUES (29, 110);
INSERT INTO public.firefightershifts VALUES (68, 110);
INSERT INTO public.firefightershifts VALUES (76, 111);
INSERT INTO public.firefightershifts VALUES (14, 111);
INSERT INTO public.firefightershifts VALUES (5, 111);
INSERT INTO public.firefightershifts VALUES (21, 111);
INSERT INTO public.firefightershifts VALUES (39, 111);
INSERT INTO public.firefightershifts VALUES (55, 112);
INSERT INTO public.firefightershifts VALUES (41, 112);
INSERT INTO public.firefightershifts VALUES (6, 112);
INSERT INTO public.firefightershifts VALUES (15, 113);
INSERT INTO public.firefightershifts VALUES (12, 113);
INSERT INTO public.firefightershifts VALUES (49, 113);
INSERT INTO public.firefightershifts VALUES (70, 113);
INSERT INTO public.firefightershifts VALUES (45, 113);
INSERT INTO public.firefightershifts VALUES (33, 113);
INSERT INTO public.firefightershifts VALUES (67, 113);
INSERT INTO public.firefightershifts VALUES (19, 114);
INSERT INTO public.firefightershifts VALUES (18, 114);
INSERT INTO public.firefightershifts VALUES (53, 114);
INSERT INTO public.firefightershifts VALUES (31, 115);
INSERT INTO public.firefightershifts VALUES (61, 115);
INSERT INTO public.firefightershifts VALUES (43, 115);
INSERT INTO public.firefightershifts VALUES (13, 116);
INSERT INTO public.firefightershifts VALUES (35, 116);
INSERT INTO public.firefightershifts VALUES (71, 116);
INSERT INTO public.firefightershifts VALUES (22, 116);
INSERT INTO public.firefightershifts VALUES (48, 116);
INSERT INTO public.firefightershifts VALUES (58, 116);
INSERT INTO public.firefightershifts VALUES (16, 117);
INSERT INTO public.firefightershifts VALUES (25, 117);
INSERT INTO public.firefightershifts VALUES (60, 117);
INSERT INTO public.firefightershifts VALUES (51, 118);
INSERT INTO public.firefightershifts VALUES (26, 118);
INSERT INTO public.firefightershifts VALUES (23, 118);
INSERT INTO public.firefightershifts VALUES (50, 118);
INSERT INTO public.firefightershifts VALUES (72, 118);
INSERT INTO public.firefightershifts VALUES (11, 118);
INSERT INTO public.firefightershifts VALUES (59, 118);
INSERT INTO public.firefightershifts VALUES (7, 118);
INSERT INTO public.firefightershifts VALUES (73, 118);
INSERT INTO public.firefightershifts VALUES (3, 119);
INSERT INTO public.firefightershifts VALUES (44, 119);
INSERT INTO public.firefightershifts VALUES (54, 119);
INSERT INTO public.firefightershifts VALUES (37, 120);
INSERT INTO public.firefightershifts VALUES (8, 120);
INSERT INTO public.firefightershifts VALUES (52, 120);
INSERT INTO public.firefightershifts VALUES (9, 121);
INSERT INTO public.firefightershifts VALUES (75, 121);
INSERT INTO public.firefightershifts VALUES (27, 121);
INSERT INTO public.firefightershifts VALUES (17, 121);
INSERT INTO public.firefightershifts VALUES (65, 121);
INSERT INTO public.firefightershifts VALUES (66, 121);
INSERT INTO public.firefightershifts VALUES (69, 121);
INSERT INTO public.firefightershifts VALUES (30, 122);
INSERT INTO public.firefightershifts VALUES (40, 122);
INSERT INTO public.firefightershifts VALUES (62, 122);


--
-- TOC entry 4956 (class 0 OID 24875)
-- Dependencies: 225
-- Data for Name: incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.incidents VALUES (1, '2025-04-10', 'Alarm', 7, 'School smoke detector - no fire', 0.07, 'B');
INSERT INTO public.incidents VALUES (2, '2025-04-10', 'Alarm', 6, 'Sprinkler Alarm - False', 0.23, 'B');
INSERT INTO public.incidents VALUES (3, '2025-04-10', 'Medical', 6, 'Chest pains - 1 transported', 0.20, 'B');
INSERT INTO public.incidents VALUES (4, '2025-04-10', 'Alarm', 3, 'Trash Fire - unauthorized', 0.07, 'B');
INSERT INTO public.incidents VALUES (5, '2025-04-10', 'Medical', 1, 'Overdose - 1 transported', 0.09, 'B');
INSERT INTO public.incidents VALUES (6, '2025-04-11', 'Medical', 4, 'Rollover Accident - 4 transported', 0.75, 'B');
INSERT INTO public.incidents VALUES (7, '2025-04-11', 'Alarm', 7, 'Fire Alarm - false alarm', 0.23, 'C');
INSERT INTO public.incidents VALUES (8, '2025-04-11', 'Medical', 1, 'Wrists cut - 1 transported', 0.22, 'C');
INSERT INTO public.incidents VALUES (9, '2025-04-11', 'Alarm', 4, 'Fire Alarm - false alarm', 0.08, 'C');
INSERT INTO public.incidents VALUES (10, '2025-04-11', 'Alarm', 3, 'Smoke detector activation - no fire', 0.08, 'C');
INSERT INTO public.incidents VALUES (11, '2025-04-11', 'Medical', 7, 'Minor MVA', 0.48, 'C');
INSERT INTO public.incidents VALUES (12, '2025-04-11', 'Medical', 1, 'Female chest pains - 1 transported', 0.13, 'C');
INSERT INTO public.incidents VALUES (13, '2025-04-11', 'Alarm', 1, 'Heavy Smoke in the area - false alarm', 0.25, 'C');
INSERT INTO public.incidents VALUES (14, '2025-04-12', 'Alarm', 6, 'Pull station - false alarm', 0.07, 'A');
INSERT INTO public.incidents VALUES (15, '2025-04-12', 'Medical', 1, 'Respiratory distress - 1 transported', 0.33, 'A');
INSERT INTO public.incidents VALUES (16, '2025-04-12', 'Alarm', 6, 'Pull station - false alarm', 0.17, 'A');
INSERT INTO public.incidents VALUES (17, '2025-04-12', 'Alarm', 4, 'Smoke alarm - Cancelled en route', 0.02, 'A');
INSERT INTO public.incidents VALUES (18, '2025-04-12', 'Medical', 1, 'Rollover accident - 3 transported', 0.57, 'A');
INSERT INTO public.incidents VALUES (19, '2025-04-12', 'Medical', 6, 'Minor MVA', 0.33, 'A');
INSERT INTO public.incidents VALUES (20, '2025-04-12', 'Other', 1, 'Unauthorized burning', 0.10, 'A');
INSERT INTO public.incidents VALUES (21, '2025-04-12', 'Fire', 1, 'Vehicle Fire', 0.50, 'A');
INSERT INTO public.incidents VALUES (22, '2025-04-12', 'Medical', 7, 'MCI', 0.54, 'A');
INSERT INTO public.incidents VALUES (23, '2025-04-12', 'Alarm', 6, 'Smoke detector - False Alarm', 0.17, 'A');
INSERT INTO public.incidents VALUES (24, '2025-04-12', 'Medical', 1, 'Seizure - 1 transported', 0.20, 'A');
INSERT INTO public.incidents VALUES (25, '2025-04-13', 'Medical', 4, 'MCI', 0.13, 'A');
INSERT INTO public.incidents VALUES (26, '2025-04-13', 'Medical', 1, 'Respiratory distress - 1 transported', 0.40, 'B');
INSERT INTO public.incidents VALUES (27, '2025-04-15', 'Other', 1, 'Service Call - Fluid clean up', 0.04, 'A');
INSERT INTO public.incidents VALUES (28, '2025-04-15', 'Medical', 3, 'Respiratory distress - 82 yr old', 0.01, 'A');
INSERT INTO public.incidents VALUES (29, '2025-04-15', 'Fire', 6, 'Grass Fire - Kimery', 0.06, 'A');
INSERT INTO public.incidents VALUES (30, '2025-04-15', 'Fire', 4, 'Stove Fire - Smoking', 0.11, 'A');
INSERT INTO public.incidents VALUES (31, '2025-04-15', 'Medical', 4, 'MVA w injury - 3 vehicles and motorcycle', 0.11, 'A');
INSERT INTO public.incidents VALUES (32, '2025-04-15', 'Medical', 1, 'Emergent Lift Assist', 0.33, 'A');
INSERT INTO public.incidents VALUES (33, '2025-04-16', 'Other', 6, 'Service call - Fluid clean up', 0.28, 'B');
INSERT INTO public.incidents VALUES (34, '2025-04-16', 'Alarm', 7, 'Fire Alarm - False Alarm', 0.08, 'B');
INSERT INTO public.incidents VALUES (35, '2025-04-16', 'Medical', 1, 'Non Emergent Lift Assist', 0.52, 'B');
INSERT INTO public.incidents VALUES (36, '2025-04-16', 'Other', 4, 'Service Call - Smell of Natural Gas', 0.28, 'B');
INSERT INTO public.incidents VALUES (37, '2025-04-16', 'Medical', 1, 'Non Emergent - Lift Assist', 0.18, 'B');
INSERT INTO public.incidents VALUES (38, '2025-04-17', 'Fire', 6, 'Dumpster Fire', 0.32, 'B');
INSERT INTO public.incidents VALUES (39, '2025-04-17', 'Alarm', 7, 'Fire Alarm - Brush Fire', 0.15, 'B');
INSERT INTO public.incidents VALUES (40, '2025-04-17', 'Medical', 7, 'Life Alert', 0.32, 'C');
INSERT INTO public.incidents VALUES (41, '2025-04-17', 'Medical', 3, 'CPR - DOA', 0.13, 'C');
INSERT INTO public.incidents VALUES (42, '2025-04-17', 'Other', 7, 'Service Call - unknown', 0.27, 'C');
INSERT INTO public.incidents VALUES (43, '2025-04-17', 'Alarm', 6, 'Grass Fire - Maintenance', 0.10, 'C');
INSERT INTO public.incidents VALUES (44, '2025-04-17', 'Other', 7, 'Service Call - Gas Line Struck', 0.80, 'C');
INSERT INTO public.incidents VALUES (45, '2025-04-17', 'Other', 1, 'Illegal Burning', 0.38, 'C');
INSERT INTO public.incidents VALUES (46, '2025-04-17', 'Alarm', 1, 'Smoke Alarm - False Alarm', 0.18, 'C');
INSERT INTO public.incidents VALUES (47, '2025-04-18', 'Medical', 1, 'MCI - 1 transported', 0.18, 'A');
INSERT INTO public.incidents VALUES (48, '2025-04-18', 'Alarm', 6, 'Pull Station - False Alarm', 0.27, 'A');
INSERT INTO public.incidents VALUES (49, '2025-04-18', 'Medical', 6, 'MVA - 2 vehicles', 0.74, 'A');
INSERT INTO public.incidents VALUES (50, '2025-04-18', 'Fire', 6, 'Structure Fire - Minor Fire in Laundry Room', 0.50, 'A');
INSERT INTO public.incidents VALUES (51, '2025-04-18', 'Other', 1, 'Power Line Sparking from Tree', 0.18, 'A');
INSERT INTO public.incidents VALUES (52, '2025-04-18', 'Other', 7, 'Illegal Burning', 0.28, 'A');
INSERT INTO public.incidents VALUES (53, '2025-04-18', 'Other', 1, 'Power Line on Fence - House Entrapment', 0.35, 'A');
INSERT INTO public.incidents VALUES (54, '2025-04-18', 'Fire', 6, 'Grass Fire - Maintenance', 0.12, 'A');
INSERT INTO public.incidents VALUES (55, '2025-04-18', 'Medical', 6, 'MVA w Ped', 0.17, 'A');
INSERT INTO public.incidents VALUES (56, '2025-04-18', 'Medical', 7, 'MCI - 1 transported', 0.80, 'A');
INSERT INTO public.incidents VALUES (57, '2025-04-18', 'Medical', 4, 'Respiratory Distress - LifeNet Extended', 0.38, 'A');
INSERT INTO public.incidents VALUES (58, '2025-04-18', 'Medical', 3, 'Unresponsive person on bus - Narcan administered', 0.15, 'A');
INSERT INTO public.incidents VALUES (59, '2025-04-18', 'Alarm', 7, 'Fire Alarm - General, False', 0.15, 'A');
INSERT INTO public.incidents VALUES (60, '2025-04-18', 'Medical', 6, 'MVA w Ped - Hit and run, ped transported', 0.17, 'A');
INSERT INTO public.incidents VALUES (61, '2025-04-19', 'Medical', 1, 'Lift Assist - Non emergent', 0.01, 'B');
INSERT INTO public.incidents VALUES (62, '2025-04-19', 'Alarm', 6, 'Smoke Alarm - False alarm', 0.13, 'B');
INSERT INTO public.incidents VALUES (63, '2025-04-19', 'Alarm', 6, 'Fire Alarm - General, False', 0.23, 'B');
INSERT INTO public.incidents VALUES (64, '2025-04-19', 'Medical', 6, 'MVA - 2 vehicle - AB deployment', 0.28, 'B');
INSERT INTO public.incidents VALUES (65, '2025-04-19', 'Medical', 6, 'MVA - 3 vehicle', 0.43, 'B');
INSERT INTO public.incidents VALUES (66, '2025-04-19', 'Medical', 4, 'MVA w ped', 0.35, 'B');
INSERT INTO public.incidents VALUES (67, '2025-04-20', 'Other', 1, 'Service Call - Smell of Natural Gas', 0.23, 'C');
INSERT INTO public.incidents VALUES (68, '2025-04-20', 'Alarm', 6, 'Smoke Alarm - Cancelled en route', 0.18, 'C');
INSERT INTO public.incidents VALUES (69, '2025-04-20', 'Alarm', 6, 'Illegal Burning', 1.00, 'C');
INSERT INTO public.incidents VALUES (70, '2025-04-20', 'Medical', 1, 'MVA - Rollover w Fatality', 0.72, 'C');
INSERT INTO public.incidents VALUES (71, '2025-04-20', 'Alarm', 3, 'Fire Alarm - General, no fire', 0.13, 'C');
INSERT INTO public.incidents VALUES (77, '2025-04-22', 'Medical', 7, 'Lift Assist - Emergent', 0.32, 'B');
INSERT INTO public.incidents VALUES (78, '2025-04-22', 'Alarm', 6, 'Fire Alarm - water flow', 0.17, 'B');
INSERT INTO public.incidents VALUES (79, '2025-04-22', 'Medical', 6, 'MVA - 2 vehicles, 1 transported', 0.26, 'B');
INSERT INTO public.incidents VALUES (80, '2025-04-22', 'Medical', 1, 'Lift Assist - Emergent', 0.17, 'B');
INSERT INTO public.incidents VALUES (81, '2025-04-22', 'Medical', 7, 'Lift Assist - Non Emergent', 0.30, 'B');
INSERT INTO public.incidents VALUES (82, '2025-04-22', 'Medical', 4, 'MVA - 2 vehicles, minor', 0.23, 'B');
INSERT INTO public.incidents VALUES (83, '2025-04-22', 'Other', 7, 'Illegal Burning', 0.40, 'B');
INSERT INTO public.incidents VALUES (84, '2025-04-22', 'Alarm', 3, 'Fire Alarm - false alarm', 0.22, 'B');
INSERT INTO public.incidents VALUES (72, '2025-04-21', 'Alarm', 7, 'Fire Alarm - Electric box smoking', 0.77, 'A');
INSERT INTO public.incidents VALUES (73, '2025-04-21', 'Medical', 1, 'MVA - 2 vehicle', 0.25, 'A');
INSERT INTO public.incidents VALUES (74, '2025-04-21', 'Medical', 6, 'Chest pains', 0.13, 'A');
INSERT INTO public.incidents VALUES (75, '2025-04-21', 'Alarm', 6, 'Black smoke coming from wooded area', 0.13, 'A');
INSERT INTO public.incidents VALUES (76, '2025-04-21', 'Medical', 6, 'Lift Assist - Non Emergent', 0.30, 'A');
INSERT INTO public.incidents VALUES (85, '2025-04-23', 'Medical', 1, 'Lift Assist - Non Emergent', 0.25, 'B');
INSERT INTO public.incidents VALUES (86, '2025-04-23', 'Fire', 6, 'Vehicle Fire - Semi-Truck with crane, fully involved', 1.23, 'C');
INSERT INTO public.incidents VALUES (87, '2025-04-23', 'Alarm', 1, 'Smoke Alarm - False Alarm', 0.10, 'C');
INSERT INTO public.incidents VALUES (88, '2025-04-23', 'Alarm', 6, 'Fire Alarm - False Alarm', 0.22, 'C');
INSERT INTO public.incidents VALUES (89, '2025-04-23', 'Other', 6, 'Standby for torches on outriggers', 1.57, 'C');
INSERT INTO public.incidents VALUES (90, '2025-04-23', 'Alarm', 1, 'Fire Alarm - False Alarm', 0.17, 'C');
INSERT INTO public.incidents VALUES (91, '2025-04-23', 'Alarm', 4, 'Fire Alarm - False Alarm', 0.22, 'C');
INSERT INTO public.incidents VALUES (92, '2025-04-23', 'Medical', 4, 'MVA - veh vs. motorcycle', 0.20, 'C');
INSERT INTO public.incidents VALUES (93, '2025-04-23', 'Medical', 1, 'Chest pains - 1 transported', 0.12, 'C');
INSERT INTO public.incidents VALUES (94, '2025-04-23', 'Other', 6, 'Service Call - Smoke alarm chirping', 0.28, 'C');
INSERT INTO public.incidents VALUES (95, '2025-04-23', 'Medical', 6, 'Allergic Reaction - 1 YO', 0.17, 'C');
INSERT INTO public.incidents VALUES (96, '2025-04-24', 'Alarm', 6, 'Fire Alarm - General alarm, false', 0.10, 'A');
INSERT INTO public.incidents VALUES (97, '2025-04-24', 'Other', 4, 'Service Call - Gas main struck', 0.25, 'A');
INSERT INTO public.incidents VALUES (98, '2025-04-24', 'Medical', 6, 'MVA - 2 vehicles', 0.53, 'A');
INSERT INTO public.incidents VALUES (99, '2025-04-24', 'Medical', 4, 'MVA - 2 vehicles, infant', 0.23, 'A');
INSERT INTO public.incidents VALUES (100, '2025-04-24', 'Alarm', 7, 'Smoke Alarm - False alarm', 0.58, 'A');
INSERT INTO public.incidents VALUES (101, '2025-04-24', 'Other', 1, 'Illegal Burning', 0.04, 'A');
INSERT INTO public.incidents VALUES (102, '2025-04-24', 'Medical', 4, 'Lift Assist - non emergent', 0.13, 'A');
INSERT INTO public.incidents VALUES (103, '2025-04-24', 'Medical', 1, 'MVA w Ped', 0.17, 'A');
INSERT INTO public.incidents VALUES (104, '2025-04-24', 'Medical', 1, 'Lift Assist - Emergent, biohaz', 0.58, 'A');
INSERT INTO public.incidents VALUES (105, '2025-04-25', 'Other', 6, 'Gas Leak - Oven', 0.22, 'A');
INSERT INTO public.incidents VALUES (106, '2025-04-25', 'Alarm', 1, 'Smoke Alarm - False Alarm', 0.32, 'A');
INSERT INTO public.incidents VALUES (107, '2025-04-25', 'Medical', 1, 'MVA - 1 vehicle, 1 transported', 0.63, 'B');
INSERT INTO public.incidents VALUES (108, '2025-04-25', 'Other', 1, 'Gas Leak - False, skunk', 0.18, 'B');
INSERT INTO public.incidents VALUES (109, '2025-04-25', 'Fire', 6, 'Vehicle Fire - radiator smoking, false alarm', 0.12, 'B');
INSERT INTO public.incidents VALUES (110, '2025-04-25', 'Medical', 3, 'Lift Assist - non emergent', 0.15, 'B');
INSERT INTO public.incidents VALUES (111, '2025-04-25', 'Medical', 1, 'Lift Assist - non emergent, biohaz', 0.27, 'B');
INSERT INTO public.incidents VALUES (112, '2025-04-25', 'Alarm', 6, 'Smoke behind building - homeless camp', 0.12, 'B');
INSERT INTO public.incidents VALUES (113, '2025-04-25', 'Medical', 3, 'MVA - 1 veh vs. pole', 2.23, 'B');
INSERT INTO public.incidents VALUES (114, '2025-04-25', 'Medical', 1, 'Lift Assist - non emergent, biohaz', 0.27, 'B');
INSERT INTO public.incidents VALUES (115, '2025-04-25', 'Medical', 4, 'MVA - 1 veh vs bicycle, fled scene', 0.15, 'B');
INSERT INTO public.incidents VALUES (116, '2025-04-25', 'Other', 7, 'Illegal Burning', 0.18, 'B');
INSERT INTO public.incidents VALUES (117, '2025-04-25', 'Other', 3, 'Illegal Burning', 0.22, 'B');
INSERT INTO public.incidents VALUES (118, '2025-04-25', 'Medical', 1, 'Lift Assist - non emergent, biohaz', 0.27, 'B');
INSERT INTO public.incidents VALUES (119, '2025-04-25', 'Medical', 6, 'Lift Assist - emergent', 0.17, 'B');
INSERT INTO public.incidents VALUES (120, '2025-04-26', 'Alarm', 6, 'Water Flow alarm - false alarm', 0.50, 'C');
INSERT INTO public.incidents VALUES (121, '2025-04-26', 'Alarm', 6, 'Fire Alarm - False alarm', 0.18, 'C');
INSERT INTO public.incidents VALUES (122, '2025-04-26', 'Alarm', 7, 'CO Alarm - False alarm', 0.17, 'C');
INSERT INTO public.incidents VALUES (123, '2025-04-26', 'Medical', 1, 'Chest Pains - LifeNet extended ETA', 0.37, 'C');
INSERT INTO public.incidents VALUES (124, '2025-04-26', 'Medical', 6, 'Respiratory Distress - Lifenet extended ETA', 0.27, 'C');
INSERT INTO public.incidents VALUES (125, '2025-04-26', 'Medical', 7, 'Lift Assist - emergent', 0.17, 'C');
INSERT INTO public.incidents VALUES (126, '2025-04-26', 'Medical', 6, 'MCI - CPR in progress', 0.73, 'C');
INSERT INTO public.incidents VALUES (127, '2025-04-26', 'Medical', 1, 'MVA w Ped - 1 transported', 0.17, 'C');
INSERT INTO public.incidents VALUES (128, '2025-04-26', 'Medical', 3, 'Lift Assist - non emergent', 0.23, 'C');
INSERT INTO public.incidents VALUES (129, '2025-04-26', 'Medical', 1, 'Respiratory Distress - Lifenet extended ETA', 0.30, 'C');
INSERT INTO public.incidents VALUES (130, '2025-04-26', 'Medical', 1, 'MVA vs Bicycle - 2 transported', 0.08, 'C');
INSERT INTO public.incidents VALUES (131, '2025-04-26', 'Medical', 1, 'MVA w Ped - 1 transported', 0.15, 'C');
INSERT INTO public.incidents VALUES (132, '2025-04-27', 'Alarm', 1, 'Fire Alarm - General alarm, false', 0.13, 'C');
INSERT INTO public.incidents VALUES (133, '2025-04-27', 'Alarm', 4, 'Fire Alarm - Counter sprayed with bug spray, false alarm', 0.25, 'C');
INSERT INTO public.incidents VALUES (134, '2025-04-27', 'Medical', 1, 'Lift Assist - non emergent, biohaz', 0.55, 'C');
INSERT INTO public.incidents VALUES (135, '2025-04-27', 'Other', 1, 'Service Call - downed powerline on vehicle', 0.67, 'C');
INSERT INTO public.incidents VALUES (136, '2025-04-27', 'Other', 6, 'CO Alarm - smell of gas inside residence', 0.25, 'A');
INSERT INTO public.incidents VALUES (137, '2025-04-27', 'Medical', 1, 'Lift Assist - non emergent, biohaz', 1.28, 'A');
INSERT INTO public.incidents VALUES (138, '2025-04-27', 'Medical', 1, 'Lift Assist - non emergent', 0.15, 'A');
INSERT INTO public.incidents VALUES (139, '2025-04-27', 'Medical', 1, 'Lift Assist - non emergent, coroner req', 0.52, 'A');
INSERT INTO public.incidents VALUES (140, '2025-04-27', 'Fire', 4, 'Vehicle Fire - EB lane, engine comp involved', 0.25, 'A');
INSERT INTO public.incidents VALUES (141, '2025-04-28', 'Medical', 6, 'Lift Assist - cancelled en route', 0.02, 'B');
INSERT INTO public.incidents VALUES (142, '2025-04-28', 'Alarm', 4, 'Smoke Alarm - false', 0.10, 'B');
INSERT INTO public.incidents VALUES (143, '2025-04-28', 'Medical', 7, 'Fall alert - not responding, 1 transported', 0.33, 'B');
INSERT INTO public.incidents VALUES (144, '2025-04-28', 'Medical', 6, 'Lift Assist - non emergent', 0.33, 'B');
INSERT INTO public.incidents VALUES (145, '2025-04-28', 'Alarm', 6, 'Fire Alarm - pull station, false', 0.18, 'B');
INSERT INTO public.incidents VALUES (146, '2025-04-28', 'Medical', 3, 'Chest Pains', 0.23, 'B');
INSERT INTO public.incidents VALUES (147, '2025-04-28', 'Other', 7, 'Illegal Burning', 0.27, 'B');
INSERT INTO public.incidents VALUES (148, '2025-04-28', 'Alarm', 1, 'Fire Alarm - Burnt food, false', 0.30, 'B');
INSERT INTO public.incidents VALUES (149, '2025-04-28', 'Medical', 3, 'Female fell 25 feet down slope', 0.87, 'B');
INSERT INTO public.incidents VALUES (150, '2025-04-28', 'Medical', 3, 'Overdose - Fentanyl, narcan, AMA', 0.15, 'B');
INSERT INTO public.incidents VALUES (151, '2025-04-28', 'Medical', 4, 'MVA - 2 vehicles', 0.15, 'B');
INSERT INTO public.incidents VALUES (152, '2025-04-29', 'Alarm', 7, 'Smoke Alarm - false alarm', 0.10, 'C');
INSERT INTO public.incidents VALUES (153, '2025-04-29', 'Alarm', 6, 'Fire Alarm - pull station, false', 0.22, 'C');
INSERT INTO public.incidents VALUES (154, '2025-04-29', 'Other', 1, 'Illegal burning', 0.48, 'C');
INSERT INTO public.incidents VALUES (155, '2025-04-29', 'Medical', 1, 'Lift Assist - non emergent', 0.25, 'C');
INSERT INTO public.incidents VALUES (156, '2025-04-29', 'Alarm', 4, 'Smoke Alarm - burnt food, false', 0.08, 'C');
INSERT INTO public.incidents VALUES (157, '2025-04-29', 'Alarm', 6, 'Vehicle Fire - engine overheating, false', 0.07, 'C');
INSERT INTO public.incidents VALUES (158, '2025-04-30', 'Alarm', 1, 'Fire Alarm - General, false alarm', 0.32, 'C');
INSERT INTO public.incidents VALUES (159, '2025-04-30', 'Alarm', 1, 'Fire Alarm - General, false alarm', 0.27, 'C');
INSERT INTO public.incidents VALUES (160, '2025-04-30', 'Other', 1, 'Illegal Burning - homeless camp', 0.25, 'A');
INSERT INTO public.incidents VALUES (161, '2025-04-30', 'Alarm', 3, 'Fire Alarm - waterflow, false alarm', 0.08, 'A');
INSERT INTO public.incidents VALUES (162, '2025-04-30', 'Other', 1, 'Service Call - tree and powerlines fell on house', 4.29, 'A');
INSERT INTO public.incidents VALUES (163, '2025-04-30', 'Alarm', 6, 'Fire Alarm - waterflow, sprinkler busted', 0.97, 'A');
INSERT INTO public.incidents VALUES (164, '2025-05-01', 'Alarm', 6, 'Fire Alarm - false alarm', 0.20, 'B');
INSERT INTO public.incidents VALUES (165, '2025-05-01', 'Alarm', 6, 'Fire Alarm - General, false alarm', 0.08, 'B');
INSERT INTO public.incidents VALUES (166, '2025-05-01', 'Medical', 1, 'Overdose - 1 transported', 0.48, 'B');
INSERT INTO public.incidents VALUES (167, '2025-05-01', 'Medical', 7, 'Lift Assist - non emergent', 0.20, 'B');
INSERT INTO public.incidents VALUES (168, '2025-05-01', 'Medical', 3, 'MCI - cpr in progress', 0.20, 'B');
INSERT INTO public.incidents VALUES (169, '2025-05-02', 'Fire', 6, 'Tree fire - caused from power line', 0.87, 'C');
INSERT INTO public.incidents VALUES (170, '2025-05-02', 'Alarm', 3, 'Smoke showing - Dust from construction crew', 0.10, 'C');
INSERT INTO public.incidents VALUES (171, '2025-05-02', 'Medical', 6, 'Unresponsive male', 0.32, 'C');
INSERT INTO public.incidents VALUES (172, '2025-05-02', 'Other', 6, 'Illegal Burning', 0.22, 'C');
INSERT INTO public.incidents VALUES (173, '2025-05-02', 'Alarm', 6, 'Smoke Alarm - power outage tripped alarm', 0.10, 'C');
INSERT INTO public.incidents VALUES (174, '2025-05-02', 'Medical', 6, 'Lift Assist - non emergent', 0.18, 'C');
INSERT INTO public.incidents VALUES (175, '2025-05-03', 'Medical', 1, 'Infant choking', 0.15, 'A');
INSERT INTO public.incidents VALUES (176, '2025-05-03', 'Medical', 6, 'Assault - Child hit with bat from mother and unable to breathe', 0.13, 'A');
INSERT INTO public.incidents VALUES (177, '2025-05-03', 'Fire', 1, 'Transformer on Fire', 0.13, 'A');
INSERT INTO public.incidents VALUES (178, '2025-05-03', 'Other', 4, 'Service Call - Fluid clean up from MVA', 0.17, 'A');
INSERT INTO public.incidents VALUES (179, '2025-05-03', 'Fire', 4, 'Dumpster Fire', 0.27, 'A');
INSERT INTO public.incidents VALUES (180, '2025-05-03', 'Alarm', 1, 'Fire Alarm - General, false alarm', 0.25, 'A');
INSERT INTO public.incidents VALUES (181, '2025-05-03', 'Other', 4, 'Service Call - Smell of something burning - false', 0.32, 'A');
INSERT INTO public.incidents VALUES (182, '2025-05-03', 'Other', 3, 'Service Call - Tree fell on powerline', 1.03, 'A');
INSERT INTO public.incidents VALUES (183, '2025-05-04', 'Other', 4, 'Service Call - Semi struck gas main', 1.51, 'B');


--
-- TOC entry 4957 (class 0 OID 24891)
-- Dependencies: 226
-- Data for Name: incidentunits; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.incidentunits VALUES (1, 121);
INSERT INTO public.incidentunits VALUES (1, 7);
INSERT INTO public.incidentunits VALUES (1, 6);
INSERT INTO public.incidentunits VALUES (1, 10);
INSERT INTO public.incidentunits VALUES (2, 121);
INSERT INTO public.incidentunits VALUES (2, 6);
INSERT INTO public.incidentunits VALUES (2, 4);
INSERT INTO public.incidentunits VALUES (2, 10);
INSERT INTO public.incidentunits VALUES (3, 6);
INSERT INTO public.incidentunits VALUES (4, 121);
INSERT INTO public.incidentunits VALUES (4, 3);
INSERT INTO public.incidentunits VALUES (4, 1);
INSERT INTO public.incidentunits VALUES (4, 5);
INSERT INTO public.incidentunits VALUES (5, 1);
INSERT INTO public.incidentunits VALUES (6, 4);
INSERT INTO public.incidentunits VALUES (6, 2);
INSERT INTO public.incidentunits VALUES (7, 121);
INSERT INTO public.incidentunits VALUES (7, 7);
INSERT INTO public.incidentunits VALUES (7, 6);
INSERT INTO public.incidentunits VALUES (7, 10);
INSERT INTO public.incidentunits VALUES (8, 1);
INSERT INTO public.incidentunits VALUES (9, 121);
INSERT INTO public.incidentunits VALUES (9, 4);
INSERT INTO public.incidentunits VALUES (9, 6);
INSERT INTO public.incidentunits VALUES (9, 10);
INSERT INTO public.incidentunits VALUES (10, 121);
INSERT INTO public.incidentunits VALUES (10, 3);
INSERT INTO public.incidentunits VALUES (10, 1);
INSERT INTO public.incidentunits VALUES (10, 5);
INSERT INTO public.incidentunits VALUES (11, 7);
INSERT INTO public.incidentunits VALUES (12, 1);
INSERT INTO public.incidentunits VALUES (13, 121);
INSERT INTO public.incidentunits VALUES (13, 1);
INSERT INTO public.incidentunits VALUES (13, 3);
INSERT INTO public.incidentunits VALUES (13, 5);
INSERT INTO public.incidentunits VALUES (14, 121);
INSERT INTO public.incidentunits VALUES (14, 6);
INSERT INTO public.incidentunits VALUES (14, 4);
INSERT INTO public.incidentunits VALUES (14, 10);
INSERT INTO public.incidentunits VALUES (15, 1);
INSERT INTO public.incidentunits VALUES (16, 121);
INSERT INTO public.incidentunits VALUES (16, 6);
INSERT INTO public.incidentunits VALUES (16, 7);
INSERT INTO public.incidentunits VALUES (16, 10);
INSERT INTO public.incidentunits VALUES (17, 1);
INSERT INTO public.incidentunits VALUES (17, 121);
INSERT INTO public.incidentunits VALUES (17, 4);
INSERT INTO public.incidentunits VALUES (17, 6);
INSERT INTO public.incidentunits VALUES (17, 2);
INSERT INTO public.incidentunits VALUES (18, 1);
INSERT INTO public.incidentunits VALUES (18, 2);
INSERT INTO public.incidentunits VALUES (19, 6);
INSERT INTO public.incidentunits VALUES (19, 2);
INSERT INTO public.incidentunits VALUES (20, 1);
INSERT INTO public.incidentunits VALUES (21, 1);
INSERT INTO public.incidentunits VALUES (22, 121);
INSERT INTO public.incidentunits VALUES (22, 6);
INSERT INTO public.incidentunits VALUES (22, 7);
INSERT INTO public.incidentunits VALUES (22, 10);
INSERT INTO public.incidentunits VALUES (23, 1);
INSERT INTO public.incidentunits VALUES (24, 4);
INSERT INTO public.incidentunits VALUES (25, 1);
INSERT INTO public.incidentunits VALUES (27, 1);
INSERT INTO public.incidentunits VALUES (28, 3);
INSERT INTO public.incidentunits VALUES (29, 6);
INSERT INTO public.incidentunits VALUES (29, 14);
INSERT INTO public.incidentunits VALUES (30, 121);
INSERT INTO public.incidentunits VALUES (30, 4);
INSERT INTO public.incidentunits VALUES (30, 6);
INSERT INTO public.incidentunits VALUES (30, 2);
INSERT INTO public.incidentunits VALUES (30, 301);
INSERT INTO public.incidentunits VALUES (30, 302);
INSERT INTO public.incidentunits VALUES (31, 4);
INSERT INTO public.incidentunits VALUES (31, 2);
INSERT INTO public.incidentunits VALUES (32, 1);
INSERT INTO public.incidentunits VALUES (33, 6);
INSERT INTO public.incidentunits VALUES (34, 121);
INSERT INTO public.incidentunits VALUES (34, 7);
INSERT INTO public.incidentunits VALUES (34, 6);
INSERT INTO public.incidentunits VALUES (34, 10);
INSERT INTO public.incidentunits VALUES (35, 1);
INSERT INTO public.incidentunits VALUES (36, 4);
INSERT INTO public.incidentunits VALUES (37, 1);
INSERT INTO public.incidentunits VALUES (38, 6);
INSERT INTO public.incidentunits VALUES (39, 121);
INSERT INTO public.incidentunits VALUES (39, 7);
INSERT INTO public.incidentunits VALUES (39, 6);
INSERT INTO public.incidentunits VALUES (39, 10);
INSERT INTO public.incidentunits VALUES (40, 7);
INSERT INTO public.incidentunits VALUES (41, 3);
INSERT INTO public.incidentunits VALUES (42, 7);
INSERT INTO public.incidentunits VALUES (43, 121);
INSERT INTO public.incidentunits VALUES (43, 6);
INSERT INTO public.incidentunits VALUES (43, 4);
INSERT INTO public.incidentunits VALUES (43, 10);
INSERT INTO public.incidentunits VALUES (44, 7);
INSERT INTO public.incidentunits VALUES (45, 1);
INSERT INTO public.incidentunits VALUES (46, 121);
INSERT INTO public.incidentunits VALUES (46, 1);
INSERT INTO public.incidentunits VALUES (46, 3);
INSERT INTO public.incidentunits VALUES (46, 5);
INSERT INTO public.incidentunits VALUES (47, 1);
INSERT INTO public.incidentunits VALUES (48, 121);
INSERT INTO public.incidentunits VALUES (48, 6);
INSERT INTO public.incidentunits VALUES (48, 4);
INSERT INTO public.incidentunits VALUES (48, 10);
INSERT INTO public.incidentunits VALUES (49, 6);
INSERT INTO public.incidentunits VALUES (49, 2);
INSERT INTO public.incidentunits VALUES (50, 121);
INSERT INTO public.incidentunits VALUES (50, 6);
INSERT INTO public.incidentunits VALUES (50, 4);
INSERT INTO public.incidentunits VALUES (50, 2);
INSERT INTO public.incidentunits VALUES (50, 7);
INSERT INTO public.incidentunits VALUES (50, 101);
INSERT INTO public.incidentunits VALUES (50, 302);
INSERT INTO public.incidentunits VALUES (51, 1);
INSERT INTO public.incidentunits VALUES (52, 7);
INSERT INTO public.incidentunits VALUES (53, 1);
INSERT INTO public.incidentunits VALUES (54, 121);
INSERT INTO public.incidentunits VALUES (54, 6);
INSERT INTO public.incidentunits VALUES (54, 14);
INSERT INTO public.incidentunits VALUES (55, 6);
INSERT INTO public.incidentunits VALUES (55, 2);
INSERT INTO public.incidentunits VALUES (56, 7);
INSERT INTO public.incidentunits VALUES (57, 4);
INSERT INTO public.incidentunits VALUES (58, 3);
INSERT INTO public.incidentunits VALUES (59, 121);
INSERT INTO public.incidentunits VALUES (59, 7);
INSERT INTO public.incidentunits VALUES (59, 6);
INSERT INTO public.incidentunits VALUES (59, 10);
INSERT INTO public.incidentunits VALUES (60, 6);
INSERT INTO public.incidentunits VALUES (60, 2);
INSERT INTO public.incidentunits VALUES (61, 1);
INSERT INTO public.incidentunits VALUES (62, 121);
INSERT INTO public.incidentunits VALUES (62, 6);
INSERT INTO public.incidentunits VALUES (62, 4);
INSERT INTO public.incidentunits VALUES (62, 10);
INSERT INTO public.incidentunits VALUES (63, 121);
INSERT INTO public.incidentunits VALUES (63, 6);
INSERT INTO public.incidentunits VALUES (63, 4);
INSERT INTO public.incidentunits VALUES (63, 2);
INSERT INTO public.incidentunits VALUES (64, 6);
INSERT INTO public.incidentunits VALUES (64, 2);
INSERT INTO public.incidentunits VALUES (65, 6);
INSERT INTO public.incidentunits VALUES (65, 2);
INSERT INTO public.incidentunits VALUES (66, 4);
INSERT INTO public.incidentunits VALUES (66, 2);
INSERT INTO public.incidentunits VALUES (67, 1);
INSERT INTO public.incidentunits VALUES (68, 121);
INSERT INTO public.incidentunits VALUES (68, 6);
INSERT INTO public.incidentunits VALUES (68, 4);
INSERT INTO public.incidentunits VALUES (68, 10);
INSERT INTO public.incidentunits VALUES (69, 6);
INSERT INTO public.incidentunits VALUES (70, 1);
INSERT INTO public.incidentunits VALUES (70, 12);
INSERT INTO public.incidentunits VALUES (71, 121);
INSERT INTO public.incidentunits VALUES (71, 3);
INSERT INTO public.incidentunits VALUES (71, 1);
INSERT INTO public.incidentunits VALUES (71, 5);
INSERT INTO public.incidentunits VALUES (72, 121);
INSERT INTO public.incidentunits VALUES (72, 7);
INSERT INTO public.incidentunits VALUES (72, 6);
INSERT INTO public.incidentunits VALUES (72, 2);
INSERT INTO public.incidentunits VALUES (73, 1);
INSERT INTO public.incidentunits VALUES (73, 12);
INSERT INTO public.incidentunits VALUES (74, 6);
INSERT INTO public.incidentunits VALUES (75, 121);
INSERT INTO public.incidentunits VALUES (75, 6);
INSERT INTO public.incidentunits VALUES (75, 7);
INSERT INTO public.incidentunits VALUES (75, 10);
INSERT INTO public.incidentunits VALUES (76, 6);
INSERT INTO public.incidentunits VALUES (77, 7);
INSERT INTO public.incidentunits VALUES (78, 121);
INSERT INTO public.incidentunits VALUES (78, 6);
INSERT INTO public.incidentunits VALUES (78, 4);
INSERT INTO public.incidentunits VALUES (78, 10);
INSERT INTO public.incidentunits VALUES (79, 6);
INSERT INTO public.incidentunits VALUES (79, 2);
INSERT INTO public.incidentunits VALUES (80, 1);
INSERT INTO public.incidentunits VALUES (81, 7);
INSERT INTO public.incidentunits VALUES (82, 4);
INSERT INTO public.incidentunits VALUES (82, 2);
INSERT INTO public.incidentunits VALUES (83, 7);
INSERT INTO public.incidentunits VALUES (84, 121);
INSERT INTO public.incidentunits VALUES (84, 3);
INSERT INTO public.incidentunits VALUES (84, 1);
INSERT INTO public.incidentunits VALUES (84, 5);
INSERT INTO public.incidentunits VALUES (85, 1);
INSERT INTO public.incidentunits VALUES (86, 6);
INSERT INTO public.incidentunits VALUES (86, 4);
INSERT INTO public.incidentunits VALUES (87, 121);
INSERT INTO public.incidentunits VALUES (87, 1);
INSERT INTO public.incidentunits VALUES (87, 7);
INSERT INTO public.incidentunits VALUES (87, 5);
INSERT INTO public.incidentunits VALUES (88, 121);
INSERT INTO public.incidentunits VALUES (88, 6);
INSERT INTO public.incidentunits VALUES (88, 4);
INSERT INTO public.incidentunits VALUES (88, 2);
INSERT INTO public.incidentunits VALUES (89, 6);
INSERT INTO public.incidentunits VALUES (90, 121);
INSERT INTO public.incidentunits VALUES (90, 1);
INSERT INTO public.incidentunits VALUES (90, 3);
INSERT INTO public.incidentunits VALUES (90, 5);
INSERT INTO public.incidentunits VALUES (91, 121);
INSERT INTO public.incidentunits VALUES (91, 4);
INSERT INTO public.incidentunits VALUES (91, 6);
INSERT INTO public.incidentunits VALUES (91, 10);
INSERT INTO public.incidentunits VALUES (92, 4);
INSERT INTO public.incidentunits VALUES (92, 2);
INSERT INTO public.incidentunits VALUES (93, 1);
INSERT INTO public.incidentunits VALUES (94, 6);
INSERT INTO public.incidentunits VALUES (95, 6);
INSERT INTO public.incidentunits VALUES (96, 121);
INSERT INTO public.incidentunits VALUES (96, 6);
INSERT INTO public.incidentunits VALUES (96, 4);
INSERT INTO public.incidentunits VALUES (96, 10);
INSERT INTO public.incidentunits VALUES (97, 4);
INSERT INTO public.incidentunits VALUES (98, 6);
INSERT INTO public.incidentunits VALUES (98, 2);
INSERT INTO public.incidentunits VALUES (99, 4);
INSERT INTO public.incidentunits VALUES (99, 2);
INSERT INTO public.incidentunits VALUES (100, 121);
INSERT INTO public.incidentunits VALUES (100, 7);
INSERT INTO public.incidentunits VALUES (100, 6);
INSERT INTO public.incidentunits VALUES (100, 2);
INSERT INTO public.incidentunits VALUES (101, 1);
INSERT INTO public.incidentunits VALUES (102, 4);
INSERT INTO public.incidentunits VALUES (103, 1);
INSERT INTO public.incidentunits VALUES (103, 12);
INSERT INTO public.incidentunits VALUES (104, 1);
INSERT INTO public.incidentunits VALUES (105, 6);
INSERT INTO public.incidentunits VALUES (106, 121);
INSERT INTO public.incidentunits VALUES (106, 1);
INSERT INTO public.incidentunits VALUES (106, 7);
INSERT INTO public.incidentunits VALUES (106, 5);
INSERT INTO public.incidentunits VALUES (107, 1);
INSERT INTO public.incidentunits VALUES (107, 12);
INSERT INTO public.incidentunits VALUES (108, 1);
INSERT INTO public.incidentunits VALUES (109, 6);
INSERT INTO public.incidentunits VALUES (110, 3);
INSERT INTO public.incidentunits VALUES (111, 1);
INSERT INTO public.incidentunits VALUES (112, 121);
INSERT INTO public.incidentunits VALUES (112, 6);
INSERT INTO public.incidentunits VALUES (112, 4);
INSERT INTO public.incidentunits VALUES (112, 10);
INSERT INTO public.incidentunits VALUES (113, 3);
INSERT INTO public.incidentunits VALUES (113, 12);
INSERT INTO public.incidentunits VALUES (114, 1);
INSERT INTO public.incidentunits VALUES (115, 4);
INSERT INTO public.incidentunits VALUES (115, 2);
INSERT INTO public.incidentunits VALUES (116, 7);
INSERT INTO public.incidentunits VALUES (117, 3);
INSERT INTO public.incidentunits VALUES (117, 14);
INSERT INTO public.incidentunits VALUES (118, 1);
INSERT INTO public.incidentunits VALUES (119, 6);
INSERT INTO public.incidentunits VALUES (120, 121);
INSERT INTO public.incidentunits VALUES (120, 6);
INSERT INTO public.incidentunits VALUES (120, 4);
INSERT INTO public.incidentunits VALUES (120, 10);
INSERT INTO public.incidentunits VALUES (121, 121);
INSERT INTO public.incidentunits VALUES (121, 6);
INSERT INTO public.incidentunits VALUES (121, 4);
INSERT INTO public.incidentunits VALUES (121, 10);
INSERT INTO public.incidentunits VALUES (122, 7);
INSERT INTO public.incidentunits VALUES (123, 1);
INSERT INTO public.incidentunits VALUES (124, 6);
INSERT INTO public.incidentunits VALUES (125, 7);
INSERT INTO public.incidentunits VALUES (126, 6);
INSERT INTO public.incidentunits VALUES (127, 1);
INSERT INTO public.incidentunits VALUES (127, 12);
INSERT INTO public.incidentunits VALUES (128, 3);
INSERT INTO public.incidentunits VALUES (129, 1);
INSERT INTO public.incidentunits VALUES (130, 1);
INSERT INTO public.incidentunits VALUES (130, 12);
INSERT INTO public.incidentunits VALUES (131, 1);
INSERT INTO public.incidentunits VALUES (131, 12);
INSERT INTO public.incidentunits VALUES (132, 121);
INSERT INTO public.incidentunits VALUES (132, 1);
INSERT INTO public.incidentunits VALUES (132, 3);
INSERT INTO public.incidentunits VALUES (132, 5);
INSERT INTO public.incidentunits VALUES (133, 121);
INSERT INTO public.incidentunits VALUES (133, 4);
INSERT INTO public.incidentunits VALUES (133, 1);
INSERT INTO public.incidentunits VALUES (133, 5);
INSERT INTO public.incidentunits VALUES (134, 1);
INSERT INTO public.incidentunits VALUES (135, 1);
INSERT INTO public.incidentunits VALUES (136, 6);
INSERT INTO public.incidentunits VALUES (137, 1);
INSERT INTO public.incidentunits VALUES (138, 1);
INSERT INTO public.incidentunits VALUES (139, 1);
INSERT INTO public.incidentunits VALUES (140, 4);
INSERT INTO public.incidentunits VALUES (141, 6);
INSERT INTO public.incidentunits VALUES (142, 121);
INSERT INTO public.incidentunits VALUES (142, 4);
INSERT INTO public.incidentunits VALUES (142, 1);
INSERT INTO public.incidentunits VALUES (142, 5);
INSERT INTO public.incidentunits VALUES (143, 7);
INSERT INTO public.incidentunits VALUES (144, 6);
INSERT INTO public.incidentunits VALUES (145, 121);
INSERT INTO public.incidentunits VALUES (145, 6);
INSERT INTO public.incidentunits VALUES (145, 4);
INSERT INTO public.incidentunits VALUES (145, 10);
INSERT INTO public.incidentunits VALUES (146, 3);
INSERT INTO public.incidentunits VALUES (147, 7);
INSERT INTO public.incidentunits VALUES (148, 121);
INSERT INTO public.incidentunits VALUES (148, 1);
INSERT INTO public.incidentunits VALUES (148, 7);
INSERT INTO public.incidentunits VALUES (148, 5);
INSERT INTO public.incidentunits VALUES (149, 3);
INSERT INTO public.incidentunits VALUES (150, 3);
INSERT INTO public.incidentunits VALUES (151, 4);
INSERT INTO public.incidentunits VALUES (151, 2);
INSERT INTO public.incidentunits VALUES (152, 121);
INSERT INTO public.incidentunits VALUES (152, 7);
INSERT INTO public.incidentunits VALUES (152, 6);
INSERT INTO public.incidentunits VALUES (152, 10);
INSERT INTO public.incidentunits VALUES (153, 121);
INSERT INTO public.incidentunits VALUES (153, 6);
INSERT INTO public.incidentunits VALUES (153, 4);
INSERT INTO public.incidentunits VALUES (153, 10);
INSERT INTO public.incidentunits VALUES (154, 1);
INSERT INTO public.incidentunits VALUES (155, 1);
INSERT INTO public.incidentunits VALUES (156, 121);
INSERT INTO public.incidentunits VALUES (156, 4);
INSERT INTO public.incidentunits VALUES (156, 6);
INSERT INTO public.incidentunits VALUES (156, 10);
INSERT INTO public.incidentunits VALUES (157, 6);
INSERT INTO public.incidentunits VALUES (158, 121);
INSERT INTO public.incidentunits VALUES (158, 1);
INSERT INTO public.incidentunits VALUES (158, 3);
INSERT INTO public.incidentunits VALUES (158, 5);
INSERT INTO public.incidentunits VALUES (159, 121);
INSERT INTO public.incidentunits VALUES (159, 1);
INSERT INTO public.incidentunits VALUES (159, 3);
INSERT INTO public.incidentunits VALUES (159, 5);
INSERT INTO public.incidentunits VALUES (160, 1);
INSERT INTO public.incidentunits VALUES (161, 121);
INSERT INTO public.incidentunits VALUES (161, 3);
INSERT INTO public.incidentunits VALUES (161, 1);
INSERT INTO public.incidentunits VALUES (161, 5);
INSERT INTO public.incidentunits VALUES (162, 1);
INSERT INTO public.incidentunits VALUES (162, 12);
INSERT INTO public.incidentunits VALUES (163, 121);
INSERT INTO public.incidentunits VALUES (163, 6);
INSERT INTO public.incidentunits VALUES (163, 4);
INSERT INTO public.incidentunits VALUES (163, 10);
INSERT INTO public.incidentunits VALUES (164, 121);
INSERT INTO public.incidentunits VALUES (164, 6);
INSERT INTO public.incidentunits VALUES (164, 4);
INSERT INTO public.incidentunits VALUES (164, 10);
INSERT INTO public.incidentunits VALUES (165, 121);
INSERT INTO public.incidentunits VALUES (165, 6);
INSERT INTO public.incidentunits VALUES (165, 4);
INSERT INTO public.incidentunits VALUES (165, 10);
INSERT INTO public.incidentunits VALUES (166, 1);
INSERT INTO public.incidentunits VALUES (167, 7);
INSERT INTO public.incidentunits VALUES (168, 3);
INSERT INTO public.incidentunits VALUES (169, 6);
INSERT INTO public.incidentunits VALUES (170, 121);
INSERT INTO public.incidentunits VALUES (170, 3);
INSERT INTO public.incidentunits VALUES (170, 1);
INSERT INTO public.incidentunits VALUES (170, 5);
INSERT INTO public.incidentunits VALUES (171, 6);
INSERT INTO public.incidentunits VALUES (172, 6);
INSERT INTO public.incidentunits VALUES (173, 121);
INSERT INTO public.incidentunits VALUES (173, 6);
INSERT INTO public.incidentunits VALUES (173, 4);
INSERT INTO public.incidentunits VALUES (173, 10);
INSERT INTO public.incidentunits VALUES (174, 6);
INSERT INTO public.incidentunits VALUES (175, 1);
INSERT INTO public.incidentunits VALUES (176, 6);
INSERT INTO public.incidentunits VALUES (177, 1);
INSERT INTO public.incidentunits VALUES (178, 4);
INSERT INTO public.incidentunits VALUES (179, 4);
INSERT INTO public.incidentunits VALUES (180, 121);
INSERT INTO public.incidentunits VALUES (180, 1);
INSERT INTO public.incidentunits VALUES (180, 3);
INSERT INTO public.incidentunits VALUES (180, 5);
INSERT INTO public.incidentunits VALUES (181, 4);
INSERT INTO public.incidentunits VALUES (182, 3);
INSERT INTO public.incidentunits VALUES (182, 12);
INSERT INTO public.incidentunits VALUES (183, 4);


--
-- TOC entry 4953 (class 0 OID 24842)
-- Dependencies: 222
-- Data for Name: shifts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shifts VALUES (1, 'B', 1, '2025-04-10', 24);
INSERT INTO public.shifts VALUES (2, 'B', 3, '2025-04-10', 24);
INSERT INTO public.shifts VALUES (3, 'B', 4, '2025-04-10', 24);
INSERT INTO public.shifts VALUES (4, 'B', 6, '2025-04-10', 24);
INSERT INTO public.shifts VALUES (5, 'B', 7, '2025-04-10', 24);
INSERT INTO public.shifts VALUES (6, 'Admin', 1, '2025-04-10', 8);
INSERT INTO public.shifts VALUES (7, 'C', 1, '2025-04-11', 24);
INSERT INTO public.shifts VALUES (8, 'C', 3, '2025-04-11', 24);
INSERT INTO public.shifts VALUES (9, 'C', 4, '2025-04-11', 24);
INSERT INTO public.shifts VALUES (10, 'C', 6, '2025-04-11', 24);
INSERT INTO public.shifts VALUES (11, 'C', 7, '2025-04-11', 24);
INSERT INTO public.shifts VALUES (12, 'Admin', 1, '2025-04-11', 8);
INSERT INTO public.shifts VALUES (13, 'A', 1, '2025-04-12', 24);
INSERT INTO public.shifts VALUES (14, 'A', 3, '2025-04-12', 24);
INSERT INTO public.shifts VALUES (15, 'A', 4, '2025-04-12', 24);
INSERT INTO public.shifts VALUES (16, 'A', 6, '2025-04-12', 24);
INSERT INTO public.shifts VALUES (17, 'A', 7, '2025-04-12', 24);
INSERT INTO public.shifts VALUES (18, 'B', 1, '2025-04-13', 24);
INSERT INTO public.shifts VALUES (19, 'B', 3, '2025-04-13', 24);
INSERT INTO public.shifts VALUES (20, 'B', 4, '2025-04-13', 24);
INSERT INTO public.shifts VALUES (21, 'B', 6, '2025-04-13', 24);
INSERT INTO public.shifts VALUES (22, 'B', 7, '2025-04-13', 24);
INSERT INTO public.shifts VALUES (23, 'C', 1, '2025-04-14', 24);
INSERT INTO public.shifts VALUES (24, 'C', 3, '2025-04-14', 24);
INSERT INTO public.shifts VALUES (25, 'C', 4, '2025-04-14', 24);
INSERT INTO public.shifts VALUES (26, 'C', 6, '2025-04-14', 24);
INSERT INTO public.shifts VALUES (27, 'C', 7, '2025-04-14', 24);
INSERT INTO public.shifts VALUES (28, 'A', 1, '2025-04-15', 24);
INSERT INTO public.shifts VALUES (29, 'A', 3, '2025-04-15', 24);
INSERT INTO public.shifts VALUES (30, 'A', 4, '2025-04-15', 24);
INSERT INTO public.shifts VALUES (31, 'A', 6, '2025-04-15', 24);
INSERT INTO public.shifts VALUES (32, 'A', 7, '2025-04-15', 24);
INSERT INTO public.shifts VALUES (33, 'B', 1, '2025-04-16', 24);
INSERT INTO public.shifts VALUES (34, 'B', 3, '2025-04-16', 24);
INSERT INTO public.shifts VALUES (35, 'B', 4, '2025-04-16', 24);
INSERT INTO public.shifts VALUES (36, 'B', 6, '2025-04-16', 24);
INSERT INTO public.shifts VALUES (37, 'B', 7, '2025-04-16', 24);
INSERT INTO public.shifts VALUES (38, 'C', 1, '2025-04-17', 24);
INSERT INTO public.shifts VALUES (39, 'C', 3, '2025-04-17', 24);
INSERT INTO public.shifts VALUES (40, 'C', 4, '2025-04-17', 24);
INSERT INTO public.shifts VALUES (41, 'C', 6, '2025-04-17', 24);
INSERT INTO public.shifts VALUES (42, 'C', 7, '2025-04-17', 24);
INSERT INTO public.shifts VALUES (43, 'A', 1, '2025-04-18', 24);
INSERT INTO public.shifts VALUES (44, 'A', 3, '2025-04-18', 24);
INSERT INTO public.shifts VALUES (45, 'A', 4, '2025-04-18', 24);
INSERT INTO public.shifts VALUES (46, 'A', 6, '2025-04-18', 24);
INSERT INTO public.shifts VALUES (47, 'A', 7, '2025-04-18', 24);
INSERT INTO public.shifts VALUES (48, 'B', 1, '2025-04-19', 24);
INSERT INTO public.shifts VALUES (49, 'B', 3, '2025-04-19', 24);
INSERT INTO public.shifts VALUES (50, 'B', 4, '2025-04-19', 24);
INSERT INTO public.shifts VALUES (51, 'B', 6, '2025-04-19', 24);
INSERT INTO public.shifts VALUES (52, 'B', 7, '2025-04-19', 24);
INSERT INTO public.shifts VALUES (53, 'C', 1, '2025-04-20', 24);
INSERT INTO public.shifts VALUES (54, 'C', 3, '2025-04-20', 24);
INSERT INTO public.shifts VALUES (55, 'C', 4, '2025-04-20', 24);
INSERT INTO public.shifts VALUES (56, 'C', 6, '2025-04-20', 24);
INSERT INTO public.shifts VALUES (57, 'C', 7, '2025-04-20', 24);
INSERT INTO public.shifts VALUES (58, 'A', 1, '2025-04-21', 24);
INSERT INTO public.shifts VALUES (59, 'A', 3, '2025-04-21', 24);
INSERT INTO public.shifts VALUES (60, 'A', 4, '2025-04-21', 24);
INSERT INTO public.shifts VALUES (61, 'A', 6, '2025-04-21', 24);
INSERT INTO public.shifts VALUES (62, 'A', 7, '2025-04-21', 24);
INSERT INTO public.shifts VALUES (63, 'B', 1, '2025-04-22', 24);
INSERT INTO public.shifts VALUES (64, 'B', 3, '2025-04-22', 24);
INSERT INTO public.shifts VALUES (65, 'B', 4, '2025-04-22', 24);
INSERT INTO public.shifts VALUES (66, 'B', 6, '2025-04-22', 24);
INSERT INTO public.shifts VALUES (67, 'B', 7, '2025-04-22', 24);
INSERT INTO public.shifts VALUES (68, 'C', 1, '2025-04-23', 24);
INSERT INTO public.shifts VALUES (69, 'C', 3, '2025-04-23', 24);
INSERT INTO public.shifts VALUES (70, 'C', 4, '2025-04-23', 24);
INSERT INTO public.shifts VALUES (71, 'C', 6, '2025-04-23', 24);
INSERT INTO public.shifts VALUES (72, 'C', 7, '2025-04-23', 24);
INSERT INTO public.shifts VALUES (73, 'A', 1, '2025-04-24', 24);
INSERT INTO public.shifts VALUES (74, 'A', 3, '2025-04-24', 24);
INSERT INTO public.shifts VALUES (75, 'A', 4, '2025-04-24', 24);
INSERT INTO public.shifts VALUES (76, 'A', 6, '2025-04-24', 24);
INSERT INTO public.shifts VALUES (77, 'A', 7, '2025-04-24', 24);
INSERT INTO public.shifts VALUES (78, 'B', 1, '2025-04-25', 24);
INSERT INTO public.shifts VALUES (79, 'B', 3, '2025-04-25', 24);
INSERT INTO public.shifts VALUES (80, 'B', 4, '2025-04-25', 24);
INSERT INTO public.shifts VALUES (81, 'B', 6, '2025-04-25', 24);
INSERT INTO public.shifts VALUES (82, 'B', 7, '2025-04-25', 24);
INSERT INTO public.shifts VALUES (83, 'C', 1, '2025-04-26', 24);
INSERT INTO public.shifts VALUES (84, 'C', 3, '2025-04-26', 24);
INSERT INTO public.shifts VALUES (85, 'C', 4, '2025-04-26', 24);
INSERT INTO public.shifts VALUES (86, 'C', 6, '2025-04-26', 24);
INSERT INTO public.shifts VALUES (87, 'C', 7, '2025-04-26', 24);
INSERT INTO public.shifts VALUES (88, 'A', 1, '2025-04-27', 24);
INSERT INTO public.shifts VALUES (89, 'A', 3, '2025-04-27', 24);
INSERT INTO public.shifts VALUES (90, 'A', 4, '2025-04-27', 24);
INSERT INTO public.shifts VALUES (91, 'A', 6, '2025-04-27', 24);
INSERT INTO public.shifts VALUES (92, 'A', 7, '2025-04-27', 24);
INSERT INTO public.shifts VALUES (93, 'B', 1, '2025-04-28', 24);
INSERT INTO public.shifts VALUES (94, 'B', 3, '2025-04-28', 24);
INSERT INTO public.shifts VALUES (95, 'B', 4, '2025-04-28', 24);
INSERT INTO public.shifts VALUES (96, 'B', 6, '2025-04-28', 24);
INSERT INTO public.shifts VALUES (97, 'B', 7, '2025-04-28', 24);
INSERT INTO public.shifts VALUES (98, 'C', 1, '2025-04-29', 24);
INSERT INTO public.shifts VALUES (99, 'C', 3, '2025-04-29', 24);
INSERT INTO public.shifts VALUES (100, 'C', 4, '2025-04-29', 24);
INSERT INTO public.shifts VALUES (101, 'C', 6, '2025-04-29', 24);
INSERT INTO public.shifts VALUES (102, 'C', 7, '2025-04-29', 24);
INSERT INTO public.shifts VALUES (103, 'A', 1, '2025-04-30', 24);
INSERT INTO public.shifts VALUES (104, 'A', 3, '2025-04-30', 24);
INSERT INTO public.shifts VALUES (105, 'A', 4, '2025-04-30', 24);
INSERT INTO public.shifts VALUES (106, 'A', 6, '2025-04-30', 24);
INSERT INTO public.shifts VALUES (107, 'A', 7, '2025-04-30', 24);
INSERT INTO public.shifts VALUES (108, 'B', 1, '2025-05-01', 24);
INSERT INTO public.shifts VALUES (109, 'B', 3, '2025-05-01', 24);
INSERT INTO public.shifts VALUES (110, 'B', 4, '2025-05-01', 24);
INSERT INTO public.shifts VALUES (111, 'B', 6, '2025-05-01', 24);
INSERT INTO public.shifts VALUES (112, 'B', 7, '2025-05-01', 24);
INSERT INTO public.shifts VALUES (113, 'C', 1, '2025-05-02', 24);
INSERT INTO public.shifts VALUES (114, 'C', 3, '2025-05-02', 24);
INSERT INTO public.shifts VALUES (115, 'C', 4, '2025-05-02', 24);
INSERT INTO public.shifts VALUES (116, 'C', 6, '2025-05-02', 24);
INSERT INTO public.shifts VALUES (117, 'C', 7, '2025-05-02', 24);
INSERT INTO public.shifts VALUES (118, 'A', 1, '2025-05-03', 24);
INSERT INTO public.shifts VALUES (119, 'A', 3, '2025-05-03', 24);
INSERT INTO public.shifts VALUES (120, 'A', 4, '2025-05-03', 24);
INSERT INTO public.shifts VALUES (121, 'A', 6, '2025-05-03', 24);
INSERT INTO public.shifts VALUES (122, 'A', 7, '2025-05-03', 24);


--
-- TOC entry 4948 (class 0 OID 24811)
-- Dependencies: 217
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.stations VALUES (1, 'Central', '310 Broadway St.');
INSERT INTO public.stations VALUES (3, 'Station 3', '758 Park Ave.');
INSERT INTO public.stations VALUES (4, 'Station 4', '525 Airport Rd.');
INSERT INTO public.stations VALUES (6, 'Station 6', '220 Lakeshore Dr.');
INSERT INTO public.stations VALUES (7, 'Station 7', '1311 Golf Links Rd.');


--
-- TOC entry 4949 (class 0 OID 24816)
-- Dependencies: 218
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.units VALUES (1, 'Engine 1', 'Engine', 1);
INSERT INTO public.units VALUES (3, 'Engine 3', 'Engine', 3);
INSERT INTO public.units VALUES (4, 'Engine 4', 'Engine', 4);
INSERT INTO public.units VALUES (6, 'Engine 6', 'Engine', 6);
INSERT INTO public.units VALUES (7, 'Engine 7', 'Engine', 7);
INSERT INTO public.units VALUES (5, 'Truck 5', 'Truck', 1);
INSERT INTO public.units VALUES (10, 'Truck 10', 'Truck', 6);
INSERT INTO public.units VALUES (121, '121', 'Command', 1);
INSERT INTO public.units VALUES (101, '101', 'Command', 1);
INSERT INTO public.units VALUES (102, '102', 'Command', 1);
INSERT INTO public.units VALUES (12, 'Rescue 12', 'Rescue', 1);
INSERT INTO public.units VALUES (2, 'Rescue 2', 'Rescue', 4);
INSERT INTO public.units VALUES (14, 'Brush Truck 14', 'Brush', 1);
INSERT INTO public.units VALUES (401, '401', 'Command', 1);
INSERT INTO public.units VALUES (402, '402', 'Command', 1);
INSERT INTO public.units VALUES (301, '301', 'Command', 1);
INSERT INTO public.units VALUES (302, '302', 'Command', 1);


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 219
-- Name: firefighters_firefighter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.firefighters_firefighter_id_seq', 76, true);


--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 224
-- Name: incidents_incident_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incidents_incident_id_seq', 183, true);


--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 221
-- Name: shifts_shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shifts_shift_id_seq', 122, true);


--
-- TOC entry 4783 (class 2606 OID 24835)
-- Name: firefighters firefighters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_pkey PRIMARY KEY (firefighter_id);


--
-- TOC entry 4787 (class 2606 OID 24858)
-- Name: firefightershifts firefightershifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefightershifts
    ADD CONSTRAINT firefightershifts_pkey PRIMARY KEY (firefighter_id, shift_id);


--
-- TOC entry 4789 (class 2606 OID 24884)
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (incident_id);


--
-- TOC entry 4793 (class 2606 OID 24895)
-- Name: incidentunits incidentunits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_pkey PRIMARY KEY (incident_id, unit_id);


--
-- TOC entry 4785 (class 2606 OID 24848)
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (shift_id);


--
-- TOC entry 4779 (class 2606 OID 24815)
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (station_id);


--
-- TOC entry 4781 (class 2606 OID 24821)
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (unit_id);


--
-- TOC entry 4790 (class 1259 OID 24913)
-- Name: idx_incidentunits_incident_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incidentunits_incident_id ON public.incidentunits USING btree (incident_id);


--
-- TOC entry 4791 (class 1259 OID 24914)
-- Name: idx_incidentunits_unit_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incidentunits_unit_id ON public.incidentunits USING btree (unit_id);


--
-- TOC entry 4795 (class 2606 OID 24836)
-- Name: firefighters firefighters_station_assignment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_station_assignment_fkey FOREIGN KEY (station_assignment) REFERENCES public.stations(station_id);


--
-- TOC entry 4796 (class 2606 OID 24906)
-- Name: firefighters firefighters_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(unit_id);


--
-- TOC entry 4798 (class 2606 OID 24859)
-- Name: firefightershifts firefightershifts_firefighter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefightershifts
    ADD CONSTRAINT firefightershifts_firefighter_id_fkey FOREIGN KEY (firefighter_id) REFERENCES public.firefighters(firefighter_id);


--
-- TOC entry 4799 (class 2606 OID 24864)
-- Name: firefightershifts firefightershifts_shift_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefightershifts
    ADD CONSTRAINT firefightershifts_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES public.shifts(shift_id);


--
-- TOC entry 4800 (class 2606 OID 24885)
-- Name: incidents incidents_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);


--
-- TOC entry 4801 (class 2606 OID 24896)
-- Name: incidentunits incidentunits_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(incident_id);


--
-- TOC entry 4802 (class 2606 OID 24901)
-- Name: incidentunits incidentunits_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(unit_id);


--
-- TOC entry 4797 (class 2606 OID 24849)
-- Name: shifts shifts_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);


--
-- TOC entry 4794 (class 2606 OID 24822)
-- Name: units units_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);


-- Completed on 2025-05-04 23:32:37

--
-- PostgreSQL database dump complete
--

