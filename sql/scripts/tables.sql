--create extension chkpass;
--create exension pgcrypto;
drop table if exists public.users cascade;
create table public.users (
  id serial primary key,
  username text not null,
  isOAuth boolean not null,
  email text,
  password text,
  oauth_token text,
  oauth_token_secret text,
  constraint username_unique unique (username),
  constraint email_unique unique (email)
);

drop table if exists public.recruiters cascade;
create table public.recruiters (
  id serial primary key,
  first_name text,
  last_name text,
  email text,
  phone_number text
);

drop table if exists public.agencies cascade;
create table public.agencies (
  id serial primary key,
  agency_name text,
  website text,
  address text,
  phone_number text
);

drop table if exists public.user_agency_ratings;
create table public.user_agency_ratings (
  id serial primary key,
  user_id int not null references users,
  agency_id int not null references agencies,
  anonymous boolean,
  rating numeric(3,2),
  comment text
);

drop table if exists public.user_recruiter_ratings;
create table public.user_recruiter_ratings (
  id serial primary key,
  user_id int not null references users,
  recruiter_id int not null references recruiters,
  anonymous boolean,
  rating numeric(3,2),
  comment text
);