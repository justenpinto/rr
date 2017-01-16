-- Create Functions
drop function if exists create_user_regular(text, text, text);
create or replace function create_user_regular (username text, email text, password text)
returns integer as $user_id$
declare
	user_id integer;
begin
	insert into public.users (username, isoauth, email, password)
    values (username, False, email, crypt(password, gen_salt('bf', 8)))
    returning id into user_id;
    return user_id;
end;
$user_id$ language plpgsql;

drop function if exists create_recruiter(text, text, text, text);
create or replace function create_recruiter(fname text, lname text, email text, phone_num text)
returns integer as $recruiter_id$
declare
    recruiter_id integer;
begin
    insert into public.recruiters (first_name, last_name, email, phone_num)
    values (fname, lname, email, phone_num)
    returning id into recruiter_id;
    return recruiter_id;
end;
$recruiter_id$ language plpgsql;

drop function if exists create_agency(text, text, text, text);
create or replace function create_agency(aname text, website text, address text, phone_num text)
returns integer as $agency_id$
declare
    agency_id integer;
begin
    insert into public.agencies (aname, website, address, phone_number)
    values (aname, website, address, phone_num)
    returning id into agency_id;
    return agency_id;
end;
$agency_id$ language plpgsql;

-- Load Functions
drop function if exists load_user_regular(text, text);
create or replace function load_user_regular(uname text, pw text)
returns integer as $user_id$
declare
    user_id integer;
begin
    select id from users
    where username = uname and password=crypt(pw, password)
    into user_id;
    return user_id;
end;
$user_id$ language plpgsql;

drop function if exists load_recruiter(int);
create or replace function load_recruiter(recruiter_id int)
returns setof recruiters as $$
begin
	return query(select * from recruiters where id = recruiter_id);
end;
$$ language plpgsql;

drop function if exists load_agency(int);
create or replace function load_agency(agency_id int)
returns setof agencies as $$
begin
    return query(select * from agencies where id = agency_id);
end;
$$ language plpgsql;


-- Rate Functions
drop function if exists rate_recruiter(int, int, numeric(3,2), text, boolean);
create or replace function rate_recruiter(user_id int, recruiter_id int, rating numeric(3,2), comment text, anonymous boolean)
returns void as $$
begin
    insert into user_recruiter_ratings(user_id, recruiter_id, anonymous, rating, comment)
    values (user_id, recruiter_id, anonymous, rating, comment);
end;
$$ language plpgsql;


drop function if exists rate_agency(int, int, numeric(3,2), text, boolean);
create or replace function rate_agency(user_id int, agency_id int, rating numeric(3,2), comment text, anonymous boolean)
returns void as $$
begin
    insert into user_agency_ratings(user_id, agency_id, anonymous, rating, comment)
    values (user_id, agency_id, anonymous, rating, comment);
end;
$$ language plpgsql;


