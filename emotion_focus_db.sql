--
-- PostgreSQL database dump
--

-- Dumped from database version 10.23
-- Dumped by pg_dump version 10.23

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: emotions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emotions (
    id integer NOT NULL,
    reg_id integer,
    emotion character varying(20),
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.emotions OWNER TO postgres;

--
-- Name: emotions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.emotions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.emotions_id_seq OWNER TO postgres;

--
-- Name: emotions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.emotions_id_seq OWNED BY public.emotions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    reg_id integer NOT NULL,
    username character varying(100),
    email character varying(150),
    password character varying(200),
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.reg_id;


--
-- Name: emotions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emotions ALTER COLUMN id SET DEFAULT nextval('public.emotions_id_seq'::regclass);


--
-- Name: users reg_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN reg_id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: emotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emotions (id, reg_id, emotion, created_at, updated_at) FROM stdin;
2	3	Positive	2026-03-11 15:16:00	\N
1	2	Positive	2026-03-11 15:07:51	\N
4	4	Negative	2026-03-12 11:12:23	\N
5	7	Positive	2026-03-12 11:14:37	\N
104	9	Negative	2026-04-18 12:29:44	\N
6	8	Positive	2026-03-12 12:29:29	2026-03-12 12:30:01
105	4	Negative	2026-04-18 12:33:33	\N
106	9	Negative	2026-04-18 12:29:44	2026-04-18 12:36:51
107	4	Positive	2026-04-18 12:33:33	2026-04-18 12:37:54
108	5	Negative	2026-04-18 12:40:31	\N
109	9	Negative	2026-04-18 12:29:44	2026-04-18 19:27:20
110	9	Negative	2026-04-18 12:29:44	2026-04-18 19:27:30
111	9	Positive	2026-04-18 12:29:44	2026-04-18 19:28:33
112	9	Positive	2026-04-18 12:29:44	2026-04-18 19:29:19
3	2	Negative	2026-03-12 11:09:24	2026-03-12 16:57:09
7	2	Positive	2026-03-12 17:01:57	\N
8	2	Positive	2026-03-12 17:05:56	\N
9	9	Negative	2026-03-17 23:52:43	\N
10	9	Negative	2026-03-17 23:54:00	\N
11	9	Positive	2026-03-17 23:54:13	\N
12	2	Negative	2026-03-17 23:57:37	\N
13	2	Negative	2026-03-17 23:57:43	\N
14	2	Negative	2026-03-17 23:57:47	\N
15	2	Negative	2026-03-17 23:57:58	\N
16	2	Positive	2026-03-17 23:58:10	\N
17	2	Negative	2026-03-17 23:58:14	\N
18	2	Positive	2026-03-18 00:19:40	\N
19	2	Negative	2026-03-18 00:19:40	2026-03-18 00:19:44
20	4	Negative	2026-03-18 00:21:09	\N
21	4	Positive	2026-03-18 00:21:09	2026-03-18 00:22:26
22	4	Negative	2026-03-18 00:21:09	2026-03-18 21:02:04
23	4	Negative	2026-03-18 00:21:09	2026-03-18 21:02:14
24	9	Positive	2026-03-18 21:33:28	\N
25	9	Positive	2026-03-18 21:33:31	\N
26	9	Positive	2026-03-18 21:35:16	\N
27	9	Positive	2026-03-18 21:35:19	\N
28	9	Positive	2026-03-18 21:33:28	2026-03-18 21:42:21
29	9	Positive	2026-03-18 21:33:28	2026-03-18 21:42:29
30	8	Positive	2026-03-18 21:45:11	\N
31	8	Negative	2026-03-18 21:45:11	2026-03-18 21:46:28
32	2	Positive	2026-03-22 11:41:11	\N
33	2	Positive	2026-03-22 11:41:11	2026-03-22 11:41:15
34	9	Negative	2026-03-22 11:43:21	\N
35	2	Negative	2026-03-22 11:41:11	2026-03-22 11:47:40
36	2	Positive	2026-03-22 11:41:11	2026-03-22 19:16:11
37	2	Positive	2026-03-22 11:41:11	2026-03-22 19:16:24
38	2	Negative	2026-03-23 09:16:26	\N
39	2	Positive	2026-03-23 09:16:26	2026-03-23 09:17:28
40	2	Positive	2026-03-23 09:16:26	2026-03-23 17:25:17
46	2	Negative	2026-03-26 11:51:28	\N
113	9	Positive	2026-04-19 09:09:57	\N
47	9	Negative	2026-03-26 11:56:30	\N
48	9	Positive	2026-03-26 11:56:30	2026-03-26 11:57:19
49	2	Positive	2026-03-26 11:51:28	2026-03-26 12:01:01
50	2	Negative	2026-03-26 11:51:28	2026-03-26 12:10:23
51	2	Negative	2026-03-26 11:51:28	2026-03-26 12:16:49
52	2	Negative	2026-03-26 11:51:28	2026-03-26 12:23:23
53	9	Negative	2026-03-26 11:56:30	2026-03-26 13:46:01
54	2	Negative	2026-03-26 11:51:28	2026-03-26 13:58:48
55	2	Negative	2026-03-26 11:51:28	2026-03-26 14:05:14
56	2	Positive	2026-03-26 11:51:28	2026-03-26 14:10:30
57	2	Positive	2026-03-26 11:51:28	2026-03-26 14:12:02
58	2	Positive	2026-03-26 11:51:28	2026-03-26 14:16:07
59	2	Negative	2026-03-26 11:51:28	2026-03-26 14:22:21
60	8	Positive	2026-03-26 14:27:39	\N
61	8	Negative	2026-03-26 14:27:39	2026-03-26 14:27:59
62	7	Negative	2026-03-26 14:30:15	\N
63	7	Positive	2026-03-26 14:30:15	2026-03-26 14:30:51
64	4	Negative	2026-03-26 14:33:40	\N
65	4	Negative	2026-03-26 14:33:40	2026-03-26 18:53:10
66	9	Negative	2026-03-26 11:56:30	2026-03-26 18:54:42
67	9	Negative	2026-03-26 11:56:30	2026-03-26 18:54:45
68	2	Negative	2026-03-28 10:36:59	\N
69	2	Negative	2026-03-28 10:36:59	2026-03-28 10:37:18
70	2	Positive	2026-03-28 10:36:59	2026-03-28 10:37:33
71	9	Negative	2026-03-28 10:45:04	\N
72	9	Negative	2026-03-28 10:45:04	2026-03-28 10:45:07
73	2	Negative	2026-03-28 10:36:59	2026-03-28 11:16:08
74	2	Negative	2026-03-28 10:36:59	2026-03-28 11:16:26
75	2	Negative	2026-03-28 10:36:59	2026-03-28 11:23:13
76	2	Positive	2026-03-28 10:36:59	2026-03-28 11:23:56
77	9	Positive	2026-03-29 08:34:22	\N
78	9	Positive	2026-03-29 08:34:22	2026-03-29 08:35:00
79	2	Positive	2026-03-29 09:03:09	\N
80	2	Positive	2026-03-29 09:03:09	2026-03-29 09:23:26
81	2	Positive	2026-03-29 09:03:09	2026-03-29 09:23:47
82	9	Positive	2026-04-01 17:21:02	\N
83	9	Positive	2026-04-01 17:21:02	2026-04-01 17:21:17
84	9	Negative	2026-04-01 17:21:02	2026-04-01 17:21:51
85	9	Negative	2026-04-01 17:21:02	2026-04-01 17:22:05
86	2	Negative	2026-04-09 15:11:55	\N
87	2	Negative	2026-04-09 15:11:55	2026-04-09 15:11:59
88	2	Positive	2026-04-09 15:11:55	2026-04-09 15:12:40
89	2	Positive	2026-04-09 15:11:55	2026-04-09 15:12:59
90	2	Positive	2026-04-13 11:57:51	\N
91	2	Positive	2026-04-13 11:57:51	2026-04-13 11:59:30
92	2	Positive	2026-04-13 11:57:51	2026-04-13 12:00:06
93	2	Positive	2026-04-13 11:57:51	2026-04-13 12:00:37
94	2	Positive	2026-04-15 17:30:25	\N
95	2	Positive	2026-04-15 17:30:25	2026-04-15 17:30:41
96	2	Positive	2026-04-15 17:30:25	2026-04-15 17:31:20
97	2	Negative	2026-04-15 17:30:25	2026-04-15 17:31:36
98	2	Positive	2026-04-18 12:25:40	\N
99	2	Positive	2026-04-18 12:25:40	2026-04-18 12:25:46
100	2	Negative	2026-04-18 12:25:40	2026-04-18 12:26:27
101	2	Negative	2026-04-18 12:25:40	2026-04-18 12:26:41
102	2	Negative	2026-04-18 12:25:40	2026-04-18 12:26:47
103	2	Positive	2026-04-18 12:25:40	2026-04-18 12:27:15
114	9	Positive	2026-04-19 09:09:57	2026-04-19 09:10:14
115	9	Negative	2026-04-19 09:09:57	2026-04-19 09:10:59
116	10	Negative	2026-04-19 10:20:51	\N
117	10	Negative	2026-04-19 10:20:51	2026-04-19 10:21:27
118	10	Negative	2026-04-19 10:20:51	2026-04-19 10:21:48
119	10	Negative	2026-04-19 10:20:51	2026-04-19 10:21:51
120	10	Negative	2026-04-19 10:20:51	2026-04-19 10:22:32
121	10	Positive	2026-04-19 10:20:51	2026-04-19 10:24:28
122	2	Positive	2026-04-19 11:09:39	\N
123	2	Positive	2026-04-19 11:09:39	2026-04-19 11:11:24
124	2	Positive	2026-04-19 11:09:39	2026-04-19 11:17:50
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (reg_id, username, email, password, created_at) FROM stdin;
1	testuser	test@gmail.com	12345	2026-03-10 17:00:08
2	shrutipawar	shrutip5070@gmail.com	Shruti@11	2026-03-11 15:02:52
3	Anjali	anjali@gmail.com	Anjali@2006	2026-03-11 15:15:00
4	pawar11	pawar11@gmail.com	Shruti@11	2026-03-11 17:05:14
5	Anju	anju@gmail.com	Anjali@20006	2026-03-11 17:10:51
6	anjali	anjalijha@gmail.com	Anjali@2006	2026-03-11 17:12:00
7	shruti2005	shruti2005@gmail.com	Shruti@11	2026-03-12 11:13:45
8	vijaya21	vijaya21@gmail.com	Vijaya@21	2026-03-12 12:28:55
9	shruti	shruti11@gmail.com	Shruti@11	2026-03-17 23:52:03
10	shree2422	shree2422@gmail.com	Shree@24	2026-04-19 10:19:36
\.


--
-- Name: emotions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.emotions_id_seq', 124, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 10, true);


--
-- Name: emotions emotions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emotions
    ADD CONSTRAINT emotions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (reg_id);


--
-- Name: emotions emotions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emotions
    ADD CONSTRAINT emotions_user_id_fkey FOREIGN KEY (reg_id) REFERENCES public.users(reg_id);


--
-- PostgreSQL database dump complete
--

