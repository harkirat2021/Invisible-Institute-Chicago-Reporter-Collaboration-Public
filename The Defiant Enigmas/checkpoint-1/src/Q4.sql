drop table if exists age_group;
create temp table age_group (
  id  serial primary key,
  min integer,
  max integer
);
insert into age_group
values (0, 21, 30),
       (1, 31, 40),
       (2, 41, 50),
       (3, 51, 1000);
select *
from age_group;

drop table if exists allegation_sustained_status;
create temp table allegation_sustained_status as
  select all_table.allegation_id,
         coalesce(sust_count, 0) * 2 >= all_count as sustained,
         all_count,
         coalesce(sust_count, 0)                  as sust_count
  from (select allegation_id, count(allegation_id) as all_count
        from data_officerallegation
        group by allegation_id) as all_table
         left join (select allegation_id, count(allegation_id) as sust_count
                    from data_officerallegation
                    where final_finding = 'SU'
                    group by allegation_id) as sust_table on all_table.allegation_id = sust_table.allegation_id;

-- note: incident_date, age, birth_year could be all null or partial null
drop table if exists complainant_sustained_status;
create temp table complainant_sustained_status as
  select dc.id, dc.gender, dc.race, ag.id as age_group, asst.sustained
  from data_complainant as dc
         left join data_allegation as da on dc.allegation_id = da.crid
         left join age_group as ag on (extract(year from da.incident_date) - dc.birth_year >= ag.min
                                         and extract(year from da.incident_date) - dc.birth_year <= ag.max) or
                                      (dc.age >= ag.min and dc.age <= ag.max)
         left join allegation_sustained_status as asst on dc.allegation_id = asst.allegation_id;


-- get race composition
select css.race, cast(count(*) as float) / (select count(*) from complainant_sustained_status) as percent
from complainant_sustained_status as css
group by css.race;


with all_st as (select race, count(*) as all_count
                from complainant_sustained_status
                group by race)
select all_st.race, cast(sust_count as float) / cast(all_count as float) as sustained_rate
from all_st
       left join (select race, count(*) as sust_count
                  from complainant_sustained_status
                  where sustained
                  group by race) as sust_st on all_st.race = sust_st.race;


-- get age composition
select css.age_group, cast(count(*) as float) / (select count(*) from complainant_sustained_status) as percent
from complainant_sustained_status as css
group by css.age_group
order by css.age_group;

-- get sustained rate per age group
with all_st as (select age_group, count(*) as all_count
                from complainant_sustained_status
                group by age_group)
select all_st.age_group, cast(sust_count as float) / cast(all_count as float) as sustained_rate
from all_st
       left join (select age_group, count(*) as sust_count
                  from complainant_sustained_status
                  where sustained
                  group by age_group) as sust_st on all_st.age_group = sust_st.age_group
order by all_st.age_group;

