--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-06-06 12:24:03

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16465)
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    order_id integer NOT NULL,
    user_id integer NOT NULL,
    order_date timestamp without time zone NOT NULL
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16477)
-- Name: order_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_detail (
    order_detail_id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.order_detail OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16476)
-- Name: order_detail_order_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_detail_order_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_detail_order_detail_id_seq OWNER TO postgres;

--
-- TOC entry 4885 (class 0 OID 0)
-- Dependencies: 221
-- Name: order_detail_order_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_detail_order_detail_id_seq OWNED BY public.order_detail.order_detail_id;


--
-- TOC entry 219 (class 1259 OID 16464)
-- Name: order_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_order_id_seq OWNER TO postgres;

--
-- TOC entry 4886 (class 0 OID 0)
-- Dependencies: 219
-- Name: order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_order_id_seq OWNED BY public."order".order_id;


--
-- TOC entry 218 (class 1259 OID 16458)
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    product_id integer NOT NULL,
    product_name character varying(100) NOT NULL,
    price numeric(10,2) NOT NULL,
    stock integer NOT NULL
);


ALTER TABLE public.product OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16457)
-- Name: product_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_product_id_seq OWNER TO postgres;

--
-- TOC entry 4887 (class 0 OID 0)
-- Dependencies: 217
-- Name: product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_product_id_seq OWNED BY public.product.product_id;


--
-- TOC entry 216 (class 1259 OID 16449)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(50) NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16493)
-- Name: user_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_product (
    user_id integer NOT NULL,
    product_id integer NOT NULL
);


ALTER TABLE public.user_product OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16448)
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_user_id_seq OWNER TO postgres;

--
-- TOC entry 4888 (class 0 OID 0)
-- Dependencies: 215
-- Name: user_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_user_id_seq OWNED BY public."user".user_id;


--
-- TOC entry 4709 (class 2604 OID 16468)
-- Name: order order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN order_id SET DEFAULT nextval('public.order_order_id_seq'::regclass);


--
-- TOC entry 4710 (class 2604 OID 16480)
-- Name: order_detail order_detail_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail ALTER COLUMN order_detail_id SET DEFAULT nextval('public.order_detail_order_detail_id_seq'::regclass);


--
-- TOC entry 4708 (class 2604 OID 16461)
-- Name: product product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN product_id SET DEFAULT nextval('public.product_product_id_seq'::regclass);


--
-- TOC entry 4707 (class 2604 OID 16452)
-- Name: user user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN user_id SET DEFAULT nextval('public.user_user_id_seq'::regclass);


--
-- TOC entry 4876 (class 0 OID 16465)
-- Dependencies: 220
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."order" (order_id, user_id, order_date) VALUES (1, 1, '2024-06-06 00:36:08.25569');
INSERT INTO public."order" (order_id, user_id, order_date) VALUES (2, 2, '2024-06-06 03:19:54.69033');


--
-- TOC entry 4878 (class 0 OID 16477)
-- Dependencies: 222
-- Data for Name: order_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_detail (order_detail_id, order_id, product_id, quantity, price) VALUES (1, 1, 2, 4, 36.00);
INSERT INTO public.order_detail (order_detail_id, order_id, product_id, quantity, price) VALUES (2, 2, 3, 4, 32.00);


--
-- TOC entry 4874 (class 0 OID 16458)
-- Dependencies: 218
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product (product_id, product_name, price, stock) VALUES (2, 'pepsi', 9.00, 12);
INSERT INTO public.product (product_id, product_name, price, stock) VALUES (1, 'fanta', 9.00, 12);
INSERT INTO public.product (product_id, product_name, price, stock) VALUES (4, 'Cola', 10.00, 15);
INSERT INTO public.product (product_id, product_name, price, stock) VALUES (3, 'monster', 8.00, 12);


--
-- TOC entry 4872 (class 0 OID 16449)
-- Dependencies: 216
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."user" (user_id, username, email, password) VALUES (3, 'test1', 'test1@gmail.com', 'pass');
INSERT INTO public."user" (user_id, username, email, password) VALUES (1, 'test2', 'test2', 'pass');
INSERT INTO public."user" (user_id, username, email, password) VALUES (2, 'example', 'example@gmail.com', 'pass');


--
-- TOC entry 4879 (class 0 OID 16493)
-- Dependencies: 223
-- Data for Name: user_product; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4889 (class 0 OID 0)
-- Dependencies: 221
-- Name: order_detail_order_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_detail_order_detail_id_seq', 1, false);


--
-- TOC entry 4890 (class 0 OID 0)
-- Dependencies: 219
-- Name: order_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_order_id_seq', 1, false);


--
-- TOC entry 4891 (class 0 OID 0)
-- Dependencies: 217
-- Name: product_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_product_id_seq', 6, true);


--
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 215
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_user_id_seq', 3, true);


--
-- TOC entry 4720 (class 2606 OID 16482)
-- Name: order_detail order_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pkey PRIMARY KEY (order_detail_id);


--
-- TOC entry 4718 (class 2606 OID 16470)
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4716 (class 2606 OID 16463)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- TOC entry 4712 (class 2606 OID 16456)
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- TOC entry 4714 (class 2606 OID 16454)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4722 (class 2606 OID 16497)
-- Name: user_product user_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_product
    ADD CONSTRAINT user_product_pkey PRIMARY KEY (user_id, product_id);


--
-- TOC entry 4724 (class 2606 OID 16483)
-- Name: order_detail order_detail_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id);


--
-- TOC entry 4725 (class 2606 OID 16488)
-- Name: order_detail order_detail_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- TOC entry 4723 (class 2606 OID 16471)
-- Name: order order_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- TOC entry 4726 (class 2606 OID 16503)
-- Name: user_product user_product_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_product
    ADD CONSTRAINT user_product_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- TOC entry 4727 (class 2606 OID 16498)
-- Name: user_product user_product_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_product
    ADD CONSTRAINT user_product_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


-- Completed on 2024-06-06 12:24:03

--
-- PostgreSQL database dump complete
--

