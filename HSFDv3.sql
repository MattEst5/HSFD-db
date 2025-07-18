--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-06-30 15:15:03

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
-- TOC entry 4973 (class 1262 OID 5)
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
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 4973
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 229 (class 1255 OID 24971)
-- Name: update_incident_shifts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_incident_shifts() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE incidents i
  SET shift_id = s.shift_id
  FROM shifts s
  JOIN stationshifts ss ON s.station_shift_id = ss.station_shift_id
  WHERE i.station_id = ss.station_id
    AND DATE(i.call_time) = s.shift_date;
END;
$$;


ALTER FUNCTION public.update_incident_shifts() OWNER TO postgres;

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
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 219
-- Name: firefighters_firefighter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.firefighters_firefighter_id_seq OWNED BY public.firefighters.firefighter_id;


--
-- TOC entry 221 (class 1259 OID 24854)
-- Name: firefightershifts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.firefightershifts (
    firefighter_id integer NOT NULL,
    station_shift_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone
);


ALTER TABLE public.firefightershifts OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24875)
-- Name: incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidents (
    incident_id integer NOT NULL,
    incident_type character varying(50),
    station_id integer,
    description text,
    duration_hours numeric(5,2),
    call_time timestamp without time zone,
    shift_id integer,
    CONSTRAINT incidents_duration_hours_check CHECK ((duration_hours > (0)::numeric)),
    CONSTRAINT incidents_incident_type_check CHECK (((incident_type)::text = ANY ((ARRAY['Fire'::character varying, 'Rescue'::character varying, 'Medical'::character varying, 'HazMat'::character varying, 'Alarm'::character varying, 'Other'::character varying, 'Aircraft'::character varying])::text[])))
);


ALTER TABLE public.incidents OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24874)
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
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 222
-- Name: incidents_incident_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incidents_incident_id_seq OWNED BY public.incidents.incident_id;


--
-- TOC entry 224 (class 1259 OID 24891)
-- Name: incidentunits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidentunits (
    incident_id integer NOT NULL,
    unit_id integer NOT NULL
);


ALTER TABLE public.incidentunits OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24953)
-- Name: shifts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shifts (
    shift_id integer NOT NULL,
    station_shift_id integer,
    shift_date date,
    hours integer
);


ALTER TABLE public.shifts OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24952)
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
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 227
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
-- TOC entry 226 (class 1259 OID 24941)
-- Name: stationshifts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stationshifts (
    station_shift_id integer NOT NULL,
    station_id integer,
    shift_name character varying(10)
);


ALTER TABLE public.stationshifts OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24940)
-- Name: stationshifts_station_shift_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stationshifts_station_shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stationshifts_station_shift_id_seq OWNER TO postgres;

--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 225
-- Name: stationshifts_station_shift_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stationshifts_station_shift_id_seq OWNED BY public.stationshifts.station_shift_id;


--
-- TOC entry 218 (class 1259 OID 24816)
-- Name: units; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.units (
    unit_id integer NOT NULL,
    unit_name character varying(50) NOT NULL,
    type character varying(25),
    station_id integer,
    CONSTRAINT units_type_check CHECK (((type)::text = ANY ((ARRAY['Engine'::character varying, 'Truck'::character varying, 'Rescue'::character varying, 'Boat'::character varying, 'Brush'::character varying, 'ATV'::character varying, 'Haz-Mat'::character varying, 'Dive'::character varying, 'Command'::character varying, 'Aircraft'::character varying])::text[])))
);


ALTER TABLE public.units OWNER TO postgres;

--
-- TOC entry 4774 (class 2604 OID 24831)
-- Name: firefighters firefighter_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters ALTER COLUMN firefighter_id SET DEFAULT nextval('public.firefighters_firefighter_id_seq'::regclass);


--
-- TOC entry 4775 (class 2604 OID 24878)
-- Name: incidents incident_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents ALTER COLUMN incident_id SET DEFAULT nextval('public.incidents_incident_id_seq'::regclass);


--
-- TOC entry 4777 (class 2604 OID 24956)
-- Name: shifts shift_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts ALTER COLUMN shift_id SET DEFAULT nextval('public.shifts_shift_id_seq'::regclass);


--
-- TOC entry 4776 (class 2604 OID 24944)
-- Name: stationshifts station_shift_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stationshifts ALTER COLUMN station_shift_id SET DEFAULT nextval('public.stationshifts_station_shift_id_seq'::regclass);


--
-- TOC entry 4959 (class 0 OID 24828)
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
-- TOC entry 4960 (class 0 OID 24854)
-- Dependencies: 221
-- Data for Name: firefightershifts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.firefightershifts VALUES (74, 2, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-04-10 07:00:00', '2025-04-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-04-11 07:00:00', '2025-04-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-04-12 07:00:00', '2025-04-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-04-13 07:00:00', '2025-04-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-04-14 07:00:00', '2025-04-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-04-15 07:00:00', '2025-04-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-04-16 07:00:00', '2025-04-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-04-17 07:00:00', '2025-04-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-04-18 07:00:00', '2025-04-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-04-19 07:00:00', '2025-04-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-04-20 07:00:00', '2025-04-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-04-21 07:00:00', '2025-04-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-04-22 07:00:00', '2025-04-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-04-23 07:00:00', '2025-04-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-04-24 07:00:00', '2025-04-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-04-25 07:00:00', '2025-04-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-04-26 07:00:00', '2025-04-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-04-27 07:00:00', '2025-04-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-04-28 07:00:00', '2025-04-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-04-29 07:00:00', '2025-04-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-04-30 07:00:00', '2025-05-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-05-01 07:00:00', '2025-05-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-05-02 07:00:00', '2025-05-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-05-03 07:00:00', '2025-05-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-05-04 07:00:00', '2025-05-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-05-05 07:00:00', '2025-05-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-05-06 07:00:00', '2025-05-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-05-07 07:00:00', '2025-05-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-05-08 07:00:00', '2025-05-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-05-09 07:00:00', '2025-05-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-05-10 07:00:00', '2025-05-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-05-11 07:00:00', '2025-05-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-05-12 07:00:00', '2025-05-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-05-13 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-05-14 07:00:00', '2025-05-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-05-15 07:00:00', '2025-05-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-05-16 07:00:00', '2025-05-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-05-16 07:00:00', '2025-05-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-05-17 07:00:00', '2025-05-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-05-18 07:00:00', '2025-05-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-05-19 07:00:00', '2025-05-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-05-20 07:00:00', '2025-05-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-05-21 07:00:00', '2025-05-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-05-22 07:00:00', '2025-05-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-05-23 07:00:00', '2025-05-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-05-24 07:00:00', '2025-05-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-05-25 07:00:00', '2025-05-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-05-26 07:00:00', '2025-05-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-05-27 07:00:00', '2025-05-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-05-28 07:00:00', '2025-05-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-05-29 07:00:00', '2025-05-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-05-30 07:00:00', '2025-05-31 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-05-31 07:00:00', '2025-06-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-06-01 07:00:00', '2025-06-02 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-06-02 07:00:00', '2025-06-03 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-06-03 07:00:00', '2025-06-04 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-06-04 07:00:00', '2025-06-05 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-06-05 07:00:00', '2025-06-06 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-06-06 07:00:00', '2025-06-07 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-06-07 07:00:00', '2025-06-08 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-06-08 07:00:00', '2025-06-09 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-06-09 07:00:00', '2025-06-10 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-06-10 07:00:00', '2025-06-11 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-06-11 07:00:00', '2025-06-12 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-06-12 07:00:00', '2025-06-13 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-06-13 07:00:00', '2025-06-14 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-06-14 07:00:00', '2025-06-15 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-06-15 07:00:00', '2025-06-16 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-06-16 07:00:00', '2025-06-17 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-06-17 07:00:00', '2025-06-18 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-06-18 07:00:00', '2025-06-19 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-06-19 07:00:00', '2025-06-20 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-06-20 07:00:00', '2025-06-21 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-06-21 07:00:00', '2025-06-22 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-06-22 07:00:00', '2025-06-23 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-06-23 07:00:00', '2025-06-24 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-06-24 07:00:00', '2025-06-25 07:00:00');
INSERT INTO public.firefightershifts VALUES (15, 3, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (12, 3, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (49, 3, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (70, 3, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (45, 3, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (33, 3, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (19, 6, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (18, 6, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (31, 9, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (61, 9, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (13, 12, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (35, 12, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (71, 12, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (22, 12, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (48, 12, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (16, 15, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (25, 15, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-06-25 07:00:00', '2025-06-26 07:00:00');
INSERT INTO public.firefightershifts VALUES (51, 1, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (26, 1, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (23, 1, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (50, 1, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (72, 1, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (11, 1, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (59, 1, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (7, 1, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (3, 4, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (44, 4, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (37, 7, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (8, 7, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (9, 10, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (75, 10, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (27, 10, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (17, 10, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (65, 10, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (66, 10, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (30, 13, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (40, 13, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-06-26 07:00:00', '2025-06-27 07:00:00');
INSERT INTO public.firefightershifts VALUES (74, 2, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (4, 2, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (36, 2, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (47, 2, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (56, 2, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (20, 5, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (32, 5, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (24, 8, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (29, 8, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (76, 11, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (14, 11, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (5, 11, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (21, 11, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (55, 14, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (41, 14, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-06-27 07:00:00', '2025-06-28 07:00:00');
INSERT INTO public.firefightershifts VALUES (67, 3, '2025-06-28 07:00:00', '2025-06-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (53, 6, '2025-06-28 07:00:00', '2025-06-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (43, 9, '2025-06-28 07:00:00', '2025-06-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (58, 12, '2025-06-28 07:00:00', '2025-06-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (60, 15, '2025-06-28 07:00:00', '2025-06-29 07:00:00');
INSERT INTO public.firefightershifts VALUES (73, 1, '2025-06-29 07:00:00', '2025-06-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (54, 4, '2025-06-29 07:00:00', '2025-06-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (52, 7, '2025-06-29 07:00:00', '2025-06-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (69, 10, '2025-06-29 07:00:00', '2025-06-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (62, 13, '2025-06-29 07:00:00', '2025-06-30 07:00:00');
INSERT INTO public.firefightershifts VALUES (28, 2, '2025-06-30 07:00:00', '2025-07-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (64, 5, '2025-06-30 07:00:00', '2025-07-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (68, 8, '2025-06-30 07:00:00', '2025-07-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (39, 11, '2025-06-30 07:00:00', '2025-07-01 07:00:00');
INSERT INTO public.firefightershifts VALUES (6, 14, '2025-06-30 07:00:00', '2025-07-01 07:00:00');


--
-- TOC entry 4962 (class 0 OID 24875)
-- Dependencies: 223
-- Data for Name: incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.incidents VALUES (651, 'Alarm', 6, 'Oven Fire - fire out on arrival', 0.27, '2025-06-30 11:53:56', 414);
INSERT INTO public.incidents VALUES (649, 'Alarm', 7, 'Fire Alarm - residential, false alarm', 0.12, '2025-06-30 10:21:59', 415);
INSERT INTO public.incidents VALUES (647, 'Alarm', 6, 'Fire Alarm - pull station, false alarm', 0.12, '2025-06-30 01:52:58', 414);
INSERT INTO public.incidents VALUES (645, 'Medical', 7, 'Lift Assist - non emergent', 0.18, '2025-06-30 07:35:11', 415);
INSERT INTO public.incidents VALUES (643, 'Alarm', 6, 'Fire Alarm - pull station, false alarm', 0.62, '2025-06-30 01:52:58', 414);
INSERT INTO public.incidents VALUES (641, 'Medical', 1, 'Overdose', 0.03, '2025-06-29 20:41:13', 406);
INSERT INTO public.incidents VALUES (640, 'Medical', 7, 'MVA - 2 veh, driver fled scene, 1 transported', 0.37, '2025-06-29 17:18:47', 410);
INSERT INTO public.incidents VALUES (636, 'Medical', 6, 'Overdose - cancelled en route', 0.01, '2025-06-29 00:49:50', 409);
INSERT INTO public.incidents VALUES (639, 'Other', 1, 'Service Call - animal services needs to gain entry to manhole', 0.12, '2025-06-29 13:39:55', 406);
INSERT INTO public.incidents VALUES (637, 'Medical', 1, 'Poss Stroke', 0.38, '2025-06-29 01:35:26', 406);
INSERT INTO public.incidents VALUES (650, 'Other', 6, 'Large commercial burn in Fire District 1 - Illegal burn', 0.43, '2025-06-30 11:23:16', 414);
INSERT INTO public.incidents VALUES (635, 'Medical', 6, 'Bicycle crash', 0.07, '2025-06-28 21:54:31', 404);
INSERT INTO public.incidents VALUES (648, 'Other', 7, 'Storm drain smoking', 0.92, '2025-06-30 09:51:08', 415);
INSERT INTO public.incidents VALUES (646, 'Other', 1, 'Service Call', 0.17, '2025-06-30 08:43:07', 411);
INSERT INTO public.incidents VALUES (633, 'Alarm', 3, 'Fire Alarm - residential, false alarm', 0.15, '2025-06-28 20:18:03', 402);
INSERT INTO public.incidents VALUES (644, 'Medical', 1, 'Chest Pains', 0.20, '2025-06-30 04:52:16', 411);
INSERT INTO public.incidents VALUES (642, 'Medical', 4, 'Lift Assist - non emergent', 0.62, '2025-06-29 21:06:59', 408);
INSERT INTO public.incidents VALUES (631, 'Fire', 4, 'Grass fire on WB ramp', 0.08, '2025-06-28 17:04:13', 403);
INSERT INTO public.incidents VALUES (629, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.90, '2025-06-28 02:46:57', 401);
INSERT INTO public.incidents VALUES (634, 'Alarm', 4, 'Poss Structure Fire, Smoke seen from passerby - false alarm', 0.17, '2025-06-28 20:24:22', 403);
INSERT INTO public.incidents VALUES (119, 'Medical', 6, 'Lift Assist - emergent', 0.17, '2025-04-24 21:56:00', 74);
INSERT INTO public.incidents VALUES (251, 'Other', 4, 'Service Call', 0.18, '2025-05-13 14:30:00', 168);
INSERT INTO public.incidents VALUES (109, 'Fire', 6, 'Vehicle Fire - radiator smoking, false alarm', 0.12, '2025-04-23 16:10:00', 69);
INSERT INTO public.incidents VALUES (326, 'Medical', 4, 'Lift Assist - non emergent', 0.30, '2025-05-23 09:46:00', 218);
INSERT INTO public.incidents VALUES (327, 'Medical', 3, 'Gain Entry', 1.95, '2025-05-23 09:59:00', 217);
INSERT INTO public.incidents VALUES (412, 'Medical', 4, 'MVA - 2 veh, minor injuries', 0.48, '2025-06-06 15:47:00', 288);
INSERT INTO public.incidents VALUES (414, 'Other', 1, 'Illegal Burning', 0.25, '2025-06-06 21:14:00', 286);
INSERT INTO public.incidents VALUES (415, 'Medical', 1, 'Lift Assist - non emergent', 0.18, '2025-06-06 11:49:00', 286);
INSERT INTO public.incidents VALUES (502, 'Other', 6, 'Illegal Burning', 0.25, '2025-06-15 23:05:00', 334);
INSERT INTO public.incidents VALUES (356, 'Medical', 4, 'MVA - Truck drove in to building, minor injuries', 0.85, '2025-05-28 12:24:00', 243);
INSERT INTO public.incidents VALUES (351, 'Other', 6, 'Illegal Burning', 0.20, '2025-05-27 15:41:00', 239);
INSERT INTO public.incidents VALUES (188, 'Alarm', 6, 'Sprinkler Alarm - System Malfunction', 0.12, '2025-05-05 11:45:00', 129);
INSERT INTO public.incidents VALUES (111, 'Medical', 1, 'Lift Assist - non emergent, biohaz', 0.27, '2025-04-23 22:14:00', 66);
INSERT INTO public.incidents VALUES (186, 'Alarm', 6, 'Sprinkler Alarm - System Malfunction', 0.35, '2025-05-05 10:40:00', 129);
INSERT INTO public.incidents VALUES (120, 'Alarm', 6, 'Water Flow alarm - false alarm', 0.50, '2025-04-24 22:18:00', 74);
INSERT INTO public.incidents VALUES (526, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.18, '2025-06-19 12:31:00', 354);
INSERT INTO public.incidents VALUES (527, 'Alarm', 4, 'Fire Alarm - general, false alarm', 0.08, '2025-06-19 12:55:00', 353);
INSERT INTO public.incidents VALUES (137, 'Medical', 1, 'Lift Assist - non emergent, biohaz', 1.28, '2025-04-26 11:40:00', 81);
INSERT INTO public.incidents VALUES (436, 'Medical', 7, 'Repiratory Distress - 1 transported', 0.30, '2025-06-08 18:21:00', 300);
INSERT INTO public.incidents VALUES (437, 'Medical', 3, 'Chest Pains - 1 transported', 0.17, '2025-06-08 21:27:00', 297);
INSERT INTO public.incidents VALUES (438, 'Other', 1, 'Fire Alarm beeping', 0.22, '2025-06-09 08:30:00', 301);
INSERT INTO public.incidents VALUES (380, 'Alarm', 4, 'Fire Alarm - pull station, false alarm', 0.18, '2025-06-01 04:47:00', 263);
INSERT INTO public.incidents VALUES (467, 'Alarm', 7, 'Fire Alarm - general, false alarm', 0.15, '2025-06-12 12:11:00', 320);
INSERT INTO public.incidents VALUES (65, 'Medical', 6, 'MVA - 3 vehicle', 0.43, '2025-04-18 13:05:00', 44);
INSERT INTO public.incidents VALUES (388, 'Fire', 3, 'Structure Fire - Balcony set, Arson', 0.50, '2025-06-01 22:22:00', 262);
INSERT INTO public.incidents VALUES (596, 'Medical', 6, 'Infant Seizure', 0.18, '2025-06-25 18:44:00', 384);
INSERT INTO public.incidents VALUES (591, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.17, '2025-06-24 21:37:00', 376);
INSERT INTO public.incidents VALUES (359, 'Medical', 4, 'MVA - Rollover, vehicle upside-down, minor injuries', 0.78, '2025-05-28 22:32:00', 243);
INSERT INTO public.incidents VALUES (360, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.05, '2025-05-28 21:28:00', 244);
INSERT INTO public.incidents VALUES (174, 'Medical', 6, 'Lift Assist - non emergent', 0.18, '2025-05-01 04:31:00', 109);
INSERT INTO public.incidents VALUES (177, 'Fire', 1, 'Transformer on Fire', 0.13, '2025-05-02 11:01:00', 111);
INSERT INTO public.incidents VALUES (178, 'Other', 4, 'Service Call - Fluid clean up from MVA', 0.17, '2025-05-02 16:49:00', 113);
INSERT INTO public.incidents VALUES (590, 'Medical', 1, 'Chest Pains', 0.33, '2025-06-24 19:17:00', 376);
INSERT INTO public.incidents VALUES (345, 'Other', 3, 'Power line fell over road', 0.10, '2025-05-26 10:15:00', 232);
INSERT INTO public.incidents VALUES (346, 'Other', 3, 'Tree fell on power line', 0.82, '2025-05-26 12:03:00', 232);
INSERT INTO public.incidents VALUES (638, 'Other', 1, 'Powerline down, blocking road', 0.97, '2025-06-29 02:31:22', 406);
INSERT INTO public.incidents VALUES (430, 'Fire', 4, 'Structure Fire - Fully involved, residential, everyone out', 1.85, '2025-06-08 08:19:00', 298);
INSERT INTO public.incidents VALUES (130, 'Medical', 1, 'MVA vs Bicycle - 2 transported', 0.08, '2025-04-25 16:14:00', 76);
INSERT INTO public.incidents VALUES (280, 'Other', 1, 'Illegal Burning', 0.23, '2025-05-16 21:39:00', 181);
INSERT INTO public.incidents VALUES (340, 'Alarm', 3, 'Fire Alarm - general, false alarm', 0.25, '2025-05-24 21:57:00', 222);
INSERT INTO public.incidents VALUES (341, 'Medical', 1, 'Intoxicated female - head trauma, 1 transported', 0.12, '2025-05-24 23:05:00', 221);
INSERT INTO public.incidents VALUES (309, 'Medical', 6, 'MCI - 1 transported', 0.30, '2025-05-20 20:24:00', 204);
INSERT INTO public.incidents VALUES (293, 'Alarm', 7, 'Smoke Alarm - cancelled en route', 0.05, '2025-05-18 11:47:00', 195);
INSERT INTO public.incidents VALUES (294, 'Alarm', 6, 'Fire Alarm - alarm malfunctioning', 0.33, '2025-05-18 18:13:00', 194);
INSERT INTO public.incidents VALUES (319, 'Other', 1, 'Illegal Burning', 0.42, '2025-05-21 21:33:00', 206);
INSERT INTO public.incidents VALUES (315, 'Medical', 4, 'Allergic Reaction while driving', 0.10, '2025-05-21 13:33:00', 208);
INSERT INTO public.incidents VALUES (85, 'Medical', 1, 'Lift Assist - Non Emergent', 0.25, '2025-04-20 11:31:00', 51);
INSERT INTO public.incidents VALUES (263, 'Other', 7, 'Illegal Burning', 0.20, '2025-05-14 11:48:00', 175);
INSERT INTO public.incidents VALUES (602, 'Medical', 6, 'Adult Seizure', 0.28, '2025-06-26 19:06:00', 389);
INSERT INTO public.incidents VALUES (240, 'Alarm', 1, 'Fire Alarm - false alarm', 0.25, '2025-05-11 18:36:00', 156);
INSERT INTO public.incidents VALUES (241, 'Medical', 1, 'Chest pains - 1 transported', 0.12, '2025-05-11 21:15:00', 156);
INSERT INTO public.incidents VALUES (104, 'Medical', 1, 'Lift Assist - Emergent, biohaz', 0.58, '2025-04-23 11:28:00', 66);
INSERT INTO public.incidents VALUES (101, 'Other', 1, 'Illegal Burning', 0.04, '2025-04-23 02:50:00', 66);
INSERT INTO public.incidents VALUES (110, 'Medical', 3, 'Lift Assist - non emergent', 0.15, '2025-04-23 21:28:00', 67);
INSERT INTO public.incidents VALUES (190, 'Medical', 6, 'Lift Assist - Non emergent', 0.37, '2025-05-05 19:39:00', 129);
INSERT INTO public.incidents VALUES (429, 'Medical', 6, 'Lift Assist - non emergent', 0.57, '2025-06-08 02:18:00', 299);
INSERT INTO public.incidents VALUES (114, 'Medical', 1, 'Lift Assist - non emergent, biohaz', 0.27, '2025-04-24 11:05:00', 71);
INSERT INTO public.incidents VALUES (580, 'Other', 4, 'Illegal Burning', 0.23, '2025-06-23 20:37:00', 373);
INSERT INTO public.incidents VALUES (581, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.12, '2025-06-23 22:13:00', 374);
INSERT INTO public.incidents VALUES (582, 'Medical', 1, 'Lift Assist - non emergent', 0.18, '2025-06-23 22:54:00', 371);
INSERT INTO public.incidents VALUES (583, 'Medical', 1, 'Chest Pains', 0.05, '2025-06-23 23:06:00', 371);
INSERT INTO public.incidents VALUES (317, 'Medical', 6, 'MVA - veh vs bicycle, 1 transported', 0.34, '2025-05-21 15:52:00', 209);
INSERT INTO public.incidents VALUES (134, 'Medical', 1, 'Lift Assist - non emergent, biohaz', 0.55, '2025-04-25 22:54:00', 76);
INSERT INTO public.incidents VALUES (56, 'Medical', 7, 'MCI - 1 transported', 0.80, '2025-04-17 07:31:00', 40);
INSERT INTO public.incidents VALUES (385, 'Medical', 6, 'Lift Assist - non emergent', 0.17, '2025-06-01 17:57:00', 264);
INSERT INTO public.incidents VALUES (349, 'Medical', 3, 'Lift Assist - emergent', 0.15, '2025-05-26 21:28:00', 232);
INSERT INTO public.incidents VALUES (350, 'Other', 1, 'Service Call - smell of natural gas', 0.23, '2025-05-26 22:09:00', 231);
INSERT INTO public.incidents VALUES (290, 'Other', 6, 'Service Call - tree fell in to powerline and is arcing', 1.55, '2025-05-18 01:55:00', 194);
INSERT INTO public.incidents VALUES (483, 'Medical', 1, 'Lift Assist  - emergent', 0.28, '2025-06-14 13:29:00', 326);
INSERT INTO public.incidents VALUES (305, 'Medical', 6, 'Heat Stroke - 1 transported', 0.13, '2025-05-20 12:48:00', 204);
INSERT INTO public.incidents VALUES (306, 'Fire', 7, 'Vehicle Fire - fully involved on bypass', 0.62, '2025-05-20 13:10:00', 205);
INSERT INTO public.incidents VALUES (155, 'Medical', 1, 'Lift Assist - non emergent', 0.25, '2025-04-27 14:11:00', 86);
INSERT INTO public.incidents VALUES (548, 'Alarm', 3, 'Fire Alarm - general, false alarm', 0.12, '2025-06-21 06:04:00', 362);
INSERT INTO public.incidents VALUES (171, 'Medical', 6, 'Unresponsive male', 0.32, '2025-04-29 18:46:00', 99);
INSERT INTO public.incidents VALUES (169, 'Fire', 6, 'Tree fire - caused from power line', 0.87, '2025-04-29 11:18:00', 99);
INSERT INTO public.incidents VALUES (500, 'Other', 4, 'Veh stranded on flooded road', 0.50, '2025-06-15 20:20:00', 333);
INSERT INTO public.incidents VALUES (73, 'Medical', 1, 'MVA - 2 vehicle', 0.25, '2025-04-18 17:00:00', 41);
INSERT INTO public.incidents VALUES (70, 'Medical', 1, 'MVA - Rollover w Fatality', 0.72, '2025-04-18 14:38:00', 41);
INSERT INTO public.incidents VALUES (243, 'Medical', 3, 'Lift Assist - non emergent', 0.22, '2025-05-12 03:09:00', 162);
INSERT INTO public.incidents VALUES (285, 'Other', 7, 'Service Call - smell of natural gas', 0.48, '2025-05-17 07:23:00', 190);
INSERT INTO public.incidents VALUES (584, 'Alarm', 4, 'Sprinkler Alarm - water flow', 0.80, '2025-06-24 00:58:00', 378);
INSERT INTO public.incidents VALUES (95, 'Medical', 6, 'Allergic Reaction - 1 YO', 0.17, '2025-04-22 11:09:00', 64);
INSERT INTO public.incidents VALUES (396, 'Alarm', 3, 'Fire Alarm - residential, false alarm', 0.60, '2025-06-03 01:06:00', 272);
INSERT INTO public.incidents VALUES (397, 'Medical', 6, 'Chest Pains', 0.20, '2025-06-03 05:47:00', 274);
INSERT INTO public.incidents VALUES (401, 'Medical', 1, 'Unresponsive Female', 0.10, '2025-06-03 19:28:00', 271);
INSERT INTO public.incidents VALUES (339, 'Other', 1, 'Service Call - CO Alarm', 0.23, '2025-05-24 19:37:00', 221);
INSERT INTO public.incidents VALUES (149, 'Medical', 3, 'Female fell 25 feet down slope', 0.87, '2025-04-27 00:12:00', 87);
INSERT INTO public.incidents VALUES (216, 'Fire', 1, 'Arson - Male subj set fire to tents at homeless camp', 0.40, '2025-05-08 22:22:00', 141);
INSERT INTO public.incidents VALUES (142, 'Alarm', 4, 'Smoke Alarm - false', 0.10, '2025-04-26 14:46:00', 83);
INSERT INTO public.incidents VALUES (140, 'Fire', 4, 'Vehicle Fire - EB lane, engine comp involved', 0.25, '2025-04-26 13:12:00', 83);
INSERT INTO public.incidents VALUES (579, 'Medical', 7, 'PT choking', 0.15, '2025-06-23 20:04:00', 375);
INSERT INTO public.incidents VALUES (304, 'Other', 1, 'Service Call - victim removal from elevator', 0.22, '2025-05-20 16:03:00', 201);
INSERT INTO public.incidents VALUES (297, 'Other', 1, 'Service Call - Power pole fell over walkway', 0.18, '2025-05-19 04:33:00', 196);
INSERT INTO public.incidents VALUES (192, 'Other', 3, 'Illegal burning', 0.08, '2025-05-06 08:08:00', 132);
INSERT INTO public.incidents VALUES (62, 'Alarm', 6, 'Smoke Alarm - False alarm', 0.13, '2025-04-17 19:53:00', 39);
INSERT INTO public.incidents VALUES (60, 'Medical', 6, 'MVA w Ped - Hit and run, ped transported', 0.17, '2025-04-17 18:54:00', 39);
INSERT INTO public.incidents VALUES (55, 'Medical', 6, 'MVA w Ped', 0.17, '2025-04-17 06:29:00', 39);
INSERT INTO public.incidents VALUES (54, 'Fire', 6, 'Grass Fire - Maintenance', 0.12, '2025-04-17 00:54:00', 39);
INSERT INTO public.incidents VALUES (233, 'Medical', 6, 'MVA - Vehicle drove through house', 0.52, '2025-05-10 23:33:00', 154);
INSERT INTO public.incidents VALUES (488, 'Other', 1, 'Powerline down', 1.54, '2025-06-14 16:24:00', 326);
INSERT INTO public.incidents VALUES (489, 'Other', 4, 'Powerline down', 0.32, '2025-06-14 16:30:00', 328);
INSERT INTO public.incidents VALUES (490, 'Other', 3, 'Powerline down', 0.12, '2025-06-14 18:01:00', 327);
INSERT INTO public.incidents VALUES (491, 'Other', 3, 'Powerline down', 0.18, '2025-06-14 18:07:00', 327);
INSERT INTO public.incidents VALUES (492, 'Other', 1, 'Powerline down', 0.48, '2025-06-14 21:05:00', 326);
INSERT INTO public.incidents VALUES (234, 'Medical', 6, 'MVA - rollover, vehicle struck off ramp sand barrels', 0.45, '2025-05-11 01:03:00', 159);
INSERT INTO public.incidents VALUES (235, 'Medical', 7, 'Unresponsive female', 0.58, '2025-05-11 06:32:00', 160);
INSERT INTO public.incidents VALUES (40, 'Medical', 7, 'Life Alert', 0.32, '2025-04-14 22:45:00', 25);
INSERT INTO public.incidents VALUES (53, 'Other', 1, 'Power Line on Fence - House Entrapment', 0.35, '2025-04-16 21:19:00', 31);
INSERT INTO public.incidents VALUES (457, 'Medical', 3, 'Poss MCI, PT AMA', 0.12, '2025-06-10 19:14:00', 307);
INSERT INTO public.incidents VALUES (413, 'Medical', 1, 'Gain Entry', 0.17, '2025-06-06 21:05:00', 286);
INSERT INTO public.incidents VALUES (148, 'Alarm', 1, 'Fire Alarm - Burnt food, false', 0.30, '2025-04-27 00:08:00', 86);
INSERT INTO public.incidents VALUES (357, 'Medical', 1, 'MVA - MC pulling wheelie hit parked vehicle, head trauma', 0.18, '2025-05-28 15:27:00', 241);
INSERT INTO public.incidents VALUES (632, 'Medical', 6, 'MVA - 1 veh, 1 transported w head trauma', 0.48, '2025-06-28 19:48:58', 404);
INSERT INTO public.incidents VALUES (627, 'Medical', 7, 'Lift Assist - non emergent', 0.18, '2025-06-27 21:35:46', 395);
INSERT INTO public.incidents VALUES (310, 'Alarm', 7, 'Fire Alarm - residential, false alarm', 0.20, '2025-05-20 22:42:00', 205);
INSERT INTO public.incidents VALUES (431, 'Fire', 4, 'Vehicle Fire - Engine compartment', 0.63, '2025-06-08 16:02:00', 298);
INSERT INTO public.incidents VALUES (226, 'Alarm', 6, 'Fire Alarm - residential, false alarm', 0.10, '2025-05-10 02:18:00', 154);
INSERT INTO public.incidents VALUES (227, 'Medical', 6, 'Diabetic coma - low blood sugar', 0.32, '2025-05-10 04:57:00', 154);
INSERT INTO public.incidents VALUES (503, 'Other', 1, 'Powerline down - charged and landed on house', 5.12, '2025-06-16 00:42:00', 336);
INSERT INTO public.incidents VALUES (72, 'Alarm', 7, 'Fire Alarm - Electric box smoking', 0.77, '2025-04-18 16:17:00', 45);
INSERT INTO public.incidents VALUES (82, 'Medical', 4, 'MVA - 2 vehicles, minor', 0.23, '2025-04-19 17:13:00', 48);
INSERT INTO public.incidents VALUES (172, 'Other', 6, 'Illegal Burning', 0.22, '2025-04-29 19:27:00', 99);
INSERT INTO public.incidents VALUES (253, 'Medical', 6, 'Possible Stroke', 0.12, '2025-05-13 16:49:00', 169);
INSERT INTO public.incidents VALUES (284, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.30, '2025-05-17 02:00:00', 189);
INSERT INTO public.incidents VALUES (24, 'Medical', 1, 'Seizure - 1 transported', 0.20, '2025-04-12 16:18:00', 11);
INSERT INTO public.incidents VALUES (180, 'Alarm', 1, 'Fire Alarm - General, false alarm', 0.25, '2025-05-03 11:13:00', 116);
INSERT INTO public.incidents VALUES (48, 'Alarm', 6, 'Pull Station - False Alarm', 0.27, '2025-04-15 19:46:00', 29);
INSERT INTO public.incidents VALUES (598, 'Medical', 6, 'Poss. MCI - Chest Pains', 0.20, '2025-06-26 00:56:00', 389);
INSERT INTO public.incidents VALUES (165, 'Alarm', 6, 'Fire Alarm - General, false alarm', 0.08, '2025-04-28 15:52:00', 94);
INSERT INTO public.incidents VALUES (33, 'Other', 6, 'Service call - Fluid clean up', 0.28, '2025-04-13 21:50:00', 19);
INSERT INTO public.incidents VALUES (592, 'Alarm', 4, 'Fire Alarm - general, false alarm', 0.10, '2025-06-25 02:02:00', 383);
INSERT INTO public.incidents VALUES (272, 'Medical', 3, 'Unconscious woman', 0.15, '2025-05-15 23:00:00', 177);
INSERT INTO public.incidents VALUES (273, 'Medical', 4, 'MVA - head on collision, 4 transported', 0.63, '2025-05-16 06:36:00', 183);
INSERT INTO public.incidents VALUES (63, 'Alarm', 6, 'Fire Alarm - General, False', 0.23, '2025-04-18 00:25:00', 44);
INSERT INTO public.incidents VALUES (374, 'Alarm', 3, 'Stove Fire - Fire out on arrival', 0.35, '2025-05-31 17:57:00', 257);
INSERT INTO public.incidents VALUES (375, 'Alarm', 6, 'Fire Alarm - Pull station, false alarm', 0.12, '2025-05-31 12:17:00', 259);
INSERT INTO public.incidents VALUES (462, 'Medical', 1, 'Lift Assist - non emergent', 0.20, '2025-06-11 19:57:00', 311);
INSERT INTO public.incidents VALUES (463, 'Medical', 1, 'MCI - 1 transported', 0.60, '2025-06-11 20:53:00', 311);
INSERT INTO public.incidents VALUES (176, 'Medical', 6, 'Assault - Child hit with bat from mother and unable to breathe', 0.13, '2025-05-02 07:26:00', 114);
INSERT INTO public.incidents VALUES (182, 'Other', 3, 'Service Call - Tree fell on powerline', 1.03, '2025-05-03 16:36:00', 117);
INSERT INTO public.incidents VALUES (181, 'Other', 4, 'Service Call - Smell of something burning - false', 0.32, '2025-05-03 11:52:00', 118);
INSERT INTO public.incidents VALUES (472, 'Medical', 6, 'MVA - 2 vehicles, 1 transported', 0.35, '2025-06-12 16:43:00', 319);
INSERT INTO public.incidents VALUES (473, 'Other', 1, 'Illegal Burning', 0.25, '2025-06-12 19:31:00', 316);
INSERT INTO public.incidents VALUES (387, 'Medical', 6, 'Gain entry', 0.33, '2025-06-01 21:22:00', 264);
INSERT INTO public.incidents VALUES (66, 'Medical', 4, 'MVA w ped', 0.35, '2025-04-18 14:03:00', 43);
INSERT INTO public.incidents VALUES (307, 'Medical', 7, 'Lift Assist - non emergent', 0.25, '2025-05-20 15:25:00', 205);
INSERT INTO public.incidents VALUES (228, 'Other', 3, 'Service Call - Smell of Natural Gas', 0.25, '2025-05-10 11:25:00', 152);
INSERT INTO public.incidents VALUES (435, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.12, '2025-06-08 18:12:00', 296);
INSERT INTO public.incidents VALUES (230, 'Alarm', 1, 'Sprinkler Alarm - false alarm, cancelled en route', 0.05, '2025-05-10 18:13:00', 151);
INSERT INTO public.incidents VALUES (231, 'Alarm', 1, 'Caller could see fire in window - candle', 0.23, '2025-05-10 20:31:00', 151);
INSERT INTO public.incidents VALUES (163, 'Alarm', 6, 'Fire Alarm - waterflow, sprinkler busted', 0.97, '2025-04-28 15:18:00', 94);
INSERT INTO public.incidents VALUES (57, 'Medical', 4, 'Respiratory Distress - LifeNet Extended', 0.38, '2025-04-17 10:06:00', 38);
INSERT INTO public.incidents VALUES (37, 'Medical', 1, 'Non Emergent - Lift Assist', 0.18, '2025-04-14 09:28:00', 21);
INSERT INTO public.incidents VALUES (554, 'Other', 6, 'Service Call - person laying on main highway without pants', 0.15, '2025-06-21 21:28:00', 364);
INSERT INTO public.incidents VALUES (379, 'Other', 6, 'Service Call - Fluid clean up', 0.33, '2025-06-01 12:17:00', 264);
INSERT INTO public.incidents VALUES (205, 'Alarm', 6, 'Fire Alarm - General, false', 0.12, '2025-05-07 23:38:00', 139);
INSERT INTO public.incidents VALUES (86, 'Fire', 6, 'Vehicle Fire - Semi-Truck with crane, fully involved', 1.23, '2025-04-20 15:46:00', 54);
INSERT INTO public.incidents VALUES (23, 'Alarm', 6, 'Smoke detector - False Alarm', 0.17, '2025-04-12 14:03:00', 14);
INSERT INTO public.incidents VALUES (22, 'Medical', 7, 'MCI', 0.54, '2025-04-12 13:16:00', 15);
INSERT INTO public.incidents VALUES (242, 'Medical', 1, 'Unresponsive Female', 0.43, '2025-05-12 02:07:00', 161);
INSERT INTO public.incidents VALUES (173, 'Alarm', 6, 'Smoke Alarm - power outage tripped alarm', 0.10, '2025-04-29 21:43:00', 99);
INSERT INTO public.incidents VALUES (464, 'Medical', 4, 'Poss MCI', 1.13, '2025-06-11 23:36:00', 313);
INSERT INTO public.incidents VALUES (465, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.32, '2025-06-12 09:27:00', 319);
INSERT INTO public.incidents VALUES (603, 'Other', 4, 'CO Alarm', 0.80, '2025-06-26 20:32:00', 388);
INSERT INTO public.incidents VALUES (556, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.15, '2025-06-21 21:32:00', 364);
INSERT INTO public.incidents VALUES (254, 'Other', 7, 'Vehicle stuck on bypass, below bridge', 0.25, '2025-05-13 19:32:00', 170);
INSERT INTO public.incidents VALUES (255, 'Alarm', 4, 'Fire Alarm - general, false alarm', 0.37, '2025-05-13 19:39:00', 168);
INSERT INTO public.incidents VALUES (256, 'Other', 4, 'CO Alarm - smell of gas', 0.12, '2025-05-13 21:42:00', 168);
INSERT INTO public.incidents VALUES (34, 'Alarm', 7, 'Fire Alarm - False Alarm', 0.08, '2025-04-13 21:59:00', 20);
INSERT INTO public.incidents VALUES (16, 'Alarm', 6, 'Pull station - false alarm', 0.17, '2025-04-11 22:39:00', 9);
INSERT INTO public.incidents VALUES (390, 'Medical', 6, 'Lift Assist - non emergent', 0.43, '2025-06-02 01:16:00', 269);
INSERT INTO public.incidents VALUES (630, 'Aircraft', 4, 'Aircraft declared Mayday - aircraft landed safely', 0.30, '2025-06-28 12:05:40', 403);
INSERT INTO public.incidents VALUES (391, 'Medical', 4, 'Chest Pains', 0.27, '2025-06-02 03:08:00', 268);
INSERT INTO public.incidents VALUES (325, 'Other', 7, 'Service Call - Smell of Natural Gas', 0.20, '2025-05-23 03:07:00', 220);
INSERT INTO public.incidents VALUES (80, 'Medical', 1, 'Lift Assist - Emergent', 0.17, '2025-04-19 13:48:00', 46);
INSERT INTO public.incidents VALUES (135, 'Other', 1, 'Service Call - downed powerline on vehicle', 0.67, '2025-04-25 23:19:00', 76);
INSERT INTO public.incidents VALUES (41, 'Medical', 3, 'CPR - DOA', 0.13, '2025-04-14 22:57:00', 22);
INSERT INTO public.incidents VALUES (97, 'Other', 4, 'Service Call - Gas main struck', 0.25, '2025-04-22 12:28:00', 63);
INSERT INTO public.incidents VALUES (98, 'Medical', 6, 'MVA - 2 vehicles', 0.53, '2025-04-22 12:56:00', 64);
INSERT INTO public.incidents VALUES (96, 'Alarm', 6, 'Fire Alarm - General alarm, false', 0.10, '2025-04-22 12:05:00', 64);
INSERT INTO public.incidents VALUES (50, 'Fire', 6, 'Structure Fire - Minor Fire in Laundry Room', 0.50, '2025-04-16 13:00:00', 34);
INSERT INTO public.incidents VALUES (426, 'Other', 1, 'Service Call - Powerline smoking', 0.20, '2025-06-07 22:46:00', 291);
INSERT INTO public.incidents VALUES (427, 'Medical', 1, 'MVA - 2 motorcycles, 2 transported', 0.20, '2025-06-07 23:02:00', 291);
INSERT INTO public.incidents VALUES (485, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.18, '2025-06-14 13:40:00', 329);
INSERT INTO public.incidents VALUES (486, 'Alarm', 3, 'Fire Alarm - general, false alarm', 0.62, '2025-06-14 13:42:00', 327);
INSERT INTO public.incidents VALUES (90, 'Alarm', 1, 'Fire Alarm - False Alarm', 0.17, '2025-04-21 18:14:00', 56);
INSERT INTO public.incidents VALUES (434, 'Other', 1, 'Service Call - Fluid Clean-up', 0.20, '2025-06-08 15:05:00', 296);
INSERT INTO public.incidents VALUES (168, 'Medical', 3, 'MCI - cpr in progress', 0.20, '2025-04-29 07:55:00', 97);
INSERT INTO public.incidents VALUES (599, 'Medical', 1, 'Lift Assist - emergent', 0.73, '2025-06-26 09:31:00', 386);
INSERT INTO public.incidents VALUES (324, 'Medical', 1, 'Lift Assist - emergent', 0.08, '2025-05-23 01:55:00', 216);
INSERT INTO public.incidents VALUES (197, 'Other', 6, 'Service Call - tree fell on powerline', 0.12, '2025-05-06 18:47:00', 134);
INSERT INTO public.incidents VALUES (193, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.12, '2025-05-06 08:59:00', 134);
INSERT INTO public.incidents VALUES (68, 'Alarm', 6, 'Smoke Alarm - Cancelled en route', 0.18, '2025-04-18 14:10:00', 44);
INSERT INTO public.incidents VALUES (64, 'Medical', 6, 'MVA - 2 vehicle - AB deployment', 0.28, '2025-04-18 12:52:00', 44);
INSERT INTO public.incidents VALUES (21, 'Fire', 1, 'Vehicle Fire', 0.50, '2025-04-12 12:42:00', 11);
INSERT INTO public.incidents VALUES (416, 'Alarm', 7, 'Fire Alarm - general, false alarm', 0.22, '2025-06-07 01:53:00', 295);
INSERT INTO public.incidents VALUES (94, 'Other', 6, 'Service Call - Smoke alarm chirping', 0.28, '2025-04-22 09:31:00', 64);
INSERT INTO public.incidents VALUES (46, 'Alarm', 1, 'Smoke Alarm - False Alarm', 0.18, '2025-04-15 15:38:00', 26);
INSERT INTO public.incidents VALUES (322, 'Other', 1, 'Service Call - SWAT team standby', 0.90, '2025-05-22 16:47:00', 211);
INSERT INTO public.incidents VALUES (199, 'Other', 1, 'Baby Drop Box - false', 0.03, '2025-05-06 19:12:00', 131);
INSERT INTO public.incidents VALUES (455, 'Medical', 1, 'Head Trauma, 1 transported', 0.28, '2025-06-10 15:47:00', 306);
INSERT INTO public.incidents VALUES (201, 'Alarm', 1, 'Fire Alarm - General, false', 0.10, '2025-05-06 23:20:00', 131);
INSERT INTO public.incidents VALUES (594, 'Other', 1, 'Veh vs Power pole - multiple poles down', 0.65, '2025-06-25 14:17:00', 381);
INSERT INTO public.incidents VALUES (604, 'Medical', 3, 'Lift Assist - non emergent', 0.27, '2025-06-26 20:49:00', 387);
INSERT INTO public.incidents VALUES (605, 'Medical', 1, 'Lift Assist - non emergent', 0.25, '2025-06-27 00:49:00', 391);
INSERT INTO public.incidents VALUES (334, 'Medical', 1, 'MCI - cpr in progress, 1 transported', 0.47, '2025-05-23 20:40:00', 216);
INSERT INTO public.incidents VALUES (335, 'Fire', 1, 'Vehicle Fire - fully involved', 0.48, '2025-05-23 21:20:00', 216);
INSERT INTO public.incidents VALUES (336, 'Medical', 6, 'Drowning victim - intoxicated male in lake', 0.73, '2025-05-24 01:15:00', 224);
INSERT INTO public.incidents VALUES (88, 'Alarm', 6, 'Fire Alarm - False Alarm', 0.22, '2025-04-21 11:18:00', 59);
INSERT INTO public.incidents VALUES (108, 'Other', 1, 'Gas Leak - False, skunk', 0.18, '2025-04-23 15:52:00', 66);
INSERT INTO public.incidents VALUES (107, 'Medical', 1, 'MVA - 1 vehicle, 1 transported', 0.63, '2025-04-23 15:47:00', 66);
INSERT INTO public.incidents VALUES (606, 'Other', 1, 'Smell of Natural Gas', 0.25, '2025-06-26 09:30:00', 386);
INSERT INTO public.incidents VALUES (281, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.42, '2025-05-16 22:46:00', 184);
INSERT INTO public.incidents VALUES (282, 'Other', 6, 'Power line down - with fire', 0.75, '2025-05-16 22:53:00', 184);
INSERT INTO public.incidents VALUES (283, 'Medical', 3, 'MVA w tree - 1 transported', 0.22, '2025-05-16 23:21:00', 182);
INSERT INTO public.incidents VALUES (232, 'Medical', 6, 'MVA - 3 vehicle, minor injuries', 0.37, '2025-05-10 21:39:00', 154);
INSERT INTO public.incidents VALUES (610, 'Alarm', 7, 'Fire Alarm - pull station, false alarm', 0.12, '2025-06-26 10:34:00', 390);
INSERT INTO public.incidents VALUES (170, 'Alarm', 3, 'Smoke showing - Dust from construction crew', 0.10, '2025-04-29 15:09:00', 97);
INSERT INTO public.incidents VALUES (208, 'Medical', 1, 'MVA w entrapment - 2 transported', 0.87, '2025-05-08 02:55:00', 141);
INSERT INTO public.incidents VALUES (287, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.32, '2025-05-17 14:28:00', 189);
INSERT INTO public.incidents VALUES (288, 'Medical', 1, 'High blood sugar', 0.06, '2025-05-17 16:09:00', 186);
INSERT INTO public.incidents VALUES (289, 'Medical', 6, 'MVA - 2 vehicles', 0.22, '2025-05-17 20:07:00', 189);
INSERT INTO public.incidents VALUES (129, 'Medical', 1, 'Respiratory Distress - Lifenet extended ETA', 0.30, '2025-04-25 15:51:00', 76);
INSERT INTO public.incidents VALUES (127, 'Medical', 1, 'MVA w Ped - 1 transported', 0.17, '2025-04-25 10:34:00', 76);
INSERT INTO public.incidents VALUES (123, 'Medical', 1, 'Chest Pains - LifeNet extended ETA', 0.37, '2025-04-25 07:42:00', 76);
INSERT INTO public.incidents VALUES (268, 'Medical', 6, 'MVA - 2 vehicles', 0.38, '2025-05-15 13:57:00', 179);
INSERT INTO public.incidents VALUES (83, 'Other', 7, 'Illegal Burning', 0.40, '2025-04-20 08:51:00', 55);
INSERT INTO public.incidents VALUES (30, 'Fire', 4, 'Stove Fire - Smoking', 0.11, '2025-04-13 18:10:00', 18);
INSERT INTO public.incidents VALUES (39, 'Alarm', 7, 'Fire Alarm - Brush Fire', 0.15, '2025-04-14 15:13:00', 25);
INSERT INTO public.incidents VALUES (433, 'Medical', 3, 'Lift Assist - non emergent', 0.25, '2025-06-08 13:44:00', 297);
INSERT INTO public.incidents VALUES (138, 'Medical', 1, 'Lift Assist - non emergent', 0.15, '2025-04-26 12:45:00', 81);
INSERT INTO public.incidents VALUES (589, 'Other', 7, 'Service Call', 0.10, '2025-06-24 17:48:00', 380);
INSERT INTO public.incidents VALUES (347, 'Alarm', 1, 'Smoke Alarm - general, false alarm', 0.20, '2025-05-26 12:41:00', 231);
INSERT INTO public.incidents VALUES (607, 'Alarm', 6, 'Sprinkler Alarm - busted sprinkler pipe flooding building', 0.52, '2025-06-26 09:41:00', 389);
INSERT INTO public.incidents VALUES (286, 'Alarm', 6, 'Smoke Alarm - Caller stated smoke coming from vent from bbq smoker restaurant', 0.23, '2025-05-17 13:51:00', 189);
INSERT INTO public.incidents VALUES (200, 'Other', 6, 'Service Call - tree fell on powerline', 0.12, '2025-05-06 09:05:00', 134);
INSERT INTO public.incidents VALUES (209, 'Alarm', 4, 'Area Smoke - false alarm, homeless camp', 0.08, '2025-05-08 05:55:00', 143);
INSERT INTO public.incidents VALUES (549, 'Other', 6, 'Brakes locked on truck going down highway', 0.37, '2025-06-21 08:41:00', 364);
INSERT INTO public.incidents VALUES (10, 'Alarm', 3, 'Smoke detector activation - no fire', 0.08, '2025-04-11 15:49:00', 7);
INSERT INTO public.incidents VALUES (9, 'Alarm', 4, 'Fire Alarm - false alarm', 0.08, '2025-04-11 11:16:00', 8);
INSERT INTO public.incidents VALUES (6, 'Medical', 4, 'Rollover Accident - 4 transported', 0.75, '2025-04-11 06:13:00', 8);
INSERT INTO public.incidents VALUES (74, 'Medical', 6, 'Chest pains', 0.13, '2025-04-18 17:47:00', 44);
INSERT INTO public.incidents VALUES (112, 'Alarm', 6, 'Smoke behind building - homeless camp', 0.12, '2025-04-24 08:44:00', 74);
INSERT INTO public.incidents VALUES (116, 'Other', 7, 'Illegal Burning', 0.18, '2025-04-24 15:05:00', 75);
INSERT INTO public.incidents VALUES (468, 'Alarm', 7, 'Fire Alarm - general, false alarm', 0.17, '2025-06-12 12:15:00', 320);
INSERT INTO public.incidents VALUES (469, 'Medical', 1, 'Lift Assist - non emergent', 0.37, '2025-06-12 13:43:00', 316);
INSERT INTO public.incidents VALUES (29, 'Fire', 6, 'Grass Fire - Kimery', 0.06, '2025-04-13 08:21:00', 19);
INSERT INTO public.incidents VALUES (58, 'Medical', 3, 'Unresponsive person on bus - Narcan administered', 0.15, '2025-04-17 15:39:00', 37);
INSERT INTO public.incidents VALUES (373, 'Other', 6, 'Illegal Burning', 0.17, '2025-05-31 16:36:00', 259);
INSERT INTO public.incidents VALUES (47, 'Medical', 1, 'MCI - 1 transported', 0.18, '2025-04-15 19:32:00', 26);
INSERT INTO public.incidents VALUES (504, 'Fire', 4, 'Aircraft Fire - Single prop caught fire', 0.52, '2025-06-16 16:21:00', 338);
INSERT INTO public.incidents VALUES (506, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.37, '2025-06-17 01:48:00', 341);
INSERT INTO public.incidents VALUES (507, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.12, '2025-06-17 03:58:00', 341);
INSERT INTO public.incidents VALUES (183, 'Other', 4, 'Service Call - Semi struck gas main', 1.51, '2025-05-04 18:53:00', 123);
INSERT INTO public.incidents VALUES (476, 'Other', 6, 'CO Alarm', 0.57, '2025-06-13 05:54:00', 324);
INSERT INTO public.incidents VALUES (25, 'Medical', 4, 'MCI', 0.13, '2025-04-12 16:21:00', 13);
INSERT INTO public.incidents VALUES (474, 'Medical', 6, 'MVA - 2 veh', 0.12, '2025-06-12 19:31:00', 319);
INSERT INTO public.incidents VALUES (497, 'Other', 1, 'Service Call', 1.12, '2025-06-15 11:47:00', 331);
INSERT INTO public.incidents VALUES (498, 'Other', 1, 'Powerline down', 0.08, '2025-06-15 12:54:00', 331);
INSERT INTO public.incidents VALUES (423, 'Medical', 1, 'Seizure', 0.13, '2025-06-07 16:02:00', 291);
INSERT INTO public.incidents VALUES (167, 'Medical', 7, 'Lift Assist - non emergent', 0.20, '2025-04-28 17:23:00', 95);
INSERT INTO public.incidents VALUES (626, 'Other', 4, 'Transformer blew up', 0.50, '2025-06-27 19:50:57', 393);
INSERT INTO public.incidents VALUES (158, 'Alarm', 1, 'Fire Alarm - General, false alarm', 0.32, '2025-04-28 07:40:00', 91);
INSERT INTO public.incidents VALUES (164, 'Alarm', 6, 'Fire Alarm - false alarm', 0.20, '2025-04-28 15:33:00', 94);
INSERT INTO public.incidents VALUES (318, 'Other', 3, 'Illegal Burning', 0.22, '2025-05-21 19:29:00', 207);
INSERT INTO public.incidents VALUES (128, 'Medical', 3, 'Lift Assist - non emergent', 0.23, '2025-04-25 11:48:00', 77);
INSERT INTO public.incidents VALUES (133, 'Alarm', 4, 'Fire Alarm - Counter sprayed with bug spray, false alarm', 0.25, '2025-04-25 21:57:00', 78);
INSERT INTO public.incidents VALUES (352, 'Other', 4, 'Illegal Burning', 0.28, '2025-05-27 18:30:00', 238);
INSERT INTO public.incidents VALUES (353, 'Medical', 4, 'Possible Stroke - 1 transported', 0.12, '2025-05-27 19:44:00', 238);
INSERT INTO public.incidents VALUES (354, 'Other', 4, 'Illegal Burning', 0.07, '2025-05-27 19:58:00', 238);
INSERT INTO public.incidents VALUES (355, 'Medical', 6, 'Chest Pains', 0.13, '2025-05-27 22:16:00', 239);
INSERT INTO public.incidents VALUES (456, 'Medical', 4, 'MVA - 1 vehicle, 1 transported', 0.72, '2025-06-10 17:14:00', 308);
INSERT INTO public.incidents VALUES (271, 'Alarm', 6, 'Smoke Alarm - residential, false alarm', 0.27, '2025-05-15 19:36:00', 179);
INSERT INTO public.incidents VALUES (224, 'Medical', 7, 'Lift Assist - non emergent', 0.35, '2025-05-09 21:45:00', 150);
INSERT INTO public.incidents VALUES (225, 'Medical', 6, 'MVA - 2 vehicle, no injuries', 0.50, '2025-05-09 22:12:00', 149);
INSERT INTO public.incidents VALUES (624, 'Other', 7, 'Gas line struck by contruction workers', 0.58, '2025-06-27 18:01:34', 395);
INSERT INTO public.incidents VALUES (99, 'Medical', 4, 'MVA - 2 vehicles, infant', 0.23, '2025-04-22 13:20:00', 63);
INSERT INTO public.incidents VALUES (245, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.22, '2025-05-12 19:37:00', 161);
INSERT INTO public.incidents VALUES (246, 'Alarm', 4, 'Fire Alarm - phone charger popping and smoking', 0.25, '2025-05-12 22:21:00', 163);
INSERT INTO public.incidents VALUES (247, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.23, '2025-05-12 23:40:00', 161);
INSERT INTO public.incidents VALUES (249, 'Medical', 1, 'Chest Pains', 0.12, '2025-05-13 03:55:00', 166);
INSERT INTO public.incidents VALUES (189, 'Medical', 4, 'Unresponsive 1yr old', 0.42, '2025-05-05 17:48:00', 128);
INSERT INTO public.incidents VALUES (28, 'Medical', 3, 'Respiratory distress - 82 yr old', 0.01, '2025-04-13 04:50:00', 17);
INSERT INTO public.incidents VALUES (31, 'Medical', 4, 'MVA w injury - 3 vehicles and motorcycle', 0.11, '2025-04-13 19:04:00', 18);
INSERT INTO public.incidents VALUES (303, 'Alarm', 6, 'Fire Alarm - storm activation, false alarm', 0.17, '2025-05-20 04:13:00', 204);
INSERT INTO public.incidents VALUES (601, 'Other', 7, 'Fluid Clean-up', 0.68, '2025-06-26 14:35:00', 390);
INSERT INTO public.incidents VALUES (395, 'Other', 1, 'CO Alarm', 0.27, '2025-06-02 22:00:00', 266);
INSERT INTO public.incidents VALUES (162, 'Other', 1, 'Service Call - tree and powerlines fell on house', 4.29, '2025-04-28 14:43:00', 91);
INSERT INTO public.incidents VALUES (298, 'Fire', 4, 'Structure Fire - Walmart, extinguished by sprinkler - ems for 1 employee', 1.23, '2025-05-19 09:09:00', 198);
INSERT INTO public.incidents VALUES (422, 'Other', 6, 'Transformer smoking, Entergy notified', 1.00, '2025-06-07 14:52:00', 294);
INSERT INTO public.incidents VALUES (432, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.20, '2025-06-08 13:39:00', 299);
INSERT INTO public.incidents VALUES (292, 'Alarm', 6, 'Fire Alarm - heat, false alarm', 0.18, '2025-05-18 11:14:00', 194);
INSERT INTO public.incidents VALUES (448, 'Medical', 4, 'Lift Assist - emergent', 0.18, '2025-06-10 06:41:00', 308);
INSERT INTO public.incidents VALUES (312, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.40, '2025-05-21 04:04:00', 206);
INSERT INTO public.incidents VALUES (313, 'Medical', 4, 'MVA - 2 vehicles, 1 head trauma', 0.53, '2025-05-21 09:29:00', 208);
INSERT INTO public.incidents VALUES (314, 'Alarm', 6, 'Fire Alarm - cancelled en route, false alarm', 0.17, '2025-05-21 12:21:00', 209);
INSERT INTO public.incidents VALUES (484, 'Medical', 7, 'MVA - 2 veh', 0.27, '2025-06-14 13:33:00', 330);
INSERT INTO public.incidents VALUES (331, 'Other', 4, 'Service Call', 0.33, '2025-05-23 12:13:00', 218);
INSERT INTO public.incidents VALUES (628, 'Medical', 1, 'Lift Assist - non emergent', 0.50, '2025-06-28 01:02:54', 401);
INSERT INTO public.incidents VALUES (332, 'Other', 4, 'Service Call - vehicle in lake, no injuries', 1.38, '2025-05-23 19:05:00', 218);
INSERT INTO public.incidents VALUES (12, 'Medical', 1, 'Female chest pains - 1 transported', 0.13, '2025-04-11 17:00:00', 6);
INSERT INTO public.incidents VALUES (117, 'Other', 3, 'Illegal Burning', 0.22, '2025-04-24 15:23:00', 72);
INSERT INTO public.incidents VALUES (525, 'Other', 3, 'Tree fell on powerlines', 2.20, '2025-06-19 11:57:00', 352);
INSERT INTO public.incidents VALUES (600, 'Other', 4, 'Child Stuck in baby swing at park', 0.23, '2025-06-26 10:43:00', 388);
INSERT INTO public.incidents VALUES (386, 'Medical', 1, 'Chest Pains', 0.33, '2025-06-01 20:07:00', 261);
INSERT INTO public.incidents VALUES (344, 'Medical', 4, '9 month old choking on vomit', 0.35, '2025-05-25 23:43:00', 228);
INSERT INTO public.incidents VALUES (372, 'Other', 1, 'Rope Rescue - 6 trapped on roller coaster', 1.57, '2025-05-31 14:33:00', 256);
INSERT INTO public.incidents VALUES (264, 'Medical', 6, 'MVA vs ped, veh struck building', 0.33, '2025-05-14 12:28:00', 174);
INSERT INTO public.incidents VALUES (105, 'Other', 6, 'Gas Leak - Oven', 0.22, '2025-04-23 13:30:00', 69);
INSERT INTO public.incidents VALUES (118, 'Medical', 1, 'Lift Assist - non emergent, biohaz', 0.27, '2025-04-24 17:47:00', 71);
INSERT INTO public.incidents VALUES (320, 'Medical', 1, 'Lift Assist - non emergent', 0.43, '2025-05-22 00:31:00', 211);
INSERT INTO public.incidents VALUES (179, 'Fire', 4, 'Dumpster Fire', 0.27, '2025-05-03 21:50:00', 118);
INSERT INTO public.incidents VALUES (100, 'Alarm', 7, 'Smoke Alarm - False alarm', 0.58, '2025-04-22 18:52:00', 65);
INSERT INTO public.incidents VALUES (593, 'Medical', 7, 'Head Trauma - 14ft fall', 0.35, '2025-06-25 14:12:00', 385);
INSERT INTO public.incidents VALUES (382, 'Other', 3, 'Service Call - fire alarm reset', 1.00, '2025-06-01 09:48:00', 262);
INSERT INTO public.incidents VALUES (407, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.27, '2025-06-06 05:57:00', 286);
INSERT INTO public.incidents VALUES (250, 'Medical', 1, 'Lift Assist - non emergent', 0.33, '2025-05-13 05:49:00', 166);
INSERT INTO public.incidents VALUES (308, 'Medical', 6, 'Respiratory Distress - 1 transported', 0.25, '2025-05-20 17:45:00', 204);
INSERT INTO public.incidents VALUES (296, 'Medical', 1, 'MCI - 1 transported', 0.40, '2025-05-19 02:47:00', 196);
INSERT INTO public.incidents VALUES (311, 'Alarm', 6, 'Fire Alarm - commercial, false alarm', 0.23, '2025-05-21 01:57:00', 209);
INSERT INTO public.incidents VALUES (470, 'Alarm', 1, 'Smoke ALarm - general, false alarm', 0.33, '2025-06-12 15:24:00', 316);
INSERT INTO public.incidents VALUES (2, 'Alarm', 6, 'Sprinkler Alarm - False', 0.23, '2025-04-10 10:16:00', 4);
INSERT INTO public.incidents VALUES (3, 'Medical', 6, 'Chest pains - 1 transported', 0.20, '2025-04-10 12:52:00', 4);
INSERT INTO public.incidents VALUES (587, 'Alarm', 7, 'Fire Alarm - general, false alarm', 0.33, '2025-06-24 14:43:00', 380);
INSERT INTO public.incidents VALUES (79, 'Medical', 6, 'MVA - 2 vehicles, 1 transported', 0.26, '2025-04-19 12:42:00', 49);
INSERT INTO public.incidents VALUES (81, 'Medical', 7, 'Lift Assist - Non Emergent', 0.30, '2025-04-19 15:08:00', 50);
INSERT INTO public.incidents VALUES (77, 'Medical', 7, 'Lift Assist - Emergent', 0.32, '2025-04-19 08:52:00', 50);
INSERT INTO public.incidents VALUES (348, 'Alarm', 3, 'Smoke Alarm - general, false alarm', 0.13, '2025-05-26 17:49:00', 232);
INSERT INTO public.incidents VALUES (405, 'Medical', 1, 'Unresponsive Female', 0.10, '2025-06-04 11:49:00', 276);
INSERT INTO public.incidents VALUES (89, 'Other', 6, 'Standby for torches on outriggers', 1.57, '2025-04-21 14:52:00', 59);
INSERT INTO public.incidents VALUES (93, 'Medical', 1, 'Chest pains - 1 transported', 0.12, '2025-04-22 09:27:00', 61);
INSERT INTO public.incidents VALUES (342, 'Alarm', 6, 'Fire Alarm - Lightning strike, false alarm', 0.32, '2025-05-25 17:31:00', 229);
INSERT INTO public.incidents VALUES (32, 'Medical', 1, 'Emergent Lift Assist', 0.33, '2025-04-13 21:41:00', 16);
INSERT INTO public.incidents VALUES (27, 'Other', 1, 'Service Call - Fluid clean up', 0.04, '2025-04-13 01:00:00', 16);
INSERT INTO public.incidents VALUES (157, 'Alarm', 6, 'Vehicle Fire - engine overheating, false', 0.07, '2025-04-28 07:18:00', 94);
INSERT INTO public.incidents VALUES (417, 'Medical', 6, 'LifeNet cancelled en route', 0.08, '2025-06-07 02:56:00', 294);
INSERT INTO public.incidents VALUES (403, 'Medical', 7, 'Lift Assist - non emergent', 0.27, '2025-06-04 08:16:00', 280);
INSERT INTO public.incidents VALUES (404, 'Alarm', 6, 'Smoke Alarm - residential, false alarm', 0.10, '2025-06-04 09:52:00', 279);
INSERT INTO public.incidents VALUES (370, 'Medical', 3, 'Unresponsive female - transported', 0.12, '2025-05-31 04:03:00', 257);
INSERT INTO public.incidents VALUES (625, 'Alarm', 7, 'Fire Alarm - general, false alarm', 0.10, '2025-06-27 19:33:03', 395);
INSERT INTO public.incidents VALUES (8, 'Medical', 1, 'Wrists cut - 1 transported', 0.22, '2025-04-11 09:28:00', 6);
INSERT INTO public.incidents VALUES (421, 'Medical', 6, 'Lift Assist - non emergent', 0.08, '2025-06-07 12:54:00', 294);
INSERT INTO public.incidents VALUES (499, 'Other', 6, 'Service Call', 0.35, '2025-06-15 17:30:00', 334);
INSERT INTO public.incidents VALUES (505, 'Medical', 6, 'Lift Assist - non emergent', 0.63, '2025-06-16 21:47:00', 339);
INSERT INTO public.incidents VALUES (106, 'Alarm', 1, 'Smoke Alarm - False Alarm', 0.32, '2025-04-23 14:11:00', 66);
INSERT INTO public.incidents VALUES (608, 'Other', 1, 'Service Call - Semi drove through powerlines, multiple lines down', 1.20, '2025-06-26 10:12:00', 386);
INSERT INTO public.incidents VALUES (609, 'Alarm', 7, 'Fire Alarm - powersurge from lines down, false alarm', 0.02, '2025-06-26 10:14:00', 390);
INSERT INTO public.incidents VALUES (207, 'Medical', 6, '1 month old choking', 0.18, '2025-05-08 00:47:00', 144);
INSERT INTO public.incidents VALUES (479, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.20, '2025-06-13 11:57:00', 321);
INSERT INTO public.incidents VALUES (480, 'Other', 6, 'Service call - Sprinkler', 0.13, '2025-06-13 12:23:00', 324);
INSERT INTO public.incidents VALUES (481, 'Medical', 1, 'Lift Assist - non emegent', 0.30, '2025-06-13 13:24:00', 321);
INSERT INTO public.incidents VALUES (482, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.22, '2025-06-13 15:14:00', 324);
INSERT INTO public.incidents VALUES (585, 'Alarm', 4, 'Fire Alarm - general, false alarm', 0.28, '2025-06-24 08:30:00', 378);
INSERT INTO public.incidents VALUES (418, 'Alarm', 1, 'Smell of electrical burning, false alarm', 1.50, '2025-06-07 09:13:00', 291);
INSERT INTO public.incidents VALUES (419, 'Medical', 1, 'Ambulance Assist', 0.15, '2025-06-07 09:45:00', 291);
INSERT INTO public.incidents VALUES (244, 'Medical', 4, 'MVA - 2 vehicle', 0.42, '2025-05-12 10:49:00', 163);
INSERT INTO public.incidents VALUES (237, 'Other', 1, 'Service call - Smell OF gas', 0.27, '2025-05-11 11:24:00', 156);
INSERT INTO public.incidents VALUES (238, 'Alarm', 6, 'Fire Alarm - false alarm', 0.13, '2025-05-11 14:33:00', 159);
INSERT INTO public.incidents VALUES (45, 'Other', 1, 'Illegal Burning', 0.38, '2025-04-15 14:50:00', 26);
INSERT INTO public.incidents VALUES (1, 'Alarm', 7, 'School smoke detector - no fire', 0.07, '2025-04-10 08:57:00', 5);
INSERT INTO public.incidents VALUES (15, 'Medical', 1, 'Respiratory distress - 1 transported', 0.33, '2025-04-11 19:36:00', 6);
INSERT INTO public.incidents VALUES (13, 'Alarm', 1, 'Heavy Smoke in the area - false alarm', 0.25, '2025-04-11 17:04:00', 6);
INSERT INTO public.incidents VALUES (623, 'Alarm', 1, 'Poss structure fire, false alarm', 0.23, '2025-06-27 16:20:10', 391);
INSERT INTO public.incidents VALUES (248, 'Medical', 7, 'Gain Entry', 0.03, '2025-05-13 02:37:00', 170);
INSERT INTO public.incidents VALUES (291, 'Alarm', 6, 'Smoke Alarm - burnt food', 0.20, '2025-05-18 08:25:00', 194);
INSERT INTO public.incidents VALUES (113, 'Medical', 3, 'MVA - 1 veh vs. pole', 2.23, '2025-04-24 08:50:00', 72);
INSERT INTO public.incidents VALUES (115, 'Medical', 4, 'MVA - 1 veh vs bicycle, fled scene', 0.15, '2025-04-24 14:52:00', 73);
INSERT INTO public.incidents VALUES (328, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.32, '2025-05-23 11:56:00', 219);
INSERT INTO public.incidents VALUES (329, 'Medical', 1, 'Lift Assist - non emergent', 0.28, '2025-05-23 11:58:00', 216);
INSERT INTO public.incidents VALUES (496, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.20, '2025-06-15 08:17:00', 331);
INSERT INTO public.incidents VALUES (535, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.52, '2025-06-20 08:30:00', 356);
INSERT INTO public.incidents VALUES (536, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.50, '2025-06-20 09:34:00', 359);
INSERT INTO public.incidents VALUES (537, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.20, '2025-06-20 10:04:00', 359);
INSERT INTO public.incidents VALUES (550, 'Other', 6, 'Illegal Burning', 0.22, '2025-06-21 17:23:00', 364);
INSERT INTO public.incidents VALUES (501, 'Other', 1, 'Service Call - water coming through ceiling', 0.65, '2025-06-15 22:02:00', 331);
INSERT INTO public.incidents VALUES (206, 'Medical', 1, 'MCI - 1 transported', 0.27, '2025-05-08 00:14:00', 141);
INSERT INTO public.incidents VALUES (160, 'Other', 1, 'Illegal Burning - homeless camp', 0.25, '2025-04-28 10:40:00', 91);
INSERT INTO public.incidents VALUES (159, 'Alarm', 1, 'Fire Alarm - General, false alarm', 0.27, '2025-04-28 09:58:00', 91);
INSERT INTO public.incidents VALUES (191, 'Medical', 1, 'Lift Assist - Non emergent', 0.23, '2025-05-06 02:55:00', 131);
INSERT INTO public.incidents VALUES (194, 'Other', 4, 'Service Call', 0.22, '2025-05-06 10:20:00', 133);
INSERT INTO public.incidents VALUES (508, 'Other', 6, 'CO Alarm', 0.27, '2025-06-17 11:07:00', 344);
INSERT INTO public.incidents VALUES (588, 'Other', 1, 'Veh stuck in ditch', 0.77, '2025-06-24 16:49:00', 376);
INSERT INTO public.incidents VALUES (316, 'Medical', 6, 'MVA - 2 vehicles, minor injuries', 0.33, '2025-05-21 14:46:00', 209);
INSERT INTO public.incidents VALUES (78, 'Alarm', 6, 'Fire Alarm - water flow', 0.17, '2025-04-19 10:57:00', 49);
INSERT INTO public.incidents VALUES (478, 'Other', 6, 'Powerline down', 0.45, '2025-06-13 10:50:00', 324);
INSERT INTO public.incidents VALUES (376, 'Medical', 7, 'LifeNet extended ETA', 0.33, '2025-05-31 20:04:00', 260);
INSERT INTO public.incidents VALUES (377, 'Other', 1, 'Service Call - powerline over roadway', 0.40, '2025-05-31 22:30:00', 256);
INSERT INTO public.incidents VALUES (378, 'Other', 6, 'Disorderly Female setting fire to bushes', 0.40, '2025-05-31 23:24:00', 259);
INSERT INTO public.incidents VALUES (337, 'Other', 4, 'Illegal Burning', 4.00, '2025-05-24 09:52:00', 223);
INSERT INTO public.incidents VALUES (338, 'Medical', 7, 'Unresponsive Female - 1 transported', 0.20, '2025-05-24 18:39:00', 225);
INSERT INTO public.incidents VALUES (196, 'Other', 1, 'Baby Drop Box', 0.06, '2025-05-06 16:16:00', 131);
INSERT INTO public.incidents VALUES (195, 'Alarm', 1, 'Fire Alarm - false alarm', 0.30, '2025-05-06 15:53:00', 131);
INSERT INTO public.incidents VALUES (595, 'Medical', 1, 'Poss. Stroke', 0.20, '2025-06-25 18:06:00', 381);
INSERT INTO public.incidents VALUES (239, 'Medical', 4, 'MVA - 2 vehicle, 2 transported', 0.33, '2025-05-11 17:56:00', 158);
INSERT INTO public.incidents VALUES (597, 'Medical', 6, 'MVA - Veh vs Ped - 1 transported', 0.22, '2025-06-25 23:56:00', 384);
INSERT INTO public.incidents VALUES (586, 'Medical', 1, 'MVA - 2 veh, minor injuries', 0.48, '2025-06-24 09:51:00', 376);
INSERT INTO public.incidents VALUES (475, 'Alarm', 3, 'Smoke Alarm - general, false alarm', 0.18, '2025-06-12 20:22:00', 317);
INSERT INTO public.incidents VALUES (460, 'Medical', 1, 'Gain Entry', 0.05, '2025-06-11 04:27:00', 311);
INSERT INTO public.incidents VALUES (461, 'Alarm', 6, 'Fire Alarm, general false alarm', 0.18, '2025-06-11 19:07:00', 314);
INSERT INTO public.incidents VALUES (154, 'Other', 1, 'Illegal burning', 0.48, '2025-04-27 13:12:00', 86);
INSERT INTO public.incidents VALUES (11, 'Medical', 7, 'Minor MVA', 0.48, '2025-04-11 16:15:00', 10);
INSERT INTO public.incidents VALUES (84, 'Alarm', 3, 'Fire Alarm - false alarm', 0.22, '2025-04-20 10:36:00', 52);
INSERT INTO public.incidents VALUES (402, 'Medical', 1, 'Lift Assist - non emergent', 0.23, '2025-06-03 23:57:00', 271);
INSERT INTO public.incidents VALUES (330, 'Medical', 1, 'MVA - 2 vehicles, minor injuries', 0.62, '2025-05-23 12:02:00', 216);
INSERT INTO public.incidents VALUES (555, 'Alarm', 7, 'Fire Alarm - general, false alarm', 0.45, '2025-06-21 21:32:00', 365);
INSERT INTO public.incidents VALUES (487, 'Other', 7, 'Powerline down', 0.35, '2025-06-14 16:18:00', 330);
INSERT INTO public.incidents VALUES (392, 'Medical', 1, 'MVA - veh vs bicycle, 1 transported', 0.35, '2025-06-02 10:20:00', 266);
INSERT INTO public.incidents VALUES (393, 'Alarm', 6, 'Sprinkler Alarm - waterflow, false alarm', 0.60, '2025-06-02 16:13:00', 269);
INSERT INTO public.incidents VALUES (449, 'Medical', 7, '10 yr old, respiratory distress', 0.22, '2025-06-10 07:18:00', 310);
INSERT INTO public.incidents VALUES (450, 'Alarm', 6, 'Fire Alarm, general, false alarm', 0.18, '2025-06-10 10:18:00', 309);
INSERT INTO public.incidents VALUES (451, 'Medical', 6, 'MVA - veh vs. building', 0.38, '2025-06-10 12:02:00', 309);
INSERT INTO public.incidents VALUES (452, 'Medical', 6, 'Lift Assist - non emergent', 0.05, '2025-06-10 13:51:00', 309);
INSERT INTO public.incidents VALUES (453, 'Medical', 7, 'Person trapped under lawnmower', 0.45, '2025-06-10 14:05:00', 310);
INSERT INTO public.incidents VALUES (454, 'Medical', 7, 'Lift Assist - non emergent', 0.10, '2025-06-10 15:11:00', 310);
INSERT INTO public.incidents VALUES (547, 'Alarm', 6, 'Smoke Alarm - general, false alarm', 0.20, '2025-06-21 04:39:00', 364);
INSERT INTO public.incidents VALUES (321, 'Other', 4, 'Service Call', 0.47, '2025-05-22 12:48:00', 213);
INSERT INTO public.incidents VALUES (369, 'Other', 7, 'Service Call - smell of natural gas', 0.58, '2025-05-30 21:11:00', 255);
INSERT INTO public.incidents VALUES (368, 'Medical', 6, 'Head Trauma from fall - major bleeding', 0.08, '2025-05-30 19:15:00', 254);
INSERT INTO public.incidents VALUES (184, 'Alarm', 1, 'False Alarm - Cooking w Smoker', 0.08, '2025-05-05 09:05:00', 126);
INSERT INTO public.incidents VALUES (398, 'Alarm', 6, 'Fire Alarm - keypad activation, false alarm', 0.15, '2025-06-03 10:04:00', 274);
INSERT INTO public.incidents VALUES (399, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.08, '2025-06-03 15:06:00', 271);
INSERT INTO public.incidents VALUES (400, 'Medical', 4, 'MVA - 2 vehicles, minor injuries', 0.80, '2025-06-03 16:06:00', 273);
INSERT INTO public.incidents VALUES (7, 'Alarm', 7, 'Fire Alarm - false alarm', 0.23, '2025-04-11 09:09:00', 10);
INSERT INTO public.incidents VALUES (26, 'Medical', 1, 'Respiratory distress - 1 transported', 0.40, '2025-04-12 22:39:00', 11);
INSERT INTO public.incidents VALUES (219, 'Medical', 1, 'Lift Assist - non emergent', 0.25, '2025-05-09 17:57:00', 146);
INSERT INTO public.incidents VALUES (221, 'Medical', 1, 'Lift Assist - emergent', 0.17, '2025-05-09 18:36:00', 146);
INSERT INTO public.incidents VALUES (222, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.10, '2025-05-09 21:39:00', 149);
INSERT INTO public.incidents VALUES (223, 'Fire', 3, 'Structure Fire - Apartment, grease fire/room and contents', 0.45, '2025-05-09 21:40:00', 147);
INSERT INTO public.incidents VALUES (406, 'Medical', 1, 'Unresponsive Male', 0.18, '2025-06-04 13:36:00', 276);
INSERT INTO public.incidents VALUES (202, 'Alarm', 3, 'Fire Alarm - General, false', 0.13, '2025-05-07 05:36:00', 137);
INSERT INTO public.incidents VALUES (408, 'Medical', 3, 'MCI - 1 transported', 0.32, '2025-06-06 08:52:00', 287);
INSERT INTO public.incidents VALUES (409, 'Medical', 6, 'Stroke symptoms', 0.12, '2025-06-06 12:40:00', 289);
INSERT INTO public.incidents VALUES (384, 'Medical', 3, 'Seizure', 0.25, '2025-06-01 16:55:00', 262);
INSERT INTO public.incidents VALUES (35, 'Medical', 1, 'Non Emergent Lift Assist', 0.52, '2025-04-14 02:11:00', 21);
INSERT INTO public.incidents VALUES (343, 'Medical', 1, 'MVA - 2 vehicles, 1 transported', 0.42, '2025-05-25 17:51:00', 226);
INSERT INTO public.incidents VALUES (266, 'Fire', 1, 'Vehicle Fire - fully involved', 0.73, '2025-05-14 17:25:00', 171);
INSERT INTO public.incidents VALUES (267, 'Fire', 6, 'Vehicle Fire - near building', 0.98, '2025-05-14 17:37:00', 174);
INSERT INTO public.incidents VALUES (198, 'Medical', 6, 'Lift Assist - non emergent', 0.43, '2025-05-06 19:03:00', 134);
INSERT INTO public.incidents VALUES (381, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.12, '2025-06-01 08:25:00', 264);
INSERT INTO public.incidents VALUES (229, 'Other', 6, 'Illegal Burning', 0.35, '2025-05-10 16:15:00', 154);
INSERT INTO public.incidents VALUES (466, 'Medical', 1, 'Overdose', 0.15, '2025-06-12 11:44:00', 316);
INSERT INTO public.incidents VALUES (92, 'Medical', 4, 'MVA - veh vs. motorcycle', 0.20, '2025-04-21 19:58:00', 58);
INSERT INTO public.incidents VALUES (91, 'Alarm', 4, 'Fire Alarm - False Alarm', 0.22, '2025-04-21 18:23:00', 58);
INSERT INTO public.incidents VALUES (459, 'Medical', 1, 'MVA - cancelled en route', 0.01, '2025-06-10 21:27:00', 306);
INSERT INTO public.incidents VALUES (295, 'Medical', 6, 'Chest Pains - 1 transported', 0.27, '2025-05-18 20:11:00', 194);
INSERT INTO public.incidents VALUES (471, 'Medical', 6, 'Chest Pains', 0.37, '2025-06-12 16:05:00', 319);
INSERT INTO public.incidents VALUES (495, 'Alarm', 6, 'Smoke Alarm - general, false alarm', 0.13, '2025-06-15 08:09:00', 334);
INSERT INTO public.incidents VALUES (302, 'Other', 1, 'Service Call - Assist PD with removing a victim in a creek with 15ft drop', 0.52, '2025-05-20 00:57:00', 201);
INSERT INTO public.incidents VALUES (394, 'Fire', 6, 'Grass Fire', 0.42, '2025-06-02 19:09:00', 269);
INSERT INTO public.incidents VALUES (126, 'Medical', 6, 'MCI - CPR in progress', 0.73, '2025-04-25 09:48:00', 79);
INSERT INTO public.incidents VALUES (150, 'Medical', 3, 'Overdose - Fentanyl, narcan, AMA', 0.15, '2025-04-27 03:46:00', 87);
INSERT INTO public.incidents VALUES (236, 'Medical', 1, 'Unresponsive female', 0.50, '2025-05-11 09:00:00', 156);
INSERT INTO public.incidents VALUES (541, 'Other', 7, 'CO Alarm', 0.35, '2025-06-20 13:13:00', 360);
INSERT INTO public.incidents VALUES (542, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.48, '2025-06-20 13:19:00', 356);
INSERT INTO public.incidents VALUES (185, 'Alarm', 7, 'Smoke Alarm - False alarm', 0.07, '2025-05-05 10:36:00', 130);
INSERT INTO public.incidents VALUES (217, 'Medical', 7, 'Head trauma from fall w entrapment', 0.18, '2025-05-09 14:42:00', 150);
INSERT INTO public.incidents VALUES (103, 'Medical', 1, 'MVA w Ped', 0.17, '2025-04-23 11:11:00', 66);
INSERT INTO public.incidents VALUES (218, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.13, '2025-05-09 15:47:00', 146);
INSERT INTO public.incidents VALUES (371, 'Alarm', 4, 'Stove Fire - fire out on arrival', 0.13, '2025-05-31 07:26:00', 258);
INSERT INTO public.incidents VALUES (175, 'Medical', 1, 'Infant choking', 0.15, '2025-05-01 05:33:00', 106);
INSERT INTO public.incidents VALUES (43, 'Alarm', 6, 'Grass Fire - Maintenance', 0.10, '2025-04-15 13:50:00', 29);
INSERT INTO public.incidents VALUES (44, 'Other', 7, 'Service Call - Gas Line Struck', 0.80, '2025-04-15 14:40:00', 30);
INSERT INTO public.incidents VALUES (42, 'Other', 7, 'Service Call - unknown', 0.27, '2025-04-15 13:12:00', 30);
INSERT INTO public.incidents VALUES (252, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.28, '2025-05-13 16:24:00', 169);
INSERT INTO public.incidents VALUES (410, 'Medical', 6, 'Lift Assist - non emergent', 0.58, '2025-06-06 13:17:00', 289);
INSERT INTO public.incidents VALUES (389, 'Medical', 6, 'Chest Pains', 0.13, '2025-06-02 01:02:00', 269);
INSERT INTO public.incidents VALUES (102, 'Medical', 4, 'Lift Assist - non emergent', 0.13, '2025-04-23 09:52:00', 68);
INSERT INTO public.incidents VALUES (411, 'Alarm', 3, 'Smoke Alarm - residential, false alarm', 0.17, '2025-06-06 15:43:00', 287);
INSERT INTO public.incidents VALUES (420, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.13, '2025-06-07 09:52:00', 291);
INSERT INTO public.incidents VALUES (383, 'Medical', 6, 'Lift Assist - non emergent', 0.23, '2025-06-01 16:26:00', 264);
INSERT INTO public.incidents VALUES (187, 'Other', 1, 'Service Call - Help W/F get out of creek', 0.07, '2025-05-05 10:55:00', 126);
INSERT INTO public.incidents VALUES (210, 'Medical', 6, 'MVA w ped - ped struck in crosswalk, 1 transported', 0.18, '2025-05-08 11:29:00', 144);
INSERT INTO public.incidents VALUES (211, 'Alarm', 1, 'Smoke Alarm - false alarm', 0.15, '2025-05-08 17:25:00', 141);
INSERT INTO public.incidents VALUES (212, 'Other', 4, 'Service Call - gas leak', 0.28, '2025-05-08 17:25:00', 143);
INSERT INTO public.incidents VALUES (213, 'Medical', 1, 'Lift Assist - non emergent', 0.13, '2025-05-08 17:54:00', 141);
INSERT INTO public.incidents VALUES (214, 'Alarm', 1, 'Fire Alarm - General, false', 0.08, '2025-05-08 18:12:00', 141);
INSERT INTO public.incidents VALUES (477, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.13, '2025-06-13 07:37:00', 324);
INSERT INTO public.incidents VALUES (204, 'Medical', 4, 'Unresponsive female - 1 transported', 0.21, '2025-05-07 13:01:00', 138);
INSERT INTO public.incidents VALUES (36, 'Other', 4, 'Service Call - Smell of Natural Gas', 0.28, '2025-04-14 07:39:00', 23);
INSERT INTO public.incidents VALUES (203, 'Other', 4, 'Service Call - tree fell on powerline', 0.12, '2025-05-07 06:59:00', 138);
INSERT INTO public.incidents VALUES (458, 'Other', 1, 'CO Alarm', 0.03, '2025-06-10 21:14:00', 306);
INSERT INTO public.incidents VALUES (493, 'Medical', 4, 'MVA - 2 veh', 0.03, '2025-06-14 22:01:00', 328);
INSERT INTO public.incidents VALUES (494, 'Medical', 1, 'Respiratory Distress', 0.33, '2025-06-14 23:00:00', 326);
INSERT INTO public.incidents VALUES (215, 'Medical', 6, 'Lift Assist - emergent', 0.27, '2025-05-08 18:33:00', 144);
INSERT INTO public.incidents VALUES (87, 'Alarm', 1, 'Smoke Alarm - False Alarm', 0.10, '2025-04-20 22:53:00', 51);
INSERT INTO public.incidents VALUES (124, 'Medical', 6, 'Respiratory Distress - Lifenet extended ETA', 0.27, '2025-04-25 08:40:00', 79);
INSERT INTO public.incidents VALUES (121, 'Alarm', 6, 'Fire Alarm - False alarm', 0.18, '2025-04-25 00:35:00', 79);
INSERT INTO public.incidents VALUES (125, 'Medical', 7, 'Lift Assist - emergent', 0.17, '2025-04-25 09:02:00', 80);
INSERT INTO public.incidents VALUES (122, 'Alarm', 7, 'CO Alarm - False alarm', 0.17, '2025-04-25 02:26:00', 80);
INSERT INTO public.incidents VALUES (139, 'Medical', 1, 'Lift Assist - non emergent, coroner req', 0.52, '2025-04-26 13:07:00', 81);
INSERT INTO public.incidents VALUES (424, 'Medical', 1, 'Baby crying...', 0.05, '2025-06-07 19:22:00', 291);
INSERT INTO public.incidents VALUES (425, 'Medical', 1, 'Gain Entry', 0.37, '2025-06-07 20:18:00', 291);
INSERT INTO public.incidents VALUES (428, 'Medical', 1, '2 male subjects fighter, head trauma', 0.20, '2025-06-08 01:54:00', 296);
INSERT INTO public.incidents VALUES (333, 'Medical', 6, 'MCI - cpr in progress, 1 transported', 0.72, '2025-05-23 20:07:00', 219);
INSERT INTO public.incidents VALUES (59, 'Alarm', 7, 'Fire Alarm - General, False', 0.15, '2025-04-17 17:53:00', 40);
INSERT INTO public.incidents VALUES (38, 'Fire', 6, 'Dumpster Fire', 0.32, '2025-04-14 12:18:00', 24);
INSERT INTO public.incidents VALUES (146, 'Medical', 3, 'Chest Pains', 0.23, '2025-04-26 19:42:00', 82);
INSERT INTO public.incidents VALUES (5, 'Medical', 1, 'Overdose - 1 transported', 0.09, '2025-04-10 17:00:00', 1);
INSERT INTO public.incidents VALUES (4, 'Alarm', 3, 'Trash Fire - unauthorized', 0.07, '2025-04-10 15:00:00', 2);
INSERT INTO public.incidents VALUES (14, 'Alarm', 6, 'Pull station - false alarm', 0.07, '2025-04-11 18:11:00', 9);
INSERT INTO public.incidents VALUES (358, 'Medical', 1, 'MVA - 1 vehicle hit ditch', 0.20, '2025-05-28 18:41:00', 241);
INSERT INTO public.incidents VALUES (439, 'Medical', 6, 'Lift Assist - non emergent', 0.18, '2025-06-09 08:46:00', 304);
INSERT INTO public.incidents VALUES (49, 'Medical', 6, 'MVA - 2 vehicles', 0.74, '2025-04-16 09:23:00', 34);
INSERT INTO public.incidents VALUES (52, 'Other', 7, 'Illegal Burning', 0.28, '2025-04-16 18:34:00', 35);
INSERT INTO public.incidents VALUES (61, 'Medical', 1, 'Lift Assist - Non emergent', 0.01, '2025-04-17 19:11:00', 36);
INSERT INTO public.incidents VALUES (220, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.43, '2025-05-09 18:08:00', 146);
INSERT INTO public.incidents VALUES (269, 'Medical', 7, 'Lift Assist - non emergent', 0.33, '2025-05-15 16:09:00', 180);
INSERT INTO public.incidents VALUES (270, 'Alarm', 7, 'Fire Alarm - residential, false alarm', 0.08, '2025-05-15 17:33:00', 180);
INSERT INTO public.incidents VALUES (361, 'Medical', 1, 'Unresponsive female w/ 6 yo child', 0.53, '2025-05-29 09:39:00', 246);
INSERT INTO public.incidents VALUES (362, 'Medical', 4, 'MVA - 2 vehicles, minor injuries', 0.23, '2025-05-29 12:17:00', 248);
INSERT INTO public.incidents VALUES (363, 'Medical', 6, 'Chest Pains', 0.27, '2025-05-30 02:22:00', 254);
INSERT INTO public.incidents VALUES (364, 'Medical', 7, 'PT found in truck unresponsive - 1 transported', 0.70, '2025-05-30 07:41:00', 255);
INSERT INTO public.incidents VALUES (69, 'Alarm', 6, 'Illegal Burning', 1.00, '2025-04-18 14:22:00', 44);
INSERT INTO public.incidents VALUES (145, 'Alarm', 6, 'Fire Alarm - pull station, false', 0.18, '2025-04-26 19:05:00', 84);
INSERT INTO public.incidents VALUES (144, 'Medical', 6, 'Lift Assist - non emergent', 0.33, '2025-04-26 17:45:00', 84);
INSERT INTO public.incidents VALUES (141, 'Medical', 6, 'Lift Assist - cancelled en route', 0.02, '2025-04-26 13:39:00', 84);
INSERT INTO public.incidents VALUES (136, 'Other', 6, 'CO Alarm - smell of gas inside residence', 0.25, '2025-04-26 09:30:00', 84);
INSERT INTO public.incidents VALUES (147, 'Other', 7, 'Illegal Burning', 0.27, '2025-04-26 23:53:00', 85);
INSERT INTO public.incidents VALUES (365, 'Alarm', 7, 'Fire Alarm - pull station, false alarm', 0.17, '2025-05-30 15:00:00', 255);
INSERT INTO public.incidents VALUES (366, 'Medical', 6, 'Lift Assist - non emergent', 0.30, '2025-05-30 15:58:00', 254);
INSERT INTO public.incidents VALUES (367, 'Alarm', 3, 'Called in - burnt food on stove', 0.43, '2025-05-30 18:28:00', 252);
INSERT INTO public.incidents VALUES (538, 'Medical', 3, 'Lift Assist - non emergent', 0.33, '2025-06-20 10:05:00', 357);
INSERT INTO public.incidents VALUES (539, 'Medical', 6, 'MVA - 2 veh', 0.67, '2025-06-20 12:52:00', 359);
INSERT INTO public.incidents VALUES (540, 'Medical', 1, 'Chest Pains', 0.45, '2025-06-20 13:07:00', 356);
INSERT INTO public.incidents VALUES (543, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.23, '2025-06-20 13:41:00', 359);
INSERT INTO public.incidents VALUES (544, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.05, '2025-06-20 16:38:00', 359);
INSERT INTO public.incidents VALUES (545, 'Medical', 7, 'Lift Assist - non emergent', 0.32, '2025-06-20 16:43:00', 360);
INSERT INTO public.incidents VALUES (546, 'Alarm', 1, 'Smoke Alarm - general, false alarm', 0.12, '2025-06-20 18:18:00', 356);
INSERT INTO public.incidents VALUES (132, 'Alarm', 1, 'Fire Alarm - General alarm, false', 0.13, '2025-04-25 20:12:00', 76);
INSERT INTO public.incidents VALUES (131, 'Medical', 1, 'MVA w Ped - 1 transported', 0.15, '2025-04-25 19:53:00', 76);
INSERT INTO public.incidents VALUES (551, 'Medical', 7, 'Lift Assist - emergent', 0.90, '2025-06-21 18:17:00', 365);
INSERT INTO public.incidents VALUES (552, 'Alarm', 4, 'Fire Alarm - general, false alarm', 0.08, '2025-06-21 18:28:00', 363);
INSERT INTO public.incidents VALUES (553, 'Medical', 3, 'MVA - MC vs retainer wall, 1 transported', 0.28, '2025-06-21 18:31:00', 362);
INSERT INTO public.incidents VALUES (509, 'Fire', 1, 'Structure Fire - Powerline landed on house and ignited attic space', 1.38, '2025-06-17 12:51:00', 341);
INSERT INTO public.incidents VALUES (510, 'Medical', 7, 'MVA - veh vs semi, 1 transported', 0.13, '2025-06-17 13:40:00', 345);
INSERT INTO public.incidents VALUES (511, 'Medical', 6, 'MCI - 1 transported', 0.23, '2025-06-17 16:27:00', 344);
INSERT INTO public.incidents VALUES (512, 'Alarm', 7, 'Fire Alarm - general, false alarm', 0.17, '2025-06-17 20:59:00', 345);
INSERT INTO public.incidents VALUES (513, 'Other', 1, 'Service call - sprinkler busted', 0.27, '2025-06-17 21:51:00', 341);
INSERT INTO public.incidents VALUES (514, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.23, '2025-06-17 22:50:00', 341);
INSERT INTO public.incidents VALUES (515, 'Medical', 4, 'Lift Assist - non emergent', 0.03, '2025-06-18 11:04:00', 348);
INSERT INTO public.incidents VALUES (516, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.12, '2025-06-18 11:59:00', 349);
INSERT INTO public.incidents VALUES (517, 'Medical', 1, 'Lift Assist - non emergent', 0.13, '2025-06-18 13:38:00', 346);
INSERT INTO public.incidents VALUES (518, 'Alarm', 1, 'Fire Alarm - general, false alarm', 0.22, '2025-06-18 18:28:00', 346);
INSERT INTO public.incidents VALUES (519, 'Other', 6, 'Service Call', 0.22, '2025-06-18 19:19:00', 349);
INSERT INTO public.incidents VALUES (520, 'Other', 3, 'Powerline down', 0.10, '2025-06-18 20:33:00', 347);
INSERT INTO public.incidents VALUES (521, 'Other', 1, 'Elevator entrapment', 0.52, '2025-06-19 04:56:00', 351);
INSERT INTO public.incidents VALUES (522, 'Medical', 4, 'MVA - 2 veh', 0.30, '2025-06-19 09:06:00', 353);
INSERT INTO public.incidents VALUES (523, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.10, '2025-06-19 10:21:00', 354);
INSERT INTO public.incidents VALUES (299, 'Medical', 4, 'Lift Assist - emergent', 0.10, '2025-05-19 16:03:00', 198);
INSERT INTO public.incidents VALUES (300, 'Medical', 6, 'Seizure w head trauma - 1 transported', 0.37, '2025-05-19 16:32:00', 199);
INSERT INTO public.incidents VALUES (301, 'Medical', 1, 'Respiratory Distress - 1 transported', 0.13, '2025-05-19 22:00:00', 196);
INSERT INTO public.incidents VALUES (524, 'Other', 4, 'Fluid clean-up', 0.10, '2025-06-19 10:49:00', 353);
INSERT INTO public.incidents VALUES (564, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.47, '2025-06-22 16:19:00', 369);
INSERT INTO public.incidents VALUES (565, 'Medical', 4, 'Respiratory Distress', 0.18, '2025-06-22 19:45:00', 368);
INSERT INTO public.incidents VALUES (566, 'Medical', 1, 'Respiratory Distress - 1 transported', 0.40, '2025-06-22 20:04:00', 366);
INSERT INTO public.incidents VALUES (567, 'Alarm', 3, 'Fire Alarm - burnt food', 0.27, '2025-06-22 22:04:00', 367);
INSERT INTO public.incidents VALUES (568, 'Medical', 7, 'Lift Assist - non emergent', 0.17, '2025-06-22 22:28:00', 370);
INSERT INTO public.incidents VALUES (569, 'Medical', 6, 'Lift Assist - emergent', 0.20, '2025-06-23 08:09:00', 374);
INSERT INTO public.incidents VALUES (570, 'Medical', 4, 'MVA - 2 veh, w trailor - minor injuries', 0.78, '2025-06-23 09:01:00', 373);
INSERT INTO public.incidents VALUES (571, 'Other', 3, 'Tree on Powerline', 0.17, '2025-06-23 10:39:00', 372);
INSERT INTO public.incidents VALUES (572, 'Medical', 1, 'Lift Assist - non emergent', 0.20, '2025-06-23 11:58:00', 371);
INSERT INTO public.incidents VALUES (573, 'Other', 4, 'Smell of gas', 0.23, '2025-06-23 13:43:00', 373);
INSERT INTO public.incidents VALUES (574, 'Medical', 4, 'MVA - 2 veh, minor injuries', 0.68, '2025-06-23 15:59:00', 373);
INSERT INTO public.incidents VALUES (575, 'Medical', 1, 'Lift Assist - non emergent', 0.23, '2025-06-23 18:22:00', 371);
INSERT INTO public.incidents VALUES (576, 'Medical', 4, 'Respiratory Distress', 0.17, '2025-06-23 19:03:00', 373);
INSERT INTO public.incidents VALUES (577, 'Medical', 6, 'Chest Pains', 0.30, '2025-06-23 19:06:00', 374);
INSERT INTO public.incidents VALUES (277, 'Medical', 1, 'MVA - 2 vehicles', 0.23, '2025-05-16 13:37:00', 181);
INSERT INTO public.incidents VALUES (67, 'Other', 1, 'Service Call - Smell of Natural Gas', 0.23, '2025-04-18 14:09:00', 41);
INSERT INTO public.incidents VALUES (71, 'Alarm', 3, 'Fire Alarm - General, no fire', 0.13, '2025-04-18 16:12:00', 42);
INSERT INTO public.incidents VALUES (76, 'Medical', 6, 'Lift Assist - Non Emergent', 0.30, '2025-04-18 23:01:00', 44);
INSERT INTO public.incidents VALUES (75, 'Alarm', 6, 'Black smoke coming from wooded area', 0.13, '2025-04-18 20:33:00', 44);
INSERT INTO public.incidents VALUES (161, 'Alarm', 3, 'Fire Alarm - waterflow, false alarm', 0.08, '2025-04-28 12:56:00', 92);
INSERT INTO public.incidents VALUES (257, 'Medical', 1, 'MVA - Truck vs Tree, 1 transported', 0.45, '2025-05-13 23:38:00', 166);
INSERT INTO public.incidents VALUES (258, 'Medical', 1, 'MCI', 0.03, '2025-05-14 02:21:00', 171);
INSERT INTO public.incidents VALUES (259, 'Other', 6, 'Service Call - fluid clean up', 0.17, '2025-05-14 04:54:00', 174);
INSERT INTO public.incidents VALUES (260, 'Medical', 3, 'Respiratory Distress', 0.33, '2025-05-14 05:15:00', 172);
INSERT INTO public.incidents VALUES (261, 'Medical', 1, 'Lift Assist - emergent', 0.43, '2025-05-14 05:58:00', 171);
INSERT INTO public.incidents VALUES (262, 'Alarm', 4, 'Kitchen Fire - fire out before arrival', 0.12, '2025-05-14 09:11:00', 173);
INSERT INTO public.incidents VALUES (51, 'Other', 1, 'Power Line Sparking from Tree', 0.18, '2025-04-16 16:40:00', 31);
INSERT INTO public.incidents VALUES (20, 'Other', 1, 'Unauthorized burning', 0.10, '2025-04-12 08:13:00', 11);
INSERT INTO public.incidents VALUES (18, 'Medical', 1, 'Rollover accident - 3 transported', 0.57, '2025-04-12 02:01:00', 11);
INSERT INTO public.incidents VALUES (17, 'Alarm', 4, 'Smoke alarm - Cancelled en route', 0.02, '2025-04-12 01:37:00', 13);
INSERT INTO public.incidents VALUES (19, 'Medical', 6, 'Minor MVA', 0.33, '2025-04-12 06:28:00', 14);
INSERT INTO public.incidents VALUES (528, 'Other', 1, 'Service Call', 0.28, '2025-06-19 13:34:00', 351);
INSERT INTO public.incidents VALUES (529, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.18, '2025-06-19 15:03:00', 354);
INSERT INTO public.incidents VALUES (530, 'Other', 1, 'Elevator entrapment', 0.23, '2025-06-19 16:02:00', 351);
INSERT INTO public.incidents VALUES (531, 'Other', 1, 'Service Call', 0.17, '2025-06-19 19:45:00', 351);
INSERT INTO public.incidents VALUES (532, 'Medical', 6, 'Lift Assist - non emergent', 0.08, '2025-06-19 21:08:00', 354);
INSERT INTO public.incidents VALUES (533, 'Medical', 6, 'Chest Pains', 0.12, '2025-06-20 02:42:00', 359);
INSERT INTO public.incidents VALUES (534, 'Alarm', 1, 'Fire Alarm - water flow', 0.48, '2025-06-20 04:23:00', 356);
INSERT INTO public.incidents VALUES (578, 'Alarm', 7, 'Fire Alarm - general, false alarm', 0.13, '2025-06-23 19:11:00', 375);
INSERT INTO public.incidents VALUES (143, 'Medical', 7, 'Fall alert - not responding, 1 transported', 0.33, '2025-04-26 16:50:00', 85);
INSERT INTO public.incidents VALUES (156, 'Alarm', 4, 'Smoke Alarm - burnt food, false', 0.08, '2025-04-27 20:22:00', 88);
INSERT INTO public.incidents VALUES (151, 'Medical', 4, 'MVA - 2 vehicles', 0.15, '2025-04-27 04:47:00', 88);
INSERT INTO public.incidents VALUES (153, 'Alarm', 6, 'Fire Alarm - pull station, false', 0.22, '2025-04-27 11:13:00', 89);
INSERT INTO public.incidents VALUES (152, 'Alarm', 7, 'Smoke Alarm - false alarm', 0.10, '2025-04-27 10:03:00', 90);
INSERT INTO public.incidents VALUES (166, 'Medical', 1, 'Overdose - 1 transported', 0.48, '2025-04-28 15:58:00', 91);
INSERT INTO public.incidents VALUES (557, 'Other', 1, 'Service Call - Water leaking in to apt from second story', 0.35, '2025-06-22 03:55:00', 366);
INSERT INTO public.incidents VALUES (558, 'Medical', 3, 'Lift Assist - non emergent', 0.27, '2025-06-22 04:02:00', 367);
INSERT INTO public.incidents VALUES (559, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.42, '2025-06-22 04:13:00', 369);
INSERT INTO public.incidents VALUES (560, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.17, '2025-06-22 09:11:00', 369);
INSERT INTO public.incidents VALUES (561, 'Alarm', 1, 'Smoke Alarm - general, false alarm', 0.07, '2025-06-22 12:07:00', 366);
INSERT INTO public.incidents VALUES (562, 'Alarm', 6, 'Fire Alarm - general, false alarm', 0.35, '2025-06-22 15:58:00', 369);
INSERT INTO public.incidents VALUES (563, 'Alarm', 6, 'Fire Alarm - burnt food, door breach', 0.23, '2025-06-22 16:16:00', 369);
INSERT INTO public.incidents VALUES (274, 'Alarm', 7, 'Fire Alarm - pull station, false alarm', 0.13, '2025-05-16 09:45:00', 185);
INSERT INTO public.incidents VALUES (275, 'Other', 3, 'Service Call - gas line struck', 0.35, '2025-05-16 10:17:00', 182);
INSERT INTO public.incidents VALUES (276, 'Alarm', 1, 'Smoke Alarm - dust from construction, false alarm', 0.22, '2025-05-16 11:51:00', 181);
INSERT INTO public.incidents VALUES (278, 'Other', 7, 'Service Call', 0.08, '2025-05-16 13:51:00', 185);
INSERT INTO public.incidents VALUES (279, 'Other', 1, 'Illegal Burning', 0.15, '2025-05-16 18:41:00', 181);
INSERT INTO public.incidents VALUES (265, 'Medical', 4, 'Lift Assist - non emergent', 0.20, '2025-05-14 17:22:00', 173);
INSERT INTO public.incidents VALUES (323, 'Alarm', 1, 'Fire Alarm - commercial, false alarm', 0.08, '2025-05-22 18:15:00', 211);


--
-- TOC entry 4963 (class 0 OID 24891)
-- Dependencies: 224
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
INSERT INTO public.incidentunits VALUES (448, 4);
INSERT INTO public.incidentunits VALUES (449, 7);
INSERT INTO public.incidentunits VALUES (450, 121);
INSERT INTO public.incidentunits VALUES (450, 6);
INSERT INTO public.incidentunits VALUES (450, 4);
INSERT INTO public.incidentunits VALUES (450, 10);
INSERT INTO public.incidentunits VALUES (451, 6);
INSERT INTO public.incidentunits VALUES (451, 2);
INSERT INTO public.incidentunits VALUES (452, 6);
INSERT INTO public.incidentunits VALUES (453, 7);
INSERT INTO public.incidentunits VALUES (454, 7);
INSERT INTO public.incidentunits VALUES (455, 1);
INSERT INTO public.incidentunits VALUES (456, 4);
INSERT INTO public.incidentunits VALUES (456, 2);
INSERT INTO public.incidentunits VALUES (457, 3);
INSERT INTO public.incidentunits VALUES (458, 1);
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
INSERT INTO public.incidentunits VALUES (184, 121);
INSERT INTO public.incidentunits VALUES (184, 1);
INSERT INTO public.incidentunits VALUES (184, 7);
INSERT INTO public.incidentunits VALUES (184, 5);
INSERT INTO public.incidentunits VALUES (185, 121);
INSERT INTO public.incidentunits VALUES (185, 7);
INSERT INTO public.incidentunits VALUES (185, 1);
INSERT INTO public.incidentunits VALUES (185, 5);
INSERT INTO public.incidentunits VALUES (186, 121);
INSERT INTO public.incidentunits VALUES (186, 6);
INSERT INTO public.incidentunits VALUES (186, 4);
INSERT INTO public.incidentunits VALUES (186, 10);
INSERT INTO public.incidentunits VALUES (187, 1);
INSERT INTO public.incidentunits VALUES (188, 121);
INSERT INTO public.incidentunits VALUES (188, 6);
INSERT INTO public.incidentunits VALUES (188, 4);
INSERT INTO public.incidentunits VALUES (188, 10);
INSERT INTO public.incidentunits VALUES (189, 4);
INSERT INTO public.incidentunits VALUES (190, 6);
INSERT INTO public.incidentunits VALUES (191, 1);
INSERT INTO public.incidentunits VALUES (192, 3);
INSERT INTO public.incidentunits VALUES (193, 121);
INSERT INTO public.incidentunits VALUES (193, 6);
INSERT INTO public.incidentunits VALUES (193, 4);
INSERT INTO public.incidentunits VALUES (193, 10);
INSERT INTO public.incidentunits VALUES (194, 4);
INSERT INTO public.incidentunits VALUES (195, 121);
INSERT INTO public.incidentunits VALUES (195, 1);
INSERT INTO public.incidentunits VALUES (195, 3);
INSERT INTO public.incidentunits VALUES (195, 5);
INSERT INTO public.incidentunits VALUES (196, 1);
INSERT INTO public.incidentunits VALUES (197, 6);
INSERT INTO public.incidentunits VALUES (198, 6);
INSERT INTO public.incidentunits VALUES (199, 1);
INSERT INTO public.incidentunits VALUES (200, 6);
INSERT INTO public.incidentunits VALUES (201, 121);
INSERT INTO public.incidentunits VALUES (201, 1);
INSERT INTO public.incidentunits VALUES (201, 7);
INSERT INTO public.incidentunits VALUES (201, 5);
INSERT INTO public.incidentunits VALUES (202, 121);
INSERT INTO public.incidentunits VALUES (202, 3);
INSERT INTO public.incidentunits VALUES (202, 1);
INSERT INTO public.incidentunits VALUES (202, 5);
INSERT INTO public.incidentunits VALUES (203, 4);
INSERT INTO public.incidentunits VALUES (204, 4);
INSERT INTO public.incidentunits VALUES (205, 121);
INSERT INTO public.incidentunits VALUES (205, 6);
INSERT INTO public.incidentunits VALUES (205, 4);
INSERT INTO public.incidentunits VALUES (205, 10);
INSERT INTO public.incidentunits VALUES (206, 1);
INSERT INTO public.incidentunits VALUES (207, 6);
INSERT INTO public.incidentunits VALUES (208, 1);
INSERT INTO public.incidentunits VALUES (208, 12);
INSERT INTO public.incidentunits VALUES (209, 121);
INSERT INTO public.incidentunits VALUES (209, 4);
INSERT INTO public.incidentunits VALUES (209, 6);
INSERT INTO public.incidentunits VALUES (209, 2);
INSERT INTO public.incidentunits VALUES (210, 6);
INSERT INTO public.incidentunits VALUES (210, 2);
INSERT INTO public.incidentunits VALUES (211, 121);
INSERT INTO public.incidentunits VALUES (211, 1);
INSERT INTO public.incidentunits VALUES (211, 3);
INSERT INTO public.incidentunits VALUES (211, 5);
INSERT INTO public.incidentunits VALUES (212, 4);
INSERT INTO public.incidentunits VALUES (213, 1);
INSERT INTO public.incidentunits VALUES (214, 121);
INSERT INTO public.incidentunits VALUES (214, 1);
INSERT INTO public.incidentunits VALUES (214, 7);
INSERT INTO public.incidentunits VALUES (214, 5);
INSERT INTO public.incidentunits VALUES (215, 6);
INSERT INTO public.incidentunits VALUES (216, 121);
INSERT INTO public.incidentunits VALUES (216, 1);
INSERT INTO public.incidentunits VALUES (216, 3);
INSERT INTO public.incidentunits VALUES (216, 5);
INSERT INTO public.incidentunits VALUES (217, 7);
INSERT INTO public.incidentunits VALUES (218, 121);
INSERT INTO public.incidentunits VALUES (218, 1);
INSERT INTO public.incidentunits VALUES (218, 3);
INSERT INTO public.incidentunits VALUES (218, 5);
INSERT INTO public.incidentunits VALUES (219, 1);
INSERT INTO public.incidentunits VALUES (220, 121);
INSERT INTO public.incidentunits VALUES (220, 1);
INSERT INTO public.incidentunits VALUES (220, 3);
INSERT INTO public.incidentunits VALUES (220, 5);
INSERT INTO public.incidentunits VALUES (221, 1);
INSERT INTO public.incidentunits VALUES (222, 121);
INSERT INTO public.incidentunits VALUES (222, 6);
INSERT INTO public.incidentunits VALUES (222, 4);
INSERT INTO public.incidentunits VALUES (222, 10);
INSERT INTO public.incidentunits VALUES (223, 121);
INSERT INTO public.incidentunits VALUES (223, 3);
INSERT INTO public.incidentunits VALUES (223, 1);
INSERT INTO public.incidentunits VALUES (223, 5);
INSERT INTO public.incidentunits VALUES (224, 7);
INSERT INTO public.incidentunits VALUES (225, 6);
INSERT INTO public.incidentunits VALUES (225, 2);
INSERT INTO public.incidentunits VALUES (226, 121);
INSERT INTO public.incidentunits VALUES (226, 6);
INSERT INTO public.incidentunits VALUES (226, 4);
INSERT INTO public.incidentunits VALUES (226, 2);
INSERT INTO public.incidentunits VALUES (227, 6);
INSERT INTO public.incidentunits VALUES (228, 3);
INSERT INTO public.incidentunits VALUES (229, 6);
INSERT INTO public.incidentunits VALUES (230, 121);
INSERT INTO public.incidentunits VALUES (230, 1);
INSERT INTO public.incidentunits VALUES (230, 3);
INSERT INTO public.incidentunits VALUES (230, 5);
INSERT INTO public.incidentunits VALUES (231, 121);
INSERT INTO public.incidentunits VALUES (231, 1);
INSERT INTO public.incidentunits VALUES (231, 3);
INSERT INTO public.incidentunits VALUES (231, 5);
INSERT INTO public.incidentunits VALUES (232, 6);
INSERT INTO public.incidentunits VALUES (232, 2);
INSERT INTO public.incidentunits VALUES (233, 121);
INSERT INTO public.incidentunits VALUES (233, 6);
INSERT INTO public.incidentunits VALUES (233, 2);
INSERT INTO public.incidentunits VALUES (234, 6);
INSERT INTO public.incidentunits VALUES (234, 2);
INSERT INTO public.incidentunits VALUES (235, 7);
INSERT INTO public.incidentunits VALUES (236, 1);
INSERT INTO public.incidentunits VALUES (237, 121);
INSERT INTO public.incidentunits VALUES (237, 6);
INSERT INTO public.incidentunits VALUES (237, 4);
INSERT INTO public.incidentunits VALUES (237, 2);
INSERT INTO public.incidentunits VALUES (238, 4);
INSERT INTO public.incidentunits VALUES (238, 2);
INSERT INTO public.incidentunits VALUES (239, 121);
INSERT INTO public.incidentunits VALUES (239, 1);
INSERT INTO public.incidentunits VALUES (239, 3);
INSERT INTO public.incidentunits VALUES (239, 5);
INSERT INTO public.incidentunits VALUES (240, 1);
INSERT INTO public.incidentunits VALUES (241, 1);
INSERT INTO public.incidentunits VALUES (242, 3);
INSERT INTO public.incidentunits VALUES (243, 4);
INSERT INTO public.incidentunits VALUES (243, 2);
INSERT INTO public.incidentunits VALUES (244, 121);
INSERT INTO public.incidentunits VALUES (244, 1);
INSERT INTO public.incidentunits VALUES (244, 3);
INSERT INTO public.incidentunits VALUES (244, 5);
INSERT INTO public.incidentunits VALUES (245, 121);
INSERT INTO public.incidentunits VALUES (245, 4);
INSERT INTO public.incidentunits VALUES (245, 1);
INSERT INTO public.incidentunits VALUES (245, 5);
INSERT INTO public.incidentunits VALUES (246, 121);
INSERT INTO public.incidentunits VALUES (246, 1);
INSERT INTO public.incidentunits VALUES (246, 3);
INSERT INTO public.incidentunits VALUES (246, 5);
INSERT INTO public.incidentunits VALUES (247, 7);
INSERT INTO public.incidentunits VALUES (248, 1);
INSERT INTO public.incidentunits VALUES (249, 1);
INSERT INTO public.incidentunits VALUES (250, 4);
INSERT INTO public.incidentunits VALUES (251, 121);
INSERT INTO public.incidentunits VALUES (251, 6);
INSERT INTO public.incidentunits VALUES (251, 4);
INSERT INTO public.incidentunits VALUES (251, 10);
INSERT INTO public.incidentunits VALUES (252, 6);
INSERT INTO public.incidentunits VALUES (253, 4);
INSERT INTO public.incidentunits VALUES (253, 6);
INSERT INTO public.incidentunits VALUES (254, 121);
INSERT INTO public.incidentunits VALUES (254, 4);
INSERT INTO public.incidentunits VALUES (254, 1);
INSERT INTO public.incidentunits VALUES (254, 10);
INSERT INTO public.incidentunits VALUES (255, 4);
INSERT INTO public.incidentunits VALUES (257, 1);
INSERT INTO public.incidentunits VALUES (257, 12);
INSERT INTO public.incidentunits VALUES (258, 1);
INSERT INTO public.incidentunits VALUES (259, 6);
INSERT INTO public.incidentunits VALUES (260, 3);
INSERT INTO public.incidentunits VALUES (261, 1);
INSERT INTO public.incidentunits VALUES (262, 121);
INSERT INTO public.incidentunits VALUES (262, 4);
INSERT INTO public.incidentunits VALUES (262, 1);
INSERT INTO public.incidentunits VALUES (262, 5);
INSERT INTO public.incidentunits VALUES (263, 7);
INSERT INTO public.incidentunits VALUES (264, 6);
INSERT INTO public.incidentunits VALUES (264, 2);
INSERT INTO public.incidentunits VALUES (265, 4);
INSERT INTO public.incidentunits VALUES (266, 1);
INSERT INTO public.incidentunits VALUES (267, 6);
INSERT INTO public.incidentunits VALUES (268, 6);
INSERT INTO public.incidentunits VALUES (268, 2);
INSERT INTO public.incidentunits VALUES (269, 7);
INSERT INTO public.incidentunits VALUES (270, 121);
INSERT INTO public.incidentunits VALUES (270, 7);
INSERT INTO public.incidentunits VALUES (270, 1);
INSERT INTO public.incidentunits VALUES (270, 5);
INSERT INTO public.incidentunits VALUES (271, 121);
INSERT INTO public.incidentunits VALUES (271, 6);
INSERT INTO public.incidentunits VALUES (271, 4);
INSERT INTO public.incidentunits VALUES (271, 2);
INSERT INTO public.incidentunits VALUES (272, 3);
INSERT INTO public.incidentunits VALUES (273, 4);
INSERT INTO public.incidentunits VALUES (273, 2);
INSERT INTO public.incidentunits VALUES (274, 121);
INSERT INTO public.incidentunits VALUES (274, 7);
INSERT INTO public.incidentunits VALUES (274, 6);
INSERT INTO public.incidentunits VALUES (274, 10);
INSERT INTO public.incidentunits VALUES (275, 3);
INSERT INTO public.incidentunits VALUES (276, 121);
INSERT INTO public.incidentunits VALUES (276, 1);
INSERT INTO public.incidentunits VALUES (276, 7);
INSERT INTO public.incidentunits VALUES (276, 5);
INSERT INTO public.incidentunits VALUES (277, 1);
INSERT INTO public.incidentunits VALUES (277, 2);
INSERT INTO public.incidentunits VALUES (278, 2);
INSERT INTO public.incidentunits VALUES (278, 1);
INSERT INTO public.incidentunits VALUES (279, 121);
INSERT INTO public.incidentunits VALUES (279, 6);
INSERT INTO public.incidentunits VALUES (279, 4);
INSERT INTO public.incidentunits VALUES (279, 10);
INSERT INTO public.incidentunits VALUES (280, 4);
INSERT INTO public.incidentunits VALUES (281, 3);
INSERT INTO public.incidentunits VALUES (281, 12);
INSERT INTO public.incidentunits VALUES (282, 121);
INSERT INTO public.incidentunits VALUES (282, 6);
INSERT INTO public.incidentunits VALUES (282, 4);
INSERT INTO public.incidentunits VALUES (282, 10);
INSERT INTO public.incidentunits VALUES (283, 7);
INSERT INTO public.incidentunits VALUES (284, 121);
INSERT INTO public.incidentunits VALUES (284, 6);
INSERT INTO public.incidentunits VALUES (284, 4);
INSERT INTO public.incidentunits VALUES (284, 10);
INSERT INTO public.incidentunits VALUES (285, 121);
INSERT INTO public.incidentunits VALUES (285, 6);
INSERT INTO public.incidentunits VALUES (285, 7);
INSERT INTO public.incidentunits VALUES (285, 10);
INSERT INTO public.incidentunits VALUES (286, 1);
INSERT INTO public.incidentunits VALUES (287, 6);
INSERT INTO public.incidentunits VALUES (287, 2);
INSERT INTO public.incidentunits VALUES (288, 6);
INSERT INTO public.incidentunits VALUES (289, 121);
INSERT INTO public.incidentunits VALUES (289, 6);
INSERT INTO public.incidentunits VALUES (289, 4);
INSERT INTO public.incidentunits VALUES (289, 2);
INSERT INTO public.incidentunits VALUES (290, 121);
INSERT INTO public.incidentunits VALUES (290, 6);
INSERT INTO public.incidentunits VALUES (290, 4);
INSERT INTO public.incidentunits VALUES (290, 10);
INSERT INTO public.incidentunits VALUES (291, 121);
INSERT INTO public.incidentunits VALUES (291, 7);
INSERT INTO public.incidentunits VALUES (291, 1);
INSERT INTO public.incidentunits VALUES (291, 5);
INSERT INTO public.incidentunits VALUES (292, 121);
INSERT INTO public.incidentunits VALUES (292, 6);
INSERT INTO public.incidentunits VALUES (292, 4);
INSERT INTO public.incidentunits VALUES (292, 10);
INSERT INTO public.incidentunits VALUES (293, 6);
INSERT INTO public.incidentunits VALUES (294, 1);
INSERT INTO public.incidentunits VALUES (295, 1);
INSERT INTO public.incidentunits VALUES (296, 121);
INSERT INTO public.incidentunits VALUES (296, 4);
INSERT INTO public.incidentunits VALUES (296, 6);
INSERT INTO public.incidentunits VALUES (296, 10);
INSERT INTO public.incidentunits VALUES (297, 4);
INSERT INTO public.incidentunits VALUES (298, 6);
INSERT INTO public.incidentunits VALUES (299, 1);
INSERT INTO public.incidentunits VALUES (300, 1);
INSERT INTO public.incidentunits VALUES (301, 121);
INSERT INTO public.incidentunits VALUES (301, 6);
INSERT INTO public.incidentunits VALUES (301, 7);
INSERT INTO public.incidentunits VALUES (301, 2);
INSERT INTO public.incidentunits VALUES (302, 1);
INSERT INTO public.incidentunits VALUES (303, 6);
INSERT INTO public.incidentunits VALUES (304, 7);
INSERT INTO public.incidentunits VALUES (305, 7);
INSERT INTO public.incidentunits VALUES (306, 6);
INSERT INTO public.incidentunits VALUES (307, 6);
INSERT INTO public.incidentunits VALUES (308, 121);
INSERT INTO public.incidentunits VALUES (308, 7);
INSERT INTO public.incidentunits VALUES (308, 6);
INSERT INTO public.incidentunits VALUES (308, 2);
INSERT INTO public.incidentunits VALUES (309, 121);
INSERT INTO public.incidentunits VALUES (309, 6);
INSERT INTO public.incidentunits VALUES (309, 7);
INSERT INTO public.incidentunits VALUES (309, 10);
INSERT INTO public.incidentunits VALUES (310, 121);
INSERT INTO public.incidentunits VALUES (310, 1);
INSERT INTO public.incidentunits VALUES (310, 3);
INSERT INTO public.incidentunits VALUES (310, 5);
INSERT INTO public.incidentunits VALUES (311, 4);
INSERT INTO public.incidentunits VALUES (311, 2);
INSERT INTO public.incidentunits VALUES (312, 121);
INSERT INTO public.incidentunits VALUES (312, 6);
INSERT INTO public.incidentunits VALUES (312, 4);
INSERT INTO public.incidentunits VALUES (312, 10);
INSERT INTO public.incidentunits VALUES (313, 4);
INSERT INTO public.incidentunits VALUES (313, 2);
INSERT INTO public.incidentunits VALUES (314, 6);
INSERT INTO public.incidentunits VALUES (314, 2);
INSERT INTO public.incidentunits VALUES (315, 6);
INSERT INTO public.incidentunits VALUES (315, 2);
INSERT INTO public.incidentunits VALUES (316, 3);
INSERT INTO public.incidentunits VALUES (317, 1);
INSERT INTO public.incidentunits VALUES (318, 1);
INSERT INTO public.incidentunits VALUES (319, 4);
INSERT INTO public.incidentunits VALUES (320, 1);
INSERT INTO public.incidentunits VALUES (321, 121);
INSERT INTO public.incidentunits VALUES (321, 1);
INSERT INTO public.incidentunits VALUES (321, 3);
INSERT INTO public.incidentunits VALUES (321, 5);
INSERT INTO public.incidentunits VALUES (322, 1);
INSERT INTO public.incidentunits VALUES (323, 7);
INSERT INTO public.incidentunits VALUES (324, 4);
INSERT INTO public.incidentunits VALUES (325, 3);
INSERT INTO public.incidentunits VALUES (326, 121);
INSERT INTO public.incidentunits VALUES (326, 6);
INSERT INTO public.incidentunits VALUES (326, 4);
INSERT INTO public.incidentunits VALUES (326, 10);
INSERT INTO public.incidentunits VALUES (327, 1);
INSERT INTO public.incidentunits VALUES (328, 1);
INSERT INTO public.incidentunits VALUES (328, 12);
INSERT INTO public.incidentunits VALUES (329, 4);
INSERT INTO public.incidentunits VALUES (330, 4);
INSERT INTO public.incidentunits VALUES (330, 2);
INSERT INTO public.incidentunits VALUES (331, 6);
INSERT INTO public.incidentunits VALUES (332, 1);
INSERT INTO public.incidentunits VALUES (333, 1);
INSERT INTO public.incidentunits VALUES (334, 6);
INSERT INTO public.incidentunits VALUES (334, 2);
INSERT INTO public.incidentunits VALUES (335, 4);
INSERT INTO public.incidentunits VALUES (336, 7);
INSERT INTO public.incidentunits VALUES (337, 1);
INSERT INTO public.incidentunits VALUES (338, 121);
INSERT INTO public.incidentunits VALUES (338, 3);
INSERT INTO public.incidentunits VALUES (338, 1);
INSERT INTO public.incidentunits VALUES (338, 5);
INSERT INTO public.incidentunits VALUES (339, 1);
INSERT INTO public.incidentunits VALUES (340, 121);
INSERT INTO public.incidentunits VALUES (340, 6);
INSERT INTO public.incidentunits VALUES (340, 7);
INSERT INTO public.incidentunits VALUES (340, 10);
INSERT INTO public.incidentunits VALUES (341, 1);
INSERT INTO public.incidentunits VALUES (341, 12);
INSERT INTO public.incidentunits VALUES (344, 4);
INSERT INTO public.incidentunits VALUES (345, 3);
INSERT INTO public.incidentunits VALUES (346, 3);
INSERT INTO public.incidentunits VALUES (347, 121);
INSERT INTO public.incidentunits VALUES (347, 1);
INSERT INTO public.incidentunits VALUES (347, 7);
INSERT INTO public.incidentunits VALUES (347, 5);
INSERT INTO public.incidentunits VALUES (348, 121);
INSERT INTO public.incidentunits VALUES (348, 3);
INSERT INTO public.incidentunits VALUES (348, 1);
INSERT INTO public.incidentunits VALUES (348, 5);
INSERT INTO public.incidentunits VALUES (349, 3);
INSERT INTO public.incidentunits VALUES (349, 1);
INSERT INTO public.incidentunits VALUES (350, 6);
INSERT INTO public.incidentunits VALUES (342, 121);
INSERT INTO public.incidentunits VALUES (342, 6);
INSERT INTO public.incidentunits VALUES (342, 4);
INSERT INTO public.incidentunits VALUES (342, 10);
INSERT INTO public.incidentunits VALUES (343, 1);
INSERT INTO public.incidentunits VALUES (343, 12);
INSERT INTO public.incidentunits VALUES (351, 4);
INSERT INTO public.incidentunits VALUES (352, 4);
INSERT INTO public.incidentunits VALUES (353, 4);
INSERT INTO public.incidentunits VALUES (354, 6);
INSERT INTO public.incidentunits VALUES (355, 4);
INSERT INTO public.incidentunits VALUES (355, 2);
INSERT INTO public.incidentunits VALUES (356, 1);
INSERT INTO public.incidentunits VALUES (356, 12);
INSERT INTO public.incidentunits VALUES (357, 1);
INSERT INTO public.incidentunits VALUES (357, 12);
INSERT INTO public.incidentunits VALUES (358, 4);
INSERT INTO public.incidentunits VALUES (358, 2);
INSERT INTO public.incidentunits VALUES (359, 121);
INSERT INTO public.incidentunits VALUES (359, 6);
INSERT INTO public.incidentunits VALUES (359, 4);
INSERT INTO public.incidentunits VALUES (359, 10);
INSERT INTO public.incidentunits VALUES (360, 1);
INSERT INTO public.incidentunits VALUES (361, 4);
INSERT INTO public.incidentunits VALUES (361, 2);
INSERT INTO public.incidentunits VALUES (362, 6);
INSERT INTO public.incidentunits VALUES (363, 7);
INSERT INTO public.incidentunits VALUES (364, 121);
INSERT INTO public.incidentunits VALUES (364, 7);
INSERT INTO public.incidentunits VALUES (364, 6);
INSERT INTO public.incidentunits VALUES (364, 10);
INSERT INTO public.incidentunits VALUES (365, 6);
INSERT INTO public.incidentunits VALUES (366, 121);
INSERT INTO public.incidentunits VALUES (366, 3);
INSERT INTO public.incidentunits VALUES (366, 1);
INSERT INTO public.incidentunits VALUES (366, 5);
INSERT INTO public.incidentunits VALUES (367, 6);
INSERT INTO public.incidentunits VALUES (368, 7);
INSERT INTO public.incidentunits VALUES (369, 3);
INSERT INTO public.incidentunits VALUES (370, 121);
INSERT INTO public.incidentunits VALUES (370, 4);
INSERT INTO public.incidentunits VALUES (370, 1);
INSERT INTO public.incidentunits VALUES (370, 5);
INSERT INTO public.incidentunits VALUES (371, 1);
INSERT INTO public.incidentunits VALUES (371, 121);
INSERT INTO public.incidentunits VALUES (371, 3);
INSERT INTO public.incidentunits VALUES (371, 5);
INSERT INTO public.incidentunits VALUES (372, 6);
INSERT INTO public.incidentunits VALUES (373, 121);
INSERT INTO public.incidentunits VALUES (373, 3);
INSERT INTO public.incidentunits VALUES (373, 1);
INSERT INTO public.incidentunits VALUES (373, 5);
INSERT INTO public.incidentunits VALUES (374, 121);
INSERT INTO public.incidentunits VALUES (374, 6);
INSERT INTO public.incidentunits VALUES (374, 4);
INSERT INTO public.incidentunits VALUES (374, 10);
INSERT INTO public.incidentunits VALUES (375, 7);
INSERT INTO public.incidentunits VALUES (376, 1);
INSERT INTO public.incidentunits VALUES (377, 6);
INSERT INTO public.incidentunits VALUES (378, 6);
INSERT INTO public.incidentunits VALUES (379, 121);
INSERT INTO public.incidentunits VALUES (379, 4);
INSERT INTO public.incidentunits VALUES (379, 6);
INSERT INTO public.incidentunits VALUES (379, 10);
INSERT INTO public.incidentunits VALUES (380, 121);
INSERT INTO public.incidentunits VALUES (380, 6);
INSERT INTO public.incidentunits VALUES (380, 4);
INSERT INTO public.incidentunits VALUES (380, 10);
INSERT INTO public.incidentunits VALUES (381, 3);
INSERT INTO public.incidentunits VALUES (382, 6);
INSERT INTO public.incidentunits VALUES (383, 3);
INSERT INTO public.incidentunits VALUES (384, 6);
INSERT INTO public.incidentunits VALUES (385, 1);
INSERT INTO public.incidentunits VALUES (386, 6);
INSERT INTO public.incidentunits VALUES (387, 121);
INSERT INTO public.incidentunits VALUES (387, 3);
INSERT INTO public.incidentunits VALUES (387, 1);
INSERT INTO public.incidentunits VALUES (387, 5);
INSERT INTO public.incidentunits VALUES (388, 6);
INSERT INTO public.incidentunits VALUES (389, 6);
INSERT INTO public.incidentunits VALUES (390, 4);
INSERT INTO public.incidentunits VALUES (391, 1);
INSERT INTO public.incidentunits VALUES (391, 12);
INSERT INTO public.incidentunits VALUES (392, 121);
INSERT INTO public.incidentunits VALUES (392, 6);
INSERT INTO public.incidentunits VALUES (392, 7);
INSERT INTO public.incidentunits VALUES (392, 10);
INSERT INTO public.incidentunits VALUES (393, 6);
INSERT INTO public.incidentunits VALUES (393, 14);
INSERT INTO public.incidentunits VALUES (394, 1);
INSERT INTO public.incidentunits VALUES (395, 121);
INSERT INTO public.incidentunits VALUES (395, 3);
INSERT INTO public.incidentunits VALUES (395, 1);
INSERT INTO public.incidentunits VALUES (395, 5);
INSERT INTO public.incidentunits VALUES (396, 6);
INSERT INTO public.incidentunits VALUES (397, 121);
INSERT INTO public.incidentunits VALUES (397, 6);
INSERT INTO public.incidentunits VALUES (397, 4);
INSERT INTO public.incidentunits VALUES (397, 2);
INSERT INTO public.incidentunits VALUES (398, 121);
INSERT INTO public.incidentunits VALUES (398, 1);
INSERT INTO public.incidentunits VALUES (398, 3);
INSERT INTO public.incidentunits VALUES (398, 5);
INSERT INTO public.incidentunits VALUES (399, 4);
INSERT INTO public.incidentunits VALUES (399, 2);
INSERT INTO public.incidentunits VALUES (400, 1);
INSERT INTO public.incidentunits VALUES (401, 1);
INSERT INTO public.incidentunits VALUES (402, 7);
INSERT INTO public.incidentunits VALUES (403, 121);
INSERT INTO public.incidentunits VALUES (403, 6);
INSERT INTO public.incidentunits VALUES (403, 4);
INSERT INTO public.incidentunits VALUES (403, 2);
INSERT INTO public.incidentunits VALUES (404, 1);
INSERT INTO public.incidentunits VALUES (405, 1);
INSERT INTO public.incidentunits VALUES (406, 121);
INSERT INTO public.incidentunits VALUES (406, 1);
INSERT INTO public.incidentunits VALUES (406, 3);
INSERT INTO public.incidentunits VALUES (406, 5);
INSERT INTO public.incidentunits VALUES (407, 3);
INSERT INTO public.incidentunits VALUES (408, 6);
INSERT INTO public.incidentunits VALUES (409, 6);
INSERT INTO public.incidentunits VALUES (410, 121);
INSERT INTO public.incidentunits VALUES (410, 3);
INSERT INTO public.incidentunits VALUES (410, 1);
INSERT INTO public.incidentunits VALUES (410, 5);
INSERT INTO public.incidentunits VALUES (411, 4);
INSERT INTO public.incidentunits VALUES (411, 2);
INSERT INTO public.incidentunits VALUES (412, 1);
INSERT INTO public.incidentunits VALUES (413, 1);
INSERT INTO public.incidentunits VALUES (414, 1);
INSERT INTO public.incidentunits VALUES (415, 121);
INSERT INTO public.incidentunits VALUES (415, 7);
INSERT INTO public.incidentunits VALUES (415, 6);
INSERT INTO public.incidentunits VALUES (415, 2);
INSERT INTO public.incidentunits VALUES (416, 6);
INSERT INTO public.incidentunits VALUES (417, 121);
INSERT INTO public.incidentunits VALUES (417, 1);
INSERT INTO public.incidentunits VALUES (417, 3);
INSERT INTO public.incidentunits VALUES (417, 5);
INSERT INTO public.incidentunits VALUES (418, 1);
INSERT INTO public.incidentunits VALUES (419, 121);
INSERT INTO public.incidentunits VALUES (419, 1);
INSERT INTO public.incidentunits VALUES (419, 4);
INSERT INTO public.incidentunits VALUES (419, 5);
INSERT INTO public.incidentunits VALUES (420, 6);
INSERT INTO public.incidentunits VALUES (421, 6);
INSERT INTO public.incidentunits VALUES (422, 1);
INSERT INTO public.incidentunits VALUES (423, 1);
INSERT INTO public.incidentunits VALUES (424, 1);
INSERT INTO public.incidentunits VALUES (459, 1);
INSERT INTO public.incidentunits VALUES (460, 1);
INSERT INTO public.incidentunits VALUES (461, 121);
INSERT INTO public.incidentunits VALUES (461, 6);
INSERT INTO public.incidentunits VALUES (461, 4);
INSERT INTO public.incidentunits VALUES (461, 2);
INSERT INTO public.incidentunits VALUES (462, 1);
INSERT INTO public.incidentunits VALUES (463, 1);
INSERT INTO public.incidentunits VALUES (464, 4);
INSERT INTO public.incidentunits VALUES (465, 121);
INSERT INTO public.incidentunits VALUES (465, 6);
INSERT INTO public.incidentunits VALUES (465, 4);
INSERT INTO public.incidentunits VALUES (465, 10);
INSERT INTO public.incidentunits VALUES (466, 1);
INSERT INTO public.incidentunits VALUES (467, 121);
INSERT INTO public.incidentunits VALUES (467, 6);
INSERT INTO public.incidentunits VALUES (467, 7);
INSERT INTO public.incidentunits VALUES (467, 10);
INSERT INTO public.incidentunits VALUES (468, 121);
INSERT INTO public.incidentunits VALUES (468, 7);
INSERT INTO public.incidentunits VALUES (468, 6);
INSERT INTO public.incidentunits VALUES (468, 2);
INSERT INTO public.incidentunits VALUES (469, 1);
INSERT INTO public.incidentunits VALUES (470, 121);
INSERT INTO public.incidentunits VALUES (470, 1);
INSERT INTO public.incidentunits VALUES (425, 1);
INSERT INTO public.incidentunits VALUES (426, 1);
INSERT INTO public.incidentunits VALUES (426, 12);
INSERT INTO public.incidentunits VALUES (427, 1);
INSERT INTO public.incidentunits VALUES (428, 6);
INSERT INTO public.incidentunits VALUES (429, 121);
INSERT INTO public.incidentunits VALUES (429, 4);
INSERT INTO public.incidentunits VALUES (429, 6);
INSERT INTO public.incidentunits VALUES (429, 5);
INSERT INTO public.incidentunits VALUES (429, 3);
INSERT INTO public.incidentunits VALUES (430, 4);
INSERT INTO public.incidentunits VALUES (431, 121);
INSERT INTO public.incidentunits VALUES (431, 6);
INSERT INTO public.incidentunits VALUES (431, 4);
INSERT INTO public.incidentunits VALUES (431, 10);
INSERT INTO public.incidentunits VALUES (432, 3);
INSERT INTO public.incidentunits VALUES (433, 1);
INSERT INTO public.incidentunits VALUES (434, 121);
INSERT INTO public.incidentunits VALUES (434, 1);
INSERT INTO public.incidentunits VALUES (434, 3);
INSERT INTO public.incidentunits VALUES (434, 5);
INSERT INTO public.incidentunits VALUES (435, 7);
INSERT INTO public.incidentunits VALUES (436, 3);
INSERT INTO public.incidentunits VALUES (437, 1);
INSERT INTO public.incidentunits VALUES (438, 6);
INSERT INTO public.incidentunits VALUES (470, 4);
INSERT INTO public.incidentunits VALUES (470, 5);
INSERT INTO public.incidentunits VALUES (471, 6);
INSERT INTO public.incidentunits VALUES (472, 6);
INSERT INTO public.incidentunits VALUES (472, 2);
INSERT INTO public.incidentunits VALUES (473, 1);
INSERT INTO public.incidentunits VALUES (474, 6);
INSERT INTO public.incidentunits VALUES (475, 121);
INSERT INTO public.incidentunits VALUES (475, 3);
INSERT INTO public.incidentunits VALUES (475, 1);
INSERT INTO public.incidentunits VALUES (475, 5);
INSERT INTO public.incidentunits VALUES (476, 6);
INSERT INTO public.incidentunits VALUES (477, 121);
INSERT INTO public.incidentunits VALUES (477, 6);
INSERT INTO public.incidentunits VALUES (477, 7);
INSERT INTO public.incidentunits VALUES (477, 10);
INSERT INTO public.incidentunits VALUES (478, 6);
INSERT INTO public.incidentunits VALUES (479, 121);
INSERT INTO public.incidentunits VALUES (479, 1);
INSERT INTO public.incidentunits VALUES (479, 7);
INSERT INTO public.incidentunits VALUES (479, 5);
INSERT INTO public.incidentunits VALUES (480, 6);
INSERT INTO public.incidentunits VALUES (481, 1);
INSERT INTO public.incidentunits VALUES (482, 121);
INSERT INTO public.incidentunits VALUES (482, 6);
INSERT INTO public.incidentunits VALUES (482, 4);
INSERT INTO public.incidentunits VALUES (482, 10);
INSERT INTO public.incidentunits VALUES (483, 1);
INSERT INTO public.incidentunits VALUES (484, 7);
INSERT INTO public.incidentunits VALUES (484, 2);
INSERT INTO public.incidentunits VALUES (485, 121);
INSERT INTO public.incidentunits VALUES (485, 6);
INSERT INTO public.incidentunits VALUES (485, 4);
INSERT INTO public.incidentunits VALUES (485, 2);
INSERT INTO public.incidentunits VALUES (486, 121);
INSERT INTO public.incidentunits VALUES (486, 3);
INSERT INTO public.incidentunits VALUES (486, 1);
INSERT INTO public.incidentunits VALUES (486, 5);
INSERT INTO public.incidentunits VALUES (487, 7);
INSERT INTO public.incidentunits VALUES (488, 1);
INSERT INTO public.incidentunits VALUES (489, 4);
INSERT INTO public.incidentunits VALUES (490, 3);
INSERT INTO public.incidentunits VALUES (491, 3);
INSERT INTO public.incidentunits VALUES (492, 1);
INSERT INTO public.incidentunits VALUES (493, 4);
INSERT INTO public.incidentunits VALUES (493, 12);
INSERT INTO public.incidentunits VALUES (494, 1);
INSERT INTO public.incidentunits VALUES (495, 121);
INSERT INTO public.incidentunits VALUES (495, 6);
INSERT INTO public.incidentunits VALUES (495, 7);
INSERT INTO public.incidentunits VALUES (495, 10);
INSERT INTO public.incidentunits VALUES (496, 121);
INSERT INTO public.incidentunits VALUES (496, 1);
INSERT INTO public.incidentunits VALUES (496, 7);
INSERT INTO public.incidentunits VALUES (496, 10);
INSERT INTO public.incidentunits VALUES (497, 1);
INSERT INTO public.incidentunits VALUES (498, 1);
INSERT INTO public.incidentunits VALUES (499, 6);
INSERT INTO public.incidentunits VALUES (500, 4);
INSERT INTO public.incidentunits VALUES (501, 1);
INSERT INTO public.incidentunits VALUES (502, 6);
INSERT INTO public.incidentunits VALUES (503, 1);
INSERT INTO public.incidentunits VALUES (504, 121);
INSERT INTO public.incidentunits VALUES (504, 4);
INSERT INTO public.incidentunits VALUES (504, 6);
INSERT INTO public.incidentunits VALUES (505, 6);
INSERT INTO public.incidentunits VALUES (506, 121);
INSERT INTO public.incidentunits VALUES (506, 1);
INSERT INTO public.incidentunits VALUES (506, 3);
INSERT INTO public.incidentunits VALUES (506, 5);
INSERT INTO public.incidentunits VALUES (507, 121);
INSERT INTO public.incidentunits VALUES (507, 1);
INSERT INTO public.incidentunits VALUES (507, 3);
INSERT INTO public.incidentunits VALUES (507, 5);
INSERT INTO public.incidentunits VALUES (508, 6);
INSERT INTO public.incidentunits VALUES (509, 121);
INSERT INTO public.incidentunits VALUES (509, 1);
INSERT INTO public.incidentunits VALUES (509, 3);
INSERT INTO public.incidentunits VALUES (509, 4);
INSERT INTO public.incidentunits VALUES (509, 6);
INSERT INTO public.incidentunits VALUES (509, 5);
INSERT INTO public.incidentunits VALUES (510, 7);
INSERT INTO public.incidentunits VALUES (510, 2);
INSERT INTO public.incidentunits VALUES (511, 6);
INSERT INTO public.incidentunits VALUES (512, 121);
INSERT INTO public.incidentunits VALUES (512, 7);
INSERT INTO public.incidentunits VALUES (512, 6);
INSERT INTO public.incidentunits VALUES (512, 2);
INSERT INTO public.incidentunits VALUES (513, 1);
INSERT INTO public.incidentunits VALUES (514, 121);
INSERT INTO public.incidentunits VALUES (514, 1);
INSERT INTO public.incidentunits VALUES (514, 3);
INSERT INTO public.incidentunits VALUES (514, 5);
INSERT INTO public.incidentunits VALUES (515, 4);
INSERT INTO public.incidentunits VALUES (516, 121);
INSERT INTO public.incidentunits VALUES (516, 6);
INSERT INTO public.incidentunits VALUES (516, 4);
INSERT INTO public.incidentunits VALUES (516, 2);
INSERT INTO public.incidentunits VALUES (517, 1);
INSERT INTO public.incidentunits VALUES (518, 121);
INSERT INTO public.incidentunits VALUES (518, 1);
INSERT INTO public.incidentunits VALUES (518, 3);
INSERT INTO public.incidentunits VALUES (518, 5);
INSERT INTO public.incidentunits VALUES (519, 6);
INSERT INTO public.incidentunits VALUES (520, 3);
INSERT INTO public.incidentunits VALUES (521, 1);
INSERT INTO public.incidentunits VALUES (522, 4);
INSERT INTO public.incidentunits VALUES (522, 2);
INSERT INTO public.incidentunits VALUES (523, 121);
INSERT INTO public.incidentunits VALUES (523, 6);
INSERT INTO public.incidentunits VALUES (523, 7);
INSERT INTO public.incidentunits VALUES (523, 10);
INSERT INTO public.incidentunits VALUES (524, 4);
INSERT INTO public.incidentunits VALUES (525, 3);
INSERT INTO public.incidentunits VALUES (526, 121);
INSERT INTO public.incidentunits VALUES (526, 6);
INSERT INTO public.incidentunits VALUES (526, 4);
INSERT INTO public.incidentunits VALUES (526, 10);
INSERT INTO public.incidentunits VALUES (527, 121);
INSERT INTO public.incidentunits VALUES (527, 4);
INSERT INTO public.incidentunits VALUES (527, 6);
INSERT INTO public.incidentunits VALUES (527, 2);
INSERT INTO public.incidentunits VALUES (528, 1);
INSERT INTO public.incidentunits VALUES (529, 121);
INSERT INTO public.incidentunits VALUES (529, 6);
INSERT INTO public.incidentunits VALUES (529, 4);
INSERT INTO public.incidentunits VALUES (529, 10);
INSERT INTO public.incidentunits VALUES (530, 1);
INSERT INTO public.incidentunits VALUES (531, 1);
INSERT INTO public.incidentunits VALUES (532, 6);
INSERT INTO public.incidentunits VALUES (533, 6);
INSERT INTO public.incidentunits VALUES (534, 121);
INSERT INTO public.incidentunits VALUES (534, 1);
INSERT INTO public.incidentunits VALUES (534, 3);
INSERT INTO public.incidentunits VALUES (534, 5);
INSERT INTO public.incidentunits VALUES (535, 121);
INSERT INTO public.incidentunits VALUES (535, 1);
INSERT INTO public.incidentunits VALUES (535, 3);
INSERT INTO public.incidentunits VALUES (535, 5);
INSERT INTO public.incidentunits VALUES (536, 121);
INSERT INTO public.incidentunits VALUES (536, 6);
INSERT INTO public.incidentunits VALUES (536, 4);
INSERT INTO public.incidentunits VALUES (536, 2);
INSERT INTO public.incidentunits VALUES (537, 121);
INSERT INTO public.incidentunits VALUES (537, 6);
INSERT INTO public.incidentunits VALUES (537, 4);
INSERT INTO public.incidentunits VALUES (537, 10);
INSERT INTO public.incidentunits VALUES (538, 3);
INSERT INTO public.incidentunits VALUES (539, 6);
INSERT INTO public.incidentunits VALUES (539, 2);
INSERT INTO public.incidentunits VALUES (540, 1);
INSERT INTO public.incidentunits VALUES (541, 7);
INSERT INTO public.incidentunits VALUES (542, 121);
INSERT INTO public.incidentunits VALUES (542, 1);
INSERT INTO public.incidentunits VALUES (542, 3);
INSERT INTO public.incidentunits VALUES (542, 5);
INSERT INTO public.incidentunits VALUES (543, 121);
INSERT INTO public.incidentunits VALUES (543, 6);
INSERT INTO public.incidentunits VALUES (543, 4);
INSERT INTO public.incidentunits VALUES (543, 2);
INSERT INTO public.incidentunits VALUES (544, 121);
INSERT INTO public.incidentunits VALUES (544, 6);
INSERT INTO public.incidentunits VALUES (544, 4);
INSERT INTO public.incidentunits VALUES (544, 10);
INSERT INTO public.incidentunits VALUES (545, 7);
INSERT INTO public.incidentunits VALUES (546, 121);
INSERT INTO public.incidentunits VALUES (546, 1);
INSERT INTO public.incidentunits VALUES (546, 3);
INSERT INTO public.incidentunits VALUES (546, 5);
INSERT INTO public.incidentunits VALUES (547, 121);
INSERT INTO public.incidentunits VALUES (547, 6);
INSERT INTO public.incidentunits VALUES (547, 4);
INSERT INTO public.incidentunits VALUES (547, 2);
INSERT INTO public.incidentunits VALUES (548, 121);
INSERT INTO public.incidentunits VALUES (548, 3);
INSERT INTO public.incidentunits VALUES (548, 1);
INSERT INTO public.incidentunits VALUES (548, 5);
INSERT INTO public.incidentunits VALUES (549, 6);
INSERT INTO public.incidentunits VALUES (550, 6);
INSERT INTO public.incidentunits VALUES (551, 7);
INSERT INTO public.incidentunits VALUES (552, 121);
INSERT INTO public.incidentunits VALUES (552, 4);
INSERT INTO public.incidentunits VALUES (552, 6);
INSERT INTO public.incidentunits VALUES (552, 2);
INSERT INTO public.incidentunits VALUES (553, 3);
INSERT INTO public.incidentunits VALUES (553, 12);
INSERT INTO public.incidentunits VALUES (554, 6);
INSERT INTO public.incidentunits VALUES (555, 121);
INSERT INTO public.incidentunits VALUES (555, 7);
INSERT INTO public.incidentunits VALUES (555, 1);
INSERT INTO public.incidentunits VALUES (555, 5);
INSERT INTO public.incidentunits VALUES (556, 121);
INSERT INTO public.incidentunits VALUES (556, 6);
INSERT INTO public.incidentunits VALUES (556, 4);
INSERT INTO public.incidentunits VALUES (556, 10);
INSERT INTO public.incidentunits VALUES (557, 1);
INSERT INTO public.incidentunits VALUES (558, 3);
INSERT INTO public.incidentunits VALUES (559, 121);
INSERT INTO public.incidentunits VALUES (559, 6);
INSERT INTO public.incidentunits VALUES (559, 4);
INSERT INTO public.incidentunits VALUES (559, 2);
INSERT INTO public.incidentunits VALUES (560, 121);
INSERT INTO public.incidentunits VALUES (560, 6);
INSERT INTO public.incidentunits VALUES (560, 1);
INSERT INTO public.incidentunits VALUES (560, 10);
INSERT INTO public.incidentunits VALUES (561, 121);
INSERT INTO public.incidentunits VALUES (561, 1);
INSERT INTO public.incidentunits VALUES (561, 7);
INSERT INTO public.incidentunits VALUES (561, 5);
INSERT INTO public.incidentunits VALUES (562, 121);
INSERT INTO public.incidentunits VALUES (562, 6);
INSERT INTO public.incidentunits VALUES (562, 4);
INSERT INTO public.incidentunits VALUES (562, 10);
INSERT INTO public.incidentunits VALUES (563, 121);
INSERT INTO public.incidentunits VALUES (563, 6);
INSERT INTO public.incidentunits VALUES (563, 4);
INSERT INTO public.incidentunits VALUES (563, 2);
INSERT INTO public.incidentunits VALUES (564, 121);
INSERT INTO public.incidentunits VALUES (564, 6);
INSERT INTO public.incidentunits VALUES (564, 7);
INSERT INTO public.incidentunits VALUES (564, 2);
INSERT INTO public.incidentunits VALUES (565, 4);
INSERT INTO public.incidentunits VALUES (566, 1);
INSERT INTO public.incidentunits VALUES (567, 121);
INSERT INTO public.incidentunits VALUES (567, 3);
INSERT INTO public.incidentunits VALUES (567, 1);
INSERT INTO public.incidentunits VALUES (567, 5);
INSERT INTO public.incidentunits VALUES (568, 7);
INSERT INTO public.incidentunits VALUES (569, 6);
INSERT INTO public.incidentunits VALUES (570, 4);
INSERT INTO public.incidentunits VALUES (570, 2);
INSERT INTO public.incidentunits VALUES (571, 3);
INSERT INTO public.incidentunits VALUES (572, 1);
INSERT INTO public.incidentunits VALUES (573, 4);
INSERT INTO public.incidentunits VALUES (574, 4);
INSERT INTO public.incidentunits VALUES (574, 2);
INSERT INTO public.incidentunits VALUES (575, 1);
INSERT INTO public.incidentunits VALUES (576, 4);
INSERT INTO public.incidentunits VALUES (577, 6);
INSERT INTO public.incidentunits VALUES (578, 121);
INSERT INTO public.incidentunits VALUES (578, 6);
INSERT INTO public.incidentunits VALUES (578, 4);
INSERT INTO public.incidentunits VALUES (578, 2);
INSERT INTO public.incidentunits VALUES (579, 7);
INSERT INTO public.incidentunits VALUES (580, 4);
INSERT INTO public.incidentunits VALUES (581, 121);
INSERT INTO public.incidentunits VALUES (581, 6);
INSERT INTO public.incidentunits VALUES (581, 7);
INSERT INTO public.incidentunits VALUES (581, 2);
INSERT INTO public.incidentunits VALUES (582, 1);
INSERT INTO public.incidentunits VALUES (583, 1);
INSERT INTO public.incidentunits VALUES (584, 121);
INSERT INTO public.incidentunits VALUES (584, 4);
INSERT INTO public.incidentunits VALUES (584, 6);
INSERT INTO public.incidentunits VALUES (584, 10);
INSERT INTO public.incidentunits VALUES (585, 121);
INSERT INTO public.incidentunits VALUES (585, 4);
INSERT INTO public.incidentunits VALUES (585, 6);
INSERT INTO public.incidentunits VALUES (585, 10);
INSERT INTO public.incidentunits VALUES (586, 1);
INSERT INTO public.incidentunits VALUES (586, 12);
INSERT INTO public.incidentunits VALUES (587, 121);
INSERT INTO public.incidentunits VALUES (587, 7);
INSERT INTO public.incidentunits VALUES (587, 6);
INSERT INTO public.incidentunits VALUES (587, 2);
INSERT INTO public.incidentunits VALUES (588, 1);
INSERT INTO public.incidentunits VALUES (589, 7);
INSERT INTO public.incidentunits VALUES (590, 1);
INSERT INTO public.incidentunits VALUES (591, 121);
INSERT INTO public.incidentunits VALUES (591, 1);
INSERT INTO public.incidentunits VALUES (591, 3);
INSERT INTO public.incidentunits VALUES (591, 5);
INSERT INTO public.incidentunits VALUES (592, 121);
INSERT INTO public.incidentunits VALUES (592, 4);
INSERT INTO public.incidentunits VALUES (592, 6);
INSERT INTO public.incidentunits VALUES (592, 10);
INSERT INTO public.incidentunits VALUES (593, 7);
INSERT INTO public.incidentunits VALUES (594, 1);
INSERT INTO public.incidentunits VALUES (595, 1);
INSERT INTO public.incidentunits VALUES (596, 6);
INSERT INTO public.incidentunits VALUES (597, 6);
INSERT INTO public.incidentunits VALUES (597, 2);
INSERT INTO public.incidentunits VALUES (598, 6);
INSERT INTO public.incidentunits VALUES (599, 1);
INSERT INTO public.incidentunits VALUES (600, 4);
INSERT INTO public.incidentunits VALUES (600, 2);
INSERT INTO public.incidentunits VALUES (601, 7);
INSERT INTO public.incidentunits VALUES (602, 6);
INSERT INTO public.incidentunits VALUES (603, 4);
INSERT INTO public.incidentunits VALUES (604, 3);
INSERT INTO public.incidentunits VALUES (605, 1);
INSERT INTO public.incidentunits VALUES (606, 1);
INSERT INTO public.incidentunits VALUES (607, 121);
INSERT INTO public.incidentunits VALUES (607, 6);
INSERT INTO public.incidentunits VALUES (607, 4);
INSERT INTO public.incidentunits VALUES (607, 10);
INSERT INTO public.incidentunits VALUES (608, 121);
INSERT INTO public.incidentunits VALUES (608, 1);
INSERT INTO public.incidentunits VALUES (608, 7);
INSERT INTO public.incidentunits VALUES (608, 3);
INSERT INTO public.incidentunits VALUES (608, 5);
INSERT INTO public.incidentunits VALUES (609, 121);
INSERT INTO public.incidentunits VALUES (609, 7);
INSERT INTO public.incidentunits VALUES (609, 3);
INSERT INTO public.incidentunits VALUES (609, 2);
INSERT INTO public.incidentunits VALUES (610, 121);
INSERT INTO public.incidentunits VALUES (610, 7);
INSERT INTO public.incidentunits VALUES (610, 3);
INSERT INTO public.incidentunits VALUES (610, 2);
INSERT INTO public.incidentunits VALUES (623, 121);
INSERT INTO public.incidentunits VALUES (623, 1);
INSERT INTO public.incidentunits VALUES (623, 7);
INSERT INTO public.incidentunits VALUES (623, 5);
INSERT INTO public.incidentunits VALUES (624, 7);
INSERT INTO public.incidentunits VALUES (625, 121);
INSERT INTO public.incidentunits VALUES (625, 7);
INSERT INTO public.incidentunits VALUES (625, 1);
INSERT INTO public.incidentunits VALUES (625, 5);
INSERT INTO public.incidentunits VALUES (626, 4);
INSERT INTO public.incidentunits VALUES (627, 7);
INSERT INTO public.incidentunits VALUES (628, 1);
INSERT INTO public.incidentunits VALUES (629, 121);
INSERT INTO public.incidentunits VALUES (629, 1);
INSERT INTO public.incidentunits VALUES (629, 3);
INSERT INTO public.incidentunits VALUES (629, 5);
INSERT INTO public.incidentunits VALUES (630, 15);
INSERT INTO public.incidentunits VALUES (630, 121);
INSERT INTO public.incidentunits VALUES (630, 4);
INSERT INTO public.incidentunits VALUES (630, 6);
INSERT INTO public.incidentunits VALUES (630, 1);
INSERT INTO public.incidentunits VALUES (630, 2);
INSERT INTO public.incidentunits VALUES (630, 5);
INSERT INTO public.incidentunits VALUES (631, 4);
INSERT INTO public.incidentunits VALUES (631, 6);
INSERT INTO public.incidentunits VALUES (631, 14);
INSERT INTO public.incidentunits VALUES (632, 7);
INSERT INTO public.incidentunits VALUES (632, 2);
INSERT INTO public.incidentunits VALUES (633, 121);
INSERT INTO public.incidentunits VALUES (633, 3);
INSERT INTO public.incidentunits VALUES (633, 1);
INSERT INTO public.incidentunits VALUES (633, 5);
INSERT INTO public.incidentunits VALUES (634, 121);
INSERT INTO public.incidentunits VALUES (634, 4);
INSERT INTO public.incidentunits VALUES (634, 6);
INSERT INTO public.incidentunits VALUES (634, 2);
INSERT INTO public.incidentunits VALUES (635, 6);
INSERT INTO public.incidentunits VALUES (635, 2);
INSERT INTO public.incidentunits VALUES (636, 6);
INSERT INTO public.incidentunits VALUES (637, 1);
INSERT INTO public.incidentunits VALUES (638, 1);
INSERT INTO public.incidentunits VALUES (640, 7);
INSERT INTO public.incidentunits VALUES (640, 12);
INSERT INTO public.incidentunits VALUES (639, 1);
INSERT INTO public.incidentunits VALUES (641, 1);
INSERT INTO public.incidentunits VALUES (642, 4);
INSERT INTO public.incidentunits VALUES (643, 121);
INSERT INTO public.incidentunits VALUES (643, 6);
INSERT INTO public.incidentunits VALUES (643, 4);
INSERT INTO public.incidentunits VALUES (643, 10);
INSERT INTO public.incidentunits VALUES (644, 1);
INSERT INTO public.incidentunits VALUES (645, 7);
INSERT INTO public.incidentunits VALUES (646, 1);
INSERT INTO public.incidentunits VALUES (647, 121);
INSERT INTO public.incidentunits VALUES (647, 4);
INSERT INTO public.incidentunits VALUES (647, 7);
INSERT INTO public.incidentunits VALUES (647, 5);
INSERT INTO public.incidentunits VALUES (648, 7);
INSERT INTO public.incidentunits VALUES (648, 6);
INSERT INTO public.incidentunits VALUES (648, 2);
INSERT INTO public.incidentunits VALUES (649, 121);
INSERT INTO public.incidentunits VALUES (649, 3);
INSERT INTO public.incidentunits VALUES (649, 2);
INSERT INTO public.incidentunits VALUES (649, 5);
INSERT INTO public.incidentunits VALUES (650, 6);
INSERT INTO public.incidentunits VALUES (651, 121);
INSERT INTO public.incidentunits VALUES (651, 6);
INSERT INTO public.incidentunits VALUES (651, 4);
INSERT INTO public.incidentunits VALUES (651, 10);


--
-- TOC entry 4967 (class 0 OID 24953)
-- Dependencies: 228
-- Data for Name: shifts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shifts VALUES (1, 2, '2025-04-10', 24);
INSERT INTO public.shifts VALUES (2, 5, '2025-04-10', 24);
INSERT INTO public.shifts VALUES (3, 8, '2025-04-10', 24);
INSERT INTO public.shifts VALUES (4, 11, '2025-04-10', 24);
INSERT INTO public.shifts VALUES (5, 14, '2025-04-10', 24);
INSERT INTO public.shifts VALUES (6, 3, '2025-04-11', 24);
INSERT INTO public.shifts VALUES (7, 6, '2025-04-11', 24);
INSERT INTO public.shifts VALUES (8, 9, '2025-04-11', 24);
INSERT INTO public.shifts VALUES (9, 12, '2025-04-11', 24);
INSERT INTO public.shifts VALUES (10, 15, '2025-04-11', 24);
INSERT INTO public.shifts VALUES (11, 1, '2025-04-12', 24);
INSERT INTO public.shifts VALUES (12, 4, '2025-04-12', 24);
INSERT INTO public.shifts VALUES (13, 7, '2025-04-12', 24);
INSERT INTO public.shifts VALUES (14, 10, '2025-04-12', 24);
INSERT INTO public.shifts VALUES (15, 13, '2025-04-12', 24);
INSERT INTO public.shifts VALUES (16, 2, '2025-04-13', 24);
INSERT INTO public.shifts VALUES (17, 5, '2025-04-13', 24);
INSERT INTO public.shifts VALUES (18, 8, '2025-04-13', 24);
INSERT INTO public.shifts VALUES (19, 11, '2025-04-13', 24);
INSERT INTO public.shifts VALUES (20, 14, '2025-04-13', 24);
INSERT INTO public.shifts VALUES (21, 3, '2025-04-14', 24);
INSERT INTO public.shifts VALUES (22, 6, '2025-04-14', 24);
INSERT INTO public.shifts VALUES (23, 9, '2025-04-14', 24);
INSERT INTO public.shifts VALUES (24, 12, '2025-04-14', 24);
INSERT INTO public.shifts VALUES (25, 15, '2025-04-14', 24);
INSERT INTO public.shifts VALUES (26, 1, '2025-04-15', 24);
INSERT INTO public.shifts VALUES (27, 4, '2025-04-15', 24);
INSERT INTO public.shifts VALUES (28, 7, '2025-04-15', 24);
INSERT INTO public.shifts VALUES (29, 10, '2025-04-15', 24);
INSERT INTO public.shifts VALUES (30, 13, '2025-04-15', 24);
INSERT INTO public.shifts VALUES (31, 2, '2025-04-16', 24);
INSERT INTO public.shifts VALUES (32, 5, '2025-04-16', 24);
INSERT INTO public.shifts VALUES (33, 8, '2025-04-16', 24);
INSERT INTO public.shifts VALUES (34, 11, '2025-04-16', 24);
INSERT INTO public.shifts VALUES (35, 14, '2025-04-16', 24);
INSERT INTO public.shifts VALUES (36, 3, '2025-04-17', 24);
INSERT INTO public.shifts VALUES (37, 6, '2025-04-17', 24);
INSERT INTO public.shifts VALUES (38, 9, '2025-04-17', 24);
INSERT INTO public.shifts VALUES (39, 12, '2025-04-17', 24);
INSERT INTO public.shifts VALUES (40, 15, '2025-04-17', 24);
INSERT INTO public.shifts VALUES (41, 1, '2025-04-18', 24);
INSERT INTO public.shifts VALUES (42, 4, '2025-04-18', 24);
INSERT INTO public.shifts VALUES (43, 7, '2025-04-18', 24);
INSERT INTO public.shifts VALUES (44, 10, '2025-04-18', 24);
INSERT INTO public.shifts VALUES (45, 13, '2025-04-18', 24);
INSERT INTO public.shifts VALUES (46, 2, '2025-04-19', 24);
INSERT INTO public.shifts VALUES (47, 5, '2025-04-19', 24);
INSERT INTO public.shifts VALUES (48, 8, '2025-04-19', 24);
INSERT INTO public.shifts VALUES (49, 11, '2025-04-19', 24);
INSERT INTO public.shifts VALUES (50, 14, '2025-04-19', 24);
INSERT INTO public.shifts VALUES (51, 3, '2025-04-20', 24);
INSERT INTO public.shifts VALUES (52, 6, '2025-04-20', 24);
INSERT INTO public.shifts VALUES (53, 9, '2025-04-20', 24);
INSERT INTO public.shifts VALUES (54, 12, '2025-04-20', 24);
INSERT INTO public.shifts VALUES (55, 15, '2025-04-20', 24);
INSERT INTO public.shifts VALUES (56, 1, '2025-04-21', 24);
INSERT INTO public.shifts VALUES (57, 4, '2025-04-21', 24);
INSERT INTO public.shifts VALUES (58, 7, '2025-04-21', 24);
INSERT INTO public.shifts VALUES (59, 10, '2025-04-21', 24);
INSERT INTO public.shifts VALUES (60, 13, '2025-04-21', 24);
INSERT INTO public.shifts VALUES (61, 2, '2025-04-22', 24);
INSERT INTO public.shifts VALUES (62, 5, '2025-04-22', 24);
INSERT INTO public.shifts VALUES (63, 8, '2025-04-22', 24);
INSERT INTO public.shifts VALUES (64, 11, '2025-04-22', 24);
INSERT INTO public.shifts VALUES (65, 14, '2025-04-22', 24);
INSERT INTO public.shifts VALUES (66, 3, '2025-04-23', 24);
INSERT INTO public.shifts VALUES (67, 6, '2025-04-23', 24);
INSERT INTO public.shifts VALUES (68, 9, '2025-04-23', 24);
INSERT INTO public.shifts VALUES (69, 12, '2025-04-23', 24);
INSERT INTO public.shifts VALUES (70, 15, '2025-04-23', 24);
INSERT INTO public.shifts VALUES (71, 1, '2025-04-24', 24);
INSERT INTO public.shifts VALUES (72, 4, '2025-04-24', 24);
INSERT INTO public.shifts VALUES (73, 7, '2025-04-24', 24);
INSERT INTO public.shifts VALUES (74, 10, '2025-04-24', 24);
INSERT INTO public.shifts VALUES (75, 13, '2025-04-24', 24);
INSERT INTO public.shifts VALUES (76, 2, '2025-04-25', 24);
INSERT INTO public.shifts VALUES (77, 5, '2025-04-25', 24);
INSERT INTO public.shifts VALUES (78, 8, '2025-04-25', 24);
INSERT INTO public.shifts VALUES (79, 11, '2025-04-25', 24);
INSERT INTO public.shifts VALUES (80, 14, '2025-04-25', 24);
INSERT INTO public.shifts VALUES (81, 3, '2025-04-26', 24);
INSERT INTO public.shifts VALUES (82, 6, '2025-04-26', 24);
INSERT INTO public.shifts VALUES (83, 9, '2025-04-26', 24);
INSERT INTO public.shifts VALUES (84, 12, '2025-04-26', 24);
INSERT INTO public.shifts VALUES (85, 15, '2025-04-26', 24);
INSERT INTO public.shifts VALUES (86, 1, '2025-04-27', 24);
INSERT INTO public.shifts VALUES (87, 4, '2025-04-27', 24);
INSERT INTO public.shifts VALUES (88, 7, '2025-04-27', 24);
INSERT INTO public.shifts VALUES (89, 10, '2025-04-27', 24);
INSERT INTO public.shifts VALUES (90, 13, '2025-04-27', 24);
INSERT INTO public.shifts VALUES (91, 2, '2025-04-28', 24);
INSERT INTO public.shifts VALUES (92, 5, '2025-04-28', 24);
INSERT INTO public.shifts VALUES (93, 8, '2025-04-28', 24);
INSERT INTO public.shifts VALUES (94, 11, '2025-04-28', 24);
INSERT INTO public.shifts VALUES (95, 14, '2025-04-28', 24);
INSERT INTO public.shifts VALUES (96, 3, '2025-04-29', 24);
INSERT INTO public.shifts VALUES (97, 6, '2025-04-29', 24);
INSERT INTO public.shifts VALUES (98, 9, '2025-04-29', 24);
INSERT INTO public.shifts VALUES (99, 12, '2025-04-29', 24);
INSERT INTO public.shifts VALUES (100, 15, '2025-04-29', 24);
INSERT INTO public.shifts VALUES (101, 1, '2025-04-30', 24);
INSERT INTO public.shifts VALUES (102, 4, '2025-04-30', 24);
INSERT INTO public.shifts VALUES (103, 7, '2025-04-30', 24);
INSERT INTO public.shifts VALUES (104, 10, '2025-04-30', 24);
INSERT INTO public.shifts VALUES (105, 13, '2025-04-30', 24);
INSERT INTO public.shifts VALUES (106, 2, '2025-05-01', 24);
INSERT INTO public.shifts VALUES (107, 5, '2025-05-01', 24);
INSERT INTO public.shifts VALUES (108, 8, '2025-05-01', 24);
INSERT INTO public.shifts VALUES (109, 11, '2025-05-01', 24);
INSERT INTO public.shifts VALUES (110, 14, '2025-05-01', 24);
INSERT INTO public.shifts VALUES (111, 3, '2025-05-02', 24);
INSERT INTO public.shifts VALUES (112, 6, '2025-05-02', 24);
INSERT INTO public.shifts VALUES (113, 9, '2025-05-02', 24);
INSERT INTO public.shifts VALUES (114, 12, '2025-05-02', 24);
INSERT INTO public.shifts VALUES (115, 15, '2025-05-02', 24);
INSERT INTO public.shifts VALUES (116, 1, '2025-05-03', 24);
INSERT INTO public.shifts VALUES (117, 4, '2025-05-03', 24);
INSERT INTO public.shifts VALUES (118, 7, '2025-05-03', 24);
INSERT INTO public.shifts VALUES (119, 10, '2025-05-03', 24);
INSERT INTO public.shifts VALUES (120, 13, '2025-05-03', 24);
INSERT INTO public.shifts VALUES (121, 2, '2025-05-04', 24);
INSERT INTO public.shifts VALUES (122, 5, '2025-05-04', 24);
INSERT INTO public.shifts VALUES (123, 8, '2025-05-04', 24);
INSERT INTO public.shifts VALUES (124, 11, '2025-05-04', 24);
INSERT INTO public.shifts VALUES (125, 14, '2025-05-04', 24);
INSERT INTO public.shifts VALUES (126, 3, '2025-05-05', 24);
INSERT INTO public.shifts VALUES (127, 6, '2025-05-05', 24);
INSERT INTO public.shifts VALUES (128, 9, '2025-05-05', 24);
INSERT INTO public.shifts VALUES (129, 12, '2025-05-05', 24);
INSERT INTO public.shifts VALUES (130, 15, '2025-05-05', 24);
INSERT INTO public.shifts VALUES (131, 1, '2025-05-06', 24);
INSERT INTO public.shifts VALUES (132, 4, '2025-05-06', 24);
INSERT INTO public.shifts VALUES (133, 7, '2025-05-06', 24);
INSERT INTO public.shifts VALUES (134, 10, '2025-05-06', 24);
INSERT INTO public.shifts VALUES (135, 13, '2025-05-06', 24);
INSERT INTO public.shifts VALUES (136, 2, '2025-05-07', 24);
INSERT INTO public.shifts VALUES (137, 5, '2025-05-07', 24);
INSERT INTO public.shifts VALUES (138, 8, '2025-05-07', 24);
INSERT INTO public.shifts VALUES (139, 11, '2025-05-07', 24);
INSERT INTO public.shifts VALUES (140, 14, '2025-05-07', 24);
INSERT INTO public.shifts VALUES (141, 3, '2025-05-08', 24);
INSERT INTO public.shifts VALUES (142, 6, '2025-05-08', 24);
INSERT INTO public.shifts VALUES (143, 9, '2025-05-08', 24);
INSERT INTO public.shifts VALUES (144, 12, '2025-05-08', 24);
INSERT INTO public.shifts VALUES (145, 15, '2025-05-09', 24);
INSERT INTO public.shifts VALUES (146, 1, '2025-05-09', 24);
INSERT INTO public.shifts VALUES (147, 4, '2025-05-09', 24);
INSERT INTO public.shifts VALUES (148, 7, '2025-05-09', 24);
INSERT INTO public.shifts VALUES (149, 10, '2025-05-09', 24);
INSERT INTO public.shifts VALUES (150, 13, '2025-05-09', 24);
INSERT INTO public.shifts VALUES (151, 2, '2025-05-10', 24);
INSERT INTO public.shifts VALUES (152, 5, '2025-05-10', 24);
INSERT INTO public.shifts VALUES (153, 8, '2025-05-10', 24);
INSERT INTO public.shifts VALUES (154, 11, '2025-05-10', 24);
INSERT INTO public.shifts VALUES (155, 14, '2025-05-10', 24);
INSERT INTO public.shifts VALUES (156, 3, '2025-05-11', 24);
INSERT INTO public.shifts VALUES (157, 6, '2025-05-11', 24);
INSERT INTO public.shifts VALUES (158, 9, '2025-05-11', 24);
INSERT INTO public.shifts VALUES (159, 12, '2025-05-11', 24);
INSERT INTO public.shifts VALUES (160, 15, '2025-05-11', 24);
INSERT INTO public.shifts VALUES (161, 1, '2025-05-12', 24);
INSERT INTO public.shifts VALUES (162, 4, '2025-05-12', 24);
INSERT INTO public.shifts VALUES (163, 7, '2025-05-12', 24);
INSERT INTO public.shifts VALUES (164, 10, '2025-05-12', 24);
INSERT INTO public.shifts VALUES (165, 13, '2025-05-12', 24);
INSERT INTO public.shifts VALUES (166, 2, '2025-05-13', 24);
INSERT INTO public.shifts VALUES (167, 5, '2025-05-13', 24);
INSERT INTO public.shifts VALUES (168, 8, '2025-05-13', 24);
INSERT INTO public.shifts VALUES (169, 11, '2025-05-13', 24);
INSERT INTO public.shifts VALUES (170, 14, '2025-05-13', 24);
INSERT INTO public.shifts VALUES (171, 3, '2025-05-14', 24);
INSERT INTO public.shifts VALUES (172, 6, '2025-05-14', 24);
INSERT INTO public.shifts VALUES (173, 9, '2025-05-14', 24);
INSERT INTO public.shifts VALUES (174, 12, '2025-05-14', 24);
INSERT INTO public.shifts VALUES (175, 15, '2025-05-14', 24);
INSERT INTO public.shifts VALUES (176, 1, '2025-05-15', 24);
INSERT INTO public.shifts VALUES (177, 4, '2025-05-15', 24);
INSERT INTO public.shifts VALUES (178, 7, '2025-05-15', 24);
INSERT INTO public.shifts VALUES (179, 10, '2025-05-15', 24);
INSERT INTO public.shifts VALUES (180, 13, '2025-05-15', 24);
INSERT INTO public.shifts VALUES (181, 2, '2025-05-16', 24);
INSERT INTO public.shifts VALUES (182, 5, '2025-05-16', 24);
INSERT INTO public.shifts VALUES (183, 8, '2025-05-16', 24);
INSERT INTO public.shifts VALUES (184, 11, '2025-05-16', 24);
INSERT INTO public.shifts VALUES (185, 14, '2025-05-16', 24);
INSERT INTO public.shifts VALUES (186, 3, '2025-05-17', 24);
INSERT INTO public.shifts VALUES (187, 6, '2025-05-17', 24);
INSERT INTO public.shifts VALUES (188, 9, '2025-05-17', 24);
INSERT INTO public.shifts VALUES (189, 12, '2025-05-17', 24);
INSERT INTO public.shifts VALUES (190, 15, '2025-05-17', 24);
INSERT INTO public.shifts VALUES (191, 1, '2025-05-18', 24);
INSERT INTO public.shifts VALUES (192, 4, '2025-05-18', 24);
INSERT INTO public.shifts VALUES (193, 7, '2025-05-18', 24);
INSERT INTO public.shifts VALUES (194, 10, '2025-05-18', 24);
INSERT INTO public.shifts VALUES (195, 13, '2025-05-18', 24);
INSERT INTO public.shifts VALUES (196, 2, '2025-05-19', 24);
INSERT INTO public.shifts VALUES (197, 5, '2025-05-19', 24);
INSERT INTO public.shifts VALUES (198, 8, '2025-05-19', 24);
INSERT INTO public.shifts VALUES (199, 11, '2025-05-19', 24);
INSERT INTO public.shifts VALUES (200, 14, '2025-05-19', 24);
INSERT INTO public.shifts VALUES (201, 3, '2025-05-20', 24);
INSERT INTO public.shifts VALUES (202, 6, '2025-05-20', 24);
INSERT INTO public.shifts VALUES (203, 9, '2025-05-20', 24);
INSERT INTO public.shifts VALUES (204, 12, '2025-05-20', 24);
INSERT INTO public.shifts VALUES (205, 15, '2025-05-20', 24);
INSERT INTO public.shifts VALUES (206, 1, '2025-05-21', 24);
INSERT INTO public.shifts VALUES (207, 4, '2025-05-21', 24);
INSERT INTO public.shifts VALUES (208, 7, '2025-05-21', 24);
INSERT INTO public.shifts VALUES (209, 10, '2025-05-21', 24);
INSERT INTO public.shifts VALUES (210, 13, '2025-05-21', 24);
INSERT INTO public.shifts VALUES (211, 2, '2025-05-22', 24);
INSERT INTO public.shifts VALUES (212, 5, '2025-05-22', 24);
INSERT INTO public.shifts VALUES (213, 8, '2025-05-22', 24);
INSERT INTO public.shifts VALUES (214, 11, '2025-05-22', 24);
INSERT INTO public.shifts VALUES (215, 14, '2025-05-22', 24);
INSERT INTO public.shifts VALUES (216, 3, '2025-05-23', 24);
INSERT INTO public.shifts VALUES (217, 6, '2025-05-23', 24);
INSERT INTO public.shifts VALUES (218, 9, '2025-05-23', 24);
INSERT INTO public.shifts VALUES (219, 12, '2025-05-23', 24);
INSERT INTO public.shifts VALUES (220, 15, '2025-05-23', 24);
INSERT INTO public.shifts VALUES (221, 1, '2025-05-24', 24);
INSERT INTO public.shifts VALUES (222, 4, '2025-05-24', 24);
INSERT INTO public.shifts VALUES (223, 7, '2025-05-24', 24);
INSERT INTO public.shifts VALUES (224, 10, '2025-05-24', 24);
INSERT INTO public.shifts VALUES (225, 13, '2025-05-24', 24);
INSERT INTO public.shifts VALUES (226, 2, '2025-05-25', 24);
INSERT INTO public.shifts VALUES (227, 5, '2025-05-25', 24);
INSERT INTO public.shifts VALUES (228, 8, '2025-05-25', 24);
INSERT INTO public.shifts VALUES (229, 11, '2025-05-25', 24);
INSERT INTO public.shifts VALUES (230, 14, '2025-05-25', 24);
INSERT INTO public.shifts VALUES (231, 3, '2025-05-26', 24);
INSERT INTO public.shifts VALUES (232, 6, '2025-05-26', 24);
INSERT INTO public.shifts VALUES (233, 9, '2025-05-26', 24);
INSERT INTO public.shifts VALUES (234, 12, '2025-05-26', 24);
INSERT INTO public.shifts VALUES (235, 15, '2025-05-26', 24);
INSERT INTO public.shifts VALUES (236, 1, '2025-05-27', 24);
INSERT INTO public.shifts VALUES (237, 4, '2025-05-27', 24);
INSERT INTO public.shifts VALUES (238, 7, '2025-05-27', 24);
INSERT INTO public.shifts VALUES (239, 10, '2025-05-27', 24);
INSERT INTO public.shifts VALUES (240, 13, '2025-05-27', 24);
INSERT INTO public.shifts VALUES (241, 2, '2025-05-28', 24);
INSERT INTO public.shifts VALUES (242, 5, '2025-05-28', 24);
INSERT INTO public.shifts VALUES (243, 8, '2025-05-28', 24);
INSERT INTO public.shifts VALUES (244, 11, '2025-05-28', 24);
INSERT INTO public.shifts VALUES (245, 14, '2025-05-28', 24);
INSERT INTO public.shifts VALUES (246, 3, '2025-05-29', 24);
INSERT INTO public.shifts VALUES (247, 6, '2025-05-29', 24);
INSERT INTO public.shifts VALUES (248, 9, '2025-05-29', 24);
INSERT INTO public.shifts VALUES (249, 12, '2025-05-29', 24);
INSERT INTO public.shifts VALUES (250, 15, '2025-05-29', 24);
INSERT INTO public.shifts VALUES (251, 1, '2025-05-30', 24);
INSERT INTO public.shifts VALUES (252, 4, '2025-05-30', 24);
INSERT INTO public.shifts VALUES (253, 7, '2025-05-30', 24);
INSERT INTO public.shifts VALUES (254, 10, '2025-05-30', 24);
INSERT INTO public.shifts VALUES (255, 13, '2025-05-30', 24);
INSERT INTO public.shifts VALUES (256, 2, '2025-05-31', 24);
INSERT INTO public.shifts VALUES (257, 5, '2025-05-31', 24);
INSERT INTO public.shifts VALUES (258, 8, '2025-05-31', 24);
INSERT INTO public.shifts VALUES (259, 11, '2025-05-31', 24);
INSERT INTO public.shifts VALUES (260, 14, '2025-05-31', 24);
INSERT INTO public.shifts VALUES (261, 3, '2025-06-01', 24);
INSERT INTO public.shifts VALUES (262, 6, '2025-06-01', 24);
INSERT INTO public.shifts VALUES (263, 9, '2025-06-01', 24);
INSERT INTO public.shifts VALUES (264, 12, '2025-06-01', 24);
INSERT INTO public.shifts VALUES (265, 15, '2025-06-01', 24);
INSERT INTO public.shifts VALUES (266, 1, '2025-06-02', 24);
INSERT INTO public.shifts VALUES (267, 4, '2025-06-02', 24);
INSERT INTO public.shifts VALUES (268, 7, '2025-06-02', 24);
INSERT INTO public.shifts VALUES (269, 10, '2025-06-02', 24);
INSERT INTO public.shifts VALUES (270, 13, '2025-06-02', 24);
INSERT INTO public.shifts VALUES (271, 2, '2025-06-03', 24);
INSERT INTO public.shifts VALUES (272, 5, '2025-06-03', 24);
INSERT INTO public.shifts VALUES (273, 8, '2025-06-03', 24);
INSERT INTO public.shifts VALUES (274, 11, '2025-06-03', 24);
INSERT INTO public.shifts VALUES (275, 14, '2025-06-03', 24);
INSERT INTO public.shifts VALUES (276, 3, '2025-06-04', 24);
INSERT INTO public.shifts VALUES (277, 6, '2025-06-04', 24);
INSERT INTO public.shifts VALUES (278, 9, '2025-06-04', 24);
INSERT INTO public.shifts VALUES (279, 12, '2025-06-04', 24);
INSERT INTO public.shifts VALUES (280, 15, '2025-06-04', 24);
INSERT INTO public.shifts VALUES (281, 1, '2025-06-05', 24);
INSERT INTO public.shifts VALUES (282, 4, '2025-06-05', 24);
INSERT INTO public.shifts VALUES (283, 7, '2025-06-05', 24);
INSERT INTO public.shifts VALUES (284, 10, '2025-06-05', 24);
INSERT INTO public.shifts VALUES (285, 13, '2025-06-05', 24);
INSERT INTO public.shifts VALUES (286, 2, '2025-06-06', 24);
INSERT INTO public.shifts VALUES (287, 5, '2025-06-06', 24);
INSERT INTO public.shifts VALUES (288, 8, '2025-06-06', 24);
INSERT INTO public.shifts VALUES (289, 11, '2025-06-06', 24);
INSERT INTO public.shifts VALUES (290, 14, '2025-06-06', 24);
INSERT INTO public.shifts VALUES (291, 3, '2025-06-07', 24);
INSERT INTO public.shifts VALUES (292, 6, '2025-06-07', 24);
INSERT INTO public.shifts VALUES (293, 9, '2025-06-07', 24);
INSERT INTO public.shifts VALUES (294, 12, '2025-06-07', 24);
INSERT INTO public.shifts VALUES (295, 15, '2025-06-07', 24);
INSERT INTO public.shifts VALUES (296, 1, '2025-06-08', 24);
INSERT INTO public.shifts VALUES (297, 4, '2025-06-08', 24);
INSERT INTO public.shifts VALUES (298, 7, '2025-06-08', 24);
INSERT INTO public.shifts VALUES (299, 10, '2025-06-08', 24);
INSERT INTO public.shifts VALUES (300, 13, '2025-06-08', 24);
INSERT INTO public.shifts VALUES (301, 2, '2025-06-09', 24);
INSERT INTO public.shifts VALUES (302, 5, '2025-06-09', 24);
INSERT INTO public.shifts VALUES (303, 8, '2025-06-09', 24);
INSERT INTO public.shifts VALUES (304, 11, '2025-06-09', 24);
INSERT INTO public.shifts VALUES (305, 14, '2025-06-09', 24);
INSERT INTO public.shifts VALUES (306, 3, '2025-06-10', 24);
INSERT INTO public.shifts VALUES (307, 6, '2025-06-10', 24);
INSERT INTO public.shifts VALUES (308, 9, '2025-06-10', 24);
INSERT INTO public.shifts VALUES (309, 12, '2025-06-10', 24);
INSERT INTO public.shifts VALUES (310, 15, '2025-06-10', 24);
INSERT INTO public.shifts VALUES (311, 1, '2025-06-11', 24);
INSERT INTO public.shifts VALUES (312, 4, '2025-06-11', 24);
INSERT INTO public.shifts VALUES (313, 7, '2025-06-11', 24);
INSERT INTO public.shifts VALUES (314, 10, '2025-06-11', 24);
INSERT INTO public.shifts VALUES (315, 13, '2025-06-11', 24);
INSERT INTO public.shifts VALUES (316, 2, '2025-06-12', 24);
INSERT INTO public.shifts VALUES (317, 5, '2025-06-12', 24);
INSERT INTO public.shifts VALUES (318, 8, '2025-06-12', 24);
INSERT INTO public.shifts VALUES (319, 11, '2025-06-12', 24);
INSERT INTO public.shifts VALUES (320, 14, '2025-06-12', 24);
INSERT INTO public.shifts VALUES (321, 3, '2025-06-13', 24);
INSERT INTO public.shifts VALUES (322, 6, '2025-06-13', 24);
INSERT INTO public.shifts VALUES (323, 9, '2025-06-13', 24);
INSERT INTO public.shifts VALUES (324, 12, '2025-06-13', 24);
INSERT INTO public.shifts VALUES (325, 15, '2025-06-13', 24);
INSERT INTO public.shifts VALUES (326, 1, '2025-06-14', 24);
INSERT INTO public.shifts VALUES (327, 4, '2025-06-14', 24);
INSERT INTO public.shifts VALUES (328, 7, '2025-06-14', 24);
INSERT INTO public.shifts VALUES (329, 10, '2025-06-14', 24);
INSERT INTO public.shifts VALUES (330, 13, '2025-06-14', 24);
INSERT INTO public.shifts VALUES (331, 2, '2025-06-15', 24);
INSERT INTO public.shifts VALUES (332, 5, '2025-06-15', 24);
INSERT INTO public.shifts VALUES (333, 8, '2025-06-15', 24);
INSERT INTO public.shifts VALUES (334, 11, '2025-06-15', 24);
INSERT INTO public.shifts VALUES (335, 14, '2025-06-15', 24);
INSERT INTO public.shifts VALUES (336, 3, '2025-06-16', 24);
INSERT INTO public.shifts VALUES (337, 6, '2025-06-16', 24);
INSERT INTO public.shifts VALUES (338, 9, '2025-06-16', 24);
INSERT INTO public.shifts VALUES (339, 12, '2025-06-16', 24);
INSERT INTO public.shifts VALUES (340, 15, '2025-06-16', 24);
INSERT INTO public.shifts VALUES (341, 1, '2025-06-17', 24);
INSERT INTO public.shifts VALUES (342, 4, '2025-06-17', 24);
INSERT INTO public.shifts VALUES (343, 7, '2025-06-17', 24);
INSERT INTO public.shifts VALUES (344, 10, '2025-06-17', 24);
INSERT INTO public.shifts VALUES (345, 13, '2025-06-17', 24);
INSERT INTO public.shifts VALUES (346, 2, '2025-06-18', 24);
INSERT INTO public.shifts VALUES (347, 5, '2025-06-18', 24);
INSERT INTO public.shifts VALUES (348, 8, '2025-06-18', 24);
INSERT INTO public.shifts VALUES (349, 11, '2025-06-18', 24);
INSERT INTO public.shifts VALUES (350, 14, '2025-06-18', 24);
INSERT INTO public.shifts VALUES (351, 3, '2025-06-19', 24);
INSERT INTO public.shifts VALUES (352, 6, '2025-06-19', 24);
INSERT INTO public.shifts VALUES (353, 9, '2025-06-19', 24);
INSERT INTO public.shifts VALUES (354, 12, '2025-06-19', 24);
INSERT INTO public.shifts VALUES (355, 15, '2025-06-19', 24);
INSERT INTO public.shifts VALUES (356, 1, '2025-06-20', 24);
INSERT INTO public.shifts VALUES (357, 4, '2025-06-20', 24);
INSERT INTO public.shifts VALUES (358, 7, '2025-06-20', 24);
INSERT INTO public.shifts VALUES (359, 10, '2025-06-20', 24);
INSERT INTO public.shifts VALUES (360, 13, '2025-06-20', 24);
INSERT INTO public.shifts VALUES (361, 2, '2025-06-21', 24);
INSERT INTO public.shifts VALUES (362, 5, '2025-06-21', 24);
INSERT INTO public.shifts VALUES (363, 8, '2025-06-21', 24);
INSERT INTO public.shifts VALUES (364, 11, '2025-06-21', 24);
INSERT INTO public.shifts VALUES (365, 14, '2025-06-21', 24);
INSERT INTO public.shifts VALUES (366, 3, '2025-06-22', 24);
INSERT INTO public.shifts VALUES (367, 6, '2025-06-22', 24);
INSERT INTO public.shifts VALUES (368, 9, '2025-06-22', 24);
INSERT INTO public.shifts VALUES (369, 12, '2025-06-22', 24);
INSERT INTO public.shifts VALUES (370, 15, '2025-06-22', 24);
INSERT INTO public.shifts VALUES (371, 1, '2025-06-23', 24);
INSERT INTO public.shifts VALUES (372, 4, '2025-06-23', 24);
INSERT INTO public.shifts VALUES (373, 7, '2025-06-23', 24);
INSERT INTO public.shifts VALUES (374, 10, '2025-06-23', 24);
INSERT INTO public.shifts VALUES (375, 13, '2025-06-23', 24);
INSERT INTO public.shifts VALUES (376, 2, '2025-06-24', 24);
INSERT INTO public.shifts VALUES (377, 5, '2025-06-24', 24);
INSERT INTO public.shifts VALUES (378, 8, '2025-06-24', 24);
INSERT INTO public.shifts VALUES (379, 11, '2025-06-24', 24);
INSERT INTO public.shifts VALUES (380, 14, '2025-06-24', 24);
INSERT INTO public.shifts VALUES (381, 3, '2025-06-25', 24);
INSERT INTO public.shifts VALUES (382, 6, '2025-06-25', 24);
INSERT INTO public.shifts VALUES (383, 9, '2025-06-25', 24);
INSERT INTO public.shifts VALUES (384, 12, '2025-06-25', 24);
INSERT INTO public.shifts VALUES (385, 15, '2025-06-25', 24);
INSERT INTO public.shifts VALUES (386, 1, '2025-06-26', 24);
INSERT INTO public.shifts VALUES (387, 4, '2025-06-26', 24);
INSERT INTO public.shifts VALUES (388, 7, '2025-06-26', 24);
INSERT INTO public.shifts VALUES (389, 10, '2025-06-26', 24);
INSERT INTO public.shifts VALUES (390, 13, '2025-06-26', 24);
INSERT INTO public.shifts VALUES (391, 2, '2025-06-27', 24);
INSERT INTO public.shifts VALUES (392, 5, '2025-06-27', 24);
INSERT INTO public.shifts VALUES (393, 8, '2025-06-27', 24);
INSERT INTO public.shifts VALUES (394, 11, '2025-06-27', 24);
INSERT INTO public.shifts VALUES (395, 14, '2025-06-27', 24);
INSERT INTO public.shifts VALUES (401, 3, '2025-06-28', 24);
INSERT INTO public.shifts VALUES (402, 6, '2025-06-28', 24);
INSERT INTO public.shifts VALUES (403, 9, '2025-06-28', 24);
INSERT INTO public.shifts VALUES (404, 12, '2025-06-28', 24);
INSERT INTO public.shifts VALUES (405, 15, '2025-06-28', 24);
INSERT INTO public.shifts VALUES (406, 1, '2025-06-29', 24);
INSERT INTO public.shifts VALUES (407, 4, '2025-06-29', 24);
INSERT INTO public.shifts VALUES (408, 7, '2025-06-29', 24);
INSERT INTO public.shifts VALUES (409, 10, '2025-06-29', 24);
INSERT INTO public.shifts VALUES (410, 13, '2025-06-29', 24);
INSERT INTO public.shifts VALUES (411, 2, '2025-06-30', 24);
INSERT INTO public.shifts VALUES (412, 5, '2025-06-30', 24);
INSERT INTO public.shifts VALUES (413, 8, '2025-06-30', 24);
INSERT INTO public.shifts VALUES (414, 11, '2025-06-30', 24);
INSERT INTO public.shifts VALUES (415, 14, '2025-06-30', 24);


--
-- TOC entry 4956 (class 0 OID 24811)
-- Dependencies: 217
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.stations VALUES (1, 'Central', '310 Broadway St.');
INSERT INTO public.stations VALUES (3, 'Station 3', '758 Park Ave.');
INSERT INTO public.stations VALUES (4, 'Station 4', '525 Airport Rd.');
INSERT INTO public.stations VALUES (6, 'Station 6', '220 Lakeshore Dr.');
INSERT INTO public.stations VALUES (7, 'Station 7', '1311 Golf Links Rd.');


--
-- TOC entry 4965 (class 0 OID 24941)
-- Dependencies: 226
-- Data for Name: stationshifts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.stationshifts VALUES (1, 1, 'A');
INSERT INTO public.stationshifts VALUES (2, 1, 'B');
INSERT INTO public.stationshifts VALUES (3, 1, 'C');
INSERT INTO public.stationshifts VALUES (4, 3, 'A');
INSERT INTO public.stationshifts VALUES (5, 3, 'B');
INSERT INTO public.stationshifts VALUES (6, 3, 'C');
INSERT INTO public.stationshifts VALUES (7, 4, 'A');
INSERT INTO public.stationshifts VALUES (8, 4, 'B');
INSERT INTO public.stationshifts VALUES (9, 4, 'C');
INSERT INTO public.stationshifts VALUES (10, 6, 'A');
INSERT INTO public.stationshifts VALUES (11, 6, 'B');
INSERT INTO public.stationshifts VALUES (12, 6, 'C');
INSERT INTO public.stationshifts VALUES (13, 7, 'A');
INSERT INTO public.stationshifts VALUES (14, 7, 'B');
INSERT INTO public.stationshifts VALUES (15, 7, 'C');


--
-- TOC entry 4957 (class 0 OID 24816)
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
INSERT INTO public.units VALUES (14, 'Brush Truck 14', 'Brush', 1);
INSERT INTO public.units VALUES (401, '401', 'Command', 1);
INSERT INTO public.units VALUES (402, '402', 'Command', 1);
INSERT INTO public.units VALUES (301, '301', 'Command', 1);
INSERT INTO public.units VALUES (302, '302', 'Command', 1);
INSERT INTO public.units VALUES (2, 'Rescue 2', 'Rescue', 6);
INSERT INTO public.units VALUES (15, 'Redball 3', 'Aircraft', 4);


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 219
-- Name: firefighters_firefighter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.firefighters_firefighter_id_seq', 76, true);


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 222
-- Name: incidents_incident_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incidents_incident_id_seq', 651, true);


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 227
-- Name: shifts_shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shifts_shift_id_seq', 415, true);


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 225
-- Name: stationshifts_station_shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stationshifts_station_shift_id_seq', 15, true);


--
-- TOC entry 4788 (class 2606 OID 24835)
-- Name: firefighters firefighters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_pkey PRIMARY KEY (firefighter_id);


--
-- TOC entry 4790 (class 2606 OID 24932)
-- Name: firefightershifts firefightershifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefightershifts
    ADD CONSTRAINT firefightershifts_pkey PRIMARY KEY (firefighter_id, station_shift_id, start_time);


--
-- TOC entry 4792 (class 2606 OID 24884)
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (incident_id);


--
-- TOC entry 4796 (class 2606 OID 24895)
-- Name: incidentunits incidentunits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_pkey PRIMARY KEY (incident_id, unit_id);


--
-- TOC entry 4800 (class 2606 OID 24958)
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (shift_id);


--
-- TOC entry 4784 (class 2606 OID 24815)
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (station_id);


--
-- TOC entry 4798 (class 2606 OID 24946)
-- Name: stationshifts stationshifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stationshifts
    ADD CONSTRAINT stationshifts_pkey PRIMARY KEY (station_shift_id);


--
-- TOC entry 4786 (class 2606 OID 24821)
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (unit_id);


--
-- TOC entry 4793 (class 1259 OID 24913)
-- Name: idx_incidentunits_incident_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incidentunits_incident_id ON public.incidentunits USING btree (incident_id);


--
-- TOC entry 4794 (class 1259 OID 24914)
-- Name: idx_incidentunits_unit_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incidentunits_unit_id ON public.incidentunits USING btree (unit_id);


--
-- TOC entry 4802 (class 2606 OID 24836)
-- Name: firefighters firefighters_station_assignment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_station_assignment_fkey FOREIGN KEY (station_assignment) REFERENCES public.stations(station_id);


--
-- TOC entry 4803 (class 2606 OID 24906)
-- Name: firefighters firefighters_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(unit_id);


--
-- TOC entry 4804 (class 2606 OID 24859)
-- Name: firefightershifts firefightershifts_firefighter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firefightershifts
    ADD CONSTRAINT firefightershifts_firefighter_id_fkey FOREIGN KEY (firefighter_id) REFERENCES public.firefighters(firefighter_id);


--
-- TOC entry 4805 (class 2606 OID 24964)
-- Name: incidents incidents_shift_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES public.shifts(shift_id);


--
-- TOC entry 4806 (class 2606 OID 24885)
-- Name: incidents incidents_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);


--
-- TOC entry 4807 (class 2606 OID 24896)
-- Name: incidentunits incidentunits_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(incident_id);


--
-- TOC entry 4808 (class 2606 OID 24901)
-- Name: incidentunits incidentunits_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(unit_id);


--
-- TOC entry 4810 (class 2606 OID 24959)
-- Name: shifts shifts_station_shift_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_station_shift_id_fkey FOREIGN KEY (station_shift_id) REFERENCES public.stationshifts(station_shift_id);


--
-- TOC entry 4809 (class 2606 OID 24947)
-- Name: stationshifts stationshifts_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stationshifts
    ADD CONSTRAINT stationshifts_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);


--
-- TOC entry 4801 (class 2606 OID 24822)
-- Name: units units_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);


-- Completed on 2025-06-30 15:15:04

--
-- PostgreSQL database dump complete
--

