drop view if exists recruiter_ratings_view;
create view recruiter_ratings_view as
select r.id, r.first_name, r.last_name, r.email, r.phone_number, rr.rating from recruiters r
inner join (
    select recruiter_id, round(avg(rating), 2) as rating
    from user_recruiter_ratings
    group by recruiter_id
) rr
on r.id = rr.recruiter_id;

drop view if exists agency_ratings_view;
create view agency_ratings_view as
select a.id, a.agency_name, a.website, a.address, a.phone_number, ar.rating from agencies a
inner join (
    select agency_id, round(avg(rating), 2) as rating
    from user_agency_ratings
    group by agency_id
) ar
on a.id = ar.agency_id;