--
-- PostgreSQL database dump
--

-- Dumped from database version 13.12 (Debian 13.12-1.pgdg100+1)
-- Dumped by pg_dump version 13.12 (Debian 13.12-1.pgdg100+1)

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
-- Name: magnets; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA magnets;


ALTER SCHEMA magnets OWNER TO postgres;

--
-- Name: handle_state_update(); Type: FUNCTION; Schema: magnets; Owner: postgres
--

CREATE FUNCTION magnets.handle_state_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if NEW.key = 'max_nyaa_si_id' then
        if NEW.value::bigint < OLD.value::bigint then
            call magnets.notify_state_change(NEW.key);
        end if;
    elsif NEW.key = 'rematch_unmatched' then
        if NEW.value::int > 0 then
            call magnets.notify_state_change(NEW.key);
        end if;
    elsif NEW.key in ('last_shows_update', 'last_schedule_update') then
        if NEW.value::text::timestamptz < OLD.value::text::timestamptz then
            call magnets.notify_state_change(NEW.key);
        end if;
    end if;
    return null;
end;
$$;


ALTER FUNCTION magnets.handle_state_update() OWNER TO postgres;

--
-- Name: notify_state_change(text); Type: PROCEDURE; Schema: magnets; Owner: postgres
--

CREATE PROCEDURE magnets.notify_state_change(key text)
    LANGUAGE plpgsql
    AS $$
begin
    perform pg_notify('state_change', key);
    return;
end;
$$;


ALTER PROCEDURE magnets.notify_state_change(key text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: hash_type; Type: TABLE; Schema: magnets; Owner: postgres
--

CREATE TABLE magnets.hash_type (
    hash_type integer NOT NULL,
    description text NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE magnets.hash_type OWNER TO postgres;

--
-- Name: rel_torrent_show; Type: TABLE; Schema: magnets; Owner: postgres
--

CREATE TABLE magnets.rel_torrent_show (
    rel_torrent_show_id bigint NOT NULL,
    show_id bigint NOT NULL,
    torrent_id bigint NOT NULL,
    nyaa_id bigint NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE magnets.rel_torrent_show OWNER TO postgres;

--
-- Name: rel_torrent_show_rel_torrent_show_id_seq; Type: SEQUENCE; Schema: magnets; Owner: postgres
--

CREATE SEQUENCE magnets.rel_torrent_show_rel_torrent_show_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE magnets.rel_torrent_show_rel_torrent_show_id_seq OWNER TO postgres;

--
-- Name: rel_torrent_show_rel_torrent_show_id_seq; Type: SEQUENCE OWNED BY; Schema: magnets; Owner: postgres
--

ALTER SEQUENCE magnets.rel_torrent_show_rel_torrent_show_id_seq OWNED BY magnets.rel_torrent_show.rel_torrent_show_id;


--
-- Name: schedule; Type: TABLE; Schema: magnets; Owner: postgres
--

CREATE TABLE magnets.schedule (
    schedule_id bigint NOT NULL,
    show_id bigint NOT NULL,
    episode integer NOT NULL,
    airs_at timestamp with time zone NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE magnets.schedule OWNER TO postgres;

--
-- Name: schedule_schedule_id_seq; Type: SEQUENCE; Schema: magnets; Owner: postgres
--

CREATE SEQUENCE magnets.schedule_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE magnets.schedule_schedule_id_seq OWNER TO postgres;

--
-- Name: schedule_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: magnets; Owner: postgres
--

ALTER SEQUENCE magnets.schedule_schedule_id_seq OWNED BY magnets.schedule.schedule_id;


--
-- Name: show; Type: TABLE; Schema: magnets; Owner: postgres
--

CREATE TABLE magnets.show (
    show_id bigint NOT NULL,
    anilist_id bigint NOT NULL,
    season integer,
    show_format integer NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE magnets.show OWNER TO postgres;

--
-- Name: show_format; Type: TABLE; Schema: magnets; Owner: postgres
--

CREATE TABLE magnets.show_format (
    show_format integer NOT NULL,
    description text NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE magnets.show_format OWNER TO postgres;

--
-- Name: show_name; Type: TABLE; Schema: magnets; Owner: postgres
--

CREATE TABLE magnets.show_name (
    show_name_id bigint NOT NULL,
    show_id bigint NOT NULL,
    show_name_type integer NOT NULL,
    name text NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE magnets.show_name OWNER TO postgres;

--
-- Name: show_name_show_name_id_seq; Type: SEQUENCE; Schema: magnets; Owner: postgres
--

CREATE SEQUENCE magnets.show_name_show_name_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE magnets.show_name_show_name_id_seq OWNER TO postgres;

--
-- Name: show_name_show_name_id_seq; Type: SEQUENCE OWNED BY; Schema: magnets; Owner: postgres
--

ALTER SEQUENCE magnets.show_name_show_name_id_seq OWNED BY magnets.show_name.show_name_id;


--
-- Name: show_name_type; Type: TABLE; Schema: magnets; Owner: postgres
--

CREATE TABLE magnets.show_name_type (
    show_name_type integer NOT NULL,
    description text NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE magnets.show_name_type OWNER TO postgres;

--
-- Name: show_show_id_seq; Type: SEQUENCE; Schema: magnets; Owner: postgres
--

CREATE SEQUENCE magnets.show_show_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE magnets.show_show_id_seq OWNER TO postgres;

--
-- Name: show_show_id_seq; Type: SEQUENCE OWNED BY; Schema: magnets; Owner: postgres
--

ALTER SEQUENCE magnets.show_show_id_seq OWNED BY magnets.show.show_id;


--
-- Name: state; Type: TABLE; Schema: magnets; Owner: postgres
--

CREATE TABLE magnets.state (
    key text NOT NULL,
    value jsonb NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE magnets.state OWNER TO postgres;

--
-- Name: torrent; Type: TABLE; Schema: magnets; Owner: postgres
--

CREATE TABLE magnets.torrent (
    torrent_id bigint NOT NULL,
    nyaa_id bigint NOT NULL,
    hash bytea NOT NULL,
    hash_type integer NOT NULL,
    uploaded_at timestamp with time zone NOT NULL,
    title text NOT NULL,
    size bigint NOT NULL,
    matched boolean DEFAULT false NOT NULL,
    trusted boolean NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE magnets.torrent OWNER TO postgres;

--
-- Name: torrent_torrent_id_seq; Type: SEQUENCE; Schema: magnets; Owner: postgres
--

CREATE SEQUENCE magnets.torrent_torrent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE magnets.torrent_torrent_id_seq OWNER TO postgres;

--
-- Name: torrent_torrent_id_seq; Type: SEQUENCE OWNED BY; Schema: magnets; Owner: postgres
--

ALTER SEQUENCE magnets.torrent_torrent_id_seq OWNED BY magnets.torrent.torrent_id;


--
-- Name: rel_torrent_show rel_torrent_show_id; Type: DEFAULT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.rel_torrent_show ALTER COLUMN rel_torrent_show_id SET DEFAULT nextval('magnets.rel_torrent_show_rel_torrent_show_id_seq'::regclass);


--
-- Name: schedule schedule_id; Type: DEFAULT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.schedule ALTER COLUMN schedule_id SET DEFAULT nextval('magnets.schedule_schedule_id_seq'::regclass);


--
-- Name: show show_id; Type: DEFAULT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.show ALTER COLUMN show_id SET DEFAULT nextval('magnets.show_show_id_seq'::regclass);


--
-- Name: show_name show_name_id; Type: DEFAULT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.show_name ALTER COLUMN show_name_id SET DEFAULT nextval('magnets.show_name_show_name_id_seq'::regclass);


--
-- Name: torrent torrent_id; Type: DEFAULT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.torrent ALTER COLUMN torrent_id SET DEFAULT nextval('magnets.torrent_torrent_id_seq'::regclass);


--
-- PostgreSQL database dump complete
--

