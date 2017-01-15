create or replace function create_user_regular (username text, password text)
returns integer as $user_id$
declare
	user_id integer;
begin
	insert into public.users (username, password)
    values (username, crypt(password, gen_salt('bf', 8)))
    returning id into user_id;
    return user_id;
end;
$user_id$ language plpgsql;