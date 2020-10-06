--the three timespans would be 2018/07/15-2014/07/15, 2014/07/15-2010/07/15, 2010/07/15-2006/07/15
--timespan1: 2018/07/15-2014/07/15
drop view if exists timespan1 cascade;
create view timespan1 as (select * from data_allegation where is_officer_complaint is false and incident_date is not null and cast(incident_date as date) >= '07-15-2014' and cast(incident_date as date) < '07-15-2018');
-- select * from timespan1;

drop view if exists timespan1oa cascade;
create view timespan1oa as (
select distinct data_officerallegation.allegation_id, data_officerallegation.officer_id
from data_officerallegation, timespan1
where data_officerallegation.allegation_id = timespan1.crid);

select count(distinct officer_id) from timespan1oa; --count is 5567, 10% is 557
--define repeaters for timespan1
drop view if exists timespan1repeater cascade;
create view timespan1repeater as (
select distinct officer_id, count(allegation_id) as ct from timespan1oa group by officer_id order by ct desc limit 557);

create view repeaterdemographics1 as(
    select distinct officer_id, data_officer.race, data_officer.gender,
        case when (2020 - data_officer.birth_year) < 30 then 'younger than 30'
            when (2020 - data_officer.birth_year) between 30 and 40 then '30 - 40'
            when (2020 - data_officer.birth_year) between 40 and 50 then '40 - 50'
            when (2020 - data_officer.birth_year) between 50 and 60 then '50 - 60'
            when (2020 - data_officer.birth_year) >= 60 then 'older than 60'
        end as age_range
    from timespan1repeater, data_officer
    where timespan1repeater.officer_id = data_officer.id);

select race, count(race) as ct from repeaterdemographics1 group by race order by ct desc;
select gender, count(gender) as ct from repeaterdemographics1 group by gender order by ct desc;
select age_range, count(age_range) as ct from repeaterdemographics1 group by age_range order by ct desc;



--timespan2: 2014/07/15-2010/07/15
drop view if exists timespan2 cascade;
create view timespan2 as (select * from data_allegation where is_officer_complaint is false and incident_date is not null and cast(incident_date as date) >= '07-15-2010' and cast(incident_date as date) < '07-15-2014');
-- select * from timespan2;

drop view if exists timespan2oa cascade;
create view timespan2oa as (
select distinct data_officerallegation.allegation_id, data_officerallegation.officer_id from data_officerallegation, timespan2 where data_officerallegation.allegation_id = timespan2.crid);


select count(distinct officer_id) from timespan2oa; --count is 7445, 10% is 744
--define repeaters for timespan2
drop view if exists timespan2repeater cascade;
create view timespan2repeater as (
select distinct officer_id, count(allegation_id) as ct from timespan2oa group by officer_id order by ct desc limit 744);

create view repeaterdemographics2 as(
    select distinct officer_id, data_officer.race, data_officer.gender,
        case when (2020 - data_officer.birth_year) < 30 then 'younger than 30'
            when (2020 - data_officer.birth_year) between 30 and 40 then '30 - 40'
            when (2020 - data_officer.birth_year) between 40 and 50 then '40 - 50'
            when (2020 - data_officer.birth_year) between 50 and 60 then '50 - 60'
            when (2020 - data_officer.birth_year) >= 60 then 'older than 60'
        end as age_range
    from timespan2repeater, data_officer
    where timespan2repeater.officer_id = data_officer.id);

select race, count(race) as ct from repeaterdemographics2 group by race order by ct desc;
select gender, count(gender) as ct from repeaterdemographics2 group by gender order by ct desc;
select age_range, count(age_range) as ct from repeaterdemographics2 group by age_range order by ct desc;


--timespan3: 2010/07/15-2006/07/15
drop view if exists timespan3 cascade;
create view timespan3 as (select * from data_allegation where is_officer_complaint is false and incident_date is not null and cast(incident_date as date) >= '07-15-2006' and cast(incident_date as date) < '07-15-2010');
-- select * from timespan3;

drop view if exists timespan3oa cascade;
create view timespan3oa as (
select distinct data_officerallegation.allegation_id, data_officerallegation.officer_id from data_officerallegation, timespan3 where data_officerallegation.allegation_id = timespan3.crid);


select count(distinct officer_id) from timespan3oa; --count is 8874, 10% is 887
--define repeaters for timespan3
drop view if exists timespan3repeater cascade;
create view timespan3repeater as (
select distinct officer_id, count(allegation_id) as ct from timespan3oa group by officer_id order by ct desc limit 887);

create view repeaterdemographics3 as(
    select distinct officer_id, data_officer.race, data_officer.gender,
        case when (2020 - data_officer.birth_year) < 30 then 'younger than 30'
            when (2020 - data_officer.birth_year) between 30 and 40 then '30 - 40'
            when (2020 - data_officer.birth_year) between 40 and 50 then '40 - 50'
            when (2020 - data_officer.birth_year) between 50 and 60 then '50 - 60'
            when (2020 - data_officer.birth_year) >= 60 then 'older than 60'
        end as age_range
    from timespan3repeater, data_officer
    where timespan3repeater.officer_id = data_officer.id);

select race, count(race) as ct from repeaterdemographics3 group by race order by ct desc;
select gender, count(gender) as ct from repeaterdemographics3 group by gender order by ct desc;
select age_range, count(age_range) as ct from repeaterdemographics3 group by age_range order by ct desc;