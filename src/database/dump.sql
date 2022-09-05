--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)

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
-- Name: transactionType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."transactionType" AS ENUM (
    'groceries',
    'restaurant',
    'transport',
    'education',
    'health'
);


ALTER TYPE public."transactionType" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: businesses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.businesses (
    id integer NOT NULL,
    name text NOT NULL,
    type public."transactionType" NOT NULL
);


ALTER TABLE public.businesses OWNER TO postgres;

--
-- Name: businesses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.businesses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.businesses_id_seq OWNER TO postgres;

--
-- Name: businesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.businesses_id_seq OWNED BY public.businesses.id;


--
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards (
    id integer NOT NULL,
    "employeeId" integer NOT NULL,
    number text NOT NULL,
    "cardholderName" text NOT NULL,
    "securityCode" text NOT NULL,
    "expirationDate" text NOT NULL,
    password text,
    "isVirtual" boolean NOT NULL,
    "originalCardId" integer,
    "isBlocked" boolean NOT NULL,
    type public."transactionType" NOT NULL
);


ALTER TABLE public.cards OWNER TO postgres;

--
-- Name: cards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cards_id_seq OWNER TO postgres;

--
-- Name: cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cards_id_seq OWNED BY public.cards.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    name text NOT NULL,
    "apiKey" text
);


ALTER TABLE public.companies OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.companies_id_seq OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    "fullName" text NOT NULL,
    cpf text NOT NULL,
    email text NOT NULL,
    "companyId" integer NOT NULL
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_id_seq OWNER TO postgres;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    "cardId" integer NOT NULL,
    "businessId" integer NOT NULL,
    "timestamp" timestamp(0) without time zone DEFAULT now() NOT NULL,
    amount integer NOT NULL
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: recharges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recharges (
    id integer NOT NULL,
    "cardId" integer NOT NULL,
    "timestamp" timestamp(0) without time zone DEFAULT now() NOT NULL,
    amount integer NOT NULL
);


ALTER TABLE public.recharges OWNER TO postgres;

--
-- Name: recharges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recharges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recharges_id_seq OWNER TO postgres;

--
-- Name: recharges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recharges_id_seq OWNED BY public.recharges.id;


--
-- Name: businesses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesses ALTER COLUMN id SET DEFAULT nextval('public.businesses_id_seq'::regclass);


--
-- Name: cards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards ALTER COLUMN id SET DEFAULT nextval('public.cards_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: recharges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recharges ALTER COLUMN id SET DEFAULT nextval('public.recharges_id_seq'::regclass);


--
-- Data for Name: businesses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.businesses (id, name, type) FROM stdin;
1	Responde Aí	education
2	Extra	groceries
3	Driven Eats	restaurant
4	Uber	transport
5	Unimed	health
\.


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards (id, "employeeId", number, "cardholderName", "securityCode", "expirationDate", password, "isVirtual", "originalCardId", "isBlocked", type) FROM stdin;
4	1	6771-8953-8364-9248	FULANO R SILVA	ace591585ae3474fa1d9b7f088f21d265116bb5a698aa3304a199e2217c220b98540eaf0c20cd5c3bea91939d79ddfba9ff8e82694e315456e5387c81a6c4cf8f1ee44f54b49c2b0d872f80fa1058e6a2ae736b137b1fa4fb9235147f601e5e916eb5b	09/27	$2a$10$OwOWIC9XvrJIQMCF6fKCrOwWscKczPffhzg7DAJ3vINiTraX9hbYu	f	\N	f	restaurant
1	1	5170-1915-8983-8705	FULANO R SILVA	2974d98856953767ac0c41b933be5574e48d0f6761fe228ce5fa60615f216c0711dc5f721ae1dd7836dce1a6e1f5da53872219b8fe0c38880094c8deeffc095f3af3e9db4b082fc56527d0a958ac9ffe306968a8c29a05e618d9d8c637d9a9689bcae4	09/27	\N	f	\N	f	groceries
2	2	5437-4806-9323-9697	CICLANA M MADEIRA	597f6c19a522856b2266d1d2f07ebdd834582032b21f513f31f7011461343c71f861c77136b397514b5367c9f1ecedd6c3387ba82f99833d860e3b234a9bd1b505b77ff11243990064e2b1904bf3e107f056f39e03b37e9a5b91bf05735f04872d65a5	09/27	\N	f	\N	f	groceries
3	1	5282-9043-3259-1313	FULANO R SILVA	67ce9d504c1f46ffc5fa3b050de74a5d98337a9eb83278f2be01c0628242a03d955164670a6a160fec775410c486c811f9b34970029ab8c0f0709ab9e1aba95d5f249738e0c843890d3f52dbac18d93250aee46c8bd1a6ffbd0973f822ce08ed1b5d20	09/27	\N	f	\N	f	health
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.companies (id, name, "apiKey") FROM stdin;
1	Driven	zadKLNx.DzvOVjQH01TumGl2urPjPQSxUbf67vs0
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (id, "fullName", cpf, email, "companyId") FROM stdin;
1	Fulano Rubens da Silva	47100935741	fulano.silva@gmail.com	1
2	Ciclana Maria Madeira	08434681895	ciclaninha@gmail.com	1
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, "cardId", "businessId", "timestamp", amount) FROM stdin;
1	4	3	2022-09-04 18:46:06	5000
2	4	3	2022-09-04 19:02:40	5000
3	4	3	2022-09-04 21:21:43	5000
4	4	3	2022-09-04 21:22:15	5000
5	4	3	2022-09-04 21:22:38	20000
\.


--
-- Data for Name: recharges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recharges (id, "cardId", "timestamp", amount) FROM stdin;
1	4	2022-09-04 18:44:23	40000
2	4	2022-09-04 20:32:37	40000
3	4	2022-09-04 21:14:32	40000
\.


--
-- Name: businesses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.businesses_id_seq', 1, false);


--
-- Name: cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cards_id_seq', 4, true);


--
-- Name: companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.companies_id_seq', 1, false);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_id_seq', 1, false);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_id_seq', 5, true);


--
-- Name: recharges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recharges_id_seq', 3, true);


--
-- Name: businesses businesses_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesses
    ADD CONSTRAINT businesses_name_key UNIQUE (name);


--
-- Name: businesses businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesses
    ADD CONSTRAINT businesses_pkey PRIMARY KEY (id);


--
-- Name: cards cards_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_number_key UNIQUE (number);


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: companies companies_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_name_key UNIQUE (name);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: employees employees_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_cpf_key UNIQUE (cpf);


--
-- Name: employees employees_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_email_key UNIQUE (email);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: recharges recharges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recharges
    ADD CONSTRAINT recharges_pkey PRIMARY KEY (id);


--
-- Name: cards cards_employeeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT "cards_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES public.employees(id);


--
-- Name: cards cards_originalCardId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT "cards_originalCardId_fkey" FOREIGN KEY ("originalCardId") REFERENCES public.cards(id);


--
-- Name: employees employees_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT "employees_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id);


--
-- Name: payments payments_businessId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT "payments_businessId_fkey" FOREIGN KEY ("businessId") REFERENCES public.businesses(id);


--
-- Name: payments payments_cardId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT "payments_cardId_fkey" FOREIGN KEY ("cardId") REFERENCES public.cards(id);


--
-- Name: recharges recharges_cardId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recharges
    ADD CONSTRAINT "recharges_cardId_fkey" FOREIGN KEY ("cardId") REFERENCES public.cards(id);


--
-- PostgreSQL database dump complete
--

