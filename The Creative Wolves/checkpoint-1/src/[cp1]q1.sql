-- Q1

--The following block generates the average number of allegation count of the top 4000 of officers who received the highest amount of allegations
with top_repeat_repeaters AS (
    select officer_id, count(distinct allegation_id) as allegation_count
    from data_officerallegation
    group by officer_id
    order by allegation_count desc
    limit 4000)
select avg(allegation_count) as top_5_percent_avg_allegation
from top_repeat_repeaters;

--Answer: 31.07

--The following block calculates the avg number of allegation per officer of all the officers who received at least 1 allegation
with overall_allegation_count as (
    select officer_id, count(distinct allegation_id) as allegation_count
    from data_officerallegation
    group by officer_id)
select avg(allegation_count) as overall_avg_allegation
from overall_allegation_count;

--Answer: 10.65







