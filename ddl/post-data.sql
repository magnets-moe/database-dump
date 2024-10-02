--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- Name: hash_type hash_type_pkey; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.hash_type
    ADD CONSTRAINT hash_type_pkey PRIMARY KEY (hash_type);


--
-- Name: rel_torrent_show rel_torrent_show_pkey; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.rel_torrent_show
    ADD CONSTRAINT rel_torrent_show_pkey PRIMARY KEY (rel_torrent_show_id);


--
-- Name: rel_torrent_show rel_torrent_show_torrent_id_show_id_key; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.rel_torrent_show
    ADD CONSTRAINT rel_torrent_show_torrent_id_show_id_key UNIQUE (torrent_id, show_id);


--
-- Name: schedule schedule_pkey; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (schedule_id);


--
-- Name: show show_anilist_id_key; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.show
    ADD CONSTRAINT show_anilist_id_key UNIQUE (anilist_id);


--
-- Name: show_format show_format_pkey; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.show_format
    ADD CONSTRAINT show_format_pkey PRIMARY KEY (show_format);


--
-- Name: show_name show_name_pkey; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.show_name
    ADD CONSTRAINT show_name_pkey PRIMARY KEY (show_name_id);


--
-- Name: show_name_type show_name_type_pkey; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.show_name_type
    ADD CONSTRAINT show_name_type_pkey PRIMARY KEY (show_name_type);


--
-- Name: show show_pkey; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.show
    ADD CONSTRAINT show_pkey PRIMARY KEY (show_id);


--
-- Name: state state_pkey; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (key);


--
-- Name: torrent torrent_hash_hash_type_key; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.torrent
    ADD CONSTRAINT torrent_hash_hash_type_key UNIQUE (hash, hash_type);


--
-- Name: torrent torrent_nyaa_id_key; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.torrent
    ADD CONSTRAINT torrent_nyaa_id_key UNIQUE (nyaa_id);


--
-- Name: torrent torrent_pkey; Type: CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.torrent
    ADD CONSTRAINT torrent_pkey PRIMARY KEY (torrent_id);


--
-- Name: rel_torrent_show_show_id_nyaa_id_idx; Type: INDEX; Schema: magnets; Owner: postgres
--

CREATE INDEX rel_torrent_show_show_id_nyaa_id_idx ON magnets.rel_torrent_show USING btree (show_id, nyaa_id DESC);


--
-- Name: show_anilist_id_idx; Type: INDEX; Schema: magnets; Owner: postgres
--

CREATE INDEX show_anilist_id_idx ON magnets.show USING btree (anilist_id);


--
-- Name: show_name_show_id_idx; Type: INDEX; Schema: magnets; Owner: postgres
--

CREATE INDEX show_name_show_id_idx ON magnets.show_name USING btree (show_id);


--
-- Name: show_season_idx; Type: INDEX; Schema: magnets; Owner: postgres
--

CREATE INDEX show_season_idx ON magnets.show USING btree (season);


--
-- Name: torrent_nyaa_id_idx; Type: INDEX; Schema: magnets; Owner: postgres
--

CREATE INDEX torrent_nyaa_id_idx ON magnets.torrent USING btree (nyaa_id DESC) WHERE matched;


--
-- Name: torrent_nyaa_id_idx1; Type: INDEX; Schema: magnets; Owner: postgres
--

CREATE INDEX torrent_nyaa_id_idx1 ON magnets.torrent USING btree (nyaa_id DESC) WHERE (NOT matched);


--
-- Name: state on_state_update; Type: TRIGGER; Schema: magnets; Owner: postgres
--

CREATE TRIGGER on_state_update AFTER UPDATE ON magnets.state FOR EACH ROW EXECUTE FUNCTION magnets.handle_state_update();


--
-- Name: rel_torrent_show rel_torrent_show_nyaa_id_fkey; Type: FK CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.rel_torrent_show
    ADD CONSTRAINT rel_torrent_show_nyaa_id_fkey FOREIGN KEY (nyaa_id) REFERENCES magnets.torrent(nyaa_id);


--
-- Name: rel_torrent_show rel_torrent_show_show_id_fkey; Type: FK CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.rel_torrent_show
    ADD CONSTRAINT rel_torrent_show_show_id_fkey FOREIGN KEY (show_id) REFERENCES magnets.show(show_id);


--
-- Name: rel_torrent_show rel_torrent_show_torrent_id_fkey; Type: FK CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.rel_torrent_show
    ADD CONSTRAINT rel_torrent_show_torrent_id_fkey FOREIGN KEY (torrent_id) REFERENCES magnets.torrent(torrent_id);


--
-- Name: schedule schedule_show_id_fkey; Type: FK CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.schedule
    ADD CONSTRAINT schedule_show_id_fkey FOREIGN KEY (show_id) REFERENCES magnets.show(show_id);


--
-- Name: show_name show_name_show_id_fkey; Type: FK CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.show_name
    ADD CONSTRAINT show_name_show_id_fkey FOREIGN KEY (show_id) REFERENCES magnets.show(show_id);


--
-- Name: show_name show_name_show_name_type_fkey; Type: FK CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.show_name
    ADD CONSTRAINT show_name_show_name_type_fkey FOREIGN KEY (show_name_type) REFERENCES magnets.show_name_type(show_name_type);


--
-- Name: show show_show_format_fkey; Type: FK CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.show
    ADD CONSTRAINT show_show_format_fkey FOREIGN KEY (show_format) REFERENCES magnets.show_format(show_format);


--
-- Name: torrent torrent_hash_type_fkey; Type: FK CONSTRAINT; Schema: magnets; Owner: postgres
--

ALTER TABLE ONLY magnets.torrent
    ADD CONSTRAINT torrent_hash_type_fkey FOREIGN KEY (hash_type) REFERENCES magnets.hash_type(hash_type);


--
-- PostgreSQL database dump complete
--

