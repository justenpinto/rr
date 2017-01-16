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
create or replace function load_recruiter(r_id int)
returns table (id int, first_name text, last_name text, email text, phone_number text, rating numeric(3,2)) as $$
begin
	return query(
	    select r.id, r.first_name, r.last_name, r.email, r.phone_number, rr.rating from recruiters r
        inner join (
            select recruiter_id, round(avg(urr.rating), 2) as rating from user_recruiter_ratings urr
            group by recruiter_id
            having recruiter_id = r_id
        ) rr on rr.recruiter_id = r.id
    );
end;
$$ language plpgsql;

drop function if exists load_agency(int);
create or replace function load_agency(a_id int)
returns table (id int, agency_name text, website text, address text, phone_number text, rating numeric(3,2)) as $$
begin
	return query(
        select a.id, a.agency_name, a.website, a.address, a.phone_number, ra.rating from agencies a
        inner join (
            select agency_id, round(avg(uar.rating), 2) as rating from user_agency_ratings uar
            group by agency_id
            having agency_id = a_id
        ) ra on ra.agency_id = a.id
    );
end;
$$ language plpgsql;

drop function if exists search_recruiters(text, text);
create or replace function search_recruiters(fname text, lname text)
returns table (id int, first_name text, last_name text, email text, phone_number text, rating numeric(3,2)) as $$
begin
    return query (
        select r.id, r.first_name, r.last_name, r.email, r.phone_number, rr.rating from recruiters r
        inner join (
            select recruiter_id, round(avg(urr.rating), 2) as rating from user_recruiter_ratings urr
            group by recruiter_id
        ) rr on rr.recruiter_id = r.id
        where lower(r.first_name) like lower(('%' || fname || '%'))
        and lower(r.last_name) like lower(('%' || lname || '%'))
    );
end;
$$ language plpgsql;

drop function if exists search_agencies(text);
create or replace function search_agencies(aname text)
returns table (id int, agency_name text, website text, address text, rating numeric(3,2)) as $$
begin
    return query (
        select a.id, a.agency_name, a.website, a.address, ar.rating from agencies a
        inner join (
            select agency_id, round(avg(uar.rating), 2) as rating from user_agency_ratings uar
            group by agency_id
        ) ar on ar.agency_id = a.id
        where lower(a.agency_name) like lower(('%' || aname || '%'))
    );
end;
$$ language plpgsql;

drop function if exists find_recruiters_associated_with_agency(int);
create or replace function find_recruiters_associated_with_agency(a_id int)
returns table (id int, first_name text, last_name text, email text, phone_number text, rating numeric(3,2)) as $$
begin
    return query (
        select r.id, r.first_name, r.last_name, r.email, r.phone_number, rr.rating
        from recruiters r
        inner join (
	        select recruiter_id, round(avg(urr.rating), 2) as rating
            from user_recruiter_ratings urr
            group by recruiter_id
        ) rr on r.id = rr.recruiter_id
        inner join agency_recruiter_associations ara
        on r.id = ara.recruiter_id
        where agency_id = a_id
    );
end;
$$ language plpgsql;

drop function if exists find_agencies_associated_with_recruiter(int);
create or replace function find_agencies_associated_with_recruiter(r_id int)
returns table (id int, agency_name text, website text, address text, phone_number text, rating numeric(3,2)) as $$
begin
    return query (
        select a.id, a.agency_name, a.website, a.address, a.phone_number, ar.rating
        from agencies a
        inner join (
            select agency_id, round(avg(uar.rating), 2) as rating
            from user_agency_ratings uar
            group by agency_id
        ) ar on a.id = ar.agency_id
        inner join agency_recruiter_associations ara
        on a.id = ara.agency_id
        where recruiter_id = r_id
    );
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


