-- Table: public.eurovision

-- DROP TABLE public.eurovision;

CREATE TABLE IF NOT EXISTS public.eurovision
(
    id integer NOT NULL,
    year integer,
    host_city character varying(40) COLLATE pg_catalog."default",
    winner character varying(40) COLLATE pg_catalog."default",
    song character varying(40) COLLATE pg_catalog."default",
    performer character varying(80) COLLATE pg_catalog."default",
    language character varying(40) COLLATE pg_catalog."default",
    runner_up character varying(40) COLLATE pg_catalog."default",
    participant_number integer,
    CONSTRAINT eurovision_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE public.eurovision
    OWNER to postgres;